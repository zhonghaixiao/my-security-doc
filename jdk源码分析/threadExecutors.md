## 参数
1. corePoolSize 核心线程数
2. maximumPoolSize 最大线程数
3. keepAliveTime 非核心线程空闲时间，超时销毁，allowCoreThreadTimeOut对核心线程使用相同策略
4. queuing 
    - SynchronousQueue direct handoff直接交付
    - LinkedBlockingQueue unbounded queue 
5. 拒绝策略
   - RejectedExecutionHandler#rejectedExecution(Runnable, ThreadPoolExecutor)
   - AbortPolicy
   - CallerRunsPolicy   减缓任务提交速度
   - DiscardOldestPolicy    
6. Hook method
   - beforeExecute
   - afterExecute
   - terminated 线程池彻底结束时调用
   - 可以用来操作执行环境，如初始化ThreadLocals,收集统计数据，记录日志

## 成员变量

### 状态参数 （workerCount|runState）
AtomicInteger ctl = new AtomicInteger(ctlOf(RUNNING, 0));

runState
1. RUNNING Accept new tasks and process queued tasks
2. SHUTDOWN Don't accept new tasks, but process queued tasks
3. STOP Don't accept new tasks, don't process queued tasks, and interrupt in-progress tasks
4. TIDYING All tasks have terminated, workerCount is zero, the thread transitioning to state TIDYING will run the terminated() hook method
5. TERMINATED terminated() has completed

### private final BlockingQueue<Runnable> workQueue;
- 缓存任务的队列，提交到worker threads中执行
- 调用workQueue.isEmpty()来判空，而不依赖于workQueue.poll返回Null,以适应DelayQueues
- 队列为空，可以从SHUTDOWN to TIDYING

### private final ReentrantLock mainLock = new ReentrantLock();
主锁，当结束线程池时控制并发

### private final HashSet<Worker> workers = new HashSet<Worker>();
当获取锁之后可以访问，存储所有的worker threads

### private final Condition termination = mainLock.newCondition();
Wait condition to support awaitTermination

### private int largestPoolSize;
记录最大的线程池大小，Accessed only under mainLock

### private long completedTaskCount;
完成任务数量，Updated only on termination of worker threads

### private volatile ThreadFactory threadFactory;
创建新线程，

### private volatile RejectedExecutionHandler handler;
Handler called when saturated or shutdown in execute.

- private volatile long keepAliveTime;
- private volatile boolean allowCoreThreadTimeOut;
- private volatile int corePoolSize;
- private volatile int maximumPoolSize;
  
# Worker extends AbstractQueuedSynchronizer implements Runnable


execute(Runnable)
1. 如果线程数小于corePoolSize，创建一个新线程执行该任务，即使线程池中有空闲线程
2. 如果线城市大于corePoolSize，小于maximunPoolSize，任务被插入等待队列
3. 当等待队列满了，创建一个新线程执行任务

预启动
1. prestartCoreThread
2. prestartAllCoreThreads

创建新线程
1. ThreadFactory # newThread
















































