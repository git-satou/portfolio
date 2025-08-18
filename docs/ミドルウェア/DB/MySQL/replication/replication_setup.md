## マスター側の設定

### `/etc/my.cnf`

```ini
[mysqld]
log-bin = mysql-bin
server-id = 1
```

### 設定の反映

```bash
systemctl restart mysqld
```

### MySQL 内での設定

```sql
-- レプリケーション用ユーザー作成（任意のパスワードを設定）
create user 'repl_user'@'%' identified by 'PASSWORD';
grant replication slave on *.* to repl_user@'%';

-- クローン用ユーザー作成（任意のパスワードを設定）
create user 'clone_user'@'%' identified by 'PASSWORD';
grant backup_admin on *.* to 'clone_user'@'%';

-- 権限反映
flush privileges;

-- プラグインのインストール
install plugin clone soname 'mysql_clone.so';
```

---

## レプリカ側の設定

### `/etc/my.cnf`

```ini
[mysqld]
log-bin = mysql-bin
relay-log = node01-relay-bin
relay-log-index = node01-relay-bin
server-id = 2
```

### 設定の反映

```bash
systemctl restart mysqld
```

### MySQL 内での設定

```sql
-- クローン用ユーザー作成（任意のパスワードを設定）
create user 'clone_user'@'%' identified by 'PASSWORD';
grant clone_admin on *.* to 'clone_user'@'%';

-- 権限反映
flush privileges;

-- プラグインのインストール
install plugin clone soname 'mysql_clone.so';
```

---

## レプリケーションの実行（クローン & レプリカ設定）

### レプリカ側 MySQL にて実施

```sql
-- MASTER の IP を指定
set global clone_valid_donor_list = '192.168.1.131:3306';

-- クローンの実行
clone instance from clone_user@192.168.1.131:3306 identified by 'PASSWORD';

-- クローンの進行状況を確認（STATE が Completed になればOK）
select ID, STATE, SOURCE, DESTINATION, BINLOG_FILE, BINLOG_POSITION 
from performance_schema.clone_status;
```

#### クローン完了時の表示例

```
+------+-----------+--------------------+----------------+------------------+-----------------+
| ID   | STATE     | SOURCE             | DESTINATION    | BINLOG_FILE      | BINLOG_POSITION |
+------+-----------+--------------------+----------------+------------------+-----------------+
|    1 | Completed | 192.168.1.131:3306 | LOCAL INSTANCE | mysql-bin.000001 |         257794  |
+------+-----------+--------------------+----------------+------------------+-----------------+
```

---

### レプリカ設定（レプリケーション開始）

```sql
-- レプリケーション元を設定（上記のBINLOG情報を利用）
change replication source to
  source_host = '192.168.1.131',
  source_log_file = 'mysql-bin.000001',
  source_log_pos = 257794;

-- レプリケーションユーザーで接続を開始
start replica user = 'repl_user' password = 'PASSWORD';

-- ステータス確認
show replica status\G
```