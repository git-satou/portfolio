## ソースからインストール
### https://tomcat.apache.org/
公式ページからソースをダウンロードし、インストールする
tomcatユーザーを作成し、解凍して設置すればOK

## 環境変数設定
### (設定例) /etc/sysconfig/tomcat

```
JAVA_HOME=/usr/local/java
JRE_HOME=/usr/local/java
TOMCAT_HOME=/usr/local/tomcat
JAVA_OPTS="-Xlog:gc*=info:file=/usr/local/tomcat/logs/gc.out:time,uptime,level,tags:filecount=5,filesize=5M -server -Xms2048M -Xmx2048M -Xss512k -verbose:gc -Djava.awt.headless=true"
UMASK=0002
```

### systemctl設定
- /etc/systemd/system/tomcat.serviceを新規で作成し下記を記載

```
[Unit]
Description=Apache Tomcat Servlet Container
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
EnvironmentFile=/etc/sysconfig/tomcat
ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh
KillMode=none

[Install]
WantedBy=multi-user.target
```

## JDBCドライバーのダウンロード
### MySQL
https://dev.mysql.com/downloads/connector/j/
Select Operating System を Platform Independent にすることでtar.gzファイルが手に入る

### PostgreSQL
https://jdbc.postgresql.org

## ApacheとTomcatの連携
### (例) /etc/httpd/conf.d/httpd-tomcat.conf
```
<VirtualHost *:80>
ServerName example.com
<Location />
    ProxyPass ajp://localhost:8009/
</Location>
</VirtualHost>
```
```
<VirtualHost *:443>
ServerName example.com
<Location />
    ProxyPass ajp://localhost:18009/
</Location>
</VirtualHost>
```

## server.xmlの修正
### (例) 8009ポートの有効化

```
    <Connector port="8009"
               maxThreads="700" minSpareThreads="25" connectionTimeout="90000"
               secretRequired="false" enableLookups="false" protocol="AJP/1.3"
               maxPostSize="5242880" />
```

### (例) 18009ポートの有効化

```
    <Connector port="18009"
               proxyPort="443" scheme="https" secure="true"
               maxThreads="700" minSpareThreads="25" connectionTimeout="90000"
               secretRequired="false" enableLookups="false" protocol="AJP/1.3"
               maxPostSize="5242880" />
```

## ログ関連の設定
### catalina.outの圧縮とローテート
#### /etc/logrotate.d/tomcat

```
/usr/local/tomcat/logs/catalina.out
{
    copytruncate
    daily
    rotate 30
    compress
    delaycompress
    missingok
    create 0664 tomcat tomcat
}
```

### catalina.out以外の圧縮とローテート
#### /root/sh/clean-up-tomcat-log.sh

```
#!/bin/bash

LOGDIR="/usr/local/tomcat/logs"

# gzip
find $LOGDIR -mtime +1 -type f -name "*.log" | xargs --no-run-if-empty gzip
find $LOGDIR -mtime +1 -type f -name "*.txt" | xargs --no-run-if-empty gzip

# delete
find $LOGDIR -mtime +30 -type f -name "*.log.gz" -delete
find $LOGDIR -mtime +30 -type f -name "*.txt.gz" -delete
```

#### cron設定

```
# Tomcat log clean up
00 02 * * * /root/sh/clean-up-tomcat-log.sh > /dev/null 2>&1
```

## その他
### RHEL9系のOSの場合
logrotateがsystemctlで制御されており、その中の「ProtectSystem=full」の設定により、/usr配下で書き込みが行えないためローテートが正常に動作しない。
そのため、tomcatのログはローテート出来るよう設定を追加する。

記述例) 

```
# systemctl edit tomcat

[Service]
ReadWritePaths=/usr/local/tomcat/logs
```