# 使用GitBook



**文档结构（示例）**

```sh
[root@VM_0_13_centos docs]# tree -L 1 .
.
|-- book.json
|-- docs
|-- node_modules # 可不预先安装js依赖
|-- README.md
`-- SUMMARY.md
```



**基于node:alpine构建gitbook-cli镜像**

Dockerfile:

```sh
FROM node:alpine

RUN npm install gitbook-cli -g && \
    gitbook fetch 3.2.3
WORKDIR /opt/data
```



**部署gitbook**

compose:

```yaml
version: '3'

services:
  pages:
    image: mynode:alpine
    build: .
    environment:
      SERVICE_NAME: pages
      SERVICE_TAGS: "prometheus-target,pages,http"
    command: ["sh", "-c", "cd /opt/data && gitbook install && gitbook serve"]
    volumes:
      - ./docs:/opt/data
    ports:
      - 4000:4000
```

*如果未事先下载好相关依赖，启动后`gitbook install`过程需要一定的时间。*



node:alpine的entrypoint是默认的docker-entrypoint.sh，构建gitbook-cli镜像时未另外指定。

docker-entrypoint.sh:

```sh
#!/bin/sh
set -e

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
```



因此，compose中command的以下写法均可：

```sh
command:
  - /bin/sh
  - -c
  - |
    cd /opt/data #当镜像默认workdir不是/opt/data时，可在command中cd；是则不必cd
    gitbook serve

command:
  - sh
  - -c
  - |
    gitbook serve

command: ["gitbook", "serve"]
command: ["sh", "-c", "gitbook serve"]
command: ["sh", "-c", "cd /opt/data && gitbook serve"]
command: [sh, -c, "gitbook serve"]
command: [sh, -c, gitbook serve]
command: [sh, -c, cd /opt/data && gitbook serve]
command: sh -c "cd /opt/data && gitbook serve"
```

