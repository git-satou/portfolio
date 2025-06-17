## hpacucliのインストール

```bash
wget http://downloads.linux.hpe.com/SDR/repo/mcp/centos/6/x86_64/9.50/hpacucli-9.40-12.0.x86_64.rpm
rpm -ihv hpacucli-9.40-12.0.x86_64.rpm
```

## ssacliのインストール

```bash
wget https://downloads.linux.hpe.com/SDR/repo/mcp/centos/7/x86_64/current/ssacli-5.10-44.0.x86_64.rpm
rpm -ivh ssacli-5.10-44.0.x86_64.rpm
```

## RAID監視スクリプト(参考)

### hpacucli

```bash
#!/bin/bash

RESULT=$(hpacucli ctrl all show config | grep "logicaldrive")

if echo "$RESULT" | grep "OK" > /dev/null 2>&1
then
 echo "$RESULT"
 exit 0
else
 echo "$RESULT"
 exit 2
fi

echo "UNKNOWN -"
exit 3
```

### ssacli

```bash
#!/bin/bash

RESULT=$(ssacli ctrl all show config | grep "logicaldrive")

if echo "$RESULT" | grep "OK" > /dev/null 2>&1
then
 echo "$RESULT"
 exit 0
else
 echo "$RESULT"
 exit 2
fi

echo "UNKNOWN -"
exit 3
```