# Basic認証
## バージョン共通
### 認証のみ
```
# Basic Auth
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user
```

## Apache 2.2
### 認証 + IP制限
```
# Basic Auth
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user
Satisfy any
order deny,allow
allow from 192.168.2.165
deny from all
```

### 認証 + ディレクトリ制限
```
# Basic Auth
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user
<FilesMatch "(allow\.php)$">
Satisfy Any
Order allow,deny
Allow from all
</FilesMatch>
```

## Apache2.4
### 認証 + IP制限
```
# Basic Auth
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user
Require ip 192.168.0.0/16
```

### 特定のファイルへのアクセスのみ認証する(wp-login.php)
```
# Basic Auth
<FilesMatch "^(wp-login.php)$">
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user
</FilesMatch>
```

#### 特定のファイルへのアクセスは認証させない(admin-ajax.php)
```
# Basic Auth
AuthType Basic
AuthName "Basic Auth"
AuthUserFile "/var/www/.htpasswd"
require valid-user

<FilesMatch "^(admin-ajax.php)$">
Require all granted
</FilesMatch>
```