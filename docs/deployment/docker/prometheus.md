# Prometheus



```yaml
version: '3.0'

services:
  alertmanager:
    image: prom/alertmanager
    volumes:
      - ./config/alertmanager:/etc/alertmanager
    ports:
      - "9093:9093"
    environment:
      SERVICE_NAME: alertmanager
      SERVICE_TAGS: "alertmanager,http"

  prometheus:
    image: prom/prometheus
    volumes:
      - ./config/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./config/prometheus/rules:/etc/prometheus/rules
      - /etc/localtime:/etc/localtime
    environment:
      SERVICE_NAME: prometheus
      SERVICE_TAGS: "prometheus-target,prometheus,http"
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    volumes:
      - ./config/grafana/grafana.ini:/etc/grafana/grafana.ini 
      - /data/grafana:/var/lib/grafana
    environment:
      - "GF_SERVER_ROOT_URL=http://home.grafana.com"
      - "GF_SECURITY_ADMIN_PASSWORD=${GF_SECURITY_ADMIN_PASSWORD}"
      - "SERVICE_NAME=grafana"
      - "SERVICE_TAGS=prometheus-target,grafana,http"
    ports:
      - 3000:3000

  node-exporter:
    image: prom/node-exporter
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    network_mode: host
    ports:
      - 9100:9100
    environment:
      SERVICE_TAGS: "prometheus-target"
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points="^(/rootfs|/host|)/(sys|proc|dev|host|etc)($$|/)"'
      - '--collector.filesystem.ignored-fs-types="^(sys|proc|auto|cgroup|devpts|ns|au|fuse\.lxc|mqueue)(fs|)$$"'
```

