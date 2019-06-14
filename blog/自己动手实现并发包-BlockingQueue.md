1. LinkedList
2. PriorityQueue
3. LinkedBlockingQueue
4. PriorityBlockingQueue

# Iterator 迭代器
迭代一个集合，Iterator不同于enumerations,Iterators：
1. 可以在迭代过程中删除底层集合

- Collection,ListIterator,Iterable

```
public interface Iterator<E>{
    boolean hasNext();
    E next();
    default void remove();
    default void forEachRemaining(Consumer<? super E> action){
        Objects.requireNonNull(action);
        while(hasNext())
            action.accept(next())
    }
}
```

demo:
```
Iterator<Integer> iterator = new Iterator<Integer>() {
            int i  = 0;
            @Override
            public boolean hasNext() {
                return i < 10;
            }

            @Override
            public Integer next() {
                return i++;
            }
        };
        while (iterator.hasNext()){
            System.out.println(iterator.next());
        }
```
迭代一个数据结构

demo arraylist:
```
private class Itr implements Iterator<E> {
        int cursor;       // index of next element to return
        int lastRet = -1; // index of last element returned; -1 if no such
        int expectedModCount = modCount;

        Itr() {}

        public boolean hasNext() {
            return cursor != size;
        }

        @SuppressWarnings("unchecked")
        public E next() {
            checkForComodification();//阻止多线程更新
            int i = cursor;
            if (i >= size)
                throw new NoSuchElementException();
            Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length)
                throw new ConcurrentModificationException();
            cursor = i + 1;
            return (E) elementData[lastRet = i];
        }

        public void remove() {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                ArrayList.this.remove(lastRet);
                cursor = lastRet;
                lastRet = -1;//重复调用两次出错
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }

        @Override
        @SuppressWarnings("unchecked")
        public void forEachRemaining(Consumer<? super E> consumer) {
            Objects.requireNonNull(consumer);
            final int size = ArrayList.this.size;
            int i = cursor;
            if (i >= size) {
                return;
            }
            final Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length) {
                throw new ConcurrentModificationException();
            }
            while (i != size && modCount == expectedModCount) {
                consumer.accept((E) elementData[i++]);
            }
            // update once at end of iteration to reduce heap write traffic
            cursor = i;
            lastRet = i - 1;
            checkForComodification();
        }

        final void checkForComodification() {
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
    }
```

# listIterator
用于遍历list,任意方向，修改遍历的元素，获取当前的index；listiterator没有当前元素，current position指向next(),previous()元素之间。

1. hasNext()
2. next()
3. hasPrevious()
4. previous()
5. nextIndex()
6. previousIndex()
7. remove()
8. set()
9. add()

```
Arrays.copyOf(T[] original, int newLength)
System.arraycopy(src, srcPos, dest, destPos, length)
Array.newInstance()
```


# 泛型
1. <? extends E> upper bound 上界，限制元素类型的上限

List<? extends Fruit> fruits, 集合中的元素类型上限为Fruit，只能是Fruit或Fruit的子类

fruits= new ArrayList<Fruit>();
fruits = new ArrayList<Apple>();
fruits = new ArrayList<Object>();//编译错误

2. <? super E> 下界，限制元素的类型下限
List<? super Apple> apples;//只能是Apple或Apple的父类
apples = new ArrayList<Apple>();
apples = new ArrayList<Fruit>();
apples = new ArrayList<Object>();

可以添加Apple或者Apple子类的对象

List<? super Apple> apples;//只能是Apple或Apple的父类
apples = new ArrayList<Apple>();
apples = new ArrayList<Fruit>();
apples = new ArrayList<Object>();
apples.add(new Apple());
apples.add(new RedApple());

## pecs法则
生产者使用extends, 消费者使用super

生产者：<? extends E>， 频繁读取内容
消费者：<? super E>，经常插入的
既要存储又要读取，不使用通配符



