# Playbooks



> ansible-playbooks仓库：<http://git.pro.keep.com/devops/ansible-playbooks.git>



## k8s

创建K8s集群，基于rancher，基于rancher rke，基于kubespray等方式。



---

## tomcat-ansible

将一个Web应用部署到由 一个NginX节点 + 两个tomcat节点集群，然后模拟升级、回退过程的playbook示例。



---

## consul

安装consul集群(未测试)。


```sh
# 修改myhosts，并配置好ansible免密登录

# 安装
ansible-playbook -i myhosts ins_consul.yaml 
```



---

## redis

部署redis集群，RPM安装、编译安装redis主从结构或集群。



---

## rabbitmq

部署rabbitmq



...
