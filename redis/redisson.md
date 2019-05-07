# Redisson 简介
基于Redis的Java驻内存网格，提供一系列具有分布式特性的工具类。使得原本Java中协调多线程的并发工具包可以协调分布式多级多线程并发。简化分布式环境中程序的相互协作。

## 使用场景
1. 分布式应用
2. 分布式缓存
3. 分布式会话管理
4. 分布式服务（任务、延时任务、执行器）
5. 分布式redis客户端

## Single Instance settings
1. address redis://host:port

# 代码调用方式
1. RedissonClient           同步/异步
2. RedissonReactiveClient   Reactive
3. RedissonRxClient         RxJava2

# 数据自动分片
将单个集合分布到整个redis集合中



- redisson支持自动重试， retryAttempts, retryInterval

# 源码分析

## 1. BlockingQueue
1. redisson.getBlockingQueue(name)
2. new RedissonBlockingQueue(connectionManager.getCommandExecutor(), name, this)

## RedissonBlockingQueue

1. offerAsync 将当前任务插入zset、list中，

## QueueTransferTask

## QueueTransferService

## ResissonAtomicLong
1. compareAndSetAsync
   
    name, expect, update
```
local currValue = redis.call('get', name);
if currValue == expect or (tonumber(expect) == 0 and currValue == false) then
    redis.call('set', name, update);
    return 1
else
    return 0
end
```

2. getAndDeleteAsync
```
local currValue = redis.call('get', name);
redis.call('del', name);
return currValue;
```

## RedissonBucket



## CommandAsyncService

## RedissonPromise

## RedisObject

## ConnectionManager 
1. SingleConnectionManager


## EvictionScheduler

## WriteBehindService





































