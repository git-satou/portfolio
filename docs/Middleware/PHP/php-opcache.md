## 調査
### GUIツールの導入
視覚的にわかりやすいよう、以下のphpプログラムを利用する。
[外部リンク](https://gist.githubusercontent.com/ck-on/4959032/raw/ad6362bff017f3c59c96ab395e3308ed52650cab/ocp.php)

### 確認
hitsグラフを確認し、90%以下の場合はチューニングする余地がある。

- メモリが足りないケース
memoryグラフのfreeが0%に近い場合、メモリ割り当てが足りていない。
以下の値を変更する。

```
; The OPcache shared memory storage size.
;opcache.memory_consumption=128
```

- キャッシュできるファイル数が足りないケース
keyグラフのfreeが0%に近い場合、キャッシュ対象となるファイルが上限値になっている。
以下の値を変更する。

```
; The maximum number of keys (scripts) in the OPcache hash table.
; Only numbers between 200 and 1000000 are allowed.
;opcache.max_accelerated_files=10000
```