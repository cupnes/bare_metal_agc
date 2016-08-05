# Bare Metal Samples (AGC: Apollo Guidance Computer) #

AGCでベアメタルプログラミングを行ってみました。

以下に当Gitリポジトリのサンプルを試す際の環境構築などについてまとめます。

Wdinwos 10とDebian 8(共にamd64)で確認しています。

## AGCのソースコードのビルド・実行環境について ##

以下のものを使用します。

- ビルド環境(アセンブラ) :: yaYUL
- CPUエミュレータ :: yaAGC
- DSKYエミュレータ :: yaDSKY2
  - DSKY :: ディスプレイとキーボード一体型のAGCのインタフェース

---

## Windowsの場合 ##

### ビルド済実行バイナリのダウンロード・インストール ###

以下からインストーラーをダウンロードし、インストールしてください。

- [Virtual AGC Download Page](http://www.ibiblio.org/apollo/download.html#Downloads)
  - "VirtualAGC-installer"のリンクです

### パスを通す ###

アセンブラやエミュレータは、コマンドプロンプトあるいはPowerShellから使用します。

そのため、インストール先フォルダ直下にあるbinフォルダにパスを通しておくと便利です。

パスの通し方については、以下の記事が参考になりました。

- [PowerShell/環境変数のパスにパスを追加する - TOBY SOFT wiki](http://tobysoft.net/wiki/index.php?PowerShell%2F%B4%C4%B6%AD%CA%D1%BF%F4%A4%CE%A5%D1%A5%B9%A4%CB%A5%D1%A5%B9%A4%F2%C4%C9%B2%C3%A4%B9%A4%EB)
- [PowerShell で Profile を利用して スクリプトの自動読み込みをしてみよう - tech.guitarrapc.cóm](http://tech.guitarrapc.com/entry/2013/09/23/164357)
- [Tech TIPS：WindowsでPowerShellスクリプトの実行セキュリティポリシーを変更する - ＠IT](http://www.atmarkit.co.jp/ait/articles/0805/16/news139.html)

### このリポジトリのソースコードのビルド方法 ###

以下のようにビルド(アセンブル)を行います。

	> cd <ソースコードフォルダのパス>
	> yaYUL <ファイル名>.agc > <ファイル名>.lst

アセンブルが完了すると、「<ファイル名>.agc.bin」と「<ファイル名>.agc.symtab」が生成されています。

### 実行方法 ###

yaDSKY2はインストール先フォルダ直下のResourcesフォルダ内で実行する必要があるため、
別のコマンドコマンドあるいはPowerShellを立ち上げ、実行します。

	> cd <インストール先フォルダパス>\Resources
	> yaDSKY2

その後、yaAGCを先ほどアセンブルを行ったコマンドコマンドあるいはPowerShellで実行します。

	> yaAGC --port=19797 <ファイル名>.agc.bin

---

## Linux(Debian)の場合 ##

yaYUL・yaAGC・yaDKSY2は、Linux版もビルド済バイナリがあるのですが、
32ビット環境用の実行バイナリだったので、ソースコードからビルドしてみました。
(ロードする共有ライブラリのパスが32ビット環境用のパスでした。
32ビット用のクロスライブラリを配置しても良かったかもしれません。)

### インストールしたパッケージ ###

WxWidget関連のパッケージをインストールします。

	$ sudo apt-get install wx-common
	$ sudo apt-get install wx3.0-headers
	$ sudo apt-get install libwxgtk3.0-0
	$ sudo apt-get install libwxgtk3.0-0-dbg
	$ sudo apt-get install libwxgtk3.0-dev

### ソースコードについて ###

以下からソースコードをダウンロードします。
このソースコードアーカイブの中に、使用する全てのソースコードが入っています。

http://www.ibiblio.org/apollo/download.html#Downloads
※ "yaAGC-dev-20100220.tar.bz2"をダウンロード(2016/08/06 時点)

なお、展開したディレクトリ直下にMakefileがありますが、
サブディレクトリのMakefileには、Debian 8環境に対応していないものがあります。

そのため、以降の手順では、使いたいyaYUL・yaAGC・yaDSKY2の3つを
各サブディレクトリの中でそれぞれビルドします。
なお、上記3つの中では、Makefileの修正が必要なのはyaDSKY2のみでした。

### アセンブラ(yaYUL)のビルド ###

以下の手順でビルドできました。

	$ cd yaYUL
	$ make NVER='\"20100220\"' CFLAGS=-DALLOW_BSUB

ビルドが完了すると、実行バイナリ"yaYUL"が生成されています。

### CPUエミュレータ(yaAGC)のビルド ###

以下の手順でビルドできました。

	$ cd yaAGC
	$ make

ビルドが完了すると、実行バイナリ"yaAGC"が生成されています。

### DSKYエミュレータ(yaDSKY2)のビルド ###

以下のようにMakefileを修正してください。

```
--- Makefile.orig       2016-07-31 17:44:50.314242533 +0900
+++ Makefile    2016-07-31 17:48:36.612275979 +0900
@@ -86,9 +86,9 @@

 ${APPNAME}: ${SOURCES} ${HEADERS}
        g++ \
-               `wx-config ${WXSTATIC} --cxxflags` \
+               `/usr/lib/x86_64-linux-gnu/wx/config/gtk2-unicode-3.0 --cxxflags` \
                -o $@ ${SOURCES} \
-               `wx-config ${WXSTATIC} --libs` \
+               `/usr/lib/x86_64-linux-gnu/wx/config/gtk2-unicode-3.0 --libs` \
                ${LIBS2}
        strip $@${EXT}
```

その後、以下の手順でビルドできました。

	$ cd yaDSKY2
	$ make

ビルドが完了すると、実行バイナリ"yaDSKY2"が生成されています。

### パスを通す ###

yaYUL・yaAGC・yaDSKY2の3つのバイナリのパスを通してください。

例えば、以下のように/usr/bin/辺りにシンボリックリンクを作成すると良いです。

	$ ln -s /path/to/yaYUL /usr/bin/yaYUL
	$ ln -s /path/to/yaAGC /usr/bin/yaAGC

ただし、yaDSKY2だけはビルドしたディレクトリ直下で実行する必要があるため、
以下のようなシェルスクリプトを作成し、/usr/bin/yaDSKY2へ配置すると良いです。

```
#!/bin/sh
cd /path/to/yaDSKY2dir/
./yaDSKY2
```

### このリポジトリのソースコードビルド・実行方法 ###

このリポジトリのソースコードについて、各サブディレクトリにMakefileを用意していますので、以下のコマンドでビルド・実行可能です。

	$ make run
