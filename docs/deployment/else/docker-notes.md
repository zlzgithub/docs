# docker若干记录



给已经启动的容器映射端口

```sh
docker run --rm -p 8001:1234 verb/socat TCP-LISTEN:1234,fork TCP-CONNECT:172.18.0.5:8000
```



定期清理大日志

```sh
0 2 * * * du -sm /var/lib/docker/containers/*/*.log |awk '{if($1>10240){print $2}}' |xargs truncate -s 100M
```



分配指定的内部IP

```yaml
version: '3'

services:
  db:
    image: mysql:5.7
    environment:
      TZ: 'Asia/Shanghai'
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    restart: always
    command: ['mysqld', '--character-set-server=utf8']
    volumes:
      - /data/mysql:/var/lib/mysql
      - ./config/master.cnf:/etc/mysql/my.cnf
      #- /var/lib/mysql/mysql.sock:/var/lib/mysql/mysql.sock
    ports:
      - "3306:3306"
    networks:
      extnetwork:
        ipv4_address: 172.19.0.2

  db2:
    image: mysql:5.7
    environment:
      TZ: 'Asia/Shanghai'
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    restart: always
    command: ['mysqld', '--character-set-server=utf8']
    volumes:
      - /data/mysql_3307:/var/lib/mysql
      - ./config/slave.cnf:/etc/mysql/my.cnf
    ports:
      - "3307:3306"
    networks:
      extnetwork:
        ipv4_address: 172.19.0.3
 
networks:
  extnetwork:
    ipam:
      config:
        - subnet: 172.19.0.0/16
          #gateway: 172.19.0.1
```



docker加速

```sh
[root@VM_0_13_centos note]# cat /etc/docker/daemon.json 
{
  "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}

===
{
  "registry-mirrors": ["https://zdojag2v.mirror.aliyuncs.com"]
}

===
registry.mirrors.aliyuncs.com

===
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
```



安装

```sh
# 设置yum源
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 列出可安装的版本
yum list docker-ce --show-duplicates
yum install docker-ce-18.09
```

