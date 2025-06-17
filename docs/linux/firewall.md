#### 設定表示
```
firewall-cmd --list-all
```

#### ルール追加(IP及びサービス指定)
```
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="127.0.0.1/32" service name="ssh" accept"
```
※service nameで指定できるサービスは「/usr/lib/firewalld/services/\*.xml」に記載あり

#### ルール削除(IP及びサービス指定)
```
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="127.0.0.1/32" service name="ssh" accept"
```
※service nameで指定できるサービスは「/usr/lib/firewalld/services/\*.xml」に記載あり