## yum でインストール

以下の公式ページにアクセスし、OSとバージョンを選択して表示されたコマンドを実行：

https://www.postgresql.org/download/linux/redhat/

---

## チューニング

DBサーバとしての推奨値のため、他のミドルウェアがある場合は要調整

### 外部接続を許可する場合

```conf
listen_addresses = 'localhost'
       ↓
listen_addresses = '*'
```

---

### キャッシュメモリサイズ

推奨値：**搭載メモリの 25% 程度**

```conf
shared_buffers = 128MB
       ↓
shared_buffers = 512MB
```

---

### ランダムページ読み込みコスト

目安値：**2.0〜3.0**

```conf
random_page_cost = 4.0
       ↓
random_page_cost = 2.0
```

---

### ディスクキャッシュ利用の推定値

目安（搭載メモリに対して）：

| メモリ | 推奨値              |
|--------|---------------------|
| 2GB    | 512MB               |
| 4GB    | 2GB                 |
| 8GB    | 4GB                 |

```conf
effective_cache_size = 4GB
       ↓
effective_cache_size = 512MB
```

---

### クエリログの記録

```conf
log_min_duration_statement = -1
       ↓
log_min_duration_statement = 1000
```

---

## 接続数の多いデータベース用：カーネルチューニング

```conf
net.core.rmem_max = 3145728
net.core.wmem_max = 3145728
net.ipv4.tcp_max_syn_backlog = 16384
net.core.netdev_max_backlog = 16384
net.core.somaxconn = 32768
```