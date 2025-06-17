## ネットワークの設定

### nmtui (GUI) で設定  
※GUIベースのため手順省略

### nmcli（CUI）で設定

#### デバイスの確認

```bash
nmcli device
```

#### グローバルIP（GIP）の設定

```bash
nmcli connection modify <DEVICE名> \
  ipv4.method manual \
  ipv4.addresses <IPアドレス>/<プレフィックス> \
  ipv4.gateway <ゲートウェイIP> \
  ipv4.dns 8.8.8.8 \
  connection.autoconnect yes \
  ipv6.method ignore
```

#### ローカルIP（LIP）の設定

```bash
nmcli connection modify <DEVICE名> \
  ipv4.method manual \
  ipv4.addresses <IPアドレス>/<プレフィックス> \
  connection.autoconnect yes \
  ipv6.method ignore
```

## 暗号化方式の許可ポリシーを下げる（古いOSと通信する場合）

参考: https://blog.future.ad.jp/crypto-policies

```bash
update-crypto-policies --set DEFAULT:SHA1
systemctl restart sshd
```

## ホストネームの変更

```bash
hostnamectl set-hostname example.com
```

## 必要パッケージのインストールとアップデート

```bash
yum -y update
yum -y groupinstall "Development Tools"
yum -y install postfix net-tools bash-completion sysstat s-nail bind-utils chrony yum-utils mlocate lsof
```

## postfixを自動起動

```bash
systemctl enable --now postfix
```

## devel系のパッケージをインストールするために有効化

### 一般的なサーバ

```bash
yum config-manager --set-enabled crb
```

### OracleLinuxの場合

```bash
yum config-manager --enable ol9_codeready_builder
```

## SELinux 及び firewalld の無効化

### firewalld の無効化

```bash
systemctl disable firewalld
```

### SELinux の無効化（※反映には再起動が必要）

```bash
grubby --update-kernel ALL --args selinux=0
```

## kernel チューニング

### 現在の設定を確認

```bash
sysctl -a
```

### 設定ファイルの作成

```bash
vi /etc/sysctl.d/custom.conf
```

```conf
# TIME_WAITのセッションを使いまわし
net.ipv4.tcp_tw_reuse = 1

# IP転送（keepalivedなどでIP転送が必要な場合）
net.ipv4.ip_forward = 1
```

### 設定の反映

```bash
sysctl --system
```

## 内部時間をJSTへ変更

```bash
timedatectl set-timezone Asia/Tokyo
```

## SFTPのログを残す設定とデフォルトでのグループ権限の追加

### /etc/rsyslog.conf に追記

```conf
# This rule to save the log output of sftp
local5.*                                                /var/log/sftp.log
```

### ログファイルの作成

```bash
touch /var/log/sftp.log
```

### sshd_config の編集

```conf
Subsystem sftp /usr/libexec/openssh/sftp-server -f LOCAL5 -l VERBOSE -u 002
```

### サービスの再起動

```bash
systemctl reload sshd.service
systemctl restart rsyslog.service
```

### ログローテート設定

```bash
vi /etc/logrotate.d/rsyslog
```

```conf
/var/log/sftp.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
}
```

## journalログのライフタイム設定

```bash
vi /etc/systemd/journald.conf
```

```conf
MaxRetentionSec=30day
```

```bash
systemctl restart systemd-journald
```

## VM環境の場合

### VMツールのインストール

```bash
yum -y install open-vm-tools
```

## cloud環境の場合に必要かもしれない cloud-init の設定

> 初回起動時にOS設定が自動で変更される。Amazon EC2のために作られたものだが、他のcloud環境にも活用されている模様。

### 設定ファイル

```bash
/etc/cloud/cloud.cfg
```

### 設定を変更しそうな箇所

#### ssh接続のパスワード認証を有効化

```yaml
ssh_pwauth: false  # → true に変更
```

#### セキュリティアップデートの無効化

```yaml
repo_upgrade: security  # → none に変更
```