# Queue
先入先出数据结构，提供插入、取出、查询等操作

有两类操作：
1. 抛出异常     add remove  element
2. 返回特殊值   offer poll  peek

# AbstractQueue
提供队列实现的骨架


# ReentrantLock 
可重入互斥锁，提供并扩展synchronized（隐式监视锁implicit monitor lock）了功能

线程调用获取lock之后一直持有锁，直到unlocking it。如果当前线程已经获得锁，lock()立即返回。
- isHeldByCurrentThread()检查当前线程是否持有锁
- getHoldCount  重入了多少次

fairness : true ，lock favor granting access to the longest-waiting thread
        false，lock不保证任何获取顺序

公平锁的性能或降低，程序更慢。锁的公平性不保证线程调度的公平性， 

tryLock()不管是否fairness,只要锁可用就返回成功，而不管是否有线程在等待

```
ReentrantLock lock = new ReentrantLock()

lock.lock()
try{

}finally{
    lock.unlock()
}
```
### nonfairTryAcquire
```
final boolean nonfairTryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {//当前没有线程占用
                if (compareAndSetState(0, acquires)) {//CAS设置同步状态
                    setExclusiveOwnerThread(current);//成功，设置当前线程
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {//当前同步状态被占用，且是自己这个线程，增加同步状态计数
                int nextc = c + acquires;
                if (nextc < 0) // overflow
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }
```
### tryRelease
```
protected final boolean tryRelease(int releases) {//释放同步状态
            int c = getState() - releases;//计算同步状态
            if (Thread.currentThread() != getExclusiveOwnerThread())
                throw new IllegalMonitorStateException();
            boolean free = false;
            if (c == 0) {//如果state为0，同步状态释放成功，否则减少state计数
                free = true;
                setExclusiveOwnerThread(null);
            }
            setState(c);
            return free;
        }
```
### isHeldExclusively 判断当前占用同步状态的线程是否是自己
```
protected final boolean isHeldExclusively() {
            // While we must in general read state before owner,
            // we don't need to do so to check if current thread is owner
            return getExclusiveOwnerThread() == Thread.currentThread();
        }
```
### getHoldCount 获取同步状态被获取次数
### isLocked 同步状态是否被占用

## NonfairSync extends Sync 非公平锁
### lock
```
final void lock() {
            if (compareAndSetState(0, 1))
                setExclusiveOwnerThread(Thread.currentThread());
            else
                acquire(1);
        }
```
### AQS acquire(1), 独站式获取，忽略中断， 调用tryAcquire(子类实现),如果成功返回，否则thread入队，阻塞直到tryAcquire成功。
```
public final void acquire(int arg) {
        if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
    }
```
### tryAcquire
```
protected final boolean tryAcquire(int acquires) {
            return nonfairTryAcquire(acquires);
        }
```

## FairSync extends Sync 公平锁，锁获取顺序与线程入队顺序一致
### lock
```
final void lock() {
            acquire(1);//见上面的AQS#acquire
        }
``` 
### tryAquire
```
protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();
            if (c == 0) {
                if (!hasQueuedPredecessors() &&//与非公平锁不同之处，如果队列中有节点在当前节点前面，直接返回失败
                    compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }
```
### ReentrantLock 默认非公平锁，效率高，上下文切换少
```
public ReentrantLock() {
        sync = new NonfairSync();
    }
```
```
public ReentrantLock(boolean fair) {
        sync = fair ? new FairSync() : new NonfairSync();
    }
```
### lock   sync.lock();
获取锁，
- 如果没有线程在占用锁，锁获取成功，state设置为1
- 如果当前线程已经获取了锁，state++
- 如果锁被其他线程占用，当前线程阻塞知道锁被获取，阻塞期间线程不再参与调度

