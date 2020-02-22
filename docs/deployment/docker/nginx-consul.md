# Nginx + Consul



```yaml
version: '3'

services:
  consul:
    image: consul
    environment:
      SERVICE_8500_NAME: "consul-ui"
      SERVICE_8500_TAGS: "consul,http,ui"
    ports:
      - 8500:8500
    network_mode: host
    volumes:
      - /data/consul/data:/consul/data
      - ./conf.d:/consul/config
    command: "agent -server -bootstrap-expect 1 -ui -disable-host-node-id -client 0.0.0.0 -bind 172.17.0.13"

  registrator:
    image: gliderlabs/registrator
    depends_on:
      - consul
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock
    network_mode: host
    environment:
      CONSUL_HTTP_TOKEN: ${CONSUL_HTTP_TOKEN}
    command: -internal consul://127.0.0.1:8500

  nginx-consul:
    image: nginx-consul:alpine
    build: .
    depends_on:
      - consul
      - registrator
    ports:
      - 80:80
    network_mode: host
    volumes:
      - ./files/nginx.conf.ctmpl:/etc/nginx/nginx.conf.ctmpl
    environment:
      HOST_TYPE: ${HOST_TYPE}
      CONSUL_HTTP_TOKEN: ${CONSUL_HTTP_TOKEN}
    command: -consul-addr=127.0.0.1:8500 -wait=5s -template /etc/nginx/nginx.conf.ctmpl:/etc/nginx/conf.d/app.conf:/etc/nginx/nginx.sh
```

