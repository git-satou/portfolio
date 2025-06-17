# 起動
```
systemctl start 〇〇.service
```

# 停止
```
systemctl stop 〇〇.service
```

# 再起動
```
systemctl restart 〇〇.service
```

# リロード
```
systemctl reload 〇〇.service
```

# 起動状況確認
```
systemctl status 〇〇.service
```

# 自動起動有効化
```
systemctl enable 〇〇.service
```

# 自動起動無効化
```
systemctl disable 〇〇.service
```

# 自動起動有効化＆起動
```
systemctl enable --now 〇〇.service
```

# 起動設定確認
```
systemctl is-enabled 〇〇.service
```

# 設定ファイル確認
```
systemctl cat 〇〇.service
```

# 設定ファイル編集(追記型)
```
systemctl edit 〇〇.service
```

# 設定ファイル編集(全部型)
```
systemctl edit --full 〇〇.service
```