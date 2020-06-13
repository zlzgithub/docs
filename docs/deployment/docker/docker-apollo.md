# Apollo配置中心



## PRO

*192.168.101.68*

```yaml
version: '3.4'

services:
 configservice:
  image: apollo:1.4.0
  ports:
  - 9880:9880
  environment:
  - spring_datasource_url=jdbc:mysql://192.168.101.28:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=apollo
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/configservice.log
  - server.port=9880
  - SERVICE_NAME=eureka
  - SERVICE_TAGS=eureka,http
  volumes:
  - /var/log/apollo:/opt/logs
  command: configservice.jar
  network_mode: host

 adminservice:
  image: apollo:1.4.0
  environment:
  - spring_datasource_url=jdbc:mysql://192.168.101.28:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=apollo
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/adminservice.log
  - server.port=9890
  volumes:
  - /var/log/apollo:/opt/logs
  command: adminservice.jar
  network_mode: host
  depends_on:
   - configservice

 portal:
  image: apollo:1.4.0
  environment:
  - spring_datasource_url=jdbc:mysql://192.168.101.28:3306/ApolloPortalDB?characterEncoding=utf8
  - spring_datasource_username=apollo
  - spring_datasource_password=xxx
  - server.port=9800
  - logging.file=/opt/logs/portal.log
  - SERVICE_NAME=apollo
  - SERVICE_TAGS=apollo,http
  volumes:
  - /var/log/apollo:/opt/logs
  command: -Ddev_meta=http://10.1.7.211:9880 -Dpro_meta=http://localhost:9880 -Dfat_meta=http://192.168.100.212:9880 portal.jar
  network_mode: host
  depends_on:
   - adminservice
  ports:
   - 9800:9800
```



## DEV

*10.1.7.211*

```yaml
version: '3.4'

services:
 configservice:
  image: apollo:1.4.0
  ports:
  - 9880:9880
  environment:
  - spring_datasource_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=root
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/configservice.log
  - server.port=9880
  - SERVICE_NAME=eureka
  - SERVICE_TAGS=eureka,http
  volumes:
  - /var/log/apollo:/opt/logs
  command: configservice.jar
  network_mode: host

 adminservice:
  image: apollo:1.4.0
  environment:
  - spring_datasource_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=root
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/adminservice.log
  - server.port=9890
  volumes:
  - /var/log/apollo:/opt/logs
  command: adminservice.jar
  network_mode: host
  depends_on:
   - configservice
```



## FAT

*192.168.100.212*

```yaml
version: '3.4'

services:
 configservice:
  image: apollo:1.4.0
  ports:
  - 9880:9880
  environment:
  - spring_datasource_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=root
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/configservice.log
  - server.port=9880
  - SERVICE_NAME=eureka
  - SERVICE_TAGS=eureka,http
  volumes:
  - /var/log/apollo:/opt/logs
  command: configservice.jar
  network_mode: host

 adminservice:
  image: apollo:1.4.0
  environment:
  - spring_datasource_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8
  - spring_datasource_username=root
  - spring_datasource_password=xxx
  - logging.file=/opt/logs/adminservice.log
  - server.port=9890
  volumes:
  - /var/log/apollo:/opt/logs
  command: adminservice.jar
  network_mode: host
  depends_on:
   - configservice
```



Dockerfile:

```sh
FROM maven:3.5-jdk-8-alpine AS build
#LABEL Author="xxx"
ARG version=1.4.0
ARG package_name=apollo-${version}.tar.gz
COPY build.sh /scripts/
WORKDIR /src
RUN wget -c https://github.com/ctripcorp/apollo/archive/v${version}.tar.gz -O ${package_name} \
    && tar zxf ${package_name} --strip-components=1 \
    && cp /scripts/build.sh scripts/ \
    && chmod 777 scripts/build.sh
RUN scripts/build.sh
RUN mkdir /app \
    && cp apollo-configservice/target/apollo-configservice-${version}.jar /app/configservice.jar \
    && cp apollo-adminservice/target/apollo-adminservice-${version}.jar /app/adminservice.jar \
    && cp apollo-portal/target/apollo-portal-${version}.jar /app/portal.jar
RUN apk add -U tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

FROM java:8-jre-alpine
WORKDIR /app
COPY --from=build /app .
COPY --from=build /etc/localtime /etc/localtime
ENTRYPOINT [ "java", "-jar" ]
CMD [ "configservice.jar" ]
```



build.sh

```sh
#!/bin/sh

echo "==== starting to build config-service and admin-service ===="
mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8 -Dspring_datasource_username=root

echo "==== starting to build portal ===="
mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8 -Dspring_datasource_username=root -Ddev_meta=http://localhost:9880
```



编镜像、启容器：

```sh
docker build -t apollo:1.4.0 .
docker-compose up -d
```



导入数据表：

```sh
create database ApolloConfigDB;
create database ApolloPortalDB;
GRANT ALL PRIVILEGES ON ApolloPortalDB.*,ApolloConfigDB.* TO apollo@'%' IDENTIFIED BY 'password';

source ApolloPortalDB.sql
source ApolloConfigDB.sql
#------------或
mysql -u apollo -p -D ApolloConfigDB < apolloconfigdb.sql
mmysql -u apollo -p -D ApolloPortalDB < apolloportaldb.sql
```

