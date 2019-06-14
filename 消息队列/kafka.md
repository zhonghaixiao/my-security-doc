


- 高性能消息发送与消息消费
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

# Apache Kafka实战

## 启动kafka
> 启动zookeeper

bin/zookeeper-server-start.sh config/zookeeper.properties

> 启动kafka

/bin/kafka-server-start.sh config/server.properties

> 创建Topic  

topic主题，partition分区，replica副本

/bin/kafka-topics.sh --create --zookeeper localhost:2181 --topic test --partitions 1 --replication-factor 1

> 查看topic状态

/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test

> 发送消息

/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test 

> 消费消息

/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

## 消息引擎系统
- 消息队列
- 消息中间件

1. 消息主体是结构化的数据


- 消息队列模型
- 发布订阅模型

## Kafka 设计
1. 吞吐量/延时
2. 消息持久化
3. 负载均衡和故障转移
4. 伸缩性

1. 高吞吐低延时

- 大量使用操作系统页缓存，内存操作速度快且命中率高
- kafka不直接参与物理io操作，而是交由最擅长的操作系统完成
- 采用追加写入方式，摒弃缓慢的磁盘随机读、写操作
- 使用以sendfile为代表的零拷贝技术加强网络间的数据传输效率

2. 消息持久化

- 解耦消息发送与消息消费
- 实现灵活的消息处理

## 消息格式

CRC|版本号|属性|时间戳|key长度|key|value长度|value

- key: 消息键，对消息做partition使用，决定消息被保存在某个topic下的哪个partition
- value: 消息体，保存实际的消息数据
- Timestamp: 消息发送时间戳，用于流式处理和其他依赖时间的处理语义

kafka消息在Java中使用ByteBuffer表示

kafka大量使用页缓存而不是堆内存，占用空间小，不用担心gc的性能，进程崩溃时页面缓存数据还在

## topic（主题） 和 partition （分区）

每一个topic可以含有多个partition

offset: topic partition下的每条消息都分配一个位移值 

每条消息在某个partition的位移是固定的，但消费该partition的消费者的位移会随着消费进度不断前移

消息： <topic, partition, offset>

## replica 副本
防止数据丢失

- leader 领导者副本
- follower 追随者副本

leader所在的broker宕机，选举一个follower作为leader 提供服务

已同步副本集合：副本与leader保持同步状态，只有该集合中的副本都收到了同一消息，kafka才会将消息置于已提交状态

## Kafka使用场景
1. 消息传输
2. 网站行为日志追踪
3. 审计数据收集     对多路消息实时收集
4. 日志收集
5. Event Sourcing 
6. 流式处理  （Apache Storm , Apache Samza, Spark Streaming , Apache Flink, Kafka Streams）


- broker
- producer
- consumer

客户端：
- KafkaConsumer
- KafkaProducer

## Producer开发

向tpoic的某个partition发送消息

- 分区器 对于每条消息，如果消息指定了key，partition根据key的hash值选择目标分区；如果没有key，使用轮询的方式确定目标分区

- send 同步/异步

### 可重试异常 RetriableException
- LeaderNotAvailableException        在选举leader
- NotControllerException        controller当前不可用，controller在选举
- NetworkException              

### 不可重试异常
- RecordTooLargeException
- SerializationException
- KafkaException

### 参数
- acks 

# 消费者

kafka消费者从kafka读取数据，若干个consumer订阅kafka集群中的若干个topic并从kafka接收属于这些topic的消息

KafkaConsumer

## 两个类别
1. 消费者组     (consomer group)    多个消费者实例构成一个整体进行消费
2. 独立消费者   (standalone consumer)

## 定义
Consumers label themselves with a consumer group name,and each record published to a topic is delivered to one container instance within each subscribing consumer group.

消费者使用一个消费者组名标记自己，topic的每条消息都只会发送到每个订阅它的消费者组的一个消费实例上

- 基于队列的模型    所有consumer实例属于相同group，每条消息只会被一个consumer实例处理
- 订阅/发布 consumer属于不同的group，kafka广播消息到每一个group中


# 设计原理

- broker
- producer
- consumer
















