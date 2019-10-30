1. 隔离调用
2. 阻止错误级联传播
3. 后备策略

1. Thread 隔离
2. Semaphore 隔离

## 目标
1. 保护网络请求调用，当出现延时和错误时保护调用方
2. 在负载分布式系统中防止级联错误传播
3. 快速失败和恢复
4. 优雅降级
5. 实时监控，警告，控制

1. wrapped all calls in a HystrixCommand , HystrixObservableCommand
2. 结束超时调用
3. 为每一个远程依赖创建线程池
4. 监控调用成功、失败、超时、thread rejection
5. 当调用的失败率高于一定阈值，断开调用，快速失败；延时一段时间继续发起调用，当成功率高于一定阈值，断路器合上，自动恢复
6. 当调用失败时，提供fallback logic
7. 监控性能指标，支持配置动态更新

## flow chart
1. construct HystrixCommand, HystrixObervableCommadn

2.  execute:queue().get
    queue:toObservable().toBlocking().toFuture()
    observe,    hot observable
    toObservable    cold observable

## 断路器 HystrixCircuitBreaker


1. 隔离远程调用，防止一个状态不正常的调用填满线程池
2. 每一个调用都对应不同的线程池，不相互干扰
3. 


# 源码分析

## HystrixExecutable
1. execute() 同步调用
2. queue() 异步调用，返回Future
3. observe() 返回Observable,可以订阅获取异步结果

## HystrixObservable
1. observe
2. toObservable

## 参数
1. HystrixCommandGroupKey
2. HystrixCommandKey
3. HystrixThreadPoolKey
4. HystrixCollapserKey
5. HystrixCommandMetrics
6. HystrixCommandProperties
7. 




























