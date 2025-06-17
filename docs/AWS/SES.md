## AWS管理画面から設定
SES画面より「IDの作成」をクリックし、作成後に各種DNSレコードを登録する

- <b>ID の詳細</b>
ID タイプ → ドメイン
ドメイン → 許可したいfromドメイン
カスタム MAIL FROM ドメインの使用 → チェック
MAIL FROM ドメイン → sesのサブドメインを設定

### タグ
必要であれば設定する

### バウンスメール自動ブラックリストの登録解除設定
- バウンスメールとなった宛先が自動でブラックリスト登録される設定
- 主にキャリアメールに多いが、端末側で拒否した場合もこのリストに入ってしまう事で想定外に送れなくなる事を防ぐ

サプレッションリスト - アカウントレベルの設定 → 編集より無効化

 ### SMTP専用のIAM作成
 - SMTP Settings → Create My SMTP Credentialsから簡単に作成できる
 
## EC2でのMTA(postfix)の設定

```
cp -ai /etc/postfix/main.cf{,.org}
postconf -e "relayhost = [email-smtp.ap-northeast-1.amazonaws.com]:587"
postconf -e "smtp_sasl_auth_enable = yes" "smtp_sasl_security_options = noanonymous" "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
postconf -e "smtp_use_tls = yes" "smtp_tls_loglevel = 1" "smtp_tls_security_level = encrypt" "smtp_tls_note_starttls_offer = yes" "smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt"
postconf -e "mynetworks = 127.0.0.0/8"
postconf -e "mydestination = localhost"
postconf -e "myhostname = {基本的にはカスタムfromで設定したドメインを指定}"
```

- /etc/postfix/sasl_passwd

```
[email-smtp.ap-northeast-1.amazonaws.com]:587 AKIAXO*********:BDVDWe6O*****************
```

```
postmap hash:/etc/postfix/sasl_passwd 
chmod 600 /etc/postfix/sasl_passwd*
```

```
systemctl restart postfix
```

## SES緩和申請(必要であれば)
デフォルトだと1秒あたりの送信数と1日あたりの送信リミットが設定されているので用途によって解除申請する

右上のアカウント - Service Quotas - AWSのサービス - Amazon Simple Email Service(Amazon SES)

Sending quotaを100000、Sending rateを90にする
※値は適当なのでよしなに