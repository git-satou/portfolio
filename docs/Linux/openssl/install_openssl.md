## ソースをダウンロードして解凍

```
cd /usr/local/src
wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz
tar zxvf openssl-1.0.2u.tar.gz
```

## configure & install

```
cd openssl-1.0.2u
./config --prefix=/usr/local/openssl-1.0.2u shared zlib
make
make install
```

## 共有ライブラリへの追加

```bash
vi /etc/ld.so.conf.d/openssl-1.0.2u.conf
```

- 追記
```conf
/usr/local/openssl-1.0.2u/lib
```

```bash
ldconfig
```

## バージョン、対応プロトコル確認

```
/usr/local/openssl-1.0.2u/bin/openssl version
OpenSSL 1.0.2u  20 Dec 2019

/usr/local/openssl-1.0.2u/bin/openssl ciphers -v
ECDHE-RSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AESGCM(256) Mac=AEAD
ECDHE-ECDSA-AES256-GCM-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AESGCM(256) Mac=AEAD
ECDHE-RSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA384
ECDHE-ECDSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA384
ECDHE-RSA-AES256-SHA    SSLv3 Kx=ECDH     Au=RSA  Enc=AES(256)  Mac=SHA1
ECDHE-ECDSA-AES256-SHA  SSLv3 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA1
(略)
```