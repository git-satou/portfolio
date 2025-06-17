## ネットワークの設定
### nmtuiで設定
GUIベースなので割愛

### nmcliで設定
- <b>デバイスの確認</b>

```
nmcli device
```

- <b>GIP設定</b>

```
nmcli connection modify {1で確認したDEVICE名} ipv4.method manual ipv4.addresses {IPアドレス ***.***.***.***./***} ipv4.gateway {ゲートウェイIP ***.***.***.***} ipv4.dns 8.8.8.8 connection.autoconnect yes ipv6.method ignore
```

- <b>LIP設定</b>

```
nmcli connection modify  {1で確認したDEVICE名} ipv4.method manual ipv4.addresses {IPアドレス ***.***.***.***./***}  connection.autoconnect yes ipv6.method ignore
```

## 必要パッケージのインストールとアップデート

```
yum -y update
yum -y groupinstall "Development Tools"
yum -y install net-tools bash-completion sysstat bind-utils yum-utils mlocate lsof
```

## SELinux 及び firewalld の無効化

- <b>firewalld</b>

```
systemctl disable firewalld
```

- <b>SELinux</b>

```
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

## kernel チューニング
- <b>設定の確認</b>

``` 
sysctl net.ipv4.tcp_tw_reuse net.ipv4.ip_local_port_range net.ipv4.tcp_syncookies net.core.somaxconn
```

- <b>設定ファイルの作成～設定反映</b>

```
vi /etc/sysctl.d/custom.conf

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
# TIME_WAITのセッションを使いまわし
net.ipv4.tcp_tw_reuse = 1
# SYN Flood 攻撃対策
net.ipv4.tcp_syncookies = 1
# 待ち(キュー)の許容範囲を増やす
net.core.somaxconn = 4096
# keepalivedなどでIP転送させる場合に必要
net.ipv4.ip_forward = 1
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

sysctl --system
```

## 内部時間をJSTへ変更

```
timedatectl set-timezone Asia/Tokyo
```

## rc.localに実行権限を付与

```
chmod 744 /etc/rc.d/rc.local
```

## sshd_configの修正

```
# rootログイン不許可
PermitRootLogin no
# 名前解決を無効化し接続を早める
UseDNS no
```

## SFTPのログを残す設定とデフォルトでのグループ権限の追加
- <b>/etc/rsyslog.conf に追記</b>

```
# This rule to save the log output of sftp
local5.*                                                /var/log/sftp.log
```

- <b>出力先のログファイルの作成</b>

```
touch /var/log/sftp.log
```

- <b>/etc/ssh/sshd_config に追記</b>

```
Subsystem sftp /usr/libexec/openssh/sftp-server -f LOCAL5 -l VERBOSE -u 002
```

- <b>反映</b>

```
systemctl reload sshd.service
systemctl restart rsyslog.service
```

- <b>ログのローテート設定</b>

```
vi /etc/logrotate.d/syslog

======================
/var/log/sftp.log
======================
```

## journalログのライフタイム設定

```
vi /etc/systemd/journald.conf

=================
MaxRetentionSec=30d
=================

systemctl restart systemd-journald
```

## VM環境の場合
- <b>VMツールのインストール</b>

```
yum -y install open-vm-tools
```

## cloud環境の場合に必要かもしれない cloud-init の設定
- <b><font color=red>初回</font>起動時にOS設定が自動で変更される
  Amazon EC2のために作られたものだが、他のcloud環境にも活用されている…らしい</b>

#### 設定ファイル

```
/etc/cloud/cloud.cfg
```

#### 設定を変更しそうな箇所
- <b>ssh接続のパスワード認証を有効化</b>

```
ssh_pwauth:   false
                  ↓
ssh_pwauth:   true
```

- <b>セキュリティアップデートの無効化</b>

```
repo_upgrade: security
                   ↓
repo_upgrade: none
```

#### ホストネームの変更

```
hostnamectl set-hostname example.com
```
