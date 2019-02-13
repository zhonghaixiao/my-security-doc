# iptables
iptables客户端代理，将用户的安全设定执行到对应的安全框架中netfilter

### iptables 位于用户空间
- 封包过滤
- 封包重定向
- 网络地址转换NAT

### netfilter linux系统核心层内部的数据包处理模块
- 网络地址转换
- 数据包内容修改
- 数据包过滤

### 启动iptables
service iptables start

### iptables核心概念    规则（rules）
- 当数据包与规则匹配，iptables就根据规则定义的方法处理这些数据包（accept,reject,drop）
- rule存储在内核空间的信息包过滤表中，rule中包含（源地址、目的地址、传输协议TCP|UDP|ICMP、服务类型HTTP|FTP|SMTP）

### iptabes中的链

![image.png](https://upload-images.jianshu.io/upload_images/5977684-725cc083bd0124cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

报文流向
- prerouting --> input
- prerouting --> forward --> postrouting
- output --> postrouting

### iptables规则分类
- filter    过滤
- nat       网络地址转换
- mangle    拆解报文
- raw       关闭nat表上启用的连接追踪机制

### 路有次序表
![image.png](https://upload-images.jianshu.io/upload_images/5977684-859b0ca586b613e3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

匹配条件
- source IP
- destination IP

扩展匹配条件
- source port
- destination port

处理动作
- accept
- drop
- reject
- snat
- masquerade
- dnat
- redirect  端口映射
- log

---
## iptables 基础命令

> iptables -t filter -L
> 
> iptables -t raw -L
> 
> iptables -t mangle -L
> 
> iptables -t nat -L

> iptables -vt filter -L    查看详细信息

> iptables  -nvL  默认查看filter表

1.  iptables -t 表名 -L
2.  iptables -t 表名 -L 链名
3.  iptables -t 表名 -v -L
4.  

## iptables 规则 = 匹配条件 + 动作

### 匹配条件

### 动作

### filter表的input链
1. 查看filter表的input链的规则
   > iptables -nL INPUT

2. 清空filter表input链中的规则
   > iptables -F INPUT

3. 增加一条规则 拦截所有来自192.168.1.146的报文
   > iptables -t filter -I INPUT [num] -s 192.168.1.146 -j DROP

4. 在INPUT链尾部添加一条规则
   > iptables -A INPUT -s 192.168.1.146 -j ACCEPT

###  删除规则
- 根据规则的编号删除
- 根据匹配条件和动作删除
  
1. iptabkes --line -vnL INPUT
2. iptables -t filter -D INPUT 3
3. iptables -D INPUT -s 192.168.1.146 -j ACCEPT
4. iptables -t 表名 -F 链名 删除所有规则

### 修改规则

1. iptables -t filter --line -nvL INPUT
2. iptables -t filter -R INPUT 1 -s 192.168.1.146 -j ACCEPT
3. iptables -t filter -P FORWARD DROP 修改指定链的默认动作

### 保存规则

> service iptables save

保存到 /etc/sysconfig/iptables

> service iptables restart

centos7默认使用firewalld
1. yum install -y iptables-services
2. systemctl stop firewalld
3. systemctl disable firewalld
4. systemctl start iptables
5. systemctl enable iptables


### 匹配规则
1. -s ip1,ip2       指定ip
2. -s 10.6.0.0/16   指定网段
3. -d ip1       匹配目标ip
4. -p tcp       匹配协议 [tcp|udp|udplite|icmp|icmpv6|esp|ah|sctp|mh]
5. -p all   默认
6. -i eth4  匹配流入网卡接口
7. -o eth4  匹配流出网卡接口
8. -p tcp -m tcp --dport 22 匹配tcp目标端口 22
9. -m tcp   指定扩展模块
10. -p tcp --sport 22   匹配源端口 22
11. -sport 22:24
12. -m multiport -dports 11,12,44 指定多个端口
13. -m multiport -sports 11,12,44 指定多个端口

## 扩展模块

### iprange
- -m iprange --src-range ip1-ip2
- -m iprange --dst-range ip1-ip2

### string
- -m string --algo bm --string "OOXX"
- -algo [bm|kmp]匹配算法
- -string 匹配的字符串

### time
- -m time
- --timestart 09:00:00
- --timestop 18:00:00
- --weekdays 6,7
- --datestart 2017-12-24
- --datestop 2017-12-27

### connlimit   每个IP的并发连接数
- -m connlimit
- --connlimit-above 2
- --connlimit-mask 24

### limit   限制连接速度
- -p icmp -m limit --limit 1-/minute -j ACCEPT

### udp
- -m udp --dport 127
- -m udp --dport 127:157

### icmp
- -p icmp -m icmp --icmp-type 8/0 拒绝ping

### state   连接状态追踪
- new
- established
- related
- invalid
- untracked

- -m state --state RELATED,ESTABLISHED 只接受回应报文，不接受请求报文

---
## --tcp-flags  

## 动作
- ACCEPT
- DROP
- REJECT
- DROP

- SNAT  出站
- DNAT  入站
- MASQUERAGE
- REDIRECT

### snat
>-t nat -A POSTROUTING -s 10.1.0.0/16 -j SNAT --to-source 192.168.1.146

### dnat
>-t nat -I PRESOUTING -d 192.168.1.146 -p tcp --dport 3389 -j DNAT --to-destination 10.1.0.6:3389

### redirect 端口映射
> iptables -t nat -A PREROUTING -p tcp -dport 80 -j REDIRECT --to-ports 8080

转发80端口的数据到8080口



















