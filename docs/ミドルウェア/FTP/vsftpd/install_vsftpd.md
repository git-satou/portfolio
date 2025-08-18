## FTP インストール

```bash
yum install vsftpd
```

---

## 基本設定（`/etc/vsftpd/vsftpd.conf`）

### 匿名ユーザからの接続を拒否

```conf
anonymous_enable=NO
```

---

### アップロード時にグループの書き込み権限をデフォルトで付与させる

```conf
local_umask=002
```

---

### ログの形式を `vsftpd.log` に変更（詳細出力に対応）

```conf
xferlog_std_format=NO
```

---

### IPv4 を有効化

```conf
listen=YES
```

---

### IPv6 を無効化

```conf
listen_ipv6=NO
```

---

## パッシブモードを使用する場合の設定

```conf
pasv_enable=YES
pasv_address={自身のGIP}
pasv_min_port=65000
pasv_max_port=65535
```