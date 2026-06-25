# mysql忘记密码

> 原创 最新推荐文章于 2022-08-31 20:14:11 发布 · 公开 · 247 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89326047

一、在my.ini文件[mysqld]下面添加以下代码，重启mysql

```java
skip-grant-tables
```

输入

```java
mysql -u root -p
```

出现password直接按回车。即登录成功

修改密码

```java
use mysql;
```

```java
update user set password=password("113506") where user="root";
```

刷新权限

```java
flush privileges;
```

去掉

```java
skip-grant-tables
```

重启mysql。