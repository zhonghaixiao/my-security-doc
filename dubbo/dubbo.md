# dubbo

## 架构演进
1. 单一应用架构：所有应用功能部署在单个节点上
2. 垂直应用架构：拆分应用，提升效率
3. 分布式服务架构：应用交互增多，将核心业务抽取作为独立的服务中心。
4. 流动计算架构：服务增多，小服务资源浪费。需要一个调度中心基于访问压力实时管理集群容量，提高集群利用率。

## Dubbo服务治理
- 服务分层：前端、集成、核心
- 调度中心：服务容量评估
- 监控中心：服务调用统计，关键路径分析
- 注册中心：服务注册与发现，服务测试
- 治理中心：服务文档，负责人，审批人
- 服务授权
- 服务容器
- 服务编排
- 软负载均衡
- 服务路由
- 服务质量协定

## 演进
1. 基于RMI，hessian， 暴露远程服务接口，配置服务的url调用，使用f5负载均衡
2. 基于注册中心，动态注册发现服务，使服务位置透明。（zookeeper）。在消费方获取服务地址列表，实现服务端负载均衡
3. 当服务依赖变得越来越复杂，服务调用量越来越大，需要服务统计信息来规划服务容量

## 架构
1. Provider: 暴露服务的服务提供方
2. Consumer：调用远程服务的服务消费方
3. Registry：服务注册与发现的注册中心
4. Monitor：统计服务调用次数和调用时间的监控中心
5. Container：运行服务的容器

## 使用 provider.xml
1. <dubbo:application name="demo-provider"/>
2. <dubbo:registry address="multicast://224.5.6.7:1234" />
3. <dubbo:protocol name="dubbo"/>
4. <dubbo:service interface="org.apache.dubbo.demo.DemoService" ref="demoService"/>

### consumer.xml
1. <dubbo:application name="demo-consumer"/>
2. <dubbo:registry address="multicast://224.5.6.7:1234"/>
3. <dubbo:reference id="demoService" interface="org.apache.dubbo.demo.DemoService" />

## 配置覆盖规则
方法级优先，接口级次之，全局配置再次之。

## 动态配置中心
1. 外部化配置，启动配置的集中式存储
2. 服务治理，服务治理规则的存储与通知



### 启用动态配置
<dubbo:config-center address="zookeeper://127.0.0.1:2181"/>

dubbo.config-center.address=zookeeper://127.0.0.1:2181

```
ConfigCenterConfig configCenter = new ConfigCenterConfig();
configCenter.setAddress("zookeeper://127.0.0.1:2181");
```

### 常用配置中心，外部化配置

dubbo.properties的外部化存储，将注册中心地址、元数据中心地址集中管理

1. Apollo
2. Nacos

```
# 将注册中心地址、元数据中心地址等配置集中管理，可以做到统一环境、减少开发侧感知。
dubbo.registry.address=zookeeper://127.0.0.1:2181
dubbo.registry.simplified=true

dubbo.metadata-report.address=zookeeper://127.0.0.1:2181

dubbo.protocol.name=dubbo
dubbo.protocol.port=20880

dubbo.application.qos.port=33333
```

1. zookeeper

<dubbo:config-center address="zookeeper://127.0.0.1:2181"/>

2. Apollo

<dubbo:config-center protocol="apollo" address="127.0.0.1:2181"/>

从名叫dubbo的命名空间中读取全局配置

应用自有的配置，会从application命名空间读取

3. 应用自行加载配置

```
// 应用自行加载配置
Map<String, String> dubboConfigurations = new HashMap<>();
dubboConfigurations.put("dubbo.registry.address", "zookeeper://127.0.0.1:2181");
dubboConfigurations.put("dubbo.registry.simplified", "true");

//将组织好的配置塞给Dubbo框架
ConfigCenterConfig configCenter = new ConfigCenterConfig();
configCenter.setExternalConfig(dubboConfigurations);
```

### 服务治理
1. configurators 覆盖规则
2. tag-router 标签路由
3. condition-router 条件路由

## 集群容错
dubbo提供多种容错方式，默认failover

1. failover cluster : 失败自动切换，当出现失败，重试其它服务器

<dubbo:service retries="2" />

<dubbo:reference retries="2" />

<dubbo:reference>
    <dubbo:method name="findFoo" retries="2" />
</dubbo:reference>

2. Failfast Cluster : 快速失败，只发起一次调用，失败立即报错。通常用于非幂等性的写操作，比如新增记录。
3. Failsafe Cluster : 失败安全，出现异常时，直接忽略。通常用于写入审计日志等操作。
4. Failback Cluster : 失败自动恢复，后台记录失败请求，定时重发。通常用于消息通知操作。
5. Forking Cluster : 并行调用多个服务器，只要一个成功即返回。
6. Broadcast Cluster : 广播调用所有提供者，逐个调用，任意一台报错则报错 [2]。通常用于通知所有提供者更新缓存或日志等本地资源信息。

### 配置集群模式

<dubbo:service cluster="failsafe" />

<dubbo:reference cluster="failsafe" />

## 负载均衡配置

