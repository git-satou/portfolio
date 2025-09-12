## インストール

```bash
yum -y install vsftpd
```

## /etc/vsftpd/vsftpd.conf
### 匿名ユーザからの接続を拒否

```conf
anonymous_enable=NO
```

### アップロード時にグループの書き込み権限をデフォルトで付与させる

```conf
local_umask=002
```

### ログの形式を `vsftpd` に変更

```conf
xferlog_std_format=NO
```

### IPv4 を有効化

```conf
listen=YES
```

### IPv6 を無効化

```conf
listen_ipv6=NO
```

## パッシブモードを使用する場合

```conf
pasv_enable=YES
pasv_min_port=65000
pasv_max_port=65535

# 必要であれば、pasv_addressも設定する
```