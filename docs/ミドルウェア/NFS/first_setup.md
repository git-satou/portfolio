## <font color=blue>サーバ側</font>
### インストール
```
yum install nfs-utils
```

### マウント元の許可設定
- /etc/exports
 
 ```
 /var/www/html 192.168.0.0/16(rw,async,no_root_squash)

 ```

### 設定反映
```
exportfs -ra
```

### 設定確認
```
exportfs -v
```

### チューニング
#### nfsのデーモンの数を変更する(Redhat 7系)
- /etc/sysconfig/nfs 
```
RPCNFSDCOUNT=32
```

#### nfsのデーモンの数を変更する(Redhat 9系)
- /etc/nfs.conf
```
[nfsd]
threads=32
```

### 起動
```
systemctl enable --now nfs
```

## <font color=red>クライアント側</font>
### チューニング
#### マウントのバージョンの切り替え
- /etc/nfsmount.conf

```
Defaultvers=4
　　　↓
Defaultvers=3
```

### mount

```
/bin/mount -t nfs 192.168.1.161:/var/www/html /var/www/html
```

### マウント状況の確認
```
nfsstat -m
```