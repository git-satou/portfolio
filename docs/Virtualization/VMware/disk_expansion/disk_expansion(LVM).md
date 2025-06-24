## 手順

```
fdisk /dev/sda
```

- pを入力

```
コマンド (m でヘルプ): p

Disk /dev/sda: 107.4 GB, 107374182400 bytes, 209715200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O サイズ (最小 / 推奨): 512 バイト / 512 バイト
Disk label type: dos
ディスク識別子: 0x000cdc77

デバイス ブート      始点        終点     ブロック   Id  システム
/dev/sda1   *        2048     4196351     2097152   83  Linux
/dev/sda2         4196352   104857599    50330624   8e  Linux LVM
```


- nを入力

```
Partition type:
p   primary (2 primary, 0 extended, 2 free)
e   extended
```

- pを入力

```
(3,4, default 3): 3
```

- pを入力

```
コマンド (m でヘルプ): p

Disk /dev/sda: 107.4 GB, 107374182400 bytes, 209715200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O サイズ (最小 / 推奨): 512 バイト / 512 バイト
Disk label type: dos
ディスク識別子: 0x000cdc77

デバイス ブート      始点        終点     ブロック   Id  システム
/dev/sda1   *        2048     4196351     2097152   83  Linux
/dev/sda2         4196352   104857599    50330624   8e  Linux LVM
/dev/sda3       104857600   209715199    52428800   83  Linux
```

- /dev/sda3が作成されたが、標準になっているのでLVM領域にする
- lを押すと一覧が見れるので確認する

```
コマンド (m でヘルプ): l

 0  空              24  NEC DOS         81  Minix / 古い Li bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux スワップ  c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 隠し C: ド c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux 拡張領域  c7  Syrinx         
 5  拡張領域        41  PPC PReP Boot   86  NTFS ボリューム da  非 FS データ   
 6  FAT16           42  SFS             87  NTFS ボリューム db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux プレーン  de  Dell ユーティリ
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX ブート可能  4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 ブートマネ 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad ハ eb  BeOS fs        
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT            
 f  W95 拡張領域 (L 54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC  
11  隠し FAT12      56  Golden Bow      a8  Darwin UFS      f1  SpeedStor      
12  Compaq 診断     5c  Priam Edisk     a9  NetBSD          f4  SpeedStor      
14  隠し FAT16 <32M 61  SpeedStor       ab  Darwin ブート   f2  DOS セカンダリ 
16  隠し FAT16      63  GNU HURD または af  HFS / HFS+      fb  VMware VMFS    
17  隠し HPFS/NTFS  64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE 
18  AST SmartSleep  65  Novell Netware  b8  BSDI スワップ   fd  Linux raid 自動
1b  隠し W95 FAT32  70  DiskSecure Mult bb  隠し Boot Wizar fe  LANstep        
1c  隠し W95 FAT32  75  PC/IX           be  Solaris ブート  ff  BBT            
1e  隠し W95 FAT16  80  古い Minix   
```

- LVMなので8eにする。tを入力

```
(1-3, default 3): 3
Hex code (type L to list all codes): 8e
```

- pを入力

```
コマンド (m でヘルプ): p

Disk /dev/sda: 107.4 GB, 107374182400 bytes, 209715200 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O サイズ (最小 / 推奨): 512 バイト / 512 バイト
Disk label type: dos
ディスク識別子: 0x000cdc77

デバイス ブート      始点        終点     ブロック   Id  システム
/dev/sda1   *        2048     4196351     2097152   83  Linux
/dev/sda2         4196352   104857599    50330624   8e  Linux LVM
/dev/sda3       104857600   209715199    52428800   8e  Linux LVM
```

- LVMに変わる。wを入力し保存してからサーバ再起動

### LVMの領域追加
- pvdisplayコマンドで今の物理ボリュームを確認する。

```
# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               centos
  PV Size               <48.00 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              12287
  Free PE               0
  Allocated PE          12287
  PV UUID               BaRxQX-iBc4-2ljN-0b09-Yg57-tC33-aQpJMq
```

- 物理ボリュームとして/dev/sda3を追加する

```
# pvcreate /dev/sda3
  Physical volume "/dev/sda3" successfully created.
```

追加されてることを確認する。

```
# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               centos
  PV Size               <48.00 GiB / not usable 3.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              12287
  Free PE               2
  Allocated PE          12285
  PV UUID               BaRxQX-iBc4-2ljN-0b09-Yg57-tC33-aQpJMq
   
  "/dev/sda3" is a new physical volume of "50.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sda3
  VG Name               
  PV Size               50.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               qxwFiR-UtPD-tcuV-F3r3-CKg8-YITq-VS3kq2
```

- 現在のボリュームグループを確認する。

```
# vgdisplay
  --- Volume group ---
  VG Name               centos
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <48.00 GiB
  PE Size               4.00 MiB
  Total PE              12287
  Alloc PE / Size       12285 / <47.99 GiB
  Free  PE / Size       2 / 8.00 MiB
  VG UUID               spFt72-oMW3-mJmj-GqlI-mEiw-jSPY-pf8wck
```

- VG Nameがcentosなのでここに/dev/sda3を参加させる

```
# vgextend centos /dev/sda3
  Volume group "centos" successfully extended
```

現在の/領域のファイルシステムを確認する

```
# df -h
ファイルシス            サイズ  使用  残り 使用% マウント位置
devtmpfs                  988M     0  988M    0% /dev
tmpfs                    1000M     0 1000M    0% /dev/shm
tmpfs                    1000M  8.9M  991M    1% /run
tmpfs                    1000M     0 1000M    0% /sys/fs/cgroup
/dev/mapper/centos-root    46G  2.1G   44G    5% /
/dev/sda1                 2.0G  168M  1.9G    9% /boot
tmpfs                     200M     0  200M    0% /run/user/1000
```

- /dev/mapper/centos-rootに対して追加したディスク分全てを拡張する

```
# lvextend -l +100%FREE /dev/mapper/centos-root
  Size of logical volume centos/root changed from <45.99 GiB (11773 extents) to 95.99 GiB (24574 extents).
  Logical volume centos/root successfully resized.
```

- 最後に拡張した分を読み込ませる

```
# xfs_growfs /dev/mapper/centos-root
meta-data=/dev/mapper/centos-root isize=512    agcount=4, agsize=3013888 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=12055552, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=5886, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 12055552 to 25163776
```

- ディスク容量確認する

```
# df -h
ファイルシス            サイズ  使用  残り 使用% マウント位置
devtmpfs                  988M     0  988M    0% /dev
tmpfs                    1000M     0 1000M    0% /dev/shm
tmpfs                    1000M  8.9M  991M    1% /run
tmpfs                    1000M     0 1000M    0% /sys/fs/cgroup
/dev/mapper/centos-root    96G  2.1G   94G    3% /
/dev/sda1                 2.0G  168M  1.9G    9% /boot
tmpfs                     200M     0  200M    0% /run/user/1000
```