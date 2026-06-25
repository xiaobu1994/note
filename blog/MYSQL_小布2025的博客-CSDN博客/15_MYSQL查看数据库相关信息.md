# MYSQL查看数据库相关信息

> 原创 最新推荐文章于 2025-01-19 13:13:14 发布 · 公开 · 327 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/111031386



- 查看指定数据库的相关信息

```sql
SELECT
	table_schema AS '数据库',
	sum(table_rows) AS '记录数',
	sum(
		TRUNCATE (data_length / 1024 / 1024, 2)
	) AS '数据容量(MB)',
	sum(
		TRUNCATE (index_length / 1024 / 1024, 2)
	) AS '索引容量(MB)'
FROM
	information_schema. TABLES
WHERE
	table_schema = 'random_code';
```

| 数据库 | 记录数 | 数据容量(MB) | 索引容量(MB) |
|:---:|:---:|:---:|:---:|
| random_code | 1984636634 | 61452.00 | 0.00 |

- 查看指定数据库下所有表的相关信息

```sql
select 
table_schema as '数据库',
table_name as '表名',
table_rows as '记录数',
truncate(data_length/1024/1024, 2) as '数据容量(MB)',
truncate(index_length/1024/1024, 2) as '索引容量(MB)'
from information_schema.tables
where table_schema='random_code'
order by data_length desc, index_length desc;
```

| 数据库 | 表名 | 记录数 | 数据容量(MB) | 索引容量(MB) |
|:---:|:---:|:---:|:---:|:---:|
| random_code | random_code_38 | 49605066 | 1608.00 | 0.00 |

- 查看指定数据库下有数据的表

```sql
SELECT
	TABLE_NAME
FROM
	information_schema. TABLES
WHERE
	TABLE_SCHEMA = 'random_code'
AND TABLE_ROWS > 0;


```

| 表名 |
|:---:|
| random_code_38 |

- 查所有数据库的容量大小

```sql
select 
table_schema as '数据库',
sum(table_rows) as '记录数',
sum(truncate(data_length/1024/1024, 2)) as '数据容量(MB)',
sum(truncate(index_length/1024/1024, 2)) as '索引容量(MB)'
from information_schema.tables
group by table_schema
order by sum(data_length) desc, sum(index_length) desc;
```

| 数据库 | 记录数 | 数据容量(MB) | 索引容量(MB) |
|:---:|:---:|:---:|:---:|
| random_code | 1984636634 | 61452.00 | 0.00 |
| springboot_demo | 49605066 | 1608.00 | 0.00 |
| ssh | 1350742 | 167.70 | 0.00 |

*查所有数据库各表的容量大小

```sql
select 
table_schema as '数据库',
table_name as '表名',
table_rows as '记录数',
truncate(data_length/1024/1024, 2) as '数据容量(MB)',
truncate(index_length/1024/1024, 2) as '索引容量(MB)'
from information_schema.tables
order by data_length desc, index_length desc;
```

| 数据库 | 表名 | 记录数 | 数据容量(MB) | 索引容量(MB) |
|:---:|:---:|:---:|:---:|:---:|
| random_code | random_code_38 | 49605066 | 1608.00 | 0.00 |
| ssh | name | 123456 | 118.00 | 0.00 |