# K8s环境信息



## Development环境

节点：

```sh
NAME    STATUS   ROLES         AGE   VERSION   INTERNAL-IP  
node1   Ready    etcd,master   35d   v1.14.1   10.1.100.123 
node2   Ready    etcd,master   35d   v1.14.1   10.1.100.124 
node3   Ready    etcd,node     35d   v1.14.1   10.1.100.125 
node4   Ready    node          35d   v1.14.1   10.1.100.126 
node5   Ready    node          35d   v1.14.1   10.1.100.127 
node6   Ready    node          35d   v1.14.1   10.1.100.128
```

VIP: 10.1.100.50

Dashboard: <https://10.1.100.50:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/>



## Staging环境

节点：

```sh
NAME    STATUS   ROLES              AGE   VERSION   INTERNAL-IP
k8s01   Ready    etcd,master        41m   v1.14.1   192.168.100.220
k8s02   Ready    etcd,master,node   40m   v1.14.1   192.168.100.221
k8s03   Ready    etcd,node          39m   v1.14.1   192.168.100.222
k8s04   Ready    node               39m   v1.14.1   192.168.100.223
k8s05   Ready    node               39m   v1.14.1   192.168.100.224
k8s06   Ready    node               39m   v1.14.1   192.168.100.225
```

VIP: 192.168.100.219

Dashboard: <https://192.168.100.219:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/>



## Production环境

```sh
NAME    STATUS   ROLES              AGE   VERSION   INTERNAL-IP
node1   Ready    etcd,master        93m   v1.14.1   192.168.100.79
node2   Ready    etcd,master,node   92m   v1.14.1   192.168.100.80
node3   Ready    etcd,node          91m   v1.14.1   192.168.100.81
node4   Ready    node               91m   v1.14.1   192.168.100.216
node5   Ready    node               91m   v1.14.1   192.168.100.217
node6   Ready    node               91m   v1.14.1   192.168.100.218
```

VIP: 192.168.100.78

Dashboard: <https://192.168.100.78:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/>

