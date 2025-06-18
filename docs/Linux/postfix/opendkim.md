## 必要パッケージのインストール

```
yum install epel-release
yum install opendkim opendkim-tools
yum install libmemcached-awesome sendmail-milter
```

## opendkimの設定
### /etc/opendkim.conf
- 変更箇所のみ記載

```
Mode  sv
SoftwareHeader        no
# Selector    default
# KeyFile     /etc/opendkim/keys/default.private
KeyTable      /etc/opendkim/KeyTable
SigningTable  refile:/etc/opendkim/SigningTable
ExternalIgnoreList    refile:/etc/opendkim/TrustedHosts
InternalHosts refile:/etc/opendkim/TrustedHosts
```

- ソケット通信からポート通信へ変更

```
Socket  inet:8891@localhost
#Socket local:/run/opendkim/opendkim.sock
```

### DKIMさせるドメインの設定

- ドメイン単位でのDKIM用ディレクトリの作成

```
mkdir /etc/opendkim/keys/example.com
```

- DKIM発行

```
opendkim-genkey -D /etc/opendkim/keys/example.com/ -d example.com -s default
```

- 発行されたディレクトリにTXTレコードが記載されているので登録する

```
cat /etc/opendkim/keys/example.com/default.txt 
```

- 権限変更

```
chown -R opendkim. /etc/opendkim/keys/example.com
```

### /etc/opendkim/KeyTable
- 読み込みさせる

```
default._domainkey.example.com example.com:default:/etc/opendkim/keys/example.com/default.private
```

### /etc/opendkim/SigningTable
- example.comをFromドメインとする全てのメールにDKIMを付与する

```
*@example.com default._domainkey.example.com
```

- リレー元サーバからのメールに対して署名を許可(リレーサーバとして使用しないのであれば設定不要)
### /etc/opendkim/TrustedHosts

```
{許可したいIP}
```

### opendkimを自動起動設定し起動

```
systemctl enable --now opendkim
```

## Postfix
### opendkimと連携

- /etc/postfix/main.cf

```
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = inet:127.0.0.1:8891
milter_default_action = accept
```

- Postfix再起動

```
systemctl restart postfix
```

### テストメール送信
Gmailなどに送信してソースヘッダを開き、DKIMが付与されているか確認する