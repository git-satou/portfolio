## インストール

---

### PHP8.1 for Amazon Linux 2

```bash
amazon-linux-extras enable php8.1
yum -y install php php-pecl-mcrypt php-mbstring php-mysqlnd php-pgsql php-xml php-pear php-opcache php-devel php-pecl-zip php-gd
```

---

### PHP8.1 for RHEL 9

```bash
yum module enable php:8.1
yum -y install php php-fpm php-mbstring php-mysqlnd php-pgsql php-xml php-pear php-opcache php-devel php-pecl-zip php-gd
```

---

## php.ini のチューニング

- PHP タグを短縮記法で記述可能にする(必要があれば)

```ini
short_open_tag = On
```

- レスポンスヘッダから PHP バージョンを隠す

```ini
expose_php = Off
```

- POST データの最大サイズを変更

```ini
post_max_size = 128M
```

- アップロード可能なファイルの最大サイズを変更

```ini
upload_max_filesize = 128M
```

- タイムゾーンを日本時間に設定

```ini
date.timezone = Asia/Tokyo
```

- マルチバイト言語対応（日本語）

```ini
mbstring.language = Japanese
```