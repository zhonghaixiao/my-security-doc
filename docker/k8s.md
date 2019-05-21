
> 运行镜像

kubectl run kubia --image=registry.cn-shanghai.aliyuncs.com/zhongfirst/zhongrepository:1.0 --port=8080 --generator=run/v1

> 创建一个服务 LoadBalancer ，使pod可以在集群外部访问

kubectl expose rc kubia --type=LoadBalancer --name kubia-http

> 增加期望的副本数

kubectl scale rc kubia --replicas=3

- in minikube

minikube service kubia-http 获取可以访问服务的ip和端口

## pod 
1. 创建，启动，停止pod
2. 使用标签组织pod和其他资源
3. 使用特定标签对所有pod执行操作
4. 使用命名空间将Pod分到不重叠的组中
5. 调度pod到指定类型的工作节点

> 获取pod的yaml定义

kubectl get po kubia-zxzij -o yaml

> 从yaml文件创建pod

kubectl create -f kubia-manual.yaml

> 查看应用日志

kubectl logs kubia-manual

> 向pod发请求，使用端口转发访问pod

kubectl port-forward kubia-manual 8888:8080

## 标签选择器
标签选择器允许选择标记特定标签的pod子集，并对这些pod执行操作

1. 包含使用特定键的标签
2. 包含具有特定键和值的标签
3. 包含具有特定键的标签，但其值不同的

> 使用标签选择器列出标签

kubectl get pod -l creation_method=manual   标签等于特定值的

kubectl get pod -l env  列出包含env标签的

kubectl get pod -l '!env'   列出没有env标签的

1. creation_method!=manual
2. env in (prod, devel)
3. env notin (prod,devel)

### 使用标签和选择器来约束pod调度

```
spec:
    nodeSelector
        gpu: "true"
    containers:
    -   image: luska/kubia
        name: kubia
```
### 注解

> 添加注解

kubectl annotate pod kubia-manual mycompany.com/someannotation="foo ba"

## 使用命名空间对资源分组

> 列出集群中的所有命名空间

kubectl get ns

> 列出指定命名空间下的pod

kubectl get po --namespace kube-system

> 创建一个命名空间

```
appVersion: v1
kind: Namespace
metadata:
  name: custom-namespace
```

> kubectl create namespace custom-namespace

## 删除pod

> 按名称删除

kubectl delete pod kubia-gpu

> 使用标签选择器删除

kubectl delete pod -l creation_method=manual

> 删除整个命名空间

kubectl delete ns custom-namespace

> 删除命名空间中的pod，但保留命名空间

kubectl delete pod --all

kubectl delete all --all


# 副本机制与其他控制器

1. 保持pod健康
2. 运行同一个pod的多个实例
3. 在节点异常之后重新调度pod
4. 水平缩放pod
5. 在集群节点上运行系统级的pod
6. 运行批量任务
7. 调度任务定时执行或延时执行一次

创建replicationcontroller,deployment来部署pod

kubernetes如何检查容器是否存在，并重启容器

1. 存活探针
2. 就绪探针

## 存货探针
1. 基于http get的探针
2. 基于tcp套接字的探针
3. exec探针

### 创建基于http的存货探针

```
appVersion: v1
kind: Pod
metadata:
  name: kubia-liveness
spec:
  containers:
  - name: kubia
    image: luksa/kubia-unhealthy
    livenessProbe:
      httpGet:
        path: /
        port: 8080
      initialDelaySeconds: 15
```

## ReplicationController
1. 确保一个pod副本持续运行，在现有pod丢失时启动一个新pod
2. 集群节点发生故障时，将为故障节点上运行的所有pod创建替代副本
3. 轻松实现pod的水平伸缩

### 创建rc

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: kubia
spec:
  replicas: 3
  selector:
    app: kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: luksa/kubia
        ports:
        - containerPort: 8080
```

### 修改pod模板
1. kubectl edit rc kubia
  
### 水平缩放pod

### 删除rc
--cascade=false 保持pod运行

## ReplicaSet
更富表达力的标签选择器

```
apiVersion: apps/v1beta2
kind: ReplicaSet
metadata:
  name: kubia
spec:
  replicas: 3
  selector:
    matchLabels:
      app: kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: luksa/kubia
```

```
selector:
  matchExpressions:
  - key: app
    operator: In
    values:
      - kubia
```

### 运算符
1. In
2. NotIn
3. Exists
4. DoesNotExist

## DaemonSet
在每个节点上运行一个pod

```
apiVersion: apps/v1beta2
kind: DaemonSet
metadata:
  name: ssd-monitor
spec:
  selector:
    matchLabels:
      app: ssd-monitor
  template:
    metadata:
      labels:
        app: ssd-monitor
    spec:
      nodeSelector:
        disk: ssd
      containers:
      - name: main
        image: luksa/ssd-monitor

```

> 向节点上添加所需的标签

1. kubectl get nodes
2. kubectl label node minikube disk=ssd

> 删除节点标签

kubectl label node minikube disk=hdd --overwrite

## 运行执行单个任务的pod

> 定义job资源

```
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-job
spec:
  template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure
      containers:
      - name: main
        image: luksa/batch-job
