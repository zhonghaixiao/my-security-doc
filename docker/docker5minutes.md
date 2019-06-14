# 容器生态系统

- 容器核心技术
- 容器平台技术
- 容器支持技术

## 容器核心技术

- 容器规范
- 容器runtime
- 容器管理工具
- 容器定义技术
- Registries
- 容器os

## 容器平台技术

- 容器编排引擎  容器调度、管理、集群定义、服务发现  （swarm, kubernetes, mesos）
- 容器管理平台  架构在容器编排之上的更通用平台，抽象编排引擎 （Rancher,ContainerShip）
- 基于容器的Paas （Deis,Flynn,Dokku）

## 容器支持技术

- 容器网络  （docker network, flannel, weave, calico）
- 服务发现  (etcd,consul,zookeeper)
- 监控      (docker ps/top/stats, docker stats api, sysdig, cAdvisor, Weave Scope)
- 数据管理
- 日志管理  (docker logs, logsout)
- 安全性    (openScap)

## 

> 重启Docker deamon

system restart docker.service

docker可以将任何应用及其依赖打包成一个轻量级、可移植、自包含的容器

## 命令
1.  attach attact local standard input ,output, and error streams to a running container
2.  docker exec -it [id] /bin/bash
3.  docker container ls
4.  docker ps -a
5.  docker pull hello-world
6.  docker images hello-world
7.  docker run --rm hello-world  退出即删除容器
8.  docker commit old new
9.  docker build -t ubuntu1 .
10. docker volume ls
11. docker run --name bbox -v /test/data busybox
12. docker volume rm 
13. docker volume rm $(docker volume ls -q)

add 如果文件是归档文件，自动解压缩




























