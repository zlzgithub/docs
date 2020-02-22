# Consul



>当前consul集群（192.168.100.140-142）用作服务发现和健康检查，配合Prometheus、NginX完成动态配置。



## API

以[Consul API](https://www.consul.io/api/index.html)为准。我们主要用了以下两个：



- 注册服务（Register Service）

```sh
curl http://192.168.100.140:8500/v1/agent/service/register -X PUT -i -H "Content-Type:application/json" -d '{
    "Name": "test-name", 
    "Tags": [
        "test-tag"
    ], 
    "EnableTagOverride": false, 
    "ID": "test-id", 
    "Meta": {"version": "1.0"}, 
    "Address": "192.168.100.150", 
    "Port": 8080, 
    "Check": {
        "DeregisterCriticalServiceAfter": "90m", 
        "Args": [], 
        "HTTP": "http://192.168.100.150:8080/", 
        "Interval": "15s"
    }
}'
```



- 注销服务（Deregister Service）

```sh
curl -X PUT http://192.168.100.140:8500/v1/agent/service/deregister/test-id
```

