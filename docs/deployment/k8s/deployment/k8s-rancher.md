[toc]

# 安装rancher的过程整理



> 记录 rke up 安装K8s集群后安装rancher的过程
>
> helm版本：2.12.0



## 安装rancher



1. 使用外部证书

	1. 外部证书方式
	helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
	helm install rancher-stable/rancher \
		--name rancher \
		--namespace cattle-system \
		--set hostname=rancher234.keep.com \
		--set tls=external



2. 由rancher自动生成证书

```
2. 由rancher自动生成证书的方式

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
# 安装证书管理器
helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system
  
# 安装rancher
helm install rancher-stable/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=rancher234.keep.com
  
# 删除证书和rancher
# helm del --purge cert-manager
# helm del --purge rancher
```

 

## 给Agent Pod添加hosts记录

为了使cattle-cluster-agent和cattle-node-agent正常，给Agent Pod添加hosts记录。也可直接在rancher管理界面上操作。

	kubectl -n cattle-system patch deployments cattle-cluster-agent --patch '{
		"spec": {
			"template": {
				"spec": {
					"hostAliases": [
						{
							"hostnames": ["rancher234.keep.com"],
							"ip": "192.168.101.71"
						}
					]
				}
			}
		}
	}'
	
	kubectl -n cattle-system patch daemonsets cattle-node-agent --patch '{
		"spec": {
			"template": {
				"spec": {
					"hostAliases": [
						{
							"hostnames":["rancher234.keep.com"],
							"ip": "192.168.101.71"
						}
					]
				}
			}
		}
	}'



## 改为NodePort方式暴露rancher服务

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: rancher
    chart: rancher-2.3.5
    heritage: Tiller
    release: rancher
  name: rancher
  namespace: cattle-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30080
  selector:
    app: rancher
  sessionAffinity: None
  type: NodePort
```



## 首节点NginX的配置

```
gzip on;
gzip_disable "msie6";
gzip_disable "MSIE [1-6]\.(?!.*SV1)";
gzip_vary on;
gzip_static on;
gzip_proxied any;
gzip_min_length 0;
gzip_comp_level 8;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types
  text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml application/font-woff
  text/javascript application/javascript application/x-javascript
  text/x-json application/json application/x-web-app-manifest+json
  text/css text/plain text/x-component
  font/opentype application/x-font-ttf application/vnd.ms-fontobject font/woff2
  image/x-icon image/png image/jpeg;

# 这里配置为配置了ingress的work节点
upstream rancher {
    server 192.168.101.71:30080;
    server 192.168.101.72:30080;
}

map $http_upgrade $connection_upgrade {
    default Upgrade;
    ''      close;
}

server {
    listen 443 ssl;
    #配置域名
    server_name rancher234.keep.com;
    #配置证书
    ssl_certificate /etc/letsencrypt/live/keep.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/keep.com/privkey.pem;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://rancher;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        # This allows the ability for the execute shell window to remain open for up to 15 minutes.
        ## Without this parameter, the default is 1 minute and will automatically close.
        proxy_read_timeout 900s;
        proxy_buffering off;
    }
}
# 配置301重定向
server {
    listen 80;
    server_name rancher234.keep.com;
    return 301 https://$server_name$request_uri;
}
```



## 登录

浏览器登录：<https://rancher234.keep.com>

初始账号：admin  /  rancher   ，当前需添加hosts记录：

	192.168.101.71  rancher234.keep.com



---

## 上述过程存在的问题

- cattle-cluster-agent 状态异常

- 是通过nodePort方式暴露rancher服务来访问集群的，rke up集群之后，只有首节点（101.71  etcd,master）没有占用80端口，用来安装NginX；不通过集群外部nginx的访问方式没有试成功。

- 当前rancher是以自动管理证书方式安装的，但nginx配置了外部证书



---

## 修复步骤

> 通过 rke up 初步安装集群之后



### 安装helm和tiller

```sh
# helm v2.12.0
wget https://get.helm.sh/helm-v2.12.0-linux-amd64.tar.gz
tar -xf helm-v2.12.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin

# tiller v2.12.0
kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.12.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
```



### 安装rancher

将会在2个worker节点各部署一个pod

```yaml
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

helm install rancher-stable/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=rancher-staging.keep.com \
  --set ingress.tls.source=secret \
  --set replicas=2
```



### 修改ingress-nginx默认的安全证书

创建secret
```sh
# 事先准备好了证书和key
kubectl -n ingress-nginx create secret tls ingress-default-cert --cert=/etc/letsencrypt/live/keep.com/fullchain.pem --key=/etc/letsencrypt/live/keep.com/privkey.pem
```



修改args

```sh
kubectl -n ingress-nginx edit daemonset nginx-ingress-controller

# 修改args参数为
args:
    ...
    - --default-ssl-certificate=ingress-nginx/ingress-default-cert	# 添加此行
```



修改部署节点使ingress-nginx部署在master上

```sh
# 原：
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: beta.kubernetes.io/os
                operator: NotIn
                values:
                - windows
              - key: node-role.kubernetes.io/worker
                operator: Exists
				
      tolerations:
      - effect: NoExecute
        operator: Exists
      - effect: NoSchedule
        operator: Exists
		
# 改为：
      nodeSelector:
        node-role.kubernetes.io/controlplane: "true"
      tolerations:
      - operator: Exists
      
# 或者:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: beta.kubernetes.io/os
                operator: NotIn
                values:
                - windows
              - key: node-role.kubernetes.io/controlplane
                operator: Exists
	  tolerations:
      - operator: Exists
```


改完之后，可通过https域名访问。




### 通过keepalived绑定虚拟IP

参考kubespray安装K8s的keepalived配置示例



### 重新安装时清理

```sh
# 1. rke 节点
su - rancher
rke remove --config rancher-cluster.yml

# 2. 各节点
docker ps -aq |xargs docker rm -f
rm -rf /opt/cni  /opt/rke  /etc/kubernetes  /var/lib/rancher
```



### 修改rancher绑定新的域名

在rancher管理界面修改rancher的ingress和deployment



### 给rancher绑定数据卷

在rancher管理界面修改rancher的deployment



### 给Agent Pod添加hosts记录

在rancher管理界面修改cattle-cluster-agent和cattle-node-agent的网络配置项



### 安装kubernetes dashboard

创建secret

```sh
kubectl -n kube-system  create secret tls com-keep-secret --cert=/etc/letsencrypt/live/keep.com/fullchain.pem --key=/etc/letsencrypt/live/keep.com/privkey.pem
```

  

修改values.yaml引入加密证书

```yaml
...
ingress:
  enabled: true
  hosts: 
    - k8s.keep.com
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  tls:
    - secretName: com-keep-secret
      hosts:
      - k8s.keep.com
...
```



安装

```sh
helm install stable/kubernetes-dashboard  --name kubernetes-dashboard  --namespace kube-system -f values.yaml
```



授权

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-minimal
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
```



获取token

```sh
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard-token|awk '{print $1}') |grep token: |awk '{print $2}'
```

