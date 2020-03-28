# dataX数据迁移示例



数据复制：

```sh
datax/bin/datax.py $dataX_json -p "-Dstart_time=$new_st -Dend_time=$new_end"
```



json描述文件：

```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 3
      },
      "errorLimit": {
        "record": 0,
        "percentage": 0.02
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "xxx",
            "where": "create_time >= FROM_UNIXTIME(${start_time}) and create_time < FROM_UNIXTIME(${end_time})",
            "column": [
              "id",
              "name",
              "ip",
              "instance",
              "severity",
              "`desc`"
              "create_time",
              "status",
              "expr"
            ],
            "connection": [
              {
                "table": [
                  "monitor_problem"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.100.200:3306/adminset"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "mysqlwriter",
          "parameter": {
            "writeMode": "insert",
            "username": "root",
            "password": "xxx",
            "column": [
              "id",
              "name",
              "ip",
              "instance",
              "severity",
              "description",
              "create_time",
              "status",
              "expression"
            ],
            "connection": [
              {
                "jdbcUrl": "jdbc:mysql://192.168.100.201:3306/test_db_dms?useUnicode=true&characterEncoding=utf8",
                "table": [
                  "monitor_problem_copy"
                ]
              }
            ]
          }
        }
      }
    ]
  }
}
```

