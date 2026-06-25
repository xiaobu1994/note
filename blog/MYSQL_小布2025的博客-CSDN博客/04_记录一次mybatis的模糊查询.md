# 记录一次mybatis的模糊查询

> 原创 最新推荐文章于 2026-04-21 03:02:13 发布 · 公开 · 502 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89203453

一、直接拼接

mysql数据库会报错，sqlserver支持

```java
select cat_id from ecs_category where cat_name LIKE '%' + #{catName} + '%';
```

二、用concat函数

```java
select cat_id from ecs_category where cat_name LIKE  concat('%',#{catName},'%');
```

三、用LOCATE实现模糊查询

```java
select cat_id from ecs_category WHERE   LOCATE(#{catName},cat_name) >0
```

---

记录一下 LOCATE的用法

1、LOCATE(substr,str)

返回子串 substr 在字符串 str 中第一次出现的位置。如果子串 substr 在 str 中不存在，返回值为 0：

```java
SELECT LOCATE('xiaobu', 'xiaobu1994xiaobu'); 
```

==>1

<span style="color:#333333;">2、LOCATE(substr,str,pos)</span>

<span style="color:#333333;">返回子串 substr 在字符串 str 中的第 pos 位置后第一次出现的位置。如果 substr 不在 str 中返回 0 ：</span>

```java
SELECT LOCATE('xiaobu', 'xiaobu1994xiaobu',5); 
```

==>11