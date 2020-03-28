# 常用的几个ES设置API



```sh
PUT /_settings
{
    "index" : {
        "number_of_replicas" : 0
    }
}

PUT /_cluster/settings
{
  "transient": {
    "cluster": {
      "max_shards_per_node": 4096
    }
  }
}

GET /_cluster/state?pretty

GET /_cat/indices?v

GET /_cluster/health?pretty

GET /_xpack/security/role/role_dev

GET /_security/role/role_dev

PUT /_security/role/role_dev
{
    "indices": [
      {
        "names": [
          "dev.*"
        ],
        "privileges": [
          "all"
        ],
        "field_security": {
          "grant": [
            "*"
          ],
          "except": []
        },
        "allow_restricted_indices": false
      }
    ],
    "applications": [
      {
        "application": "kibana-.kibana",
        "privileges": [
          "feature_discover.all",
          "feature_visualize.all",
          "feature_dashboard.all",
          "feature_dev_tools.all",
          "feature_indexPatterns.all"
        ],
        "resources": [
          "space:default"
        ]
      }
    ],
    "run_as": [],
    "metadata": {},
    "transient_metadata": {
      "enabled": true
    }
}

PUT /dev.a_2020.02.28/_doc/1
{
  "datetime": "2020-02-28T12:47:00",
  "msg": "dev.a 1"
}

GET /dev.a_2020.02.28/_search
{
  "query": {
    ""
    "regexp": {
    "msg": ".*1"
  }}
}

GET /_security/role_mapping/admins

DELETE /_security/role_mapping/admins

GET /_security/role_mapping/basic_users

DELETE /_security/role_mapping/basic_users

PUT /_security/role_mapping/admins
{
  "roles" : [ "superuser" ],
  "rules" : {
    "field" : {
      "groups" : "CN=elk_admin,OU=Elasticsearch,OU=系统帐号,DC=keep,DC=com"
    }
  },
  "enabled": true
}

PUT  /_security/role_mapping/basic_users
{
    "enabled" : true,
    "roles" : [
      "role_default"
    ],
    "rules" : {
      "any" : [
        {
          "field" : {
            "groups" : "CN=elk_user,OU=Elasticsearch,OU=系统帐号,DC=keep,DC=com"
          }
        },
        {
          "field" : {
            "groups" : "CN=elk_admin,OU=Elasticsearch,OU=系统帐号,DC=keep,DC=com"
          }
        }
      ]
    },
    "metadata" : { }
}
```

