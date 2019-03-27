- 一个面向实时数据流的平台
- 基于持续数据流构建应用程序

## 应用场景
- 用于事件驱动微服务系统的消息总线
- 流式应用
- 大规模数据管道


命令：
1.  启动server
>  .\kafka-server-start.bat ..\..\config\server.properties

2. 创建一个topic
>  .\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

> 除了手动创建topic,也可以配置broker在消息发布时自动创建不存在的topic

3. topics列表
> .\kafka-topics.bat --list --zookeeper localhost:2181

4. 发送消息
> .\kafka-console-producer.bat --broker-list localhost:9092 --topic test

5. 创建消费者
>  .\kafka-console-consumer.bat --bootstrap-server localhost:9092 --topic test --from-b
eginning

## 深入理解kafka



























