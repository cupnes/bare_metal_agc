# 040_860 #
yaDSKY2の7セグメント表示器に"860"と表示するプログラムです。AGCのIOポート制御の仕様上、7セグメント表示器には数字しか表示させることができないので、"ハロー(860)"と表示させています。

`030_control_indicator`と同じく、yaAGCとyaDSKY2を起動し、`run`させるとyaDSKY2へ表示されます。

```
$ make run
yaDSKY2 &
yaAGC --port=19797 860.agc.bin
Apollo Guidance Computer simulation, ver. , built Aug 11 2016 16:57:40
Copyright (C) 2003-2009 Ronald S. Burkey, Onno Hommes.
yaAGC is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Refer to http://www.ibiblio.org/apollo/index.html for additional information.
0x426d600x426e780x426f08Hostname=localhost, port=19797
(agc) yaDSKY is connected.

(agc) run
[New Thread 11]
[Switching to Thread 11]
```

## ソースコードの簡単な説明 ##

```
		CAF	PUT8
		EXTEND
		WRITE	OUT0

		CAF	PUT60
		EXTEND
		WRITE	OUT0

		CAF	CLR
		EXTEND
		WRITE	OUT0

END		TC	END

# 0b0111 0 00000 11101
PUT8		OCT	34035

# 0b0110 0 11100 10101
PUT60		OCT	31625

# 0b1100 0 00000 00000
CLR		OCT	60000

OUT0		EQUALS	10
```

`030_control_indicator`と同じく、I/Oチャンネルへ決められたビットパターンで値を書き込むと、7セグメント表示器を点灯させることができます。ただし、`040_860`では`WOR`ではなく、単なる`WRITE`(OR演算は行わず、単にAレジスタの内容をオペランドのI/Oチャンネルアドレスへ書き込む)を使用しています。

ビットパターンは"AAAABCCCCCDDDDD"です。最初の"AAAA"の4ビットでは出力先の7セグメント表示器を指定します。次の"B"の1ビットでは"±"の表示の指定、その次の"CCCCCDDDDD"では表示する数値を2桁分指定します。各フィールドで指定する値は[Table of I/O Channels](http://www.ibiblio.org/apollo/developer.html#Table_of_IO_Channels)の表を参照してください。

なお、`CAF CLR`から`WRITE OUT0`までのコードブロックではインジケータのクリアを行っています。まだ理由を理解できていないのですが、7セグメント表示器へ表示を行うと`NO ATT`・`GIMBAL LOCK`・`PROG`が点灯してしまうためクリア処理を行っています。
