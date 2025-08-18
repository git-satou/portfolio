## CORS設定
許可するオリジンを受け側のドメインにて設定する。
設定としては対象バーチャルホスト内に下記の様な記述を追加すればよい

```
Header set Access-Control-Allow-Headers "Content-Type"
Header set Access-Control-Allow-Origin "http://example.com"
```

複数オリジン許可する場合は下記のように書きたくなるが
この場合片方しか反映されない。

```
Header set Access-Control-Allow-Headers "Content-Type"
Header set Access-Control-Allow-Origin "http://example.com"
Header set Access-Control-Allow-Origin "http://example.jp"
```

複数登録したい場合は下記のように
SetEnvIfを利用してAccess-Control-Allow-Originに読み込ませる

```
# リクエストのOriginヘッダが指定ドメイン場合はAccessControlAllowOrigin変数へOriginドメインをセット
SetEnvIf Origin "^http://example.com$" AccessControlAllowOrigin=$0
SetEnvIf Origin "^http://example.jp$" AccessControlAllowOrigin=$0
# AccessControlAllowOrigin変数が空ではない場合、Access-Control-Allow-OriginレスポンスヘッダへAccessControlAllowOrigin変数の値をセット
Header set Access-Control-Allow-Origin %{AccessControlAllowOrigin}e env=AccessControlAllowOrigin
# AccessControlAllowOrigin変数が空ではない場合、Access-Control-Allow-Credentialsレスポンスヘッダへtrueをセット
Header set Access-Control-Allow-Credentials true env=AccessControlAllowOrigin
```

httpとhttpsどちらも来る可能性がある場合は
下記のようにどちらも登録する必要がある。

```
SetEnvIf Origin "^http://example.com$" AccessControlAllowOrigin=$0
SetEnvIf Origin "^https://example.com$" AccessControlAllowOrigin=$0
```

特定ディレクトリのみCORS設定したい場合は
Locationで囲んだ中で設定を行えばよい。