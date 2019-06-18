## Transport Services   传输层
1. socket，datagram
2. http Tunnel
3. In-VM pipe

## Protocol Support
1. Http, websocket
2. ssl
3. protobuf
4. rtsp
5. large file transfer
6. zlib、gzip compression 
7. legacy text.binary protocols 



8. EventLoopGroup NioEventLoopGroup 死循环，不停地检测IO事件，处理IO事件，执行任务
9. ServerBootstrap  服务端的一个启动辅助类，通过给他设置一系列参数来绑定端口启动服务
10. NioServerSocketChannel
11. ChannelInitializer
12. ChannelHander  表示数据流经过的处理器，可以理解为流水线上的每一道关卡


# 服务端启动

## ServerBootstrap

- bind(new InetSocketAddress(inetPort))
- ChannelFuture bind(SocketAddress localAddress)
  - validate() check group,channelFactory not null
  - ChannelFuture doBind(SocketAddress localAddress)

1. initAndRegister()
2. 





- group(parentGroup, childGroup):
  - group = parentGroup: 处理创建channel的事件，即连接接入事件，(acceptor)
  - childGroup = childGroup, 
    这些EventLoopGroup用来处理ServerChannel和Channel的事件，和IO读写

- channelFactory: 
- channel(Class<? extends C> channelClass)
  - channel(NioServerSocketChannel.class)
    - channelFactory(new ReflectiveChannelFactory(channelClass))
      - this.channelFactory = channelFactory;

- ReflectiveChannelFactory extends ChannelFactory
  - newChannel() --> clazz.newInstance()

## AbstractBootstrap

## AbstractBootstrapConfig

## ServerBootstrapAcceptor

## DefaultChannelPromise

## NioUnsafe
