### lockInterruptibly 获取锁，可以响应中断
- 如果当前锁被其他线程占用，当前线程被阻塞，那么当前线程获取成功或者其他线程中断当前线程方法返回
- 如果当前线程占有锁，如果当前线程被中断，在acquire获取锁时抛出InterruptedException

sync.acquireInterruptibly(1);

### AQS acquireInterruptibly
独站式获取锁，响应中断。先检查中断状态，然后调用tryAcquire。如果失败，线程被入队阻塞，线程循环blocking, unblocking,直到tryAcquire成功或者线程被中断
```
public final void acquireInterruptibly(int arg)
            throws InterruptedException {
        if (Thread.interrupted())
            throw new InterruptedException();
        if (!tryAcquire(arg))
            doAcquireInterruptibly(arg);
    }
```
doAcquireInterruptibly 独占式响应中断获取
```
private void doAcquireInterruptibly(int arg)
        throws InterruptedException {
        final Node node = addWaiter(Node.EXCLUSIVE);//线程作为Node入同步队列
        boolean failed = true;
        try {
            for (;;) {//循环执行，如果当前线程的前驱是头结点，尝试获取同步状态，否则继续阻塞
                final Node p = node.predecessor();
                if (p == head && tryAcquire(arg)) {
                    setHead(node);
                    p.next = null; // help GC
                    failed = false;//只有获取成功，failed=true，用于finally中释放同步状态
                    return;
                }
                if (shouldParkAfterFailedAcquire(p, node) &&
                    parkAndCheckInterrupt())
                    throw new InterruptedException();
            }
        } finally {
            if (failed)
                cancelAcquire(node);
        }
    }
```
addWaiter 线程由于没有获得锁而被入队
```
private Node addWaiter(Node mode) {
        Node node = new Node(Thread.currentThread(), mode);//构建节点
        // Try the fast path of enq; backup to full enq on failure
        Node pred = tail;
        if (pred != null) {//快速入队，如果失败（其他线程也在入队），enq()循环直到入队
            node.prev = pred;
            if (compareAndSetTail(pred, node)) {//CAS
                pred.next = node;
                return node;
            }
        }
        enq(node);
        return node;
    }
```
enq
```
private Node enq(final Node node) {
        for (;;) {
            Node t = tail;
            if (t == null) { // Must initialize
                if (compareAndSetHead(new Node()))
                    tail = head;
            } else {
                node.prev = t;
                if (compareAndSetTail(t, node)) {
                    t.next = node;
                    return t;
                }
            }
        }
    }
```
shouldParkAfterFailedAcquire(Node pred, Node node) 
```
private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
        int ws = pred.waitStatus;//根据pred的waitStatus判断
        if (ws == Node.SIGNAL)
            /*
             * This node has already set status asking a release
             * to signal it, so it can safely park.
             */
            return true;
        if (ws > 0) {
            /*
             * Predecessor was cancelled. Skip over predecessors and
             * indicate retry.
             */
            do {
                node.prev = pred = pred.prev;
            } while (pred.waitStatus > 0);
            pred.next = node;
        } else {
            /*
             * waitStatus must be 0 or PROPAGATE.  Indicate that we
             * need a signal, but don't park yet.  Caller will need to
             * retry to make sure it cannot acquire before parking.
             */
            compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
        }
        return false;
    }
```
### tryLock
尝试获取锁，如果没有其他线程占用，则获取成功


# AQS (AbstractQueuedSynchronizer)

acquire(int arg): 排斥获取，忽略中断。调用tryAcquire成功，否则thread进入队列，可能多次被阻塞、唤醒，调用tryAcquire直到成功。用来实现Lock#lock()
```
if(!tryAcquire(arg)&&acquireQueued(addWaiter(Node.EXCLUSIVE),arg))
    selfInterrupt();
```

boolean tryAcquire(int acquires):尝试获取锁。如果该方法失败，线程入队，直到锁释放时被其他线程唤醒。用来实现Lock#tryLock()

in Fair version: 不能获取到，除非recursive call, no waiters, is first

