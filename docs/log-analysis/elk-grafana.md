### ELK - Grafana图表



- 配置数据源

  示例：

  ![1577242259945](elk-grafana.assets/1577242259945.png)

  

- 安装piechart控件

```sh
grafana-cli plugins install grafana-piechart-panel
```



- 自定义图表

![1577242466917](elk-grafana.assets/1577242466917.png)



以其中Security日志表为例，配置如下：

![1577242584010](elk-grafana.assets/1577242584010.png)



- 识图

![1577243080388](elk-grafana.assets/1577243080388.png)



![1577243382431](elk-grafana.assets/1577243382431.png)



