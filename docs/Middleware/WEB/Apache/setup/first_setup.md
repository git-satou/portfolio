## インストール

```bash
yum -y install httpd httpd-devel
```

### HTTPS を使用する場合

```bash
yum -y install mod_ssl
```

### 自動起動の有効化

```bash
systemctl enable httpd
```

---

## VirtualHost の設定例

### HTTP 用

```apacheconf
<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    ServerAdmin admin
    DocumentRoot /var/www/example.com/html/
    CustomLog /var/log/httpd/example.com_access.log combined
    ErrorLog /var/log/httpd/example.com_error.log

    <Directory "/var/www/example.com/html/">
        Options +FollowSymLinks -Indexes
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

---

### HTTPS 用

```apacheconf
<VirtualHost *:443>
    ServerName example.com
    ServerAlias www.example.com
    ServerAdmin admin
    DocumentRoot /var/www/example.com/html/
    CustomLog /var/log/httpd/example.com_ssl_access.log combined
    ErrorLog /var/log/httpd/example.com_ssl_error.log

    SSLEngine on
    SSLProtocol all -SSLv2 -SSLv3
    SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA
    SSLCertificateFile /etc/httpd/ssl/example.com.crt
    SSLCertificateKeyFile /etc/httpd/ssl/example.com.key
    SSLCertificateChainFile /etc/httpd/ssl/example.com.ca

    <Directory "/var/www/example.com/html/">
        Options +FollowSymLinks -Indexes
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

---

## チューニング

### `/etc/httpd/conf/httpd.conf` 例

```conf
keepAlive off
ServerTokens Prod
```

---

### 上位にロードバランサー等がある場合

#### X-Forwarded-For ヘッダで IP 評価

```conf
RemoteIPHeader X-Forwarded-For
```

#### ログフォーマットの出力形式変更（viエディタ で置換）

```vim
:%s/LogFormat "%h/LogFormat "%a/g
```

#### HTTP/2 を無効化する（Safari + ALB の HTTPS 問題回避）

参考：https://dev.classmethod.jp/articles/resolve-safari-and-alb-https-connection-errors/

```bash
mv /etc/httpd/conf.modules.d/10-h2.conf{,.org}
```

---

#### Apache の書き込みにグループ権限を付与する場合

```bash
systemctl edit httpd
```

以下のみを記載（他の記述は削除）：

```ini
[Service]
UMask=002
```

---

## `.htaccess` による推奨設定

### HTTP → HTTPS へリダイレクト

#### 上位に LB が**ない**場合

```apacheconf
# HTTP to HTTPS
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)?$ https://%{HTTP:Host}%{REQUEST_URI} [L,R=302,NE]
```

#### 上位に LB が**ある**場合

```apacheconf
# HTTP to HTTPS
RewriteEngine On
RewriteCond %{HTTP:X-Forwarded-Proto} !https
RewriteRule ^(.*)?$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=302,NE]
```

---

### www の有無統一

#### `www` **なし**に統一

```apacheconf
# Redirect to not WWW
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www\.(.*) [NC]
RewriteRule ^(.*)$ https://%1%{REQUEST_URI} [L,R=302,NE]
```

#### `www` **あり**に統一

```apacheconf
# Redirect to WWW
RewriteEngine On
RewriteCond %{HTTP_HOST} !^www\. [NC]
RewriteRule ^(.*)$ https://www.%{HTTP_HOST}%{REQUEST_URI} [L,R=302,NE]
```