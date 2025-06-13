/opt/homebrew/etc/redis.conf


<!-- //方式一：使用brew帮助我们启动软件 -->
brew services start redis


<!-- 最后使用brew命令关闭redis服务 -->
brew services stop redis



//方式二
redis-server /usr/local/etc/redis.conf


<!-- 查看redis服务进程 -->
ps axu | grep redis

ps -ef | grep redis


<!-- 正确停止Redis的方式应该是向Redis发送SHUTDOWN命令 -->

redis-cli shutdown

<!-- 强行终止redis -->
sudo pkill redis-server


通过Mac自带的Homebrew工具，查看服务列表

brew services list

