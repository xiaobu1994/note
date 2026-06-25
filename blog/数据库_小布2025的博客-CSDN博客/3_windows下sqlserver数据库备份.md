# windows下sqlserver数据库备份

> 原创 于 2018-12-21 17:12:18 发布 · 公开 · 829 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/85165233

一、sqlserver_export.bat



```java
@echo off
set path=%path%;C:\Program Files (x86)\Microsoft SQL Server\80\Tools\Binn
echo 数据库备份开始
osql.exe -S 127.0.0.1 -U sa -P xiaobu@1994 -i sqlserver_export.sql -o F:\sqlserver_export\sqlserver_export.out
echo 数据库备份完成
pause
```



二、sqlserver_export.sql



```java
DECLARE @name varchar(50)
DECLARE @datetime char(14)
DECLARE @path varchar(255)
DECLARE @bakfile varchar(255)
set @name='han'
set @datetime=CONVERT(char(8),getdate(),112) + REPLACE(CONVERT(char(8),getdate(),108),':','')
set @path='F:\sqlserver_export\'
set @bakfile=@path+''+@name+'_'+'bak_'+@datetime+'.BAK'
backup database @name to disk=@bakfile with name=@name
go

```

---

SQLServer还原.bak文件为数据库： [https://blog.csdn.net/qq_23888451/article/details/59123766](https://blog.csdn.net/qq_23888451/article/details/59123766) 