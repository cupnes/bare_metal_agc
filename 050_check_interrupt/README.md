# 050_check_interrupt #
割り込みハンドラを設置し、割り込みの発生を確認するサンプルです。

```
$ make run
yaDSKY2 &
yaAGC --port=19797 check_interrupt.agc.bin
Apollo Guidance Computer simulation, ver. , built Aug 11 2016 16:57:40
Copyright (C) 2003-2009 Ronald S. Burkey, Onno Hommes.
yaAGC is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Refer to http://www.ibiblio.org/apollo/index.html for additional information.
0x426d600x426e780x426f08Hostname=localhost, port=19797
(agc) yaDSKY is connected.

(agc) step
IBOOT () at check_interrupt.agc:4
4       IBOOT           TCF     IBOOT
(agc) step
43      IDOWNRUPT       TCF     IDOWNRUPT       # DOWNRUPT
(agc) step
43      IDOWNRUPT       TCF     IDOWNRUPT       # DOWNRUPT
(agc)
```

## ソースコードの簡単な説明 ##

4000から始まるブート時の処理では、`RELINT`で割り込み有効化を行ったあと、無限ループです。

実は、4000以降は割り込みベクターで、割り込みを有効化すると、割り込み発生時、決められたアドレスへジャンプしてきます。

そのため、ブート時の処理以降は`NOOP`命令(NO OPeration:何もしない命令)をはさみながら、無限ループをいくつか設置しています。各割り込みのアドレスは[Interrupt Processing](http://www.ibiblio.org/apollo/assembly_language_manual.html#Interrupt_Processing)の表を参照してください。

上記の実行例では、4040のDOWNRUPT割り込みが発生したことがわかります。
