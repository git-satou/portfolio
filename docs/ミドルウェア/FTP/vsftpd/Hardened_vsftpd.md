## インストールを設定変更
### パッケージインストール

```
yum install vsftpd
```

### vsftpd.confの修正

```
# 匿名ユーザの拒否
anonymous_enable=NO

# umaskの変更
local_umask=002

# ipv4でlistenさせる
listen=YES
listen_ipv6=NO

# chrootの有効化
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list

# chroot時の接続ディレクトリ指定
user_config_dir=/etc/vsftpd/user_config_dir

# 接続時に逆引きしない設定
reverse_lookup_enable=NO

# chrootディレクトリが書き込み可能でも許可する
allow_writeable_chroot=YES

# ログのフォーマットをvsftpd形式に変更
xferlog_std_format=NO
vsftpd_log_file=/var/log/vsftpd.log

# パッシブモードでのポート指定
pasv_min_port=60000
pasv_max_port=61000

#必要があれば
pasv_address={自身のGIP}

# SSL有効化
ssl_enable=YES

# 使用プロトコル
ssl_sslv2=NO
ssl_sslv3=NO
ssl_tlsv1=NO
ssl_tlsv1_1=NO
ssl_tlsv1_2=YES
ssl_tlsv1_3=YES

# 暗号化方式
ssl_ciphers=kEECDH+AESGCM+AES128:kEECDH+AESGCM:kEECDH+AES128:kEECDH+AES:!aNULL:!eNULL:!LOW:!EXP

# 証明書設定(rsa_cert_fileは証明書＋中間証明書)
rsa_cert_file=/etc/letsencrypt/live/example.com/fullchain.pem
rsa_private_key_file=/etc/letsencrypt/live/example.com/privkey.pem
```

### pam(vsftpd)の変更
- /etc/pam.d/vsftpd

```
#account    include    password-auth
account    required     pam_access.so accessfile=/etc/security/vsftpd_access.conf
```

### vsftpd_access.confの追加

- /etc/security/vsftpd_access.conf

```
+:hoge:192.168.1.1 192.168.2.1
+:fuga:192.168.3.1 192.168.4.1
-:ALL:ALL
```

下記のような記述でも可

```
-:hoge:ALL EXCEPT 192.168.1.100
-:fuga:ALL EXCEPT 192.168.1.101
-:ALL:ALL
```

### chroot設定

```
mkdir /etc/vsftpd/user_config_dir
```

- /etc/vsftpd/chroot_list
chrootしたいユーザを追記

- /etc/vsftpd/user_config_dir/hoge
chrootしたいユーザ名ファイルを作成し

chroot先を接続させたいディレクトリに指定し、読み込み専用に設定

```
local_root={ディレクトリ}
write_enable=NO
```

### 反映

```
systemctl restart vsftpd
```