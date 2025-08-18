## 必要なdevelのインストール

```
yum install augeas-devel
```

## 仮想環境の作成

```
/usr/local/Python-3.12.4/bin/python3.12 -m venv /opt/certbot/
```

## certbotのインストール
cryptographyはバージョン指定しないとエラーになる

```
/opt/certbot/bin/pip install --upgrade pip
/opt/certbot/bin/pip install certbot certbot-apache cryptography==3.4.1
```

## 確認

```
/opt/certbot/bin/certbot renew --dry-run
```