```
protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            int c = getState();//c == 0 标识没有其他线程获得锁
            if (c == 0) {
                if (!hasQueuedPredecessors() &&//是否有线程在队列前面
                    compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                setState(nextc);
                return true;
            }
            return false;
        }
```

- hasQueuedPredecessors： 查询是否有线程在队列中等待，且当前线程的等待时间久

相当于 getFirstQueuedThread() != Thread.currentThread() && hasQueuedThreads()

- compareAndSetState(expect, update):
- setExclusiveOwnerThread

## addWaiter 写入队列
如果tryAcquire(arg)获取锁失败，addWaiter将当前线程写入队列，

- Node.EXCLUSIVE for exclusive, 
- Node.SHARED for shared

## 挂起等待线程 acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
写入队列之后将当前线程挂起

## LockSupport#park 挂起当前线程，直到被唤醒

- tryAcquire(fair,reentrant,exclusive) mode :
```
 protected boolean tryAcquire(int arg) {
      if (isHeldExclusively()) {
         // A reentrant acquire; increment hold count
         return true;
       } else if (hasQueuedPredecessors()) {
         return false;
       } else {
         // try to acquire normally
       }
```

# 无锁编程
上下文切换非常的耗时：
1. 采用无锁编程，将数据按照hash(id)取模分段，每个线程各自处理各自分段的数据，避免使用锁
2. CAS算法
3. 合理创建线程，避免创建一些线程但其中大部分状态处于waiting状态，因为每次从waiting切换到runnning都是一次上下文切换

# 死锁
解决：
1. 一个线程只获取一个锁
2. 一个线程只占用一个资源
3. 定时锁

# AQS

1. clh队列，同步队列：存放所有等待锁的线程



- Node:

waitStatus: CANCELLED(1)、SIGNAL(-1)、CONDITION(-2)、PROPAGATE(-3)以及0(无效)

pre,next

thread 当前节点的线程，当拥有锁的线程释放锁时，LockSupport.unpark(thread)唤醒线程

nextWaiter: SHARED当前节点为共享模式，null当前节点为独占模式,

Node实现两个队列：
1. pre,next实现同步队列
2. nextWaiter在Condition条件上的等待队列（单向队列）

- CLH队列的操作

volatile Node head, tail;

compareAndSetHead(Node update)

重新设置head
```
// 重新设置队列头head，它只在acquire系列的方法中调用
    private void setHead(Node node) {
        head = node;
        // 线程也没有意义了，因为该线程已经获取到锁了
        node.thread = null;
        // 前一个节点已经没有意义了
        node.prev = null;
    }
```

设置CLH队列尾tail compareAndSetTail(Node expect, Node update)

```
// 向队列尾插入新节点，如果队列没有初始化，就先初始化。返回原先的队列尾节点
    private Node enq(final Node node) {
        for (;;) {
            Node t = tail;
            // t为null，表示队列为空，先初始化队列
            if (t == null) {
                // 采用CAS函数即原子操作方式，设置队列头head值。
                // 如果成功，再将head值赋值给链表尾tail。如果失败，表示head值已经被其他线程，那么就进入循环下一次
                if (compareAndSetHead(new Node()))
                    tail = head;
            } else {
                // 新添加的node节点的前一个节点prev指向原来的队列尾tail
                node.prev = t;
                // 采用CAS函数即原子操作方式，设置新队列尾tail值。
                if (compareAndSetTail(t, node)) {
                    // 设置老的队列尾tail的下一个节点next指向新添加的节点node
                    t.next = node;
                    return t;
                }
            }
        }
    }
```

