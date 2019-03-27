## 分布式存储 GFS分布式文件系统
## 分布式计算 MapReduce 并行计算框架
## 联机事务处理（OLTP）
也称为生产系统，它是事件驱动的、面向应用的，比如电子商务网站的交易系统就是一个典型的OLTP系统。
1. 数据在系统中产生
2. 基于交易的处理系统（Transaction-Based）
3. 每次交易牵涉的数据量很小
4. 对响应时间要求非常高
5. 用户数量非常庞大，主要是操作人员
6. 数据库的各种操作主要基于索引进行

## OLAP（On-Line Analytical Processing，联机分析处理）系统
是基于数据仓库的信息分析处理过程，是数据仓库的用户接口部分。是跨部门的、面向主题的。
1. 本身不产生数据，其基础数据来源于生产系统中的操作数据
2. 基于查询的分析系统
3. 复杂查询经常使用多表联结、全表扫描等，牵涉的数据量往往十分庞大  
4. 响应时间与具体查询有很大关系
5. 用户数量相对较小，其用户主要是业务人员与管理人员
6. 由于业务问题不固定，数据库的各种操作不能完全基于索引进行

## OLAP,OLTP比较
- OLTP是传统关系型数据库的主要应用，主要是事务处理（银行交易）
- OLTP强调数据库内存效率，强调内存各种指标的命令率、并发操作
- OLAP是数据仓库的主要应用，支持复杂的分析操作、侧重决策支持、提供直观的查询结果
- OLAP强调数据分析、SQL执行市场，磁盘IO，分区





- Greenplum 属于OLAP
- Gemfire 内存数据库
- MPP系统在决策支持和数据挖掘方面有优势 
- 

- shared Disk
  1. oracle
- shared Nothing
  1. db2
  2. sql server 
  3. hadoop

在postGreSQL基础上增加以下功能
- 并行处理
- 数据仓库
- BI（报表开发）(ETL SSIS , OLAP SSAS) 熟悉ETL逻辑、OLAP设计、数据挖掘相关算法

## greenplum架构
### Master Host
1. 建立与客户端的会话连接和管理；
2. SQL的解析并形成分布式的执行计划；
3. 将生成好的执行计划分发到每个Segment上执行；
4. 收集Segment的执行结果
5. 不存储业务数据，只存储数据字典；
6. 可以一主一备，分布在两台机器上，为了提高性能，最好单独占用一台机器。

### Segment Host
1. 业务数据的存储和存取；
2. 执行由Master分发的SQL语句；
3. 对于Master来说，每个Segment都是对等的，负责对应数据的存储和计算；
4. 每一台机器上可以配置一到多个Segment，因此建议采用相同的机器配置。
### Interconnect
1. 是GP数据库的网络层，在每个Segment中起到一个IPC作用
2. 推荐使用千兆以太网交换机做Interconnect；
3. 支持UDP和TCP两种协议，推荐使用UDP协议，因为其高可靠性、高性能以及可扩展性；而TCP协议最高只能使用1000个Segment实例。

# GP VS Hadoop
- gp 可以处理大量数据, hadoop 可以处理海量
- gp 只能处理湖量,或者河量. 无法处理海量.
- gp 面向分析的应用
- hadoop是大规模分布式计算框架，涉及分布式存储HDFS、分布式并行计算框架MapReduce、Hadoop Yarn作业调度和集群资源管理框架，（Hbase,Hive,Pig,ZooKeeper,Spark）
- Hadoop 是一种分布式计算框架

MPP数据库是为了解决大问题而设计的并行计算技术，而不是大量的小问题的高并发请求。

## Master-Slave架构
1. Hadoop Fs
2. Hbase
3. MapReduce
4. Storm
5. Mesos

# GemFire 分布式内存数据库

## 关系数据库，网络，安全

## Lucene 文本索引与查询库
使用lucene引擎在文档上添加搜索功能
## Nutch 以Lucene为核心的web搜索引擎
Nutch为HTML提供了解析器，还有网页抓取工具、链接图形数据库




















