

# Docker 学习

1. [**Docker**](https://docs.docker.com/engine/docker-overview/) 是一种[操作系统层面的虚拟化技术](https://en.wikipedia.org/wiki/Operating-system-level_virtualization)，基于 `Linux` 内核的 [cgroup](https://zh.wikipedia.org/wiki/Cgroups)，[namespace](https://en.wikipedia.org/wiki/Linux_namespaces)，以及 [OverlayFS](https://docs.docker.com/storage/storagedriver/overlayfs-driver/) 类的 [Union FS](https://en.wikipedia.org/wiki/Union_mount) 等技术对进程进行封装隔离 。

1. Docker是 C/S（客户端/服务器）架构。
2. Docker客户端与Docker守护进程通信，后者负责构建，运行和分发Docker容器。

1. Docker客户端和守护程序使用REST API，通过UNIX套接字或网络接口进行通信。

![Docker Architecture Diagram](E:\docs\myNote\_Daily\docker-k8s.assets\architecture.svg)



# 为什么使用Docker

> - **更高效的利用系统资源**
>
> - **更快速的启动时间**
>
> - **一致的运行环境**
>
> - **持续交付和部署**
>
> - **更轻松的迁移**
>
> - **更轻松的维护和扩展**



由于容器不需要进行硬件虚拟以及运行完整操作系统等额外开销，`Docker` 对系统资源的利用率更高。无论是应用执行速度、内存损耗或者文件存储速度，都要比传统虚拟机技术更高效。因此，相比虚拟机技术，一个相同配置的主机，往往可以运行更多数量的应用。



传统的虚拟机技术启动应用服务往往需要数分钟，而 `Docker` 容器应用，由于直接运行于宿主内核，无需启动完整的操作系统，因此可以做到秒级、甚至毫秒级的启动时间。大大的节约了开发、测试、部署的时间。



开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 `Docker` 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 *「这段代码在我机器上没问题啊」* 这类问题。



对开发和运维（[DevOps](https://zh.wikipedia.org/wiki/DevOps)）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。

使用 `Docker` 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过 [Dockerfile]() 来进行镜像构建，并结合 [持续集成(Continuous Integration)](https://en.wikipedia.org/wiki/Continuous_integration) 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合 [持续部署(Continuous Delivery/Deployment)](https://en.wikipedia.org/wiki/Continuous_delivery) 系统进行自动部署。

而且使用 Dockerfile使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。



由于 `Docker` 确保了执行环境的一致性，使得应用的迁移更加容易。`Docker` 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。



`Docker` 使用的分层存储以及镜像的技术，使得应用重复部分的复用更为容易，也使得应用的维护更新更加简单，基于基础镜像进一步扩展镜像也变得非常简单。此外，`Docker` 团队同各个开源项目团队一起维护了一大批高质量的 [官方镜像](https://hub.docker.com/search/?type=image&image_filter=official)，既可以直接在生产环境使用，又可以作为基础进一步定制，大大的降低了应用服务的镜像制作成本。




## Docker 与 VM 比较



![1561264718294](E:\docs\myNote\_Daily\docker-k8s.assets\1561264718294.png)

![1561264737939](E:\docs\myNote\_Daily\docker-k8s.assets\1561264737939.png)



| 特性       | 容器               | 虚拟机      |
| ---------- | ------------------ | ----------- |
| 启动       | 秒级               | 分钟级      |
| 硬盘使用   | 一般为 `MB`        | 一般为 `GB` |
| 性能       | 接近原生           | 弱于        |
| 系统支持量 | 单机支持上千个容器 | 一般几十个  |



---



# 基本概念



## 镜像

1. **Docker 镜像是一个特殊的文件系统**，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像不包含任何动态数据，其内容在构建之后也不会被改变。
2. 镜像采用分层存储，实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。这个特点也使得镜像的复用、定制变的更为容易
3. 镜像在构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。



## 容器

1. 镜像（`Image`）和容器（`Container`）的关系，好比面向对象程序设计中的 `类` 和 `实例` 。
2. 容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的 [命名空间](https://en.wikipedia.org/wiki/Linux_namespaces)。
3. 每一个容器运行时，是以镜像为基础层，在其上创建一个当前容器的存储层，这个为容器运行时读写而准备的存储层叫 **容器存储层**。

4. 容器存储层的生存周期和容器一样。
5. 不随容器销毁的数据的读写，应该使用 **数据卷**（Volume）、或者绑定宿主目录。



## 仓库

仓库是镜像的版本库，不同的镜像标签代表该镜像的不同版本。Docker提供了**Docker Registry**作为镜像仓库管理服务，由于没有图形界面等原因，一般会使用Docker Hub （外部个人环境）或 Harbor（私服）托管Docker镜像。

![img](E:\docs\myNote\_Daily\docker-k8s.assets\1149398-20190917180200231-1649134988.png)



# 常用命令

当前使用的docker版本：

```sh
[root@VM_0_13_centos ~]# docker version
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
```



## 镜像操作

| 功能         | 命令                                                         |
| ------------ | ------------------------------------------------------------ |
| 拉取镜像     | `docker pull [选项] [仓库地址[:端口号]/]仓库名[:标签]`       |
| 列出镜像     | `docker images` 或者 `docker image ls`                       |
| 构建         | docker build  -t  <镜像名称]>  .   [-f Dockerfile路径]       |
| 重命名       | docker tag   <原镜像>   <新镜像>                             |
| 推送         | docker push   <镜像>                                         |
| 删除镜像     | `docker image rm [选项] <镜像1> [<镜像2> ...]` 或 `docker rmi ...` |
| 查看镜像信息 | `docker inspect  <镜像>`                                     |



部分示例如下：

```sh
# docker pull alpine:latest
latest: Pulling from library/alpine
188c0c94c7c5: Pull complete
Digest: sha256:c0e9560cda118f9ec63ddefb4a173a2b2a0347082d7dff7dc14272e7841a5b5a
Status: Downloaded newer image for alpine:latest

# docker image ls
REPOSITORY	TAG			IMAGE ID		CREATED			SIZE
alpine		latest     	d6e46aa2470d 	10 days ago  	5.57MB

# 查看镜像的分层信息，可以看到alpine镜像只有1层
# docker inspect alpine:latest |jq ".[0].RootFS"
{
  "Type": "layers",
  "Layers": [
    "sha256:ace0eda3e3be35a979cec764a3321b4c7d0b9e4bb3094d20d3ff6782961a8d54"
  ]
}

# docker rmi alpine:latest
Untagged: alpine:latest
Untagged: alpine@sha256:c0e9560cda118f9ec63ddefb4a173a2b2a0347082d7dff7dc14272e7841a5b5a
Deleted: sha256:d6e46aa2470df1d32034c6707c8041158b652f38d2a9ae3d7ad7e7532d22ebe0
Deleted: sha256:ace0eda3e3be35a979cec764a3321b4c7d0b9e4bb3094d20d3ff6782961a8d54
```



## 容器操作

| 功能             | 命令                              |
| ---------------- | --------------------------------- |
| 运行容器         | `docker run [选项] <镜像> [命令]` |
| 停止容器         | `docker stop <容器>`              |
| 列出运行中的容器 | `docker ps`                       |
| 删除容器         | `docker  rm  <容器>`              |



部分示例如下：

```sh
# docker run -it --rm --name test_a  alpine:3 sh   #-i交互，-t终端，--rm退出即删除
/ # ls
bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ # exit

# 在exit之前，另开一个ssh窗口查看
# docker ps |grep test_a
CONTAINER ID	IMAGE		COMMAND		CREATED			STATUS		PORTS		NAMES
7495b9bd3c5e	alpine:3 	"sh"      	15 seconds ago 	Up 14 seconds        	test_a

# 退出后再查看，上面这个容器已消失
```



## 磁盘空间管理



> **docker system** 命令用于管理磁盘空间。



### 查看docker磁盘占用

```sh
# docker system df
TYPE                TOTAL         ACTIVE        SIZE          RECLAIMABLE
Images              70            22            12.88GB       9.229GB (71%)
Containers          36            21            1.924GB       1.281GB (66%)
Local Volumes       86            22            1.546GB       7.825MB (0%)
Build Cache         0             0             0B            0B
```



### 清理docker磁盘空间

`docker system prune` 命令可以用于清理磁盘，删除关闭的容器、无用的数据卷和网络，以及dangling镜像(即无tag的镜像)。

`docker system prune -a` 命令清理得更加彻底，可以将没有容器使用Docker镜像都删掉。

注意，这两个命令会把你暂时关闭的容器，以及暂时没有用到的Docker镜像都删掉。



```sh
# docker system prune 
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all dangling build cache
Are you sure you want to continue? [y/N] y
Deleted Containers:
（略）
Deleted Networks:
（略）
Total reclaimed space: 2.627GB
```



# Dockerfile

部分常用指令：

- FROM：指定基础镜像

- ARG：参数设置

- ENV：环境变量设置

- ADD：添加构建上下文

- COPY：复制文件

- RUN：编写一些shell命令

- EXPOSE：暴露容器需监听的端口

- CMD：容器启动后执行的命令

- ENTRYPOINT：入口指令

  有了 `CMD` 后，为什么还要有 `ENTRYPOINT` 呢？<https://yeasy.gitbook.io/docker_practice/image/dockerfile/entrypoint>

- VOLUME指令

  可以通过docker run命令的 -v 参数创建volume挂载点。如果通过dockerfile的 VOLUME 指令可以在镜像中创建挂载点，那么通过该镜像创建容器时不指定 -v 参数时，会在宿主机上随机生成一个数据目录绑定到 VOLUME 所指定的容器内目录。



## Dockerfile示例



```sh
FROM python:2.7-alpine


ARG APP_HOME
ENV APP_HOME=${APP_HOME:-/opt/apps}

WORKDIR $APP_HOME
COPY ./myweb  myweb

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/main/" > /etc/apk/repositories && \
    echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/community/" >> /etc/apk/repositories && \
    apk add gcc g++ make mysql-dev --no-cache && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install -U pip && \
    pip install supervisor==4.2.0 && \
    /usr/local/bin/echo_supervisord_conf > /etc/supervisord.conf && \
    mkdir /etc/supervisord.d && \
    echo "[include]" >> /etc/supervisord.conf && \
    echo "files = supervisord.d/*.conf" >> /etc/supervisord.conf && \
    cd $APP_HOME/myweb && \
    pip install -r requirements.txt && \
    cp $APP_HOME/myweb/myweb_supervisord.conf  /etc/supervisord.d/

EXPOSE $PORT
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
```



## 构建、运行



> 发出docker build命令时，当前工作目录称为build context。默认情况下，Dockerfile假定位于此处，但可以使用文件标志（-f）指定其他位置。不管Dockerfile实际位于何处，当前目录中文件和目录的所有递归内容都将作为构建上下文发送到Docker守护进程。



Dockerfile文件名称不是Dockerfile时，需通过 -f 参数指定，点号 “.” 表示当前目录作为构建上下文。如果在demo的上一级目录执行构建，则命令可以这样写：`docker build -f demo/Dockerfile-myweb -t myweb:0.1 demo`



构建时打印的内容：

```sh
[root@VM_0_13_centos demo]# docker build -f Dockerfile-myweb -t myweb:0.1 .
Sending build context to Docker daemon  1.117MB
Step 1/9 : FROM python:2.7-alpine
 ---> 8579e446340f
Step 2/9 : ARG APP_HOME
 ---> Using cache
 ---> 9c173fd3707d
Step 3/9 : ENV APP_HOME=${APP_HOME:-/opt/apps}
 ---> Using cache
 ---> 721207dba6e7
Step 4/9 : WORKDIR $APP_HOME
 ---> Using cache
 ---> 99a3b8ce16a1
Step 5/9 : COPY ./myweb  myweb
 ---> 2e9790a1fa90
Step 6/9 : VOLUME ["$APP_HOME/myweb"]
 ---> Running in 1e647a4987d7
Removing intermediate container 1e647a4987d7
 ---> dd03f21e2aa6
Step 7/9 : RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/main/" > /etc/apk/repositories &&     echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/community/" >> /etc/apk/repositories &&     apk add gcc g++ make mysql-dev --no-cache &&     pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple &&     pip install -U pip &&     pip install supervisor==4.2.0 &&     /usr/local/bin/echo_supervisord_conf > /etc/supervisord.conf &&     mkdir /etc/supervisord.d &&     echo "[include]" >> /etc/supervisord.conf &&     echo "files = supervisord.d/*.conf" >> /etc/supervisord.conf &&     cd $APP_HOME/myweb &&     pip install -r requirements.txt &&     cp $APP_HOME/myweb/myweb_supervisord.conf  /etc/supervisord.d/
 ---> Running in 3b58653054de
fetch https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch https://mirror.tuna.tsinghua.edu.cn/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/27) Upgrading libcrypto1.1 (1.1.1d-r3 -> 1.1.1g-r0)
(2/27) Upgrading libssl1.1 (1.1.1d-r3 -> 1.1.1g-r0)
(3/27) Installing libgcc (9.3.0-r0)
(4/27) Installing libstdc++ (9.3.0-r0)
(5/27) Installing binutils (2.33.1-r0)
(6/27) Installing gmp (6.1.2-r1)
(7/27) Installing isl (0.18-r0)
(8/27) Installing libgomp (9.3.0-r0)
(9/27) Installing libatomic (9.3.0-r0)
(10/27) Installing mpfr4 (4.0.2-r1)
(11/27) Installing mpc1 (1.1.0-r1)
(12/27) Installing gcc (9.3.0-r0)
(13/27) Installing musl-dev (1.1.24-r2)
(14/27) Installing libc-dev (0.7.2-r0)
(15/27) Installing g++ (9.3.0-r0)
(16/27) Installing make (4.2.1-r2)
(17/27) Installing pkgconf (1.6.3-r0)
(18/27) Installing openssl-dev (1.1.1g-r0)
(19/27) Installing zlib-dev (1.2.11-r3)
(20/27) Installing mariadb-connector-c (3.1.6-r0)
(21/27) Installing mariadb-connector-c-dev (3.1.6-r0)
(22/27) Installing mariadb-common (10.4.15-r0)
(23/27) Installing libaio (0.3.112-r1)
(24/27) Installing xz-libs (5.2.4-r0)
(25/27) Installing pcre (8.43-r0)
(26/27) Installing mariadb-embedded (10.4.15-r0)
(27/27) Installing mariadb-dev (10.4.15-r0)
Executing busybox-1.31.1-r9.trigger
Executing ca-certificates-20191127-r1.trigger
OK: 206 MiB in 57 packages
Writing to /root/.config/pip/pip.conf
DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. A future version of pip will drop support for Python 2.7. More details about Python 2 support in pip, can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support
DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. A future version of pip will drop support for Python 2.7. More details about Python 2 support in pip, can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Collecting pip
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/cb/28/91f26bd088ce8e22169032100d4260614fc3da435025ff389ef1d396a433/pip-20.2.4-py2.py3-none-any.whl (1.5 MB)
Installing collected packages: pip
  Attempting uninstall: pip
    Found existing installation: pip 20.0.2
    Uninstalling pip-20.0.2:
      Successfully uninstalled pip-20.0.2
Successfully installed pip-20.2.4
DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. pip 21.0 will drop support for Python 2.7 in January 2021. More details about Python 2 support in pip can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support pip 21.0 will remove support for this functionality.
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Collecting supervisor==4.2.0
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/2f/43/130066cd6003233401142f5f98cd09c93165f5c6408f850dd965b4f2470e/supervisor-4.2.0-py2.py3-none-any.whl (738 kB)
Installing collected packages: supervisor
Successfully installed supervisor-4.2.0
DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 is no longer maintained. pip 21.0 will drop support for Python 2.7 in January 2021. More details about Python 2 support in pip can be found at https://pip.pypa.io/en/latest/development/release-process/#python-2-support pip 21.0 will remove support for this functionality.
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
Collecting django==1.11
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/47/a6/078ebcbd49b19e22fd560a2348cfc5cec9e5dcfe3c4fad8e64c9865135bb/Django-1.11-py2.py3-none-any.whl (6.9 MB)
Collecting mysqlclient==1.3.12
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/6f/86/bad31f1c1bb0cc99e88ca2adb7cb5c71f7a6540c1bb001480513de76a931/mysqlclient-1.3.12.tar.gz (89 kB)
Collecting pytz
  Downloading https://pypi.tuna.tsinghua.edu.cn/packages/12/f8/ff09af6ff61a3efaad5f61ba5facdf17e7722c4393f7d8a66674d2dbd29f/pytz-2020.4-py2.py3-none-any.whl (509 kB)
Building wheels for collected packages: mysqlclient
  Building wheel for mysqlclient (setup.py): started
  Building wheel for mysqlclient (setup.py): finished with status 'done'
  Created wheel for mysqlclient: filename=mysqlclient-1.3.12-cp27-cp27mu-linux_x86_64.whl size=114991 sha256=aaaaa66718424c6b59bf7d69bd448408c90f72b86fad837db5a0faeaf4755278
  Stored in directory: /root/.cache/pip/wheels/ec/42/25/33153f9d017dea3007e9da4daa09ac5ab23e853ec2c2c6a14d
Successfully built mysqlclient
Installing collected packages: pytz, django, mysqlclient
Successfully installed django-1.11 mysqlclient-1.3.12 pytz-2020.4
Removing intermediate container 3b58653054de
 ---> 74221bc92419
Step 8/9 : EXPOSE $PORT
 ---> Running in bc109d388ec3
Removing intermediate container bc109d388ec3
 ---> 7f45f5e2be2c
Step 9/9 : CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
 ---> Running in f0f4f867b879
Removing intermediate container f0f4f867b879
 ---> 4eede34e1dad
Successfully built 4eede34e1dad
Successfully tagged myweb:0.1
```



**查看容器进程**

```sh
[root@VM_0_13_centos demo]# docker ps |grep myweb
9ad3a7949611        myweb:0.1                              "supervisord -n -c /…"   7 minutes ago       Up 7 minutes        0.0.0.0:8009->8000/tcp                                   myweb
```

其中 `9ad3a7949611` 是容器id，也是容器的hostname



**查看volume**

```sh
[root@VM_0_13_centos demo]# docker inspect 9ad3a7949611 |jq ".[0].Mounts"
[
  {
    "Type": "volume",
    "Name": "9bf8c23683f1d587c6184216377472ae5262a3f0a7f39794bb4e13124616bb2f",
    "Source": "/var/lib/docker/volumes/9bf8c23683f1d587c6184216377472ae5262a3f0a7f39794bb4e13124616bb2f/_data",
    "Destination": "/opt/apps/myweb",
    "Driver": "local",
    "Mode": "",
    "RW": true,
    "Propagation": ""
  }
]

[root@VM_0_13_centos demo]# ls /var/lib/docker/volumes/9bf8c23683f1d587c6184216377472ae5262a3f0a7f39794bb4e13124616bb2f/_data
manage.py  myweb  myweb_supervisord.conf  requirements.txt  static  templates  visit
```



**查看env**

```sh
[root@VM_0_13_centos demo]# docker inspect 9ad3a7949611 |jq ".[0].Config.Env"
[
  "PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "LANG=C.UTF-8",
  "PYTHONIOENCODING=UTF-8",
  "GPG_KEY=C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF",
  "PYTHON_VERSION=2.7.18",
  "PYTHON_PIP_VERSION=20.0.2",
  "PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d59197a3c169cef378a22428a3fa99d33e080a5d/get-pip.py",
  "PYTHON_GET_PIP_SHA256=421ac1d44c0cf9730a088e337867d974b91bdce4ea2636099275071878cc189e",
  "APP_HOME=/opt/apps"
]
```



**进入容器查看**

```sh
[root@VM_0_13_centos demo]# docker exec -it myweb sh
/opt/apps # hostname
bc8b06c2c6a1

/opt/apps # env
PYTHONIOENCODING=UTF-8
HOSTNAME=9ad3a7949611
PYTHON_PIP_VERSION=20.0.2
SHLVL=1
HOME=/root
GPG_KEY=C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/d59197a3c169cef378a22428a3fa99d33e080a5d/get-pip.py
TERM=xterm
APP_HOME=/opt/apps
PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LANG=C.UTF-8
PYTHON_VERSION=2.7.18
PWD=/opt/apps
PYTHON_GET_PIP_SHA256=421ac1d44c0cf9730a088e337867d974b91bdce4ea2636099275071878cc189e

/opt/apps # ps -ef 
PID   USER     TIME  COMMAND
    1 root      0:01 {supervisord} /usr/local/bin/python /usr/local/bin/supervisord -n -c /etc/supervisord.conf
    7 root      0:00 /usr/local/bin/python manage.py runserver 0.0.0.0:8000
   17 root      0:56 /usr/local/bin/python manage.py runserver 0.0.0.0:8000
   34 root      0:00 sh
   40 root      0:00 ps -ef
```



## Dockerfile最佳实践



1. 基础镜像

如果你以 `scratch` 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。

不以任何系统为基础，直接将可执行文件复制进镜像的做法并不罕见，比如 [`swarm`](https://hub.docker.com/_/swarm/)、[`etcd`](https://quay.io/repository/coreos/etcd)。对于 Linux 下静态编译的程序来说，并不需要有操作系统提供运行时支持，所需的一切库都已经在可执行文件里了，因此直接 `FROM scratch` 会让镜像体积更加小巧。使用 [Go 语言](https://golang.org/) 开发的应用很多会使用这种方式来制作镜像，这也是为什么有人认为 Go 是特别适合容器微服务架构的语言的原因之一。

2. 多阶段构建



# docker-compose



`Compose` 项目是 Docker 官方的开源项目，负责实现对 Docker 容器集群的快速编排。

`Compose` 定位是 「定义和运行多个 Docker 容器的应用（Defining and running multi-container Docker applications）」，其前身是开源项目 Fig。

`Compose` 中有两个重要的概念：

- 服务 (`service`)：一个应用的容器，实际上可以包括若干运行相同镜像的容器实例。
- 项目 (`project`)：由一组关联的应用容器组成的一个完整业务单元，在 `docker-compose.yml` 文件中定义。

`Compose` 的默认管理对象是项目，通过子命令对项目中的一组容器进行便捷地生命周期管理。



## 安装

```sh
$ sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

$ sudo chmod +x /usr/local/bin/docker-compose
```

或者通过pip安装

```sh
$ sudo pip install -U docker-compose
```





## docker-compose示例 —— WordPress



docker-compose.yml

```yaml
version: "3"
services:

   db:
     image: mysql:8.0
     command:
      - --default_authentication_plugin=mysql_native_password
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci     
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8020:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
volumes:
  db_data:
```



启动

```sh
[root@VM_0_13_centos wordpress-demo]# docker-compose up -d
Creating network "wordpress-demo_default" with the default driver
Creating wordpress-demo_db_1 ... done
Creating wordpress-demo_wordpress_1 ... done

[root@VM_0_13_centos wordpress-demo]# docker-compose ps
Name                         Command               			  State   Ports        
-----------------------------------------------------------------------------------
wordpress-demo_db_1          docker-entrypoint.sh --def ...   Up      3306/tcp, 33060/tcp 
wordpress-demo_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8020->80/tcp
```

![image-20201107174243776](E:\docs\myNote\_Daily\docker-k8s.assets\image-20201107174243776.png)



查看db数据卷

```sh
[root@VM_0_13_centos wordpress-demo]# docker inspect wordpress-demo_db_1 |jq ".[0].Mounts"
[
  {
    "Type": "volume",
    "Name": "wordpress-demo_db_data",
    "Source": "/var/lib/docker/volumes/wordpress-demo_db_data/_data",
    "Destination": "/var/lib/mysql",
    "Driver": "local",
    "Mode": "rw",
    "RW": true,
    "Propagation": ""
  }
]

[root@VM_0_13_centos wordpress-demo]# ls /var/lib/docker/volumes/wordpress-demo_db_data/_data
auto.cnf       binlog.000004  client-cert.pem    ib_buffer_pool  ibtmp1        performance_schema  server-key.pem  wordpress
binlog.000001  binlog.index   client-key.pem     ibdata1         #innodb_temp  private_key.pem     sys
binlog.000002  ca-key.pem     #ib_16384_0.dblwr  ib_logfile0     mysql         public_key.pem      undo_001
binlog.000003  ca.pem         #ib_16384_1.dblwr  ib_logfile1     mysql.ibd     server-cert.pem     undo_002
```



进入容器查看

```sh
[root@VM_0_13_centos wordpress-demo]# docker-compose exec db sh
# ls
bin  boot  dev	docker-entrypoint-initdb.d  entrypoint.sh  etc	home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

# hostname
9a3da80a05ac

# env
HOSTNAME=9a3da80a05ac
MYSQL_MAJOR=8.0
HOME=/root
MYSQL_ROOT_PASSWORD=somewordpress
TERM=xterm
MYSQL_PASSWORD=wordpress
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MYSQL_VERSION=8.0.22-1debian10
MYSQL_USER=wordpress
GOSU_VERSION=1.12
PWD=/
MYSQL_DATABASE=wordpress

# which mysqld
/usr/sbin/mysqld

# ls /var/lib/mysql
'#ib_16384_0.dblwr'   binlog.000001   binlog.index      client-key.pem	 ibdata1     performance_schema   server-key.pem   wordpress
'#ib_16384_1.dblwr'   binlog.000002   ca-key.pem        ib_buffer_pool	 ibtmp1      private_key.pem	  sys
'#innodb_temp'	      binlog.000003   ca.pem	        ib_logfile0	 mysql	     public_key.pem	  undo_001
 auto.cnf	      binlog.000004   client-cert.pem   ib_logfile1	 mysql.ibd   server-cert.pem	  undo_002
```

![image-20201107174911101](E:\docs\myNote\_Daily\docker-k8s.assets\image-20201107174911101.png)