1. Random LoadBalance
2. RoundRobin LoadBalance
3. LeastActive LoadBalance
4. ConsistentHash LoadBalance

### 配置
<dubbo:service interface="..." loadbalance="roundrobin" />
<dubbo:reference interface="..." loadbalance="roundrobin" />
<dubbo:service interface="...">
    <dubbo:method name="..." loadbalance="roundrobin"/>
</dubbo:service>
<dubbo:reference interface="...">
    <dubbo:method name="..." loadbalance="roundrobin"/>
</dubbo:reference>

## 线程模型
如果事件处理的逻辑能迅速完成，并且不会发起新的 IO 请求，比如只是在内存中记个标识，则直接在 IO 线程上处理更快，因为减少了线程池调度。

但如果事件处理逻辑较慢，或者需要发起新的 IO 请求，比如需要查询数据库，则必须派发到线程池，否则 IO 线程阻塞，将导致不能接收其它请求。

如果用 IO 线程处理事件，又在事件处理过程中发起新的 IO 请求，比如在连接事件中发起登录请求，会报“可能引发死锁”异常，但不会真死锁。

### 因此，需要通过不同的派发策略和不同的线程池配置的组合来应对不同的场景:
<dubbo:protocol name="dubbo" dispatcher="all" threadpool="fixed" threads="100" />

Dispatcher

1. all 所有消息都派发到线程池，包括请求，响应，连接事件，断开事件，心跳等
2. direct 所有消息都不派发到线程池，全部在 IO 线程上直接执行。
3. message 只有请求响应消息派发到线程池，其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
4. execution 只请求消息派发到线程池，不含响应，响应和其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
5. connection 在 IO 线程上，将连接断开事件放入队列，有序逐个执行，其它消息派发到线程池。

ThreadPool

1. fixed 固定大小线程池，启动时建立线程，不关闭，一直持有。(缺省)
2. cached 缓存线程池，空闲一分钟自动删除，需要时重建。
3. limited 可伸缩线程池，但池中的线程数只会增长不会收缩。只增长不收缩的目的是为了避免收缩时突然来了大流量引起的性能问题。
4. eager 优先创建Worker线程池。在任务数量大于corePoolSize但是小于maximumPoolSize时，优先创建Worker来处理任务。当任务数量大于maximumPoolSize时，将任务放入阻塞队列中。阻塞队列充满时抛出RejectedExecutionException。(相比于cached:cached在任务数量超过maximumPoolSize时直接抛出异常而不是将任务放入阻塞队列)

*** 这里与JDK的线程池处理任务的策略不同

## 直连提供者
在开发及测试环境下，经常需要绕过注册中心，只测试指定服务提供者，这时候可能需要点对点直连，点对点直连方式，将以服务接口为单位，忽略注册中心的提供者列表，A 接口配置点对点，不影响 B 接口从注册中心获取列表。

<dubbo:reference id="xxxService" interface="com.alibaba.xxx.XxxService" url="dubbo://localhost:20890" />

java -Dcom.alibaba.xxx.XxxService=dubbo://localhost:20890

## 只订阅
可以让服务提供者开发方，只订阅服务(开发的服务可能依赖其它服务)，而不注册正在开发的服务，通过直连测试正在开发的服务。

<dubbo:registry address="10.20.153.10:9090" register="false" />

<dubbo:registry address="10.20.153.10:9090?register=false" />

## 只注册
如果有两个镜像环境，两个注册中心，有一个服务只在其中一个注册中心有部署，另一个注册中心还没来得及部署，而两个注册中心的其它应用都需要依赖此服务。这个时候，可以让服务提供者方只注册服务到另一注册中心，而不从另一注册中心订阅服务。

<dubbo:registry id="hzRegistry" address="10.20.153.10:9090" />
<dubbo:registry id="qdRegistry" address="10.20.141.150:9090" subscribe="false" />

dubbo:registry id="hzRegistry" address="10.20.153.10:9090" />
<dubbo:registry id="qdRegistry" address="10.20.141.150:9090?subscribe=false" />

## 静态服务
有时候希望人工管理服务提供者的上线和下线，此时需将注册中心标识为非动态管理模式。

<dubbo:registry address="10.20.141.150:9090" dynamic="false" />

<dubbo:registry address="10.20.141.150:9090?dynamic=false" />

## 多协议
Dubbo 允许配置多协议，在不同服务上支持不同协议或者同一服务上同时支持多种协议。

### 不同服务不同协议
不同服务在性能上适用不同协议进行传输，比如大数据用短连接协议，小数据大并发用长连接协议

<!-- 多协议配置 -->
<dubbo:protocol name="dubbo" port="20880" />
<dubbo:protocol name="rmi" port="1099" />

<!-- 使用dubbo协议暴露服务 -->
<dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" protocol="dubbo" />
    <!-- 使用rmi协议暴露服务 -->
<dubbo:service interface="com.alibaba.hello.api.DemoService" version="1.0.0" ref="demoService" protocol="rmi" /> 

///

