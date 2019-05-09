# API gateway   
1. 服务路由
2. 负载均衡
3. 缓存
4. 访问控制
5. 鉴权

# 微服务问题
1. 服务发现
2. 服务调用链的跟踪
3. 分区的数据库体系与分布式事务

1. API gateway
2. 服务间调用
3. 服务发现
4. 服务容错
5. 服务部署
6. 数据调用

# 第一代微服务架构
1. Spring Cloud
2. Dubbo

# 下一代微服务 Service mesh
服务网格，作为服务间通信的基础设施层。服务间的TCP/IP，负责服务之间的网络调用、限流、熔断和监控。

1. 应用程序间通信的中间层
2. 轻量级网络代理
3. 应用程序无感知
4. 解耦应用程序的重试、超时、监控、追踪和服务发现

![](http://dockone.io/uploads/article/20180306/347b3068d7be7039fd26dd17ae7686d3.png)

service mesh作为sidecar运行，对应用程序透明，所有应用程序的流量都通过它

## 开源软件
1. linkerd
2. envoy
3. lstio
4. Conduit

## 未来微服务技术栈
![](http://dockone.io/uploads/article/20180306/073c1177b53080ebb2a4e88d2fde32c9.jpg)


