将当前线程添加到CLH队列尾
```
// 通过给定的模式mode(独占或者共享)为当前线程创建新节点，并插入队列中
    private Node addWaiter(Node mode) {
        // 为当前线程创建新的节点
        Node node = new Node(Thread.currentThread(), mode);
        Node pred = tail;
        // 如果队列已经创建，就将新节点插入队列尾。
        if (pred != null) {
            node.prev = pred;
            if (compareAndSetTail(pred, node)) {
                pred.next = node;
                return node;
            }
        }
        // 如果队列没有创建，通过enq方法创建队列，并插入新的节点。
        enq(node);
        return node;
    }
```

2. 独占锁 

- 获取锁，多线程获取锁时，只有一个线程获得锁，其他线程在当前位置阻塞等待
- 释放锁，获取锁的线程释放锁资源，而且需要唤醒正在等待锁资源的一个线程

acquire(arg): 获取独占锁
```
/**
     * 获取独占锁。如果没有获取到，线程就会阻塞等待，直到获取锁。不会响应中断异常
     * @param arg
     */
    public final void acquire(int arg) {
        // 1. 先调用tryAcquire方法，尝试获取独占锁，返回true，表示获取到锁，不需要执行acquireQueued方法。
        // 2. 调用acquireQueued方法，先调用addWaiter方法为当前线程创建一个节点node，并插入队列中，
        // 然后调用acquireQueued方法去获取锁，如果不成功，就会让当前线程阻塞，当锁释放时才会被唤醒。
        // acquireQueued方法返回值表示在线程等待过程中，是否有另一个线程调用该线程的interrupt方法，发起中断。
        if (!tryAcquire(arg) &&
            acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
            selfInterrupt();
    }
```
equal:
```
public final void acquire(int arg) {
        // 1.先调用tryAcquire方法，尝试获取独占锁，返回true则直接返回
        if (tryAcquire(arg)) return;
        // 2. 调用addWaiter方法为当前线程创建一个节点node，并插入队列中
        Node node = addWaiter(Node.EXCLUSIVE);
        // 调用acquireQueued方法去获取锁，
        // acquireQueued方法返回值表示在线程等待过程中，是否有另一个线程调用该线程的interrupt方法，发起中断。
        boolean interrupted = acquireQueued(node, arg);
        // 如果interrupted为true，则当前线程要发起中断请求
        if (interrupted) {
            selfInterrupt();
        }
    }
```

tryAcquire:

如果子类想实现独占锁，则必须重写这个方法，否则抛出异常。这个方法的作用是当前线程尝试获取锁，如果获取到锁，就会返回true，并更改锁资源。没有获取到锁返回false。

```
// 尝试获取锁，与非公平锁最大的不同就是调用hasQueuedPredecessors()方法
        // hasQueuedPredecessors方法返回true，表示等待线程队列中有一个线程在当前线程之前，
        // 根据公平锁的规则，当前线程不能获取锁。
        protected final boolean tryAcquire(int acquires) {
            final Thread current = Thread.currentThread();
            // 获取锁的记录状态
            int c = getState();
            // 如果c==0表示当前锁是空闲的
            if (c == 0) {
                if (!hasQueuedPredecessors() &&
                    compareAndSetState(0, acquires)) {
                    setExclusiveOwnerThread(current);
                    return true;
                }
            }
            // 判断当前线程是不是独占锁的线程
            else if (current == getExclusiveOwnerThread()) {
                int nextc = c + acquires;
                if (nextc < 0)
                    throw new Error("Maximum lock count exceeded");
                // 更改锁的记录状态
                setState(nextc);
                return true;
            }
            return false;
        }
```

