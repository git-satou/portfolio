## 正規表現を使用しない設定方法
- メール転送したい 例）Toアドレスが hoge@example.com の場合はfuga@example.comへ転送

```conf
hoge:  fuga@example.com
```

 - シェルに渡す 例）Toアドレスが hoge@example.com の場合はshell.shに渡して処理する

```conf
hoge:  |"/home/hoge/shell.sh"
```

 - javaに渡す 例）Toアドレスが hoge@@example.com の場合はjavaに渡して処理する

```conf
hoge:  |"/usr/bin/java -jar /home/hoge/java.jar"
```

## 正規表現を使用した設定方法

　- main.cfでalias_mapsの設定を変更し、正規表現でのaliasを有効化する

```
alias_maps = hash:/etc/aliases
　　　　　　　　　　↓
alias_maps = hash:/etc/aliases,regexp:/etc/aliases.reg
```

/etc/aliases.regに正規表現でアドレスを指定し、その後に処理を追加する
　- メール転送したい 例）Toアドレスが piyo-12345678-9AB@example.com とかの場合はhoge@example.comへ転送

```
/^piyo-[0-9]{8}-[a-zA-Z0-9]{3}(@example.com)?$/ hoge@example.com
```

 - シェルに渡す 例）Toアドレスが piyo-12345678-9AB@example.com とかの場合はshell.shに渡して処理する

```
/^piyo-[0-9]{8}-[a-zA-Z0-9]{3}(@example.com)?$/  |"/home/hoge/shell.sh"
```

 - javaに渡す 例）Toアドレスが piyo-12345678-9AB@example.com とかの場合はjavaに渡して処理する

```
/^piyo-[0-9]{8}-[a-zA-Z0-9]{3}(@example.com)?$/  |"/usr/bin/java -jar /home/hoge/java.jar"
```

## 注意点
シェルやjavaのプログラムに渡す際はそのプログラムの権限の考慮が必要になる
デフォルトではnobodyで実行されるので、実行先プログラムのディレクトリ等の権限に注意されたし

- /etc/postfix/main.cf

```
# The default_privs parameter specifies the default rights used by
#default_privs = nobody
```