# 1071 - Specified key was too long; max key length is 767 bytes

> 原创 最新推荐文章于 2025-01-17 22:45:50 发布 · 公开 · 1.6k 阅读 · 2 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/103314927

Mysql 建表错误1071 - Specified key was too long; max key length is 767 bytes
今天遇到了一个Mysql建表问题，报错1071 - Specified key was too long; max key length is 767 bytes。

仔细查看建表sql语句，没有发现什么特别的地方，最后找到原因，这里记录下。

起因：

我在表中设置某个字段为varchar(255) unique,执行建表语句就报错。

经过各方查找，我发现了这个问题和数据库字符集有关。具体的情况stackoverflow上大家的讨论：一个utf8字符占3个byte，一个utf8mb4的字符占4个byte,而mysql的innodb有限制索引长度不得超过767，简而言之就是一个公式。

utf8: 255 *3 = 765 < 767 < 256* 3 = 768
utf8mb4: 191 *4 = 764 < 767 < 192* 4=768
所以就得出了结论

INNODB utf8 VARCHAR(255)
INNODB utf8mb4 VARCHAR(191)
解决办法有以下几种：

1.建表时候直接指定使用utf8字符集而不是utf8mb4（这个方案就是修改字符集，当然你也可以修改mysql的全局配置实现）

2.使用innodb建表，并设置mysql配置项innodb_large_prefix=on，这种办法就是设置启用innodb_large_prefix选项，将约束项扩展至3072byte

3.修改字段长度即utf8下面255 utf8mb4下191

参考:
[1071 - Specified key was too long; max key length is 767 bytes](https://stackoverflow.com/questions/1814532/1071-specified-key-was-too-long-max-key-length-is-767-bytes) 

[Mysql 建表错误1071 - Specified key was too long; max key length is 767 bytes](http://www.linhongxu.com/post/view?id=232) 