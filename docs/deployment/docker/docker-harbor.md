# 安装Harbor



> github：https://github.com/goharbor/harbor



## 环境

```sh
wget -P /etc/yum.repos.d https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install docker-ce-18.09.6 docker-ce-cli-18.09.6 -y
```



```
[root@VM_0_4_centos harbor]# docker version
Client:
 Version:           18.09.6
 API version:       1.39
 Go version:        go1.10.8
 Git commit:        481bc77156
 Built:             Sat May  4 02:34:58 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.6
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.8
  Git commit:       481bc77
  Built:            Sat May  4 02:02:43 2019
  OS/Arch:          linux/amd64
  Experimental:     false
[root@VM_0_4_centos harbor]# 
[root@VM_0_4_centos harbor]# 
[root@VM_0_4_centos harbor]# 
[root@VM_0_4_centos harbor]# docker-compose version
docker-compose version 1.24.0, build 0aa59064
docker-py version: 3.7.2
CPython version: 3.6.8
OpenSSL version: OpenSSL 1.1.0j  20 Nov 2018
```



## 安装

获取安装工具

```sh
wget https://github.com/goharbor/harbor/releases/download/v1.10.1/harbor-online-installer-v1.10.1.tgz
```



创建自签名证书

```sh
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ./tls.key -out ./tls.crt -subj "/CN=harbor.lzzeng.cn"
```



修改配置

```yaml
hostname: harbor.keep.com

# http related config
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 80

# https related config
https:
  # https port for harbor, default is 443
  port: 443
  # The path of cert and key files for nginx
  certificate: /opt/docker/harbor/tls.crt
  private_key: /opt/docker/harbor/tls.key
```



登录设置

```sh
[root@n01 ~]# docker login -u admin  -p  xxx  https://harbor.lzzeng.cn/
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Error response from daemon: Get https://harbor.lzzeng.cn/v2/: x509: certificate signed by unknown authority

[root@n01 ~]# cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://zdojag2v.mirror.aliyuncs.com"],
  "insecure-registries": ["harbor.lzzeng.cn"]
}
```


