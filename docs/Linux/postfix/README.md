## opendkim.md

### 概要
postfixと連携し、Fromドメインを判定してDKIM署名を行う。
例としてドメインをexample.comとし、シグネチャーはdefaultとする。

### 環境
RHEL6系以降

## postfix-alias-handlers.md

### 概要
メールを受け取った際に、プログラムで処理されるように/etc/aliasesに追記する。
/etc/aliasesの設定後はnewaliasesコマンドを実行して反映させる。

### 環境
RHEL6系以降