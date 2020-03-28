# Consul API



```sh
# register
curl http://192.168.100.140:8500/v1/agent/service/register -X PUT -i -H "Content-Type:application/json" -d '{
    "Name": "name002", 
    "Tags": [
        "tag2"
    ], 
    "EnableTagOverride": false, 
    "ID": "name002_id01", 
    "Meta": {"ver": "2.0"}, 
    "Address": "127.0.0.1", 
    "Port": 80, 
    "Check": {
        "DeregisterCriticalServiceAfter": "90m", 
        "Args": [], 
        "HTTP": "www.bd6.com", 
        "Interval": "15s"
    }
}'


# deRegister by ID
curl  -X PUT http://192.168.100.140:8500/v1/agent/service/deregister/test.swms.api2.01

# DNS查询
dig @192.168.100.140 -p 8600 web.service.consul SRV

# passing状态的服务
curl -s http://192.168.100.141:8500/v1/health/state/passing    ### OK

curl http://192.168.100.140:8500/v1/agent/health/service/name/swms.api2    #??? 输出[]

curl -s http://192.168.100.142:8500/v1/catalog/service/web  ## OK

[root@yh-zlz ~]# curl http://192.168.100.141:8500/v1/catalog/services
{"YH.EasEdi":[""],"consul":[],"swms.api2":["swms","api2"],"web":["rails"]}

[root@yh-zlz opt]# consul members
Node          Address               Status  Type    Build  Protocol  DC    Segment
140-consul01  192.168.100.140:8301  alive   server  1.4.4  2         dc01  <all>
141-consul02  192.168.100.141:8301  alive   server  1.4.4  2         dc01  <all>
142-consul03  192.168.100.142:8301  alive   server  1.4.4  2         dc01  <all>
2-RuntoTest   192.168.100.2:8301    alive   client  1.4.4  2         dc01  <default>
yh_zlz        192.168.100.150:8301  alive   client  1.4.4  2         dc01  <default>

[root@yh-zlz opt]# consul operator raft list-peers
Node          ID                                    Address               State     Voter  RaftProtocol
142-consul03  e75bff67-c414-286e-4e44-ab29ade3a5e5  192.168.100.142:8300  leader    true   3
140-consul01  bc1918d1-f12f-a149-4e92-054a1794a6fd  192.168.100.140:8300  follower  true   3
141-consul02  bcea5d37-80a5-521b-1703-c9578ff0a261  192.168.100.141:8300  follower  true   3

```