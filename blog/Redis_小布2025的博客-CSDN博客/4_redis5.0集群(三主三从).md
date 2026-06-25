# redis5.0集群(三主三从)

> 原创 于 2022-06-29 14:14:36 发布 · 公开 · 436 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/125521048

进入目录

```cmd
cd /usr01/admin/redis
```

解压

```cmd
tar zxvf redis-5.0.8.tar.gz
```

进入redis目录

```cmd
cd redis-5.0.8/
```

指定内存管理

```cmd
make MALLOC=libc
```

```cmd
make && make install
```

创建 redis_cluster文件夹。redis_cluster下面创建master、slave文件夹，并在文件夹下添加redis.conf

master下的redis.conf

```text
port 6379
cluster-enabled yes
cluster-config-file "nodes-6379.conf"
logfile "redis-server-6379.log"
dbfilename "dump-6379.rdb"
daemonize yes
bind 172.29.128.70
protected-mode no
supervised no
pidfile /run/redis_6379.pid
dir /usr01/admin/redis_cluster/master

```

slave下的redis.conf

```text
port 6381
cluster-enabled yes
cluster-config-file "nodes-6381.conf"
logfile "redis-server-6381.log"
dbfilename "dump-6381.rdb"
daemonize yes
bind 172.29.128.70
protected-mode no
supervised no
pidfile /run/redis_6381.pid
dir /usr01/admin/redis_cluster/slave


```

(其他机器也一样 主要是端口和ip做修改)

启动master、slave的conf

```text

/usr01/admin/redis-5.0.8/src/redis-server /usr01/admin/redis_cluster/master/redis.conf

/usr01/admin/redis-5.0.8/src/redis-server /usr01/admin/redis_cluster/slave/redis.conf
```

查看redis进程

```cmd
netstat -tunpl | grep redis
```

进入任意一个节点，执行以下指令创建集群

```text
/usr01/admin/redis-5.0.8/src/redis-cli  --cluster create 172.29.128.69:6379 172.29.128.69:6381 172.29.128.70:6379 172.29.128.70:6381 172.29.128.71:6379 172.29.128.71:6381  --cluster-replicas 1
```

结果：

```text
Adding replica 172.29.128.70:6381 to 172.29.128.69:6379
Adding replica 172.29.128.71:6381 to 172.29.128.70:6379
Adding replica 172.29.128.69:6381 to 172.29.128.71:6379
M: 91ef1e57b58956a7d74993fb90cc953c9c200e56 172.29.128.69:6379
   slots:[0-5460] (5461 slots) master
S: 4f71bb349fcb6db59a0b03d6e11104a5d5c3f949 172.29.128.69:6381
   replicates ddeae76e33280b7638074b0ab32b66813b6c324e
M: 338bb3844df88ff27579cab07c1d6647fc16ec35 172.29.128.70:6379
   slots:[5461-10922] (5462 slots) master
S: ddf89386a37bba752790af7645b673f9db8edd20 172.29.128.70:6381
   replicates 91ef1e57b58956a7d74993fb90cc953c9c200e56
M: ddeae76e33280b7638074b0ab32b66813b6c324e 172.29.128.71:6379
   slots:[10923-16383] (5461 slots) master
S: 503284f26104613e9e3cceb29aaa82b9e81198ad 172.29.128.71:6381
   replicates 338bb3844df88ff27579cab07c1d6647fc16ec35
```

查看集群状态

```text
/usr01/admin/redis-5.0.8/src/redis-cli --cluster check 172.29.128.69:6379
```

客户端以集群模式连接

```text
/usr01/admin/redis-5.0.8/src/redis-cli  -h 172.29.128.69 -p 6379 -c
```

cluster info（查看集群信息）、cluster nodes（查看节点列表）

```text
 CLUSTER INFO
```

```text
CLUSTER NODES
```

参考：
[Redis集群搭建](https://blog.csdn.net/Zhuge_Dan/article/details/119809596) 
[Redis 5 之后版本的高可用集群搭建](https://www.jianshu.com/p/8045b92fafb2) 
[Redis 6.X Cluster 集群搭建](https://cloud.tencent.com/developer/article/1810396#:~:text=%E9%9B%86%E7%BE%A4%E5%8F%82%E6%95%B0%E8%A7%A3%E9%87%8A%EF%BC%9A%20cluster-replicas%201%EF%BC%9A%E8%A1%A8%E7%A4%BA%E5%B8%8C%E6%9C%9B%E4%B8%BA%E9%9B%86%E7%BE%A4%E4%B8%AD%E7%9A%84%E6%AF%8F%E4%B8%AA%E4%B8%BB%E8%8A%82%E7%82%B9%E5%88%9B%E5%BB%BA%E4%B8%80%E4%B8%AA%E4%BB%8E%E8%8A%82%E7%82%B9,%28%E4%B8%80%E4%B8%BB%E4%B8%80%E4%BB%8E%29%E3%80%82%20cluster-replicas%202%EF%BC%9A%E8%A1%A8%E7%A4%BA%E5%B8%8C%E6%9C%9B%E4%B8%BA%E9%9B%86%E7%BE%A4%E4%B8%AD%E7%9A%84%E6%AF%8F%E4%B8%AA%E4%B8%BB%E8%8A%82%E7%82%B9%E5%88%9B%E5%BB%BA%E4%B8%A4%E4%B8%AA%E4%BB%8E%E8%8A%82%E7%82%B9%20%28%E4%B8%80%E4%B8%BB%E4%BA%8C%E4%BB%8E%29%E3%80%82) 