<!-- 多协议配置 -->
<dubbo:protocol name="dubbo" port="20880" />
<dubbo:protocol name="hessian" port="8080" />

 <!-- 使用多个协议暴露同一个服务 -->
<dubbo:service id="helloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" protocol="dubbo,hessian" />

## 多注册中心
Dubbo 支持同一服务向多注册中心同时注册，或者不同服务分别注册到不同的注册中心上去，甚至可以同时引用注册在不同注册中心上的同名服务

### 多注册中心注册
<!-- 多注册中心配置 -->
<dubbo:registry id="hangzhouRegistry" address="10.20.141.150:9090" />
<dubbo:registry id="qingdaoRegistry" address="10.20.141.151:9010" default="false" />
<!-- 向多个注册中心注册 -->
<dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" registry="hangzhouRegistry,qingdaoRegistry" />

### 不同服务使用不同注册中心
<!-- 多注册中心配置 -->
<dubbo:registry id="chinaRegistry" address="10.20.141.150:9090" />
<dubbo:registry id="intlRegistry" address="10.20.154.177:9010" default="false" />
<!-- 向中文站注册中心注册 -->
<dubbo:service interface="com.alibaba.hello.api.HelloService" version="1.0.0" ref="helloService" registry="chinaRegistry" />
<!-- 向国际站注册中心注册 -->
<dubbo:service interface="com.alibaba.hello.api.DemoService" version="1.0.0" ref="demoService" registry="intlRegistry" />

### 多注册中心引用：服务调用方引用不同注册中心的同一个服务
<!-- 多注册中心配置 -->
<dubbo:registry id="chinaRegistry" address="10.20.141.150:9090" />
<dubbo:registry id="intlRegistry" address="10.20.154.177:9010" default="false" />
<!-- 引用中文站服务 -->
<dubbo:reference id="chinaHelloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" registry="chinaRegistry" />
<!-- 引用国际站站服务 -->
<dubbo:reference id="intlHelloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" registry="intlRegistry" />

<!-- 多注册中心配置，竖号分隔表示同时连接多个不同注册中心，同一注册中心的多个集群地址用逗号分隔 -->
<dubbo:registry address="10.20.141.150:9090|10.20.154.177:9010" />
<!-- 引用服务 -->
<dubbo:reference id="helloService" interface="com.alibaba.hello.api.HelloService" version="1.0.0" />

## 服务分组
当一个接口有多种实现时，可以用 group 区分。

<dubbo:service group="feedback" interface="com.xxx.IndexService" ref="com.xxx.IndexServiceImpl1"/>
<dubbo:service group="member" interface="com.xxx.IndexService" ref="com.xxx.IndexServiceImpl2"/>

<dubbo:reference id="feedbackIndexService" group="feedback" interface="com.xxx.IndexService" />
<dubbo:reference id="memberIndexService" group="member" interface="com.xxx.IndexService" />

任意组

<dubbo:reference id="barService" interface="com.foo.BarService" group="*" />

## 多版本

当一个接口实现，出现不兼容升级时，可以用版本号过渡，版本号不同的服务相互间不引用。


？？？

1. 在低压力时间段，先升级一半提供者为新版本
2. 再将所有消费者升级为新版本
3. 然后将剩下的一半提供者升级为新版本


<dubbo:service interface="com.foo.BarService" version="1.0.0" /> old service
<dubbo:service interface="com.foo.BarService" version="2.0.0" /> new service
<dubbo:reference id="barService" interface="com.foo.BarService" version="1.0.0" />  old consumer
<dubbo:reference id="barService" interface="com.foo.BarService" version="2.0.0" />  new consumer
<dubbo:reference id="barService" interface="com.foo.BarService" version="*" />  不区分版本

## 分组聚合
按组合并返回结果，比如菜单服务，接口一样，但有多种实现，用group区分，现在消费方需从每种group中调用一次返回结果，合并结果返回，这样就可以实现聚合菜单项。

<dubbo:reference interface="com.xxx.MenuService" group="*" merger="true" />

<dubbo:reference interface="com.xxx.MenuService" group="aaa,bbb" merger="true" />

<dubbo:reference interface="com.xxx.MenuService" group="*">
    <dubbo:method name="getMenuItems" merger="true" />
</dubbo:reference>

<dubbo:reference interface="com.xxx.MenuService" group="*" merger="true">
    <dubbo:method name="getMenuItems" merger="false" />
</dubbo:reference>

















## 技术栈
1. Netty
2. Zookeeper
3. 



4. 服务提供者 - 启动时在指定端口上暴露服务，并将服务地址和端口注册到注册中心上
5. 服务消费者 - 启动时向注册中心订阅自己感兴趣的服务，以便获得服务提供方的地址列表
6. 注册中心 - 负责服务的注册和发现，负责保存服务提供方上报的地址信息，并向服务消费方推送
7. 监控中心 - 负责收集服务提供方和消费方的运行状态，比如服务调用次数、延迟等，用于监控
8. 运行容器 - 负责服务提供方的初始化、加载以及运行的生命周期管理

![image.png](https://upload-images.jianshu.io/upload_images/5977684-1c17817cefb2cc30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




# CuratorFrameworkImpl
























