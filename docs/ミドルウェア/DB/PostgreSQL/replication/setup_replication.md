## マスターサーバで設定

### postgresql.conf

```conf
listen_addresses = '*'
archive_mode = on 
archive_command= '/bin/cp %p /var/lib/pgsql/pg_archive/%f'
restore_command = 'rsync -az rsync://restoredb/archive/%f %p'
```

### pg_archive ディレクトリの作成

```bash
mkdir /var/lib/pgsql/pg_archive
chmod 700 /var/lib/pgsql/pg_archive
chown postgres:postgres /var/lib/pgsql/pg_archive
```

### pg_hba.conf

```conf
host    replication     repl_user       192.168.0.1/32         md5 
host    replication     repl_user       192.168.0.2/32         md5 
```

## 起動

```bash
systemctl start postgresql
```

## postgresへログインし、レプリケーションユーザーを作成

```sql
create role repl_user login replication password '********'; 
```

## スタンバイサーバで設定 
### マスターデータをコピー

```bash
pg_basebackup -h {IP} -p {Port} -U repl_user -D /var/lib/pgsql/data -X fetch --progress --verbose -R
```

### postgresql.conf

```bash
hot_standby = on
hot_standby_feedback = on
```

## 起動 

```
systemctl start postgresql
```