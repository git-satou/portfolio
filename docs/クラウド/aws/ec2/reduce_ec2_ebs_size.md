## 環境

- OS: Amazon Linux 2

---

## 作業手順

1. 作業用インスタンスを起動
2. 対象インスタンスの「ストレージ」タブからルートデバイス名を控える  
3. `lsblk` でディスクのアタッチ状況を確認
4. 対象インスタンスのスナップショットを取得し、スナップショットからEBSを作成  
   ※アベイラビリティゾーンは作業インスタンスと一致させる  
   ※作成したボリュームIDは控えておく
5. 縮小したいサイズで新規EBSを作成  
   ※同じくアベイラビリティゾーン一致が必要  
   ※作成したボリュームIDは控える
6. 作業用インスタンスに、上記2つのEBSをアタッチ
7. `lsblk` で再確認
8. ブートパーティションのコピー  
   ※`if`は旧EBS、`of`は新EBS

   ```bash
   dd if=/dev/nvme1n1 of=/dev/nvme2n1 bs=512 count=24576
   ```

9. `gdisk`で新しいボリュームのパーティションテーブルを調整

   ```bash
   gdisk /dev/nvme2n1
   ```

   - Expertメニューに入る:
     ```text
     Command (? for help): x
     Expert command (? for help): e
     ```
   - メニューに戻る:
     ```text
     Expert command (? for help): m
     ```
   - 古いパーティションを削除:
     ```text
     Command (? for help): d
     Partition number (1-128): 1
     ```
   - 新しいパーティションを作成:
     ```text
     Command (? for help): n
     Partition number (1-128, default 1): 1
     First sector (34-419430366, default = 4096): 4096
     Last sector (4096-419430366, default = 419430366): 0
     Hex code or GUID: <Enter>
     ```
   - 変更を保存:
     ```text
     Command (? for help): w
     Do you want to proceed? (Y/N): y
     ```

10. 新しいパーティションに `xfs` ファイルシステムを作成

    ```bash
    mkfs -t xfs -f /dev/nvme2n1p1
    ```

11. マウントポイント作成とマウント

    ```bash
    mkdir /mnt/old /mnt/new
    mount -t xfs -o nouuid /dev/nvme1n1p1 /mnt/old
    mount -t xfs -o nouuid /dev/nvme2n1p1 /mnt/new
    ```

12. データ同期

    ```bash
    rsync -axvP --delete /mnt/old/ /mnt/new/
    ```

13. アンマウント

    ```bash
    umount /mnt/old /mnt/new
    ```

14. `blkid`でUUID確認、UUIDとラベルを旧EBSと一致させる

    ```bash
    xfs_admin -U {旧UUID} /dev/nvme2n1p1
    xfs_admin -L / /dev/nvme2n1p1
    ```

15. 再度 `blkid` で変更を確認

16. 対象インスタンスを停止し、3つのEBSをデタッチ  
    ※ストレージ情報を記録しておく

17. 縮小済みEBSをルートデバイスとしてアタッチし、インスタンスを起動

18. 起動後、インスタンス終了時にEBSを削除するよう設定を変更

    ```bash
    # ボリュームの確認
    aws ec2 describe-volumes --volume-ids {ボリュームID}

    # 更新
    aws ec2 modify-instance-attribute --instance-id {インスタンスID} \
      --block-device-mappings '[{"DeviceName": "/dev/xvda", "Ebs": {"DeleteOnTermination": true}}]'

    # ボリュームの確認
    aws ec2 describe-volumes --volume-ids {ボリュームID}
    ```

---

## 作業後

- 不要になったスナップショット・ボリューム・作業インスタンスを削除すること
