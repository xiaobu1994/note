# windows下redis的安装和注册服务

> 原创 于 2019-04-25 14:14:40 发布 · 公开 · 380 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89515162

#### 启动

```cmd
redis-server redis.windows.conf
```

###注册服务

```cmd
redis-server --service-install redis.windows-service.conf --loglevel verbose
```

#### 卸载服务

```cmd
redis-server --service-uninstall
```

#### 打开客户端连接

```cmd
redis-cli.exe -h 127.0.0.1 -p 6379 
```

#### 查看有无密码

```cmd
CONFIG get requirepass
```

#### 设置密码

```cmd
CONFIG set requirepass 'xiaobu@1994'
```

#### 登录认证

```cmd
AUTH xiaobu@1994
```