# K8s helm & tiller



> https://v2.helm.sh/docs/using_helm/#installing-helm

​	

```
export helm_version=v2.16.3
# 获取helm
wget https://get.helm.sh/helm-${helm_version}-linux-amd64.tar.gz
tar -xf helm-${helm_version}-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/

# 安装tiller
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:${helm_version} --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts --upgrade

# helm reset
Tiller (the Helm server-side component) has been uninstalled from your Kubernetes Cluster.
```



恢复google的stable chart地址：

```
# helm repo add stable https://kubernetes-charts.storage.googleapis.com
```



常用的选项参数：

```
# 选项参数
-n, --name
--namespace
-f, --values

[root@m01 helm-elk]# helm del es 
release "es" deleted
[root@m01 helm-elk]# helm del es --purge
release "es" deleted
/[root@m01 helm-elk]# helm install --name es --namespace elk -f values.yaml  elasticsearch-7.5.1/
```



K8s v1.16+ 按以上方法安装tiller可能会报错：

```sh
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

# 安装tiller报错（k8s版本问题，旧版yaml需修改）
helm init --service-account tiller --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:${helm_version} --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts 

# 解决方法：
# 1. 导出yaml
helm init --output yaml > tiller.yaml

# 2. 添加
  selector:
    matchLabels:
      app: helm
      name: tiller
  spec:
    serviceAccount: tiller

# 3. apply
kubectl apply -n kube-system -f tiller.yaml
```

