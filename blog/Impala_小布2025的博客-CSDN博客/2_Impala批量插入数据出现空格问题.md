# Impala批量插入数据出现空格问题

> 原创 于 2021-10-15 10:43:48 发布 · 公开 · 929 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120778918

### 常用语句记录

### impalainsertvalues 批量插入出现空格

出现空格(password的两个值长度不一样 导致666666那个会出现空格)

```sql
UPSERT
into user ( name, password )
VALUES ('admin','666666'),('xiaobu','88888888')

```

正常

```sql
UPSERT
UPSERT
into user ( name, password )
VALUES ("admin","666666"),("xiaobu","88888888")
```

解决方法：

```sql
<insert id="upsertList">
        upsert into user (
        <include refid="Base_Column_List"/>
        )
        values
        <foreach collection="list" item="item" index="index" separator=",">
            (
            "${item.name}",
            "${item.password}"
            <!-- 
#{item.name,jdbcType=VARCHAR},
#{item.password,jdbcType=VARCHAR}-->
)
</
foreach
>
</
insert
>
```