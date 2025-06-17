# 初期セットアップ手順（CentOS / Rocky Linux）

## ネットワークの設定

### nmtui（GUI）で設定  
※GUIベースのため手順省略

### nmcli（CLI）で設定

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

## 必要パッケージのインストールとアップデート

```bash
yum -y update
yum -y groupinstall "Development Tools"
yum -y install net-tools bash-completion sysstat bind-utils yum-utils mlocate lsof
```

## SELinux と firewalld の無効化

### firewalld の無効化

```bash
systemctl disable firewalld
```

### SELinux の無効化

```bash
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

## カーネルパラメータのチューニング

### 現在の設定確認

```bash
sysctl net.ipv4.tcp_tw_reuse net.ipv4.ip_local_port_range \
       net.ipv4.tcp_syncookies net.core.somaxconn
```

### 設定ファイルの作成と反映

```bash
vi /etc/sysctl.d/custom.conf
```

```conf
# TIME_WAITのセッションを使いまわし
net.ipv4.tcp_tw_reuse = 1

# SYN Flood 攻撃対策
net.ipv4.tcp_syncookies = 1

# 接続待ちキューを拡張
net.core.somaxconn = 4096

# IP転送（keepalivedなどで使用）
net.ipv4.ip_forward = 1
```

```bash
sysctl --system
```

## タイムゾーン設定（JST）

```bash
timedatectl set-timezone Asia/Tokyo
```

## rc.local に実行権限を付与

```bash
chmod 744 /etc/rc.d/rc.local
```

## SSH 設定の強化

```conf
# /etc/ssh/sshd_config の編集

PermitRootLogin no
UseDNS no
```

## SFTP ログの出力とパーミッション設定

### rsyslog の設定

```bash
echo 'local5.*    /var/log/sftp.log' >> /etc/rsyslog.conf
touch /var/log/sftp.log
```

### sshd_config の設定

```conf
Subsystem sftp /usr/libexec/openssh/sftp-server -f LOCAL5 -l VERBOSE -u 002
```

### 設定の反映

```bash
systemctl reload sshd.service
systemctl restart rsyslog.service
```

### ログローテーションの設定

```bash
vi /etc/logrotate.d/sftp
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

## journal ログの保持期間設定

```bash
vi /etc/systemd/journald.conf
```

```conf
MaxRetentionSec=30d
```

```bash
systemctl restart systemd-journald
```

## VM 環境向けツールのインストール

```bash
yum -y install open-vm-tools
```

## cloud-init の設定（cloud 環境向け）

### 設定ファイルの場所

```bash
/etc/cloud/cloud.cfg
```

### よく変更する項目

#### パスワード認証の有効化

```yaml
ssh_pwauth: true  # false → true に変更
```

#### セキュリティアップデートの無効化

```yaml
repo_upgrade: none  # security → none に変更
```

### ホスト名の設定

```bash
hostnamectl set-hostname example.com
```
