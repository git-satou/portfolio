## 必要パッケージのインストール

```bash
yum install epel-release
yum install opendkim opendkim-tools
yum install libmemcached-awesome sendmail-milter
```

## opendkim
### /etc/opendkim.conf

```conf
#Mode  v
Mode  sv
```

```conf
#SoftwareHeader        yes
SoftwareHeader        no
```

```conf
Selector      default
# Selector    default
```

```conf
KeyFile       /etc/opendkim/keys/default.private
# KeyFile     /etc/opendkim/keys/default.private
```

```conf
# KeyTable    /etc/opendkim/KeyTable
KeyTable      /etc/opendkim/KeyTable
```

```conf
# SigningTable        refile:/etc/opendkim/SigningTable
SigningTable  refile:/etc/opendkim/SigningTable
```

```conf
# ExternalIgnoreList  refile:/etc/opendkim/TrustedHosts
ExternalIgnoreList    refile:/etc/opendkim/TrustedHosts
```

```conf
# InternalHosts       refile:/etc/opendkim/TrustedHosts
InternalHosts refile:/etc/opendkim/TrustedHosts
```

- ソケット通信からポート通信へ変更

```conf
#Socket local:/run/opendkim/opendkim.sock
Socket  inet:8891@localhost
```

### ドメインの設定
#### ディレクトリの作成

```bash
mkdir /etc/opendkim/keys/example.com
```

#### 鍵の発行

```bash
opendkim-genkey -D /etc/opendkim/keys/example.com/ -d example.com -s default
```

#### default.txtよりDNSにてTXTレコードを設定

```bash
cat /etc/opendkim/keys/example.com/default.txt 
```

#### 権限変更

```bash
chown -R opendkim. /etc/opendkim/keys/example.com
```

#### 鍵の読み込み
- /etc/opendkim/KeyTable

```conf
default._domainkey.example.com example.com:default:/etc/opendkim/keys/example.com/default.private
```

#### example.comをFromドメインとする全てのメールにDKIMを付与する
- /etc/opendkim/SigningTable

```conf
*@example.com default._domainkey.example.com
```

#### リレー元サーバからのメールに対して署名を許可(リレーサーバとして使用しないのであれば設定不要)
- /etc/opendkim/TrustedHosts

```conf
<許可IP>
```

### 起動

```bash
systemctl enable --now opendkim
```

## Postfix
### opendkimとの連携

- /etc/postfix/main.cf

```conf
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = inet:127.0.0.1:8891
milter_default_action = accept
```

### Postfix再起動

```bash
systemctl restart postfix
```