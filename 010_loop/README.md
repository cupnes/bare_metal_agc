# 010_loop #
「無限ループするだけ」という最も単純なAGCのサンプルプログラムです。

yaAGCでstep実行すると、無限ループで同じ行を繰り返し実行していることが確認できます。

```
$ make run
yaAGC loop.agc.bin
Apollo Guidance Computer simulation, ver. , built Aug  6 2016 04:07:23
Copyright (C) 2003-2009 Ronald S. Burkey, Onno Hommes.
yaAGC is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Refer to http://www.ibiblio.org/apollo/index.html for additional information.
(agc) step
LOOP () at loop.agc:2
2       LOOP            TCF     LOOP
(agc) step
2       LOOP            TCF     LOOP
(agc) step
2       LOOP            TCF     LOOP
(agc) 
```

## ソースコードの簡単な説明 ##
> 		SETLOC	4000

以降の処理を配置するメモリ上のアドレスを指定しています。AGCはメモリアドレス"4000"から実行を開始しますので、"4000"を指定しています。

なお、"4000"は8進表記です。8進数以外でも指定する方法があるのかも知れませんが、[Apollo-11号のソースコード](https://github.com/chrislgarry/Apollo-11)を見ている限り、数値はたいてい8進数で指定しているので、それに倣っています。

> LOOP		TCF	LOOP

ラベル"LOOP"を設定し、TCF命令で"LOOP"へジャンプします。"TC"は"Transfer Control"の略です。末尾の"F"はジャンプ先のメモリアドレスが"Fixed(read-only)"のメモリ領域であることを指定しています。

## 参考 ##

- [Virtual AGC Assembly-Language Manual](http://www.ibiblio.org/apollo/assembly_language_manual.html)
    - 各命令の詳細は[AGC4 Instruction Set](http://www.ibiblio.org/apollo/assembly_language_manual.html#AGC4_Instruction_Set)を参照
    - "Fixed(read-only)"や"Erasable(read-write)"など、AGCのメモリ管理については[Memory Map](http://www.ibiblio.org/apollo/assembly_language_manual.html#Memory_Map)を参照
