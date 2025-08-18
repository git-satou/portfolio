## モジュール確認

```
# /usr/local/php-5.2.17/bin/php -m
```

## インストール
- PHPソースディレクトリにあるインストールするモジュール配下へ移動

```
# cd /usr/local/src/php-5.2.17/ext/curl
```

- phpize

```
# /usr/local/php-5.2.17/bin/phpize
```

- cofigure & make & install

```
# ./configure --with-curl=/usr/local/curl --with-php-config=/usr/local/php-5.2.17/bin/php-config
# make
# make install

Installing shared extensions: /usr/local/php-5.2.17/lib/php/extensions/no-debug-non-zts-20060613/
```

## php.iniへの反映

- php.iniファイルを見つける

```
# php -i | grep php.ini
```

- php.iniの編集

```
extension_dir = "/usr/local/php-5.2.17/lib/php/extensions/no-debug-non-zts-20060613/"
extension=curl.so
```

- php -i で確認

```
# php -i | grep curl
```
