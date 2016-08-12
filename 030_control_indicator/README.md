# 030_control_indicator #
yaDSKY2のインジケータを制御するプログラムです。

yaAGCとyaDSKY2をそれぞれ起動し(`make run`で共に起動します)、yaAGCで`run`すると`TEMP`インジケータが点灯します。

```
$ make run
yaDSKY2 &
yaAGC --port=19797 control_indicator.agc.bin
Apollo Guidance Computer simulation, ver. , built Aug 11 2016 16:57:40
Copyright (C) 2003-2009 Ronald S. Burkey, Onno Hommes.
yaAGC is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Refer to http://www.ibiblio.org/apollo/index.html for additional information.
(agc) 0x426d600x426e780x426f08Hostname=localhost, port=19797
yaDSKY is connected.

(agc) run
[New Thread 11]
[Switching to Thread 11]
```

![turn on temp light](https://raw.githubusercontent.com/cupnes/bare_metal_agc/030_control_indicator/turn_on_temp_light.png)

また、`CAF BIT4`をコメントアウト(行頭に'#'追加)し、`CAF BIT7`のコメントアウトを解除すると`OPR ERR`が点滅するようになります。

## ソースコードの簡単な説明 ##
`TEMP`を点灯させるための処理のみを抜粋すると以下のとおりです。

```
		CAF	BIT4		# turn on temp light
```

```
		EXTEND
		WOR	DSALMOUT
```

```
BIT4		OCT	00010
```

```
DSALMOUT	EQUALS	11
```

上記抜粋した中で3つ目の"WOR"命令でDSKYのインジケータを点灯させています。WOR命令はオペランドで指定されたI/Oチャンネルのアドレス上の内容とAレジスタの内容をOR演算で重ねあわせ、その結果をI/Oチャンネルのアドレス上とAレジスタへ格納します。

DSALMOUT(11)がインジケータが並ぶI/Oチャンネルのアドレスで、TEMPインジケータはBIT4で制御できます(そのためBIT4をCAF命令でAレジスタへ格納しています)。I/Oチャンネルアドレスと制御するためのビットフィールドについては[Virtual AGC Developer-info](http://www.ibiblio.org/apollo/developer.html#Table_of_IO_Channels)を参照してください。

WOR命令は拡張(EXTEND)の命令なので、WORの実行前にEXTEND命令を実行しています。(EXTEND命令は直後の命令を拡張命令と解釈する命令です。)

## 参考 ##
- [Virtual AGC Developer-Info Page](http://www.ibiblio.org/apollo/developer.html)
    - DSKYインジケータ制御方法の詳細は[yaAGC I/O Channel Specifics](http://www.ibiblio.org/apollo/developer.html#IO_Channel_Specifics)を参照
- [Virtual AGC Assembly-Language Manual](http://www.ibiblio.org/apollo/assembly_language_manual.html)
    - 各命令の詳細は[AGC4 Instruction Set](http://www.ibiblio.org/apollo/assembly_language_manual.html#AGC4_Instruction_Set)を参照
