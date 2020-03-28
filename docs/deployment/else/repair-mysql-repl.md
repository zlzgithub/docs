# MySQL主从复制异常中断恢复



> mysql  Ver 15.1 Distrib 10.2.17-MariaDB, for Linux (x86_64) using readline 5.1



## 重建主从关系

```sh
# 1. S（从节点执行）: 
stop slave; reset slave all;		# 注意：mysql相关命令要进入mysql控制台执行

systemctl stop mysqld;
rsync -avzp --delete 主节点:/var/lib/mysql/  /var/lib/mysql/

# 2. M（主节点执行）:
create user repl@'S'; grant replication slave on *.* to repl@'S' identified by 'xxx';
flush tables with read lock;

# 3. S（从节点执行）:
rsync -avzp --delete 主节点:/var/lib/mysql/  /var/lib/mysql/
rm -f /var/lib/mysql/auto.cnf
systemctl start mysqld

change master to master_host='M', master_user='repl',
   master_password='xxx', master_port=3306, master_log_file='mysql-bin.xxxxxx',
    master_log_pos=xxxxxxxx, master_connect_retry=30;
start slave;
set global max_connections=1000;
flush privileges;

# 4. M（主节点执行）:
unlock tables;
```

```sh
# 1. S（从节点执行）: 
stop slave; reset slave all;  # 注意：mysql相关命令要进入mysql控制台执行

systemctl stop mysqld;

## 同步主节点的mysql数据目录 到从节点；本次同步时间很长，有100多G数据；如果不执行这一步，主从状态也能恢复正常，但主从节点数据不一致，不知道具体有何影响。
rsync -avzp --delete 主节点:/var/lib/mysql/  /var/lib/mysql/

# 2. M（主节点执行）:
 ## 创建一个同步用的账号repl
create user repl@'S'; grant replication slave on *.* to repl@'S' identified by 'xxx';   

## 给master节点的表上锁，只读
flush tables with read lock;

# 3. S（从节点执行）:    
## 继前一次同步之后，再次同步主节点的mysql数据目录到从节点，并删除同步过来的/var/lib/mysql/auto.cnf文件；时间较短；
rsync -avzp --delete 主节点:/var/lib/mysql/  /var/lib/mysql/

rm -f /var/lib/mysql/auto.cnf
systemctl start mysqld

## 设置主从
change master to master_host='M', master_user='repl',
   master_password='xxx', master_port=3306, master_log_file='mysql-bin.xxxxxx',
    master_log_pos=xxxxxxxx, master_connect_retry=30;
start slave;
set global max_connections=1000;
flush privileges;

# 4. M（主节点执行）:
## 解除表锁
unlock tables;
```



- 其它相关

```sh
  mysql> show variables like 'server_uuid%';
+---------------+--------------------------------------+
| Variable_name | Value                                |
+---------------+--------------------------------------+
| server_uuid   | 11b29075-20ac-11ea-a52f-0242ac110002 |
+---------------+--------------------------------------+

  mysql> show slave hosts;
+-----------+------+------+-----------+--------------------------------------+
| Server_id | Host | Port | Master_id | Slave_UUID                           |
+-----------+------+------+-----------+--------------------------------------+
|       101 |      | 3306 |       100 | 11b29075-20ac-11ea-a52f-0242ac110002 |
+-----------+------+------+-----------+--------------------------------------+
1 row in set (0.00 sec)

change master to master_host='192.168.0.3', master_user='repl', \
 master_password='xxxxxx', master_port=3306, master_log_file='edu-mysql-slave1-bin.000003', \
 master_log_pos=1105, master_connect_retry=30;

CREATE DATABASE mydatabase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE TABLE `test_users` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`)
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB;

# 二进制日志解析
mysqlbinlog --no-defaults /var/lib/mysql/edu-mysql-bin.000020 |tail -n 20 |grep end_log_pos |awk '{print $7}'
mysqlbinlog --no-defaults /var/lib/mysql/edu-mysql-bin.000020 >/opt/binlog.txt 

# 忽略某些异常代号
slave-skip-errors = 1062,1032,1060
```