acquireQueued , acquireQueued方法作用就是获取锁，如果没有获取到，就让当前线程阻塞等待。
```
/**
     * 想要获取锁的 acquire系列方法，都会这个方法来获取锁
     * 循环通过tryAcquire方法不断去获取锁，如果没有获取成功，
     * 就有可能调用parkAndCheckInterrupt方法，让当前线程阻塞
     * @param node 想要获取锁的节点
     * @param arg
     * @return 返回true，表示在线程等待的过程中，线程被中断了
     */
    final boolean acquireQueued(final Node node, int arg) {
        boolean failed = true;
        try {
            // 表示线程在等待过程中，是否被中断了
            boolean interrupted = false;
            // 通过死循环，直到node节点的线程获取到锁，才返回
            for (;;) {
                // 获取node的前一个节点
                final Node p = node.predecessor();
                // 如果前一个节点是队列头head，并且尝试获取锁成功
                // 那么当前线程就不需要阻塞等待，继续执行
                if (p == head && tryAcquire(arg)) {
                    // 将节点node设置为新的队列头
                    setHead(node);
                    // help GC
                    p.next = null;
                    // 不需要调用cancelAcquire方法
                    failed = false;
                    return interrupted;
                }
                // 当p节点的状态是Node.SIGNAL时，就会调用parkAndCheckInterrupt方法，阻塞node线程
                // node线程被阻塞，有两种方式唤醒，
                // 1.是在unparkSuccessor(Node node)方法，会唤醒被阻塞的node线程，返回false
                // 2.node线程被调用了interrupt方法，线程被唤醒，返回true
                // 在这里只是简单地将interrupted = true，没有跳出for的死循环，继续尝试获取锁
                if (shouldParkAfterFailedAcquire(p, node) &&
                    parkAndCheckInterrupt())
                    interrupted = true;
            }
        } finally {
            // failed为true，表示发生异常，非正常退出
            // 则将node节点的状态设置成CANCELLED，表示node节点所在线程已取消，不需要唤醒了。
            if (failed)
                cancelAcquire(node);
        }
    }
```
shouldParkAfterFailedAcquire, 返回值决定是否要阻塞当前线程
```
 /**
     * 根据前一个节点pred的状态，来判断当前线程是否应该被阻塞
     * @param pred : node节点的前一个节点
     * @param node
     * @return 返回true 表示当前线程应该被阻塞，之后应该会调用parkAndCheckInterrupt方法来阻塞当前线程
     */
    private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
        int ws = pred.waitStatus;
        if (ws == Node.SIGNAL)
            // 如果前一个pred的状态是Node.SIGNAL，那么直接返回true，当前线程应该被阻塞
            return true;
        if (ws > 0) {
            // 如果前一个节点状态是Node.CANCELLED(大于0就是CANCELLED)，
            // 表示前一个节点所在线程已经被唤醒了，要从CLH队列中移除CANCELLED的节点。
            // 所以从pred节点一直向前查找直到找到不是CANCELLED状态的节点，并把它赋值给node.prev，
            // 表示node节点的前一个节点已经改变。
            do {
                node.prev = pred = pred.prev;
            } while (pred.waitStatus > 0);
            pred.next = node;
        } else {
            // 此时前一个节点pred的状态只能是0或者PROPAGATE，不可能是CONDITION状态
            // CONDITION(这个是特殊状态，只在condition列表中节点中存在，CLH队列中不存在这个状态的节点)
            // 将前一个节点pred的状态设置成Node.SIGNAL，这样在下一次循环时，就是直接阻塞当前线程
            compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
        }
        return false;
    }
```

