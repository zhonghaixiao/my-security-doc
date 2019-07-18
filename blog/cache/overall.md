# 应用服务缓存优化

- GC调优
- 缓存穿透
- 缓存覆盖

## 数据同步 + Redis缓存
通过消息队列将数据同步到Redis中，

第一次请求到来，先查询缓存，若未命中则查库，然后将结果写入消息队列返回；监听消息队列，根据消息类型将数据写入Redis或者执行动作(新数据写入、数据过期删除)

？ 这里是不是直接写入Redis更快一些；（缓存是否写入成功影响不大，可以采用发后及忘模式，所以消息队列应该更快）

？ redis单点故障导致的缓存雪崩如何解决

## JavaMap, Guava cache
进程内缓存作为一级缓存，redis作为二级缓存

## Guava Cache刷新
设置Guava写后刷新时间，进行刷新。无法实时刷新

## 外部缓存异步刷新
基于Redis作为消息通知，刷新Guava Cache

# 缓存进化史
1. hashmap,concurrentHashmap
2. lruHashMap, fifo(先入先出)， lru(最近最少使用), lfu(最近最少频率)

lru map最为常用，但存在几个问题：
- 锁争用
- 不支持过期时间
- 不支持自动刷新


3. Guava cache

```
LoadingCache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(100)
                //写之后30ms过期
                .expireAfterWrite(30L, TimeUnit.MILLISECONDS)
                //访问之后30ms过期
                .expireAfterAccess(30L, TimeUnit.MILLISECONDS)
                //20ms之后刷新
                .refreshAfterWrite(20L, TimeUnit.MILLISECONDS)
                //开启weakKey key 当启动垃圾回收时，该缓存也被回收
                .weakKeys()
                .build(createCacheLoader());
        System.out.println(cache.get("hello"));
        cache.put("hello1", "我是hello1");
        System.out.println(cache.get("hello1"));
        cache.put("hello1", "我是hello2");
        System.out.println(cache.get("hello1"));

```

- guava cache 分段加锁，每个段负责自己的淘汰
































