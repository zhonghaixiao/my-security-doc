# Jedis配置

### Redis数据库索引（默认为0）
spring.redis.database=0
### Redis服务器地址
spring.redis.host=localhost
### Redis服务器连接端口
spring.redis.port=6379
### Redis服务器连接密码（默认为空）
spring.redis.password=123456
### 连接池最大连接数（使用负值表示没有限制）
spring.redis.jedis.pool.max-active=1024
### 连接池最大阻塞等待时间（使用负值表示没有限制）
spring.redis.jedis.pool.max-wait=10000
### 连接池中的最大空闲连接
spring.redis.jedis.pool.max-idle=200
### 连接池中的最小空闲连接
spring.redis.jedis.pool.min-idle=0
### 连接超时时间（毫秒）
spring.redis.timeout=10000
spring.redis.block-when-exhausted=true

# jedis连接池的实现 GenericObjectPool 对象池

# redis lua  (lua 5.1)
1. eval
2. evalsha

## 优势
1. 减少网络开销
2. 原子操作，无需担心并发，也无需事务
3. 复用，脚本永久保存在redis中，其他客户端也可以使用

> eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second
eval的参数分别是：lua脚本，keys参数数量，keys,values

> eval "return redis.call('set','foo','bar')" 0

> eval "return redis.call('set', KEYS[1], 'bar')" 1 foo


1. redis.call()
2. redis.pcall()

# url:
1. https://redis.io/documentation
2. https://crossoverjie.top/JCSprout/#/collections/ArrayList
3. https://www.cnblogs.com/barrywxx/p/8563284.html
4. https://github.com/zhonghaixiao/redistest.git
5. https://github.com/redisson/redisson/wiki/Table-of-Content






