```

> 定义CronJob

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: batch-job-every-fifteen-minutes
spec:
  schedule: "0,15,30,45 * * * *"
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            app: periodic-batch-job
        spec:
          restartPolicy: OnFailure
          containers:
            - name: main
              image: luksa/batch-job
```


# 服务
让客户端发现pod并与之通信

1. 创建服务资源，利用单一地址访问一组pod
2. 发现集群中的服务
3. 将服务公开给外部客户端
4. 从集群内部链接外部服务
5. 控制pod是与服务关联
6. 排除服务故障

1. pod是短暂的
2. kubernetes在pod启动前会给已经调度到节点上的pod分配ip
3. 水平伸缩意味着多个pod会提供相同的服务
   
> 创建服务
```
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - port: 80          #服务的可用端口
    targetPort: 8080  #服务将连接转发到的容器端口
  selector:
    app: kubia
```

> 在运行的pod中执行命令

kubectl exec kubia-xxx -- curl -s http://10.99.129.85

> 设置服务的客户端粘性

```
kind: Service
spec:
  sessionAffinity: ClientIP
```

> 同一个服务暴露多个端口

```
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443
  selector:
    app: kubia
```

> 使用命名端口

```
kind: Pod
spec:
  containers:
  - name: kubia
    ports:
    - name: http
      containerPort: 8080
    - name: https
      containerPort:  8443
```

```
kind: Service
spec:
  ports:
  - name: http
    port: 80
    targetPort: http
  - name: https
    port: 443
    targetPort: https
```

## 服务发现

### 通过环境变量获得服务地址

1. kubectl delete pod --all
2. kubectl exec kubia-xxx env   列出pod中的环境变量

### 通过DNS发现服务

FQDN 全限定域名

> 在pod中运行pod

kubectl.exe exec -it kubia-nwqqp bash

> 访问服务

1. curl http://kubia.default.svc.cluster.local
2. curl http://kubia.default
3. curl http://kubia

cat /etc/resolv.conf

ping kubia 不通

## 连接集群外部的服务

EndPoints资源就是暴露一个服务的IP地址和端口的列表，

kubectl get endpoints kubia

### 手动创建服务

> 手动配置服务的endpoint

> 创建没有选择器的服务

```
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  ports:
  - port: 800
```

该服务将接收端口80上传入的连接

> 为没有选择器的服务创建Endpoint资源

```
apiVersion: v1
kind: Endpoints
metadata:
  name: external-service
subsets:
  - addresses:
    - ip: 11.11.11.11
    - ip: 22.22.22.22
    ports:
    - port: 80
```

> 为外部服务创建别名

```
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  type: ExternalName
  externalName: someapi.somecompany.com
  ports:
  - port: 80
```

全限定域名：  external-service.default.svc.cluster.local

## 将服务暴露给外部客户端
1. 将服务类型设置成NodePort,  在集群节点本身打开一个端口，在该端口上接收到的流量重定向到基础服务
2. 将服务类型设置成LoadBalance，NodePort的一种扩展  使得服务可以通过专用的负载均衡器访问
3. Ingress资源，通过一个IP地址公开多个服务，运行在http层

### NodePort

> 创建

```
apiVersion: v1
kind: Service
metadata:
  name: kubia-nodeport
spec:
  type: NodePort
  ports:
  - port: 80      #服务集群ip的端口号
    targetPort: 8080  #背后pod的目标端口号
    nodePort: 30123 #通过集群节点的端口号可以访问到服务
  selector:
    app: kubia
```

### 负载均衡器

```
apiVersion: v1
kind: Service
metadata:
  name: kubia-loadbalancer
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```

### Ingress

> 创建

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kubia
spec:
  rules:
  - host: kubia.example.com
    http:
      paths:
      - path: /
        backend:
          serviceName: kubia-nodeport
          servicePort: 80
```

# 将磁盘挂载到容器

1. 创建多容器pod
2. 创建一个可以在容器间共享磁盘存储的卷
3. 在pod中使用git仓库
4. 将持久性存储挂载到pod
5. 使用预先配置的持久性存储

pod中的容器共享CPU，RAM,网络接口。但pod中的每个容器有独立的文件系统，文件系统来自于镜像

pod中的容器都可以使用卷，但必须先将它挂载在每一个需要访问它的容器中。在每个容器中，都可以在文件系统的任意位置挂载卷

## 使用卷在容器之间共享数据
在一个pod的多个容器间共享数据

### emptyDir

> 创建pod

```
apiVersion: v1
kind: Pod
metadata:
  name: fortune
spec:
  containers:
  - image: luksa/fortune
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    emptyDir: 
      medium: Memory  # 卷文件存储在内存中
```

kubectl port-forward fortune 8081:80

### 使用git作为仓库存储卷 gitRepo

```
apiVersion: v1
kind: Pod
metadata:
  name: gitrepo-volume-pod
