# 基本安全框架
![shiro-overall.jpg](https://upload-images.jianshu.io/upload_images/5977684-ea9de28d14bd83fc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
## 1. 认证		    Authentication
- 
---
## 2. 授权		    Authorization
-
---
## 3. 前端拦截器	filter	
- web filter拦截请求，读取请求Cookie中的sessionId,判断是否当前Subject是否有权访问此url
- 拦截token，将Subject信息写入ThreadLocal中，用于校验service方法层的权限，同时作为环境信息供业务层使用
- 
--- 
## 4. 数据源配置	Realm
- 数据源可以是JDBC或者InMemory、LDAP,可以配置多个数据源并配置数据源使用策略
- 
---
## 5. 缓存          Cache
- 缓存包括本地缓存(EhCache、Coffine)、Redis缓存
- 缓存用于缓存当前用户的认证和授权信息等，解决每次认证都访问数据库的问题
---
## 6. 会话          Session
- 标识用户端有两种方式
  1. Token:在Cookie中写入加密的用户基本信息，并设置过期时间
  2. session：由一个sessionId标识客户端，所有用户信息存储在服务端，可以使用redis缓存session对应的用户信息，解决集群间授权信息共享问题
-  
---
## 7. AOP          方法调用权限
- 在需要授权的方法上添加注解，标识所需权限，在方法执行前检查当前用户是否有权限调用方法
- Spring AOP
- AspectJ
---




















