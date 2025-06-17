## rsyncをデーモンとして起動し定期的に同期する(設定例)
### rsyncされる側
- /etc/rsyncd.conf

```
[web]
path = /var/www/example.com/
comment = web
max connections = 4
lock file = /root/web-rsync.lock
uid = root
gid = root
read only = no
use chroot = no
hosts allow = 192.168.0.0/16
```

- 起動

```
systemctl start rsyncd
```

### rsyncする側(事前にドライランは実行しておく)
- /root/sh/rsync.sh

```
#!/bin/bash

rsync -avz --delete rsync://192.168.1.100/web/ /var/www/example.com/
```

- cron
※要挙動確認
```
# rsync to master
*/5 * * * * pgrep -fx "/bin/bash /root/sh/rsync.sh" > /dev/null || /root/sh/rsync.sh > /root/sh/rsync.log 2>&1
```