spec:
  containers:
  - image: nginx:alpine
    name: web-server
    volumeMounts: 
    - name: html
      moundPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    gitRepo:
      repository: https://github.com/luksa/kubia-website-example.git
      revision: master  #检测主分支
      directory: .  #克隆到根目录
```

## 访问工作节点文件系统上的卷

### hostPath卷

> 检查使用hostPath卷的系统pod

kubectl get pods --namespace kube-system


## 使用持久化存储

```
apiVersion: v1
kind: Pod
metadata:
  name: mongodb
spec:
  volumes:
  - name: mongodb-data
    gcePersistentDisk:
      pdName: mongodb
      fsType: ext4
  containers:
  - image: mongo
    name: mongodb
    volumeMounts:
    - name: mongodb-data
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
```

> 挂载nfs

```
volumes:
- name: mongodb-data
  nfs:
    server: 1.2.3.4
    path: /some/path
```

## 创建持久卷和持久卷声明pvc

# ConfigMap和Secret

1. 更改容器主进程
2. 将命令行选项传递给应用程序
3. 设置暴露给应用程序的环境变量
4. 通过ConfigMap配置应用程序
5. 通过Secret传递敏感配置信息

> 传递配置选项给运行在kubernete上的应用程序

## 配置容器化应用程序
1. 向容器传递命令行参数
2. 为每个容器设置自定义环境变量
3. 通过特殊类型的卷将配置文件挂载到容器中

### 向容器传递命令行参数

1. entrypoint 定义容器启动时被调用的可执行程序
2. cmd 指定传递给entrypoint的参数

docker run <image> <arguments> docker容器运行时添加参数，覆盖dockerfile中任何由cmd指定的默认参数值

1. shell形式： entrypoint node app.js
2. exec形式：  entrypoint ["node", "app.js"]

exec形式直接运行进程，无需打开shell启动进程

```
from ubuntu:latest
run apt-get update ; apt-get -y install fortune
add fortuneloop.sh /bin/fortuneloop.sh
entrypoint ["/bin/fortuneloop.sh"]
cmd ["10"]
```

> 在pod中覆盖参数

```
kind: Pod
spec:
  containers:
  - image:  some/image
    command: ["/bin/command"]
    args: ["arg1", "arg2", "arg3"]
```

### 为容器设置环境变量
```
kind: Pod
spec:
  containers:
  - image: luksa/fortune:env
    env:
    - name: INTERVAL  
      value: "30"
    name: html-generator
```

> 在环境变量中引用环境变量

```
env:
- name: FIRST_VAR
  value: "foo"
- name: SECOND_VAR
  value: "$(FIRST_VAR)bar"
```
## ConfigMap 解耦配置
键值对， 应用无需读取文件，映射的内容通过环境变量或者卷文件的形式传递给容器

将配置存放在独立的资源对象中有助于在不同环境下拥有多份同名配置清单， pod通过名称引用ConfigMap,因此可以在多环境下使用pod定义描述,同时保持不同的配置值以适应不同环境

可以使用不同的配置清单创建同名的ConfigMap对象

> 创建ConfigMap

kubectl create configmap fortune-config --from-literal=sleep-interval=25

kubectl create configmap fortune-config --from-literal=sleep-interval=25 --from-literal=one=two

> 从文件创建

kubectl create configmap fortune-config --from-file=customkey=config-file.conf

> 从文件夹创建

kubectl create configmap fortune-config --from-file=/path/to/dir

### 给容器传递ConfigMap
```
kind: Pod
metadata:
  name: fortune-env-from-configmap
spec:
  containers:
  - image: luksa/fortune:env
    env:
    - name: INTERVAL
      valueFrom:
        configMapKeyRef:
          name: fortune-config
          key: sleep-interval
```

> 暴露ConfigMap中的所有条目作为环境变量

```
spec:
  containers:
  - image: some-image
    envFrom:
    - prefix: CONFIG_
      configMapRef:
        name: my-config-map
```

### 传递ConfigMap条目作为命令行参数
```
kind: Pod
metadata:
  name: fortune-args-from-configmap
spec:
  containers:
  - image: luksa/fortune-args
    env:
    - name: INTERVAL
      valueFrom:
        configMapKeyRef:
          name: fortune-config
          key: sleep-interval
    args: ["$(INTERVAL)"]
```

### 使用ConfigMap卷将条目暴露为文件

> 删除configmap

 kubectl delete configmap fortune-config

 > 从文件夹创建configmap

  kubectl create configmap fortune-config --from-file=configmap-files

> 查看configmap

kubectl get configmap fortune-config -o yaml

### 缩写
1. replicationcontroller rc
2. pods po
3. service svc



- kubectl get pods -o wide --show-labels 列出ip和所运行的节点
- kubectl get pods -L creation_method,env                   列pod出标签
- kubectl label pod kubia-manual creation_method=manual     添加标签
- kubectl label pod kubia-manual-v2 env=debug --overwrite   修改标签
- kubectl describe pod 
- kubectl describe rc xx
- kubectl get services
- kubectl get replicationcontrollers
- kubectl explain pods
- kubectl get pod --all-namespaces 列出所有命名空间中的资源




- ps aux





























