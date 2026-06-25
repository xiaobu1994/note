# sharding-jdbc配置主从数据库

> 原创 于 2020-11-02 11:14:12 发布 · 公开 · 2.7k 阅读 · 1 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/109445190

## 配置主从数据库

```properties
sharding.jdbc.dataSource.names=db-test0,db-test1,db-test2
# 配置主库
sharding.jdbc.dataSource.db-test0.type=com.alibaba.druid.pool.DruidDataSource
sharding.jdbc.dataSource.db-test0.driverClassName=com.mysql.jdbc.Driver
sharding.jdbc.dataSource.db-test0.url=jdbc:mysql://172.18.0.220:3306/cool?useUnicode=true&characterEncoding=utf8&tinyInt1isBit=false&useSSL=false&serverTimezone=GMT
sharding.jdbc.dataSource.db-test0.username=root
sharding.jdbc.dataSource.db-test0.password=
sharding.jdbc.dataSource.db-test0.maxPoolSize=20
# 配置第一个从库
sharding.jdbc.dataSource.db-test1.type=com.alibaba.druid.pool.DruidDataSource
sharding.jdbc.dataSource.db-test1.driverClassName=com.mysql.jdbc.Driver
sharding.jdbc.dataSource.db-test1.url=jdbc:mysql://172.18.250.231:3306/cool?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&useSSL=false&serverTimezone=GMT
sharding.jdbc.dataSource.db-test1.username=root
sharding.jdbc.dataSource.db-test1.password=
sharding.jdbc.dataSource.db-test1.maxPoolSize=20
# 配置第二个从库
sharding.jdbc.dataSource.db-test2.type=com.alibaba.druid.pool.DruidDataSource
sharding.jdbc.dataSource.db-test2.driverClassName=com.mysql.jdbc.Driver
sharding.jdbc.dataSource.db-test2.url=jdbc:mysql://172.18.9.166:3306/cool?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&useSSL=false&serverTimezone=GMT
sharding.jdbc.dataSource.db-test2.username=root
sharding.jdbc.dataSource.db-test2.password=
sharding.jdbc.dataSource.db-test2.maxPoolSize=20
# 配置从库选择策略，提供轮询与随机，这里选择用轮询//random 随机 //round_robin 轮询
sharding.jdbc.config.masterslave.load-balance-algorithm-type=round_robin
sharding.jdbc.config.masterslave.name=db1s2
sharding.jdbc.config.masterslave.master-data-source-name=db-test0
sharding.jdbc.config.masterslave.slave-data-source-names=db-test1,db-test2
#开启SQL显示，默认值: false，注意：仅配置读写分离时不会打印日志！！！
sharding.jdbc.props.sql.show=true
server.port=8085
mybatis.config-location=classpath:META-INF/mybatis-config.xml

```

> > 在玩转读写分离时，遇到如下几个需要注意的地方
> 
> 

1. Sharding-JDBC目前仅支持一主多从的结构

2. Sharding-JDBC没有提供主从同步的实现，该功能需要自己额外搭建，可参照《基于Docker的Mysql主从复制搭建》简易搭建测试使用

3. 主库和从库的数据同步延迟导致的数据不一致问题需要自己去解决

4. Sharding-JDBC虽然提供了打印SQL日志的开关，但是如果仅配置了读写分离好像是没有用的

5. 使用其他连接池时，需要将jdbc-url配置名该为url，否则可能会抛异常

