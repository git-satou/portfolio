
## インストール手順

### RPMを取得

```bash
cd /usr/local/src
wget https://vault.centos.org/7.9.2009/os/Source/SPackages/dovecot-2.2.36-8.el7.src.rpm
```

### 環境作るのに必要なものをyumでインストール

```
yum install rpm-build
yum install pam-devel bzip2-devel libcap-devel libtool autoconf automake sqlite-devel postgresql-devel mysql-devel openldap-devel quota-devel gettext-devel clucene-core-devel libcurl-devel xz-devel tcp_wrappers-devel expat-devel portreserve
```

### RPMをインストール

```
# warning: user/group mockbuild does not exist と出るが、root直下にインストールされるので問題はない
rpm -ihv dovecot-2.2.36-8.el7.src.rpm
cd
```

### specファイルの編集
- configure のオプション内に「–with-vpopmail」を入れる

```
# vi rpmbuild/SPECS/dovecot.spec

%configure                       \
    --with-vpopmail              \ ← 追加
```

### コンパイル(パッケージ作成)

```
rpmbuild -bb --clean rpmbuild/SPECS/dovecot.spec
```

### 作成されたパッケージをインストール

```
rpm -Uhv rpmbuild/RPMS/x86_64/dovecot-2.2.36-8.el7.x86_64.rpm
```

### yumでアップデートされないように

```
# vi /etc/yum.conf

exclude=dovecot
```

### confの設定
- /etc/dovecot/dovecot.conf

```
#protocols = imap pop3 lmtp
protocols = imap pop3
```

- /etc/dovecot/conf.d/10-auth.conf
 - 「!include auth-system.conf.ext」をコメントアウト
 - 「!include auth-vpopmail.conf.ext」をアンコメント

 ```
#!include auth-system.conf.ext
#!include auth-sql.conf.ext
#!include auth-ldap.conf.ext
#!include auth-passwdfile.conf.ext
#!include auth-checkpassword.conf.ext
!include auth-vpopmail.conf.ext
#!include auth-static.conf.ext
 ``` 

 - 「disable_plaintext_authの無効化」

 ```
disable_plaintext_auth = no
 ```


- /etc/dovecot/conf.d/10-ssl.conf

```
ssl = required
     ↓
ssl = no
```

### サービスの起動＆自動起動

```
systemctl start dovecot
systemctl enable dovecot
```

### テストアカウントで受信確認
- POPとIMAPの両方で確認しよう

## 注意点

 ### /home/vpopmail/etc/open-smtp について

/home/vpopmail/etc/open-smtpをdovecotが書き換える際にオーナーがroot:root、権限が600になってしまいpostfixのvpopmailユーザーが書き込めなくなってしまう。

ソースをいじって修正する以外の方法では、下記のようなcronでごり押すしかない…

```
# open-smtp for dovecot
* * * * * /root/sh/open-smtp.sh > /dev/null 2>&1
```

```
cat /root/sh/open-smtp.sh 
#!/bin/sh

chown vpopmail:vchkpw /home/vpopmail/etc/open-smtp
```

dovecotをソースインストールする場合は
下記ファイルを変更してからコンパイルすることでも解消出来る。

・対象ファイル
dovecot-2.3.11.3/src/auth

下記を追記

```
                        char *opstchown = "chown vpopmail:vchkpw /home/vpopmail/etc/open-smtp";
                        int opstres;
                        opstres = system(opstchown);
```

- 修正前
```
#ifdef POP_AUTH_OPEN_RELAY
        if (strcasecmp(request->service, "POP3") == 0 ||
            strcasecmp(request->service, "IMAP") == 0) {
                const char *host = net_ip2addr(&request->remote_ip);
                /* vpopmail 5.4 does not understand IPv6 */
                if (host[0] != '\0' && IPADDR_IS_V4(&request->remote_ip)) {
                        /* use putenv() directly rather than env_put() which
                           would leak memory every time we got here. use a
                           static buffer for putenv() as SUSv2 requirements
                           would otherwise corrupt our environment later. */
                        static char ip_env[256];

                        i_snprintf(ip_env, sizeof(ip_env),
                                   "TCPREMOTEIP=%s", host);
                        putenv(ip_env);
                        open_smtp_relay();
                }
        }
#endif
```

- 修正後

```
#ifdef POP_AUTH_OPEN_RELAY
        if (strcasecmp(request->service, "POP3") == 0 ||
            strcasecmp(request->service, "IMAP") == 0) {
                const char *host = net_ip2addr(&request->remote_ip);
                /* vpopmail 5.4 does not understand IPv6 */
                if (host[0] != '\0' && IPADDR_IS_V4(&request->remote_ip)) {
                        /* use putenv() directly rather than env_put() which
                           would leak memory every time we got here. use a
                           static buffer for putenv() as SUSv2 requirements
                           would otherwise corrupt our environment later. */
                        static char ip_env[256];

                        i_snprintf(ip_env, sizeof(ip_env),
                                   "TCPREMOTEIP=%s", host);
                        putenv(ip_env);
                        open_smtp_relay();
                        char *opstchown = "chown vpopmail:vchkpw /home/vpopmail/etc/open-smtp";
                        int opstres;
                        opstres = system(opstchown);
                }
        }
#endif
```

## エラーナレッジ

↓こんなエラーがmaillogで出たら
```
Error: Mail access for users with UID 509 not permitted (see first_valid_uid in config file, uid from userdb lookup).
```

↓こんな感じで修正

```
vi /etc/dovecot/conf.d/10-mail.conf

first_valid_uid = 1000
　　　↓
first_valid_uid = 500
```