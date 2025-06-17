## 確認

```
 /usr/local/java/bin/keytool -v --list -keystore /usr/local/java/jre/lib/security/cacerts
```

## インストール

```
/usr/local/java/bin/keytool -import -trustcacerts -alias root -file {証明書(crt)ファイルパス} -keystore 
```