# Actuator
暴露方式
- JMX
- HTTP

## 端点（Endpoints）
用于监控应用并与应用进行交互

1. health       /actuator/info
2. 

management.endpoints.web.base-path=/        

## 启用端点
management.endpoint.<id>.enabled

management.endpoint.shutdown.enabled=true

### 启用info，禁用其他端点
management.endpoints.enabled-by-default=false

management.endpoint.info.enabled=true

management.endpoints.web.exposure.include=*

management.endpoints.web.exposure.exclude=env,beans

# Prometheus



























