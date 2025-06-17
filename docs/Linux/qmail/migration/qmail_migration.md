## 【新環境】qmail インストール

※パッケージはすでに設置済みとする。  
※自動で作成されるユーザー・グループの UID/GID は旧環境と合わせること。

```bash
cd /usr/local/src/qmail_package_cname/
./qmail_package.sh
```

---

##  【旧環境→新環境】ドメイン配下のデータ移行

#### 🔹 旧環境

```bash
cd /home/vpopmail/
tar zcfp domains.tar.gz ./domains/
scp domains.tar.gz <新環境のホスト>:/home/vpopmail/
```

#### 🔹 新環境

```bash
cd /home/vpopmail/
mv domains{,.old}
tar zxvfp domains.tar.gz
```

---

##  【新環境】旧環境からコピーすべき設定ファイル（※必要に応じて追加確認）

```text
/var/qmail/control/rcpthosts
/var/qmail/control/virtualdomains
/var/qmail/control/smtproutes
/var/qmail/users/assign
```

---

##  【新環境】仮想ユーザの割り当て反映

```bash
/var/qmail/bin/qmail-newu
```

---

##  【新環境】起動スクリプトの作成

```bash
ln -s /var/qmail/service/init.rc /etc/init.d/qmaild
```

---

##  【新環境】qmail の起動

```bash
/etc/init.d/qmaild start
chkconfig --add qmaild
chkconfig qmaild on
```

---

##  【新環境】テスト送受信確認
- テストメールを送信・受信して、正常に動作していることを確認する
