## rsyncをデーモンとして起動し定期的に同期する(設定例)

### rsyncされる側
- /etc/rsyncd.conf

```bash
[web]
path = /var/www/example.com/
max connections = 4
uid = root
gid = root
read only = no
use chroot = no
hosts allow = 192.168.0.0/16
```

- 起動

```bash
systemctl start rsyncd
```

### rsyncする側(事前にドライランは実行しておく)
- /root/sh/rsync.sh

```bash
#!/bin/bash

rsync -avz --delete rsync://192.168.1.100/web/ /var/www/example.com/
```

- cron

```bash
*/5 * * * * pgrep -fx "/bin/bash /root/sh/rsync.sh" > /dev/null || bash -c '/root/sh/rsync.sh | ts '[\%Y-\%m-\%d \%H:\%M:\%S]' > /var/log/rsync/rsync.log 2>&1'
```