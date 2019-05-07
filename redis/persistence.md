1. RDB (snapshotting)       快照持久化（默认）
2. AOP (append-only file)   在执行写命令时，将被执行的写命令复制到硬盘里

## RDB
1. save     阻塞redis服务器进程，知道RDB文件创建完毕为止；redis阻塞期间不处理任何命令请求
2. bgsave   在子进程中创建RDB文件
3. lastsave 检查RDB文件操作是否成功

### 自动保存RBD文件
redis.conf

```
save 900 1          900秒内修改至少一次
save 300 10         300秒至少修改10次
save 60 10000       60秒至少10000次修改
```

满足其中一个，BGSAVE就执行

```
dbfilename dump.db                  rdb文件名
dir ./                              rdb存放路径
stop-writes-on-bgsave-error yes     当生成rdb文件出错时是否继续处理redis写命令
rdbcompression yes                  是否对RDB文件压缩
rdbchecksum yes                     是否对RDB文件进行校验
```

## AOF
```
appendonly yes                      是否打开AOF持久化功能
appendfilename "appendonly.aof"     AOF文件名
appendfsync everysec                同步频率
```
1. always 每一个redis命令都同步写入硬盘，严重降低性能
2. everysec 每一秒执行一次，显示地将多个写命令同步到硬盘
3. no       让操作系统决定应该同时进行同步

- bgrewriteaof  移除aof文件中冗余的命令来重写aof文件，使AOF文件体积变小

```
auto-aof-rewrite-percentage
auto-aof-rewrite-min-size
```
两个条件同时满足才重写













