parkAndCheckInterrupt, 阻塞当前线程，线程被唤醒后返回当前线程中断状态
```
/**
     * 阻塞当前线程，线程被唤醒后返回当前线程中断状态
     */
    private final boolean parkAndCheckInterrupt() {
        // 通过LockSupport.park方法，阻塞当前线程
        LockSupport.park(this);
        // 当前线程被唤醒后，返回当前线程中断状态
        return Thread.interrupted();
    }
```
cancelAcquire, 将node节点的状态设置成CANCELLED，表示node节点所在线程已取消，不需要唤醒了。
```
// 将node节点的状态设置成CANCELLED，表示node节点所在线程已取消，不需要唤醒了。
    private void cancelAcquire(Node node) {
        // 如果node为null，就直接返回
        if (node == null)
            return;
        node.thread = null;
        // 跳过那些已取消的节点，在队列中找到在node节点前面的第一次状态不是已取消的节点
        Node pred = node.prev;
        while (pred.waitStatus > 0)
            node.prev = pred = pred.prev;

        // 记录pred原来的下一个节点，用于CAS函数更新时使用
        Node predNext = pred.next;

        // Can use unconditional write instead of CAS here.
        // After this atomic step, other Nodes can skip past us.
        // Before, we are free of interference from other threads.
        // 将node节点状态设置为已取消Node.CANCELLED;
        node.waitStatus = Node.CANCELLED;

        // 如果node节点是队列尾节点，那么就将pred节点设置为新的队列尾节点
        if (node == tail && compareAndSetTail(node, pred)) {
            // 并且设置pred节点的下一个节点next为null
            compareAndSetNext(pred, predNext, null);
        } else {
            // If successor needs signal, try to set pred's next-link
            // so it will get one. Otherwise wake it up to propagate.
            int ws;
            if (pred != head &&
                ((ws = pred.waitStatus) == Node.SIGNAL ||
                 (ws <= 0 && compareAndSetWaitStatus(pred, ws, Node.SIGNAL))) &&
                pred.thread != null) {
                Node next = node.next;
                if (next != null && next.waitStatus <= 0)
                    compareAndSetNext(pred, predNext, next);
            } else {
                unparkSuccessor(node);
            }

            node.next = node; // help GC
        }
    }
```
- 释放独占锁的方法

release
```
 // 在独占锁模式下，释放锁的操作
    public final boolean release(int arg) {
        // 调用tryRelease方法，尝试去释放锁，由子类具体实现
        if (tryRelease(arg)) {
            Node h = head;
            // 如果队列头节点的状态不是0，那么队列中就可能存在需要唤醒的等待节点。
            // 还记得我们在acquireQueued(final Node node, int arg)获取锁的方法中，如果节点node没有获取到锁，
            // 那么我们会将节点node的前一个节点状态设置为Node.SIGNAL，然后调用parkAndCheckInterrupt方法
            // 将节点node所在线程阻塞。
            // 在这里就是通过unparkSuccessor方法，进而调用LockSupport.unpark(s.thread)方法，唤醒被阻塞的线程
            if (h != null && h.waitStatus != 0)
                unparkSuccessor(h);
            return true;
        }
        return false;
    }
```
tryRelease 试去释放当前线程持有的独占锁，立即返回。如果返回true表示释放锁成功

```
protected final boolean tryRelease(int releases) {
            // c表示新的锁的记录状态
            int c = getState() - releases;
            // 如果当前线程不是独占锁的线程，就抛出IllegalMonitorStateException异常
            if (Thread.currentThread() != getExclusiveOwnerThread())
                throw new IllegalMonitorStateException();
            // 标志是否可以释放锁
            boolean free = false;
            // 当新的锁的记录状态为0时，表示可以释放锁
            if (c == 0) {
                free = true;
                // 设置独占锁的线程为null
                setExclusiveOwnerThread(null);
            }
            setState(c);
            return free;
        }
```
unparkSuccessor, 
```
// 唤醒node节点的下一个非取消状态的节点所在线程(即waitStatus<=0)
    private void unparkSuccessor(Node node) {
        // 获取node节点的状态
        int ws = node.waitStatus;
        // 如果小于0，就将状态重新设置为0，表示这个node节点已经完成了
        if (ws < 0)
            compareAndSetWaitStatus(node, ws, 0);

        // 下一个节点
        Node s = node.next;
        // 如果下一个节点为null，或者状态是已取消，那么就要寻找下一个非取消状态的节点
        if (s == null || s.waitStatus > 0) {
            // 先将s设置为null，s不是非取消状态的节点
            s = null;
            // 从队列尾向前遍历，直到遍历到node节点
            for (Node t = tail; t != null && t != node; t = t.prev)
                // 因为是从后向前遍历，所以不断覆盖找到的值，这样才能得到node节点后下一个非取消状态的节点
                if (t.waitStatus <= 0)
                    s = t;
        }
        // 如果s不为null，表示存在非取消状态的节点。那么调用LockSupport.unpark方法，唤醒这个节点的线程
        if (s != null)
            LockSupport.unpark(s.thread);
    }
```
唤醒node节点的下一个非取消状态的节点所在线程,将node节点的状态设置为0,寻找到下一个非取消状态的节点s,如果节点s不为null，则调用LockSupport.unpark(s.thread)方法唤醒s所在线程。

