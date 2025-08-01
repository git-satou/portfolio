- /etc/systemd/system/log-backup-to-s3-on-shutdown.service

```
[Unit]
Description=Sync logs to S3 on shutdown
DefaultDependencies=no
Before=shutdown.target
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStop=/usr/local/sbin/log_backup_s3.sh
RemainAfterExit=true

[Install]
WantedBy=shutdown.target
```

- /usr/local/sbin/s3_sync.sh
IPやバケット名は環境によって変更してください。

```
#!/bin/bash

IP=$(ip -4 addr show | grep -oE '192\.168\.[0-9]+\.[0-9]+' | head -n1)
TEMPLATE_IP="192.168.0.1"
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
S3_BUCKET="s3://my-log-backup-s3/$(date +%Y%m%d)/${INSTANCE_ID}"

if [ "$IP" != "$TEMPLATE_IP" ]
then
    aws s3 sync --delete /var/log/ ${S3_BUCKET}/
fi
```

- 実行権限追加

```
chmod 744 /usr/local/sbin/s3_sync.sh
```

- 自動起動有効化

```
systemctl enable log-backup-to-s3-on-shutdown.service
```