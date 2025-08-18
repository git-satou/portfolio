## インストール手順

### MySQL リポジトリ RPM のインストール

- OSバージョンと相談する

リポジトリURL（公式）：https://dev.mysql.com/downloads/repo/yum/

### バージョンを切り替える

####  MySQL 5.7 をインストールしたい場合

```bash
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
```

#### MySQL 8.0 をインストールしたい場合

```bash
yum-config-manager --disable mysql57-community
yum-config-manager --enable mysql80-community
```

---

### バージョン確認（念のため）

```bash
yum info mysql-community-server
```

---

### MySQL サーバのインストール

```bash
yum -y install mysql-community-server mysql-community-devel
```

### クライアントだけ必要な場合

```bash
yum -y install mysql-community-client
```

---

### GPG エラー対処（出た場合）

エラー例：  
`GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql`

対処：

```bash
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
```

---

## MySQL 起動と初期設定

### サービス起動と自動起動設定

```bash
systemctl enable --now mysqld
```

---

### 初期パスワードの確認

```bash
grep "temporary password" /var/log/mysqld.log
```

---

### セキュアインストールの実行

```bash
mysql_secure_installation
```

実行ログ例：

```text
Enter password for user root:  ← [ログから取得した初期パスワード]

New password:  ← [新しいパスワード]
Re-enter new password:  ← [再入力]

Change the password for root ? : No
Remove anonymous users? : y
Disallow root login remotely? : y
Remove test database and access to it? : y
Reload privilege tables now? : y

All done!
```

---

## チューニング（任意）

### スロークエリ関連

- `mysql-slow.log` を利用する場合は、ファイルを事前に作成し、`mysqld.log` と同じオーナー・権限に設定しておくこと。

```ini
[mysqld]

log_timestamps = SYSTEM
slow_query_log = ON
slow_query_log-file = /var/log/mysql-slow.log
long_query_time = 1
```

### バッファサイズの変更
- DB専用サーバの場合、メモリの半分ほど割り当てる

```ini
innodb_buffer_pool_size = 1GB
```