唤醒线程也是有顺序的，就是添加到CLH队列线程的顺序。

调用tryRelease方法去释放当前持有的锁资源,如果完全释放了锁资源，那么就调用unparkSuccessor方法，去唤醒一个等待锁的线程。

3. 共享锁

共享锁与独占锁相比，共享锁可能被多个线程共同持有

acquireShared, 获得锁
```
// 获取共享锁
    public final void acquireShared(int arg) {
        // 尝试去获取共享锁，如果返回值小于0表示获取共享锁失败
        if (tryAcquireShared(arg) < 0)
            // 调用doAcquireShared方法去获取共享锁
            doAcquireShared(arg);
    }
```
tryAcquireShared, 尝试去获取共享锁，立即返回。返回值大于等于0，表示获取共享锁成功

ReentrantReadWriteLock#tryAcquireShared


4. Condition
Condition实现线程之间相互等待，只能在独占锁中使用

- 首先内部存在一个Condition队列，存储着所有在此Condition条件等待的线程。
- await系列方法：让当前持有锁的线程释放锁，并唤醒一个在CLH队列上等待锁的线程，再为当前线程创建一个node节点，插入到Condition队列(注意不是插入到CLH队列中)
- signal系列方法：其实这里没有唤醒任何线程，而是将Condition队列上的等待节点插入到CLH队列中，所以当持有锁的线程执行完毕释放锁时，就会唤醒CLH队列中的一个线程，这个时候才会唤醒线程。

await方法：
```
 /**
         * 让当前持有锁的线程阻塞等待，并释放锁。如果有中断请求，则抛出InterruptedException异常
         * @throws InterruptedException
         */
        public final void await() throws InterruptedException {
            // 如果当前线程中断标志位是true，就抛出InterruptedException异常
            if (Thread.interrupted())
                throw new InterruptedException();
            // 为当前线程创建新的Node节点，并且将这个节点插入到Condition队列中了
            Node node = addConditionWaiter();
            // 释放当前线程占有的锁，并唤醒CLH队列一个等待线程
            int savedState = fullyRelease(node);
            int interruptMode = 0;
            // 如果节点node不在同步队列中(注意不是Condition队列)
            while (!isOnSyncQueue(node)) {
                // 阻塞当前线程,那么怎么唤醒这个线程呢？
                // 首先我们必须调用signal或者signalAll将这个节点node加入到同步队列。
                // 只有这样unparkSuccessor(Node node)方法，才有可能唤醒被阻塞的线程
                LockSupport.park(this);
                // 如果当前线程产生中断请求，就跳出循环
                if ((interruptMode = checkInterruptWhileWaiting(node)) != 0)
                    break;
            }
            // 如果节点node已经在同步队列中了，获取同步锁，只有得到锁才能继续执行，否则线程继续阻塞等待
            if (acquireQueued(node, savedState) && interruptMode != THROW_IE)
                interruptMode = REINTERRUPT;
            // 清除Condition队列中状态不是Node.CONDITION的节点
            if (node.nextWaiter != null)
                unlinkCancelledWaiters();
            // 是否要抛出异常，或者发出中断请求
            if (interruptMode != 0)
                reportInterruptAfterWait(interruptMode);
        }
```







































