# kubeadm安装K8s步骤记录

> 阅读资料：
>
> - https://kubernetes.io/docs/setup/independent/install-kubeadm/
>
> - https://www.howtoforge.com/tutorial/centos-kubernetes-docker-cluster/



## 镜像准备

Master

```sh
# kubeadm config images list
k8s.gcr.io/kube-apiserver:v1.13.2
k8s.gcr.io/kube-controller-manager:v1.13.2
k8s.gcr.io/kube-scheduler:v1.13.2
k8s.gcr.io/kube-proxy:v1.13.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.2.24
k8s.gcr.io/coredns:1.2.6
#另外
quay.io/coreos/flannel:v0.10.0-amd64
```



Slave

```
k8s.gcr.io/kube-proxy:v1.13.2
k8s.gcr.io/pause:3.1
k8s.gcr.io/coredns:1.2.6
quay.io/coreos/flannel:v0.10.0-amd64
```



## yum源配置

```sh
wget -P /etc/yum.repos.d https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```



## 主机名设置

```sh
hostnamectl set-hostname master
hostnamectl set-hostname node01

vim /etc/hosts
xxx master
xxx node01
```



## 授权免密登录

ssh-copy-id ...



## 防火墙等设置

```sh
systemctl stop firewalld
systemctl disable firewalld

setenforce 0
sed -i -re '/^\s*SELINUX=/s/^/#/' -e '$i\\SELINUX=disabled'  /etc/selinux/config

swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# 同步时间
# yum install ntpdate
ntpdate pool.ntp.org
```



## 安装docker-ce

```sh
yum install docker-ce-18.06.1.ce
systemctl start docker
systemctl enable docker
systemctl status docker

cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF

systemctl daemon-reload
systemctl restart docker
```



## 安装kubectl等

```sh
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && sudo systemctl start kubelet
```



## 初始化集群

```sh
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=xxx
```

token过期生成新的token：

```sh
kubeadm token create --print-join-command
```

节点加入集群：

```sh
kubeadm join xxx:6443 --token xx.xxxx --discovery-token-ca-cert-hash sha256:xxxx
```

```sh
cp /etc/kubernetes/admin.conf $HOME/
chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
```

flannel网络设置：
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
```



## 查看集群信息

```sh
kubectl get nodes
kubectl label node xxx node-role.kubernetes.io/master='master'
kubectl label node xxx node-role.kubernetes.io/node='node'
kubectl cluster-info
# 查看所有Pod
kubectl get pods --all-namespaces
```



## hello-world

```sh
kubectl run hello-world --replicas=2 --labels="run=load-balancer-example" --image=gcr.io/google-samples/node-hello:1.0  --port=8080

# 集群信息
kubectl get deployments hello-world
kubectl describe deployments hello-world

kubectl get replicasets
kubectl describe replicasets

# 创建service
kubectl expose deployment hello-world --type=NodePort --name=example-service

# 查看service
kubectl describe services example-service

kubectl get pods --selector="run=load-balancer-example" --output=wide
```



## 安装dashboard

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# 删除dashboard
kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard)
```
