# Oracle对表delete后空间不释放

> 原创 最新推荐文章于 2026-03-05 00:45:29 发布 · 公开 · 2.5k 阅读 · 7 · 8 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 GEO检测 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/134822179

Oracle对表delete后空间不释放

> 开启允许行移动，该语句允许rowid改变

```sql
alter table TableName enable row movement;
```

> 把块中的数据堆到一起，但会保持high water mark

```sql
alter table TableName shrink space  compact;
```

> (这个会锁表) 回收空间

```sql
alter table TableName shrink space;
```

> 关闭允许行移动，该语句允许rowid改变

```sql
alter table TableName disable row movement;
```