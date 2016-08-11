# 020_move_value_into_regA #
`010_loop`へ少し書き変え/書き足しを行った「レジスタAへ値"8"を格納する」サンプルです。

yaAGCで実行する際には、`info registers`でレジスタの中身を確認しながら`step`でステップ実行すると、プログラムの動きを確認できます。

```
$ make run
yaAGC move_value_into_regA.agc.bin
Apollo Guidance Computer simulation, ver. , built Aug  6 2016 04:07:23
Copyright (C) 2003-2009 Ronald S. Burkey, Onno Hommes.
yaAGC is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Refer to http://www.ibiblio.org/apollo/index.html for additional information.
(agc) info registers
A               0x0000  0
L               0x0000  0
Q               0x0000  0
EB              0x0000  0
FB              0x0000  0
Z               0x0800  2048
BB              0x0000  0
ARUPT           0x0000  0
LRUPT           0x0000  0
QRUPT           0x0000  0
ZRUPT           0x0000  0
BBRUPT          0x0000  0
BRUPT           0x0000  0
CHAN07          0x0000  0
CYR             0x0000  0
SR              0x0000  0
CYL             0x0000  0
EDOP            0x0000  0
INDEX           0x0000  0
EXTEND          0x0000  0
IRQMSK          0x0000  0
ISR             0x0000  0
(agc) step
END () at move_value_into_regA.agc:3
3       END             TCF     END
(agc) info registers
A               0x0008  8
L               0x0000  0
Q               0x0000  0
EB              0x0000  0
FB              0x0000  0
Z               0x0801  2049
BB              0x0000  0
ARUPT           0x0000  0
LRUPT           0x0000  0
QRUPT           0x0000  0
ZRUPT           0x0000  0
BBRUPT          0x0000  0
BRUPT           0x0000  0
CHAN07          0x0000  0
CYR             0x0000  0
SR              0x0000  0
CYL             0x0000  0
EDOP            0x0000  0
INDEX           0x0000  0
EXTEND          0x0000  0
IRQMSK          0x0000  0
ISR             0x0000  0
(agc) quit
```

## ソースコードの簡単な説明 ##

書き足した行は以下の2行です。

```
		CAF	OCT10
```

```
OCT10		OCT	10
```

"CA"は(Clear and Add)の略でメモリロケーション上の内容をAレジスタへ格納する命令です。末尾の"F"は"TCF"と同じく"Fixed(read-only)"のメモリ領域からロードすることを指定しています。オペランドの"OCT10"はレジスタAへロードするデータが格納されているアドレスを示すラベルです。"OCT10 OCT 10"の行で、"OCT(8進数指定)"で"10(10進数で8)"というデータを配置し、"OCT10"というラベルをつけています。

なお、[GitHubに公開されているApollo-11号ソースコード](https://github.com/chrislgarry/Apollo-11)を読んでいる限り、AGCに即値の概念は無い様です。演算等に使用する値は全てメモリ上からアドレス指定で読み書きしている様に見えます。(例えば、[1、2、3などの数字も定義している場所があり](https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/FIXED_FIXED_CONSTANT_POOL.agc#L225)、これらの値を使用する際は、この場所のアドレスをラベルで指定しています。)

```
END		TCF	END
```

ここは`010_loop`からラベル名を変えただけです。このように無限ループを配置しておかないと、CPUは次へ次へとメモリ上のデータを「命令」と解釈して実行しようとしてしまうため、プログラムの最後には無限ループを配置します。

## 参考 ##
- [Virtual AGC Assembly-Language Manual](http://www.ibiblio.org/apollo/assembly_language_manual.html)
    - 各命令の詳細は[AGC4 Instruction Set](http://www.ibiblio.org/apollo/assembly_language_manual.html#AGC4_Instruction_Set)を参照
    - "Fixed(read-only)"など、AGCのメモリ管理については[Memory Map](http://www.ibiblio.org/apollo/assembly_language_manual.html#Memory_Map)を参照
