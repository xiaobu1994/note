# windows下mysql数据备份bat文件

> 原创 于 2018-12-21 15:44:34 发布 · 公开 · 578 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/85163244

```cobol
@echo off
 
forfiles /p "E:\db_backup" /m lpc_backup_*.sql -d -7 /c "cmd /c del /f @path"
 
set "Ymd=%date:~0,4%%date:~5,2%%date:~8,2%0%time:~1,1%%time:~3,2%%time:~6,2%"
E:\mysql-5.6.24-win32\bin\mysqldump --opt --single-transaction=TRUE --user=root --password=113506 --host=127.0.0.1 --protocol=tcp --port=3306 --default-character-set=utf8 --single-transaction=TRUE --routines --events "lpc" > E:\db_backup\lpc_backup_%Ymd%.sql
 
@echo on
```