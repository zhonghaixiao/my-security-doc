# rxjava

1. 异步与基于事件的程序的开发库，使用可观察序列
2. 观察者模式
3. 声明式将多个序列组合
4. 不用考虑底层线程，同步，线程安全，并发数据结构

## version2.0
1. 依赖 Reactive Streams
2. java8风格API
3. 同步、异步调用
4. 

## 基础类
1. Flowable     0..N flows,支持Reactive Streams,和backpressure
2. Observable   0..N flows,不支持backpressure
3. Single       a flow of exactly 1 item or an error
4. Completable  a flow without items but only a completion or error signal,
5. Mabe         a flow with no items, exactly one item or an error.

1. source.operator1().operator2().operator3().subscribe(consumer);
2. source.flatMap(value -> source.operator1().operator2().operator3());

## Schedulers 调度器
RxJava不与Thread或者ExecutorServices直接交互，而是抽象出并发源。

1. Schedulers.computation() 在固定数目线程中运行计算任务，默认调度器
2. Schedulers.io()       在动态数量的线程中执行IO或阻塞任务
3. Schedulers.single()
4. Schedulers.trampoline(): Run work in a sequential and FIFO manner in one of the participating threads, usually for testing purposes.

Schedulers.from(Executor) 包装现有线程池

## 并行执行
map在相同的计算线程中顺序收到1到10
```
Flowable.range(1, 10)
  .observeOn(Schedulers.computation())
  .map(v -> v * v)
  .blockingSubscribe(System.out::println);
```
并行处理，顺序与输入不一致
```
Flowable.range(1, 10)
                .flatMap(v ->
                        Flowable.just(v)
                                .subscribeOn(Schedulers.computation())
                                .map(w -> w * w)
                )
                .blockingSubscribe(System.out::println);
```











































