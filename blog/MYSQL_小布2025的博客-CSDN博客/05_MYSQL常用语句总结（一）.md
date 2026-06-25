# MYSQL常用语句总结（一）

> 原创 最新推荐文章于 2024-03-10 15:24:07 发布 · 公开 · 216 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89315794

一、安装

```java
mysqld –install mysql
```

启动服务

如果启动服务报 1067的话 需要删除D:\mysql-5.6.26-winx64\data目录下的 ibdata1，ib_logfile1，ib_logfile0三个文件 重新安装服务并启动

```java
net start mysql
```

登录

windows下不能带分号，linux下带不带分号都可以

```
mysql -uroot -p 
```

查看数据库属性

```
use mysql;
```

查看root用户对应的连接

```java
select host from user where user ='root';
```

修改密码:

```
UPDATE user SET Password = PASSWORD('123456') WHERE user = 'root';
```



root可以远程连接

```java
update user set host='%' where user = 'root'; 
```

刷新权限

```java
flush privileges;
```

(赋予admin在任意机器上都有可以访问数据库的权限  密码是admin)

```java
GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION; 
```

同上

```java
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '113506' WITH GRANT OPTION;
```

刷新权限

```java
FLUSH PRIVILEGES;
```

查询mysql安装的路径

```java
select @@basedir as basePath from dual
```

```java
select version()
```

查看版本号

```java
select version()
```

查询数据库有多少个表

```java
SELECT COUNT( * ) FROM information_schema.tables WHERE TABLE_SCHEMA = 'ecshop'
```

查看数据库的隔离级别

```java
SELECT @@tx_isolation;
```

创建用户

```java
CREATE USER 'shenmm'@'localhost' IDENTIFIED BY '113081';
```

授权（lpc是数据库,后面*表示任意表）

```java
GRANT ALL ON lpc.* TO 'shenmm'@'%';
```



---



二、数据操作

清空表t

```java
truncate t;
```

删除表t

```java
drop table t;
```

导出数据库

```java
mysqldump -uroot -p113506 lpc > lpc.sql 
```

导出单个表

```java
 mysqldump -uroot -p113506 shiro4 test > D:\test.sql  
```

忽略某个表的数据

```java
mysqldump -uroot -p113506 lps --ignore-table=lps.lps_phone_type > lps.sql
```

导入数据

首先登录mysql，选择数据库

```java
use lpc;
```

执行导入

```java
source  F:/lpc.sql
```

复制表结构

```java
create TABLE springbootdemo.test_book  like ssh.test_book
```

复制表结构以及数据

```java
CREATE TABLE springbootdemo.test_area SELECT * FROM ssh.test_area
```

mysql 创建表

```java
DROP TABLE IF EXISTS `uc_user`;
CREATE TABLE `uc_user` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `USER_NAME` varchar(100) DEFAULT NULL COMMENT '用户名',
  `CREATE_DATE` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `USER_NAME` (`USER_NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='用户表';
```

---

三、查询

查询（四舍五入）

```java
select ROUND(3.1415926, 3);
```

```java
select convert(totalPrice,decimal(10,2)) from xg_material
```

查询小数点后面位数大于2的

```java
select * ,totalPrice*100 from xg_material where totalPrice*100 - floor(totalPrice*100) > 0
```

查看某个表所占空间大小

```sql
select concat(round(sum(DATA_LENGTH/1024/1024),2),'M') as table_size 
   from information_schema.tables 
      where table_schema='xuangang' AND table_name='xg_material';
```