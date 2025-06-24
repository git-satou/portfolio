## SWAPの表示
### topコマンドから、fを押すと下記画面になる

```
Fields Management for window 1:Def, whose current sort field is %CPU
   Navigate with Up/Dn, Right selects for move then <Enter> or Left commits,
   'd' or <Space> toggles display, 's' sets sort.  Use 'q' or <Esc> to end!

* PID     = Process Id             nDRT    = Dirty Pages Count
* USER    = Effective User Name    WCHAN   = Sleeping in Function
* PR      = Priority               Flags   = Task Flags <sched.h>
* NI      = Nice Value             CGROUPS = Control Groups
* VIRT    = Virtual Image (KiB)    SUPGIDS = Supp Groups IDs
* RES     = Resident Size (KiB)    SUPGRPS = Supp Groups Names
* SHR     = Shared Memory (KiB)    TGID    = Thread Group Id
* S       = Process Status         ENVIRON = Environment vars
* %CPU    = CPU Usage              vMj     = Major Faults delta
* %MEM    = Memory Usage (RES)     vMn     = Minor Faults delta
* TIME+   = CPU Time, hundredths   USED    = Res+Swap Size (KiB)
* COMMAND = Command Name/Line      nsIPC   = IPC namespace Inode
  PPID    = Parent Process pid     nsMNT   = MNT namespace Inode
  UID     = Effective User Id      nsNET   = NET namespace Inode
  RUID    = Real User Id           nsPID   = PID namespace Inode
  RUSER   = Real User Name         nsUSER  = USER namespace Inode
  SUID    = Saved User Id          nsUTS   = UTS namespace Inode
  SUSER   = Saved User Name
  GID     = Group Id
  GROUP   = Group Name
  PGRP    = Process Group Id
  TTY     = Controlling Tty
  TPGID   = Tty Process Grp Id
  SID     = Session Id
  nTH     = Number of Threads
  P       = Last Used Cpu (SMP)
  TIME    = CPU Time
  SWAP    = Swapped Size (KiB)
  CODE    = Code Size (KiB)
  DATA    = Data+Stack (KiB)
  nMaj    = Major Page Faults
  nMin    = Minor Page Faults
```

### スペースを押すとアスタリスクが先頭に表示され有効化される。SWAPとUSEDが関連する

```
Fields Management for window 1:Def, whose current sort field is %CPU
   Navigate with Up/Dn, Right selects for move then <Enter> or Left commits,
   'd' or <Space> toggles display, 's' sets sort.  Use 'q' or <Esc> to end!

* PID     = Process Id             nDRT    = Dirty Pages Count
* USER    = Effective User Name    WCHAN   = Sleeping in Function
* PR      = Priority               Flags   = Task Flags <sched.h>
* NI      = Nice Value             CGROUPS = Control Groups
* VIRT    = Virtual Image (KiB)    SUPGIDS = Supp Groups IDs
* RES     = Resident Size (KiB)    SUPGRPS = Supp Groups Names
* SHR     = Shared Memory (KiB)    TGID    = Thread Group Id
* S       = Process Status         ENVIRON = Environment vars
* %CPU    = CPU Usage              vMj     = Major Faults delta
* %MEM    = Memory Usage (RES)     vMn     = Minor Faults delta
* TIME+   = CPU Time, hundredths * USED    = Res+Swap Size (KiB)
* COMMAND = Command Name/Line      nsIPC   = IPC namespace Inode
  PPID    = Parent Process pid     nsMNT   = MNT namespace Inode
  UID     = Effective User Id      nsNET   = NET namespace Inode
  RUID    = Real User Id           nsPID   = PID namespace Inode
  RUSER   = Real User Name         nsUSER  = USER namespace Inode
  SUID    = Saved User Id          nsUTS   = UTS namespace Inode
  SUSER   = Saved User Name
  GID     = Group Id
  GROUP   = Group Name
  PGRP    = Process Group Id
  TTY     = Controlling Tty
  TPGID   = Tty Process Grp Id
  SID     = Session Id
  nTH     = Number of Threads
  P       = Last Used Cpu (SMP)
  TIME    = CPU Time
* SWAP    = Swapped Size (KiB)
  CODE    = Code Size (KiB)
  DATA    = Data+Stack (KiB)
  nMaj    = Major Page Faults
  nMin    = Minor Page Faults
```

### キーボードの右矢印を押して上下に移動することで、表示順番を変更する事ができる。左矢印で確定。

```
Fields Management for window 1:Def, whose current sort field is %CPU
   Navigate with Up/Dn, Right selects for move then <Enter> or Left commits,
   'd' or <Space> toggles display, 's' sets sort.  Use 'q' or <Esc> to end!

* PID     = Process Id             nMin    = Minor Page Faults
* USER    = Effective User Name    nDRT    = Dirty Pages Count
* PR      = Priority               WCHAN   = Sleeping in Function
* NI      = Nice Value             Flags   = Task Flags <sched.h>
* VIRT    = Virtual Image (KiB)    CGROUPS = Control Groups
* RES     = Resident Size (KiB)    SUPGIDS = Supp Groups IDs
* SHR     = Shared Memory (KiB)    SUPGRPS = Supp Groups Names
* S       = Process Status         TGID    = Thread Group Id
* %CPU    = CPU Usage              ENVIRON = Environment vars
* %MEM    = Memory Usage (RES)     vMj     = Major Faults delta
* SWAP    = Swapped Size (KiB)     vMn     = Minor Faults delta
* USED    = Res+Swap Size (KiB)    nsIPC   = IPC namespace Inode
* TIME+   = CPU Time, hundredths   nsMNT   = MNT namespace Inode
* COMMAND = Command Name/Line      nsNET   = NET namespace Inode
  PPID    = Parent Process pid     nsPID   = PID namespace Inode
  UID     = Effective User Id      nsUSER  = USER namespace Inode
  RUID    = Real User Id           nsUTS   = UTS namespace Inode
  RUSER   = Real User Name
  SUID    = Saved User Id
  SUSER   = Saved User Name
  GID     = Group Id
  GROUP   = Group Name
  PGRP    = Process Group Id
  TTY     = Controlling Tty
  TPGID   = Tty Process Grp Id
  SID     = Session Id
  nTH     = Number of Threads
  P       = Last Used Cpu (SMP)
  TIME    = CPU Time
  CODE    = Code Size (KiB)
  DATA    = Data+Stack (KiB)
  nMaj    = Major Page Faults
```

- ESCで戻り、大文字のWで保存される。表示の保存はユーザ依存


## おまけ
### SWAPでソートする

```
top -o SWAP
```

### SWAPソートを行い、プロンプトを返しながら表示する。末尾を変更すればそれぞれに対応可能。

```
top -b -n 1 -o SWAP
```