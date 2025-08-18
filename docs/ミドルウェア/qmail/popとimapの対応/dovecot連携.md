
## インストール手順
### 環境作るのに必要なものをyumでインストール

```
yum install rpm-build pam-devel bzip2-devel libcap-devel libtool autoconf automake sqlite-devel postgresql-devel mysql-devel openldap-devel quota-devel gettext-devel clucene-core-devel libcurl-devel xz-devel tcp_wrappers-devel expat-devel portreserve
```

### RPMインストール

```bash
cd /usr/local/src
wget https://vault.centos.org/7.9.2009/os/Source/SPackages/dovecot-2.2.36-8.el7.src.rpm
rpm -ihv dovecot-2.2.36-8.el7.src.rpm
```

### specファイルの編集
- vi /root/rpmbuild/SPECS/dovecot.spec

```conf
# 追記
%configure                       \
    --with-vpopmail              \
```

### コンパイル(パッケージ作成)

```bash
rpmbuild -bb --clean /root/rpmbuild/SPECS/dovecot.spec
```

### 作成されたパッケージをインストール

```bash
rpm -Uhv /root/rpmbuild/RPMS/x86_64/dovecot-2.2.36-8.el7.x86_64.rpm
```

### yumでアップデートされないように
- vi /etc/yum.conf

```conf
exclude=dovecot
```

### confの設定
- /etc/dovecot/dovecot.conf

```conf
#protocols = imap pop3 lmtp
protocols = imap pop3
```

- /etc/dovecot/conf.d/10-auth.conf

```conf
!include auth-system.conf.ext
#!include auth-system.conf.ext
```

```conf
#!include auth-vpopmail.conf.ext
!include auth-vpopmail.conf.ext
```

```conf
disable_plaintext_auth = no
```

- /etc/dovecot/conf.d/10-ssl.conf

```conf
#ssl = required
ssl = no
```

### サービスの起動＆自動起動

```bash
systemctl enable --now dovecot
```

## その他
### /home/vpopmail/etc/open-smtp について

/home/vpopmail/etc/open-smtpをdovecotが書き換える際にオーナーがroot:root、権限が600になってしまいpostfixのvpopmailユーザーが書き込めなくなってしまうため、対処法として以下のcronを設定する。  

```
# open-smtp for dovecot
* * * * * /usr/bin/chown vpopmail:vchkpw /home/vpopmail/etc/open-smtp
```

dovecotをソースインストールする場合は、設定ファイルを変更してからコンパイルすることでcronを使わずに解消出来る。

- dovecot-2.3.11.3/src/auth (修正前)
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

- dovecot-2.3.11.3/src/auth (修正後)

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