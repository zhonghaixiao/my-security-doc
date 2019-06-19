# rpc 远程过程调用
让构建分布式计算更容易，提供强大的远程调用能力又不失本地调用的语义简洁性

## 分类
1. 同步调用 客户端等待调用执行完成返回
2. 异步调用 客户端不用等待执行结果返回，但依然可以通过回调通知等方式获取返回结果
3. 

![](http://p3.pstatp.com/large/pgc-image/f8fa49a12b0647df91b82de4eaf6d7f1)

RPC服务通过rpcserver导出远程接口方法，客户端rpcclient引入远程接口方法。客户端像调用本地方法一样调用远程接口。

rpc框架提供接口的代理实现，实际调用委托给rpcProxy。代理封装调用信息转交rpcinvoker去实际执行。

在客户端，rpcinvoker通过连接器rpcconnnector维持与服务端的通道rpcChannel,并使用rpcProtocol执行协议解码，并将解码后的请求消息通过通道发送给服务方。

rpc服务端接收器rpcAcceptor接收客户端的调用请求，同样使用RPCProtocol执行协议解码。解码后的调用信息传递给RpcProcessor去控制处理调用过程，最后委托RpcInvoker去实际执行并返回调用结果。

## 组件
1. RpcServer ， 负责导出远程接口
2. RpcClient ， 负责导入远程接口的代理实现
3. RpcProxy ， 远程接口的代理实现
4. RpcInvoker ， 客户端负责编码调用信息和发送调用请求到服务端并等待调用结果；
                 服务端负责调用服务端接口的具体实现并返回调用结果
5. RpcProtocol , 负责协议解码
6. RpcConnector , 维持客户端与服务端的连接通道
7. RpcAcceptor , 接收客户端的请求并返回请求结果
8. RpcProcessor , 负责在服务方控制调用过程，包括管理调用线程池、超时时间等
9. RpcClient ， 数据传输通道

## 

调用编码：
- 接口方法， 接口名，方法名
- 方法参数， 参数类型，参数值
- 调用属性， 附加参数，超时时间

返回编码：
- 接口方法中定义的返回值
- 返回码， 异常返回码
- 返回异常信息

# RPC DUBBO
![](https://images2015.cnblogs.com/blog/17071/201705/17071-20170516003936869-83202981.jpg)

1. 远程通信， dubbo支持多种远程通信协议（netty）
2. 编码， 远程通信需要将信息进行编码以及解码，（protobuf）
3. 客户端代理， rpc将远程调用本地化，采用动态代理

# 影响RPC效率的因素
1. 传输方式     http, tcp
2. 序列化       protobuf,kryo,hessian,Jackson

# 实现一个rpc框架
1. TCP协议
2. NIO
3. 序列化
4. 服务注册与发现

1. Spring
2. Netty
3. Protostuff 基于protobuf框架
4. zookeeper














































