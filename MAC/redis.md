# Redis 常用命令

## 配置文件位置

```text
/opt/homebrew/etc/redis.conf
```

## 使用 Homebrew 管理 Redis

启动 Redis：

```shell
brew services start redis
```

停止 Redis：

```shell
brew services stop redis
```

查看服务列表：

```shell
brew services list
```

## 直接启动 Redis

```shell
redis-server /usr/local/etc/redis.conf
```

## 查看 Redis 进程

```shell
ps axu | grep redis
ps -ef | grep redis
```

## 停止 Redis

推荐向 Redis 发送 `SHUTDOWN` 命令：

```shell
redis-cli shutdown
```

强制终止 Redis：

```shell
sudo pkill redis-server
```
