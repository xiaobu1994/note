# redis哨兵模式

> 原创 于 2022-06-29 14:15:14 发布 · 公开 · 303 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/125521069

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

进入src目录

```cmd
cd src
```

启动server

```cmd
./redis-server  ../redis.conf
```

启动从机

```cmd
./redis-server  /usr01/admin/redis/slave-6381/redis.conf
```

连接客户端 进入src目录

```cmd
cd src
```

连接

```cmd
./redis-cli

```

或指定ip和端口

```cmd
redis-cli -h 172.29.128.69 -p 6384
```

启动哨兵

```cmd
./redis-sentinel  ../sentinel.conf
```

或

```cmd
./redis-server   ../sentinel.conf --sentinel
```

查看redis进程

```cmd
netstat -tunpl | grep redis
```

#### redis_master.conf

```conf
# NETWORK 设置
# 关闭保护模式
protected-mode no
# 绑定IP地址，可以通过ifconfig 获取Ip地址
bind 192.168.3.166
# 保持默认值，也可以修改
port 6381
# Client 端空闲断开连接的时间,0表示不断开
timeout 30 
# GENERAL 设置
# 默认值是no，把值修改为yes，以后台模式运行
daemonize yes 
# 日志文件的位置
logfile ""
dir ""
loglevel debug
# APPEND ONLY MODE 设置
# 默认值是No，意思是使用RDB全量持久化的方式。Yes是使用AOF增量持久化的方式
appendonly yes  
appendfsync always 
# 关闭集群模式
cluster-enabled no

```

#### redis_slave.conf

```conf
################################# NETWORK #####################################
bind 172.29.128.71
# 主服务器的Ip地址和Port端口号
# 如果slave 无法与master 同步，设置成slave不可读，方便监控脚本发现问题
replica-serve-stale-data yes
port 6381
timeout 30
################################# GENERAL #####################################
daemonize yes
pidfile "/var/run/redis_6381.pid"
loglevel debug
logfile "redis-server-6381.log"
dir "/usr01/admin/redis/slave"
dbfilename "dump-6381.rdb"
# REPLICATION 设置
# 主服务器的Ip地址和Port端口号
slaveof 192.168.3.166 6379
# 如果slave 无法与master 同步，设置成slave不可读，方便监控脚本发现问题
slave-serve-stale-data no
# APPEND ONLY MODE 设置
appendonly yes 
appendfsync always
# 关闭集群模式
cluster-enabled no
```

#### sentinel.conf

```conf
bind 172.29.128.71
protected-mode no
port 26379
daemonize yes
pidfile "/var/run/redis-sentinel.pid"
logfile "sentinel.log"
dir "/usr01/admin/redis/sentinel-work"
sentinel deny-scripts-reconfig yes
# 多长时间（默认30秒）不能使用后标记为sdown状态(单位毫秒)
sentinel monitor mymaster 172.29.128.71 6381 2
# 指定了最多可以有多少个slave同时对新的master进行同步
sentinel config-epoch mymaster 1
# 指定故障转移超时时间(单位毫秒)
loglevel debug

```

参考：

[Redis哨兵模式和集群搭建](https://zhangweisep.github.io/2018/09/26/Redis%E5%93%A8%E5%85%B5%E6%A8%A1%E5%BC%8F%E5%92%8C%E9%9B%86%E7%BE%A4%E6%90%AD%E5%BB%BA/) 