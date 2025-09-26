## GUI
[このプログラム](https://gist.githubusercontent.com/ck-on/4959032/raw/ad6362bff017f3c59c96ab395e3308ed52650cab/ocp.php)を利用することで可視化可能。

## 確認

- メモリが足りないケース

```ini
; The OPcache shared memory storage size.
;opcache.memory_consumption=128
```

- キャッシュできるファイル数が足りないケース

```ini
; The maximum number of keys (scripts) in the OPcache hash table.
; Only numbers between 200 and 1000000 are allowed.
;opcache.max_accelerated_files=10000
```