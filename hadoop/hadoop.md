## Hadoop 分布式编程框架
hadoop是一个开源框架，可编写和运行分布式应用处理大规模数据
## MapReduce框架
1. map 映射
2. reduce 归约
- 映射： MapReduce算法将查询操作和数据集都分解为组件
- 归约： 在查询中被映射的组件可以被同时处理从而快速的返回结果

# 第一章
1. 编写可扩展、分布式的数据密集型程序的基础知识
2. 理解Hadoop和MapReduce
3. 编写和运行一个基本的MapReduce程序

## 代码向数据迁移的理念
- 在hadoop集群中，数据被拆分后在集群中分布，并且尽可能让一段数据的计算发生在同一台机器上，即数据数据驻留的地方。
- 让数据不动，而让执行代码移动到数据所在的机器上去

## sql vs hadoop
1. sql针对结构化数据的
2. hadoop处理文本数据
3. hadoop专为离线处理和大规模数据分析而设计，最适合一次写入，多次读取的数据存储需求

## MapReduce
1. mapper: 对输入进行过滤和转换，是reducer可以完成聚合
2. reducer

1. mapping
2. reducing
3. partitioning
4. shuffling

1. 应用的输入组织为一个键值对的列表list(<k1,v1>)
- 处理多个文件的输入格式为list(<string filename,string file_content>)
- 日志这种大文件的输入格式list(<Integer line_number,string log_event>)
2. 对键值对列表拆分，然后调用mapper的map函数对每个单独的键值对进行处理

## Hadoop的三种工作模式
1. 单机
2. 伪分布式
3. 全分布式

















































