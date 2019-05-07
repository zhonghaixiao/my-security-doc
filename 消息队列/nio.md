## 三大组件
1. Buffer
2. Channel
3. Selector

## Buffer
ByteBuffer

1. position
2. limit
3. capacity

flip 切换读写模式， position清0


- 初始化Buffer
ByteBuffer byteBuffer = ByteBuffer.allocate(1024);

- mark临时保存position的值
- reset position=mark
- rewind position=0 , 从头读写buffer
- clear 重置Buffer
- compact


## Channel
1. FileChannel
2. SocketChannel
3. DatagramChannel
4. ServerSocketChannel

## selector
1. Selector selector = Selector.open()
2. 
```
channel.configureBlocking(false);
SelectionKey key = channel.register(selector, SelectorKey.OP_READ);
```
3. 
```
while(true){
    int readyChannels = selector.select();
    if(readyChannels == 0){
        continue;
    }
    //遍历
    Set<SelectionKey> selectedKeys = select.selectedKeys();
    Iterator<SelectionKey> keyIterator = selectedKeys.iterator();

    while(keyIterator.hasNext()) {
        SelectionKey key = keyIterator.next();

        if(key.isAcceptable()) {
            // a connection was accepted by a ServerSocketChannel.

        } else if (key.isConnectable()) {
        // a connection was established with a remote server.

        } else if (key.isReadable()) {
        // a channel is ready for reading

        } else if (key.isWritable()) {
        // a channel is ready for writing
        }
        keyIterator.remove();
    }
}
```

1. select() 阻塞
2. selectNow return 0
3. select(long timeout)
4. wakeup


































