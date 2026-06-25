# idea连接mysql8.0数据库失败

> 原创 最新推荐文章于 2026-05-09 22:10:23 发布 · 公开 · 3.9k 阅读 · 1 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/90701310

### mysql驱动版本

```
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.16</version>
  <packaging>jar</packaging>
```

### 错误信息

```
java.lang.RuntimeException: com.mysql.cj.exceptions.InvalidConnectionAttributeException: The server time zone value '?Ð¹???×¼Ê±?' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.
```

 ![1559207976(1)](./assets/08_1.jpg)

#### 正确示例

> jdbc:mysql://localhost:3306/dog_info?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull&allowMultiQueries=true&useSSL=false&serverTimezone=GMT%2B8

北京东八时区

> serverTimezone=GMT%2B8

