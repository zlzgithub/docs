# 目录

* [目 录](SUMMARY.md)

## >> 自动化运维

* [首 页](README.md)
* [Alerts](docs/devops.md)

### 应用部署

* [Ansible](docs/deployment/ansible/README.md)
  * [简介](docs/deployment/ansible/ansible-intro.md)
  * [示例](docs/deployment/ansible/ansible-examples.md)
* [Docker](docs/deployment/docker/README.md)
  * [Prometheus](docs/deployment/docker/docker-prometheus.md)
  * [Nginx Consul](docs/deployment/docker/docker-nginx-consul.md)
  * [PMM](docs/deployment/docker/docker-pmm.md)
  * [Redis in Docker](docs/deployment/docker/docker-redis.md)
  * [LDAP](docs/deployment/docker/docker-ldap.md)
  * [Harbor](docs/deployment/docker/docker-harbor.md)
  * [Apollo](docs/deployment/docker/docker-apollo.md)
* [Kubernetes](docs/deployment/k8s/README.md)
  * [安装](docs/deployment/k8s/installation/README.md)
    * [Kubespray](docs/deployment/k8s/installation/kubespray-k8s/kubespray-k8s.md)
    * [RKE](docs/deployment/k8s/installation/rke-k8s/rke-k8s.md)
    * [Rancher](docs/deployment/k8s/installation/rancher-k8s/rancher-k8s.md)
    * [Kubeadm](docs/deployment/k8s/installation/kubeadm-k8s/kubeadm-k8s-steps.md)
  * [部署](docs/deployment/k8s/deployment/README.md)
    * [K8s Dashboard](docs/deployment/k8s/deployment/Kubernetes-dashboard.md)
    * [ELK](docs/deployment/k8s/deployment/ELK.md)
    * [Prometheus](docs/deployment/k8s/deployment/k8s-prometheus.md)
    * [NFS动态PV](docs/deployment/k8s/deployment/k8s-nfs-storageclass.md)
    * [Rancher](docs/deployment/k8s/deployment/k8s-rancher.md)
    * [Helm&Tiller](docs/deployment/k8s/deployment/k8s-helm.md)
* [其它](docs/deployment/else/README.md)
  * [MySQL主从复制](docs/deployment/else/mysql-replication.md)
  * [Percona toolkit](docs/deployment/else/percona-toolkit.md)
  * [yum安装MySQL](docs/deployment/else/ins_mysql.md)
  * [yum安装RabbitMQ](docs/deployment/else/ins_rabbitmq.md)
  * [yum安装Redis](docs/deployment/else/ins_redis5.md)
  * [安装ruby和redis dump](docs/deployment/else/ins_ruby_redis_dump.md)
  * [Y-API的安装步骤](docs/deployment/else/ins_yapi.md)
  * [GitLab升级](docs/deployment/else/gitlab-update.md)
  * [dataX示例](docs/deployment/else/dataX-demo.md)
  * [git分支重置](docs/deployment/else/git-orphan-usage.md)
  * [修复mysql主从](docs/deployment/else/repair-mysql-repl.md)
  * [磁盘扩容](docs/deployment/else/disk-lvcreate.md)
  * [docker若干](docs/deployment/else/docker-notes.md)

### 服务监控

* [Consul](docs/monitoring/consul/README.md)
  * [Consul](docs/monitoring/consul/consul.md)
  * [Consul-template](docs/monitoring/consul/consul-template.md)
  * [Nginx-Consul-template](docs/monitoring/consul/my-nginx-consul.md)
  * [Consul-ACL](docs/monitoring/consul/consul-acl.md)
  * [Consul APIs](docs/monitoring/consul/consul-api-memo.md)
* [Prometheus](docs/monitoring/prometheus/README.md)
  * [Prometheus](docs/monitoring/prometheus/prom/README.md)
    * [核心组件——prometheus](docs/monitoring/prometheus/prom/prometheus-intro.md)
    * [告警组件——alertmanager](docs/monitoring/prometheus/prom/alertmanager.md)
    * [图表展示——grafana](docs/monitoring/prometheus/prom/grafana-intro.md)
    * [联邦](docs/monitoring/prometheus/prom/prometheus_federate.md)
    * [自动发现](docs/monitoring/prometheus/prom/prometheus-discovery.md)    
  * [常用软件接入Prometheus监控](docs/monitoring/prometheus/3rd/README.md)
    * [MySQL](docs/monitoring/prometheus/3rd/mysql-monitor-steps.md)
    * [MySQL主从同步](docs/monitoring/prometheus/3rd/Prometheus-monitor-mysql-replication.md)
    * [MongoDB](docs/monitoring/prometheus/3rd/mongodb-monitor-steps.md)
    * [Redis](docs/monitoring/prometheus/3rd/redis-monitor-steps.md)
    * [RabbitMQ](docs/monitoring/prometheus/3rd/rabbitmq-monitor-steps.md)
    * [NginX](docs/monitoring/prometheus/3rd/nginx-monitor-steps.md)
  * [自研应用接入Prometheus监控](docs/monitoring/prometheus/self/prometheus-consul-guide.md)
* [Zabbix](docs/monitoring/zabbix/zabbix-intro.md)
  * [自动发现](docs/monitoring/zabbix/zabbix-discovery-rule.md)

### 日志分析

* [ELK](docs/log-analysis/README.md)
  * [X-pack权限控制版ES](docs/log-analysis/es-xpack.md)
  * [ELK账号权限分组管理](docs/log-analysis/es-account-manage.md)
  * [ELK若干问题](docs/log-analysis/elk-problems.md)
  * [清理ES索引](docs/log-analysis/clean_elk_indices.md)
  * [K8s部署ELK并启用AD认证](docs/log-analysis/k8s-elk-auth-kibana-via-ad.md)
  * [ELK部署整改](docs/log-analysis/k8s-elk-improvement.md)
  * [使用Grafana](docs/log-analysis/elk-grafana.md)
  * [ES APIs](docs/log-analysis/es-api-memo.md)

### 持续集成

* [CI/CD](docs/cicd/README.md)
* [GitLab CI/CD](docs/cicd/gitlab/README.md)
  * [GitLab Runner](docs/cicd/gitlab/gitlab-runner.md)
  * [GitLab CI/CD](docs/cicd/gitlab/gitlab-cicd.md)

### 配置管理

* [CMDB](docs/config-management/README.md)
  * [Ansible Tower](docs/config-management/ansible-tower.md)
  * [BlueKing](docs/config-management/bk-cmdb.md)

### 任务调度

* [简介](docs/task-scheduling/README.md)
* [XXL-JOB](docs/task-scheduling/xxl-job.md)
  * [XXL-JOB升级](docs/task-scheduling/upgrade-xxl-job.md)

## >> 关于本书

* [制作](docs/my-gitbook.md)
* [发布](docs/cicd/publish-gitbook.md)
* [官方示例](docs/HELP.md)

