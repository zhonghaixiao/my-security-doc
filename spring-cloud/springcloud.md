1. 分布式版本控制配置   distributed/versioned configuration
2. 服务注册与发现   service registration and discovery
3. 路由 routing
4. service-to-service calls 服务调用
5. load balancing   负载均衡
6. circuit breakers 熔断
7. Distributed messaging 分布式消息

1. spring cloud context
2. spring cloud common

## The Bootstrap Apllication context
1. bootstrap.properties
2. application.properties

# spring cloud config
- client ---> spring Environment
- server ---> spring PropertySource

# Eureka
1. locate service
2. load balance
3. 后备策略

1. Eureka Server
2. Eureka Client

## load balance 考虑的因素
1. traffic
2. resource usage
3. error condition

## ELB (elastic load balancer)
基于代理的loadBalance

1. hystrix          https://github.com/Netflix/Hystrix
2. resilience4j     https://github.com/resilience4j/resilience4j
3. Sentinel         https://github.com/alibaba/Sentinel
4. feign            https://github.com/OpenFeign/feign



































