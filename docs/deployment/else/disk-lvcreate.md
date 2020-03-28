# 磁盘扩容



```sh
# lvdisplay
# vgdisplay

# 删除lv
lvremove /dev/docker_vg/data
lvremove /dev/docker_vg/docker_lv

# 删除vg
vgremove docker_vg

# 创建vg
vgcreate vg /dev/sdb1

# 创建lv, 大小200G
lvcreate -L 200G -n docker vg
lvcreate -l 76790 -n data vg		# 76790单位？

mkfs.xfs /dev/vg/data
mount /dev/vg/data /data

mkfs.xfs /dev/vg/docker
mkdir /var/lib/docker
mount /dev/vg/docker /var/lib/docker

vim /etc/fstab

​```
/dev/mapper/vg-data /data      xfs     defaults        0 0
/dev/mapper/vg-docker /var/lib/docker      xfs     defaults        0 0
​```

ls /dev/mapper/vg-docker
ls /dev/mapper/vg-data
```

