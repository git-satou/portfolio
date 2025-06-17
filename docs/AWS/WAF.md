## <font color=blue>【AWS】</font>Web ACLの新規作成

### **WAF & Shield -> Web ACLs**
プルダウンをcloudfrontまたはALBのリージョンに合わせ「Create web ACL」 を押す
設定内容について、変更箇所がある場合のみ記載する

#### Describe web ACL and associate it to AWS resources
- **Name**
例) wafcharm-hogehoge
- **Description**
例) wafcharm-hogehoge
- **CloudWatch metric name**

## <font color=blue>【AWS】</font>wafcharmロールの作成
Credential -> 登録 Assume Role 方式

やり方書いてあるのでそっち見てね

## <font color=blue>【AWS】</font>弾くためのログ出力設定
###  Cloud Frontの場合
- **出力先パケットの作成**
※なかったら作って下さい
例)hogehoge-cloudfront-log

- **ACLを有効化し、特定の外部アカウントを許可する**
 https://dev.classmethod.jp/articles/cloudfront-access-log-dont-choose-no-acl-s3-bucket/

- **cloudfrontの初期設定時**
***Standard logging***のログ配信をオンにする
***Cookie logging***はオフのまま、***Deliver to***は***Amazon S3***を選択し
***Destination log group***にはドメイン名を入力する
<p>例)hoge.com</p>
 この場合、選択したS3のサブディレクトリとしてログが保存される<br>
 また、初回のログ出力時にディレクトリが作成されるため、手動で作成する必要はない

### ALBの場合
- 出力先パケットの作成
※なかったら作って下さい。デフォルトの暗号化は無効で設定
例)hogehoge-alb-log

- パケットポリシーに許可のためのjson記述が必要
https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html

 - ログプレフィックスはサブディレクトリを指定する
    例) hogehoge-alb/

## <font color=red>【WAF】</font>Config -> Credential
#### IAM Roleを新規作成して登録する ####
やったことないでござる

#### 既存のIAM Roleを登録する ###
「IAM Roleの信頼ポリシーを生成する」をクリックし、出てきた内容でIAM Roleを作成する
ロールの名前は「WafCharmAssumeRole」にする。登録する流れは省略

検証してうまくいけばOK

## <font color=red>【WAF】</font>Config -> WAF
新規登録
#### Web ACL選択
流れで

#### 基本設定
特に変更する箇所はない

#### ルール設定
AllowリストにうちのIPを入れておく

#### ログ・通知設定
アクセスログ連携設定は「WAFのログを出力させ、レポートを作成する」の対応後、こちらも更新する
WAFログアラートは「WafCharmルールでの検知通知」をONにして、通知先メールアドレスを記載する

## <font color=blue>【AWS】</font>WAF & Shield の設定
Web ACLs をクリックし
Global(CloudFront)またはALBなら対象リージョンに切り替えて
Associated AWS resources から「Add AWS resources」をクリックし
作成したものを追加する

## アタックする
- `curl https://hogefugapiyo.com/?cmd=cat%20/etc/passwd`
　WAFに弾かれてるっぽいログが出ればOK

## <font color=blue>【AWS】</font>WAFのログを出力させ、レポートを作成する
https://console.wafcharm.com/ja/help/configuring_waf_logs_old_method_aws_v2_ja

※cloudwatchに保存されるwafcharm-waflogの期間を変更しておく