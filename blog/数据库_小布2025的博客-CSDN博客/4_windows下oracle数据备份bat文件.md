# windows下oracle数据备份bat文件

> 原创 于 2018-12-21 15:47:53 发布 · 公开 · 912 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/85163348

```cobol
@echo off  
set "tbuf=E:\Backup_Oracle_BANJIN"  
  
echo 设置备份文件名(以星期几命名，即备份文件只保存最近一周)...  
set name=%date%  
set name=%name:~-3%  
set name=ORCL_backup_%name%  
  
echo 是否存在同名文件，若存在则删除同名文件...  
if exist %tbuf%\%name%.dmp del %tbuf%\%name%.dmp  
if exist %tbuf%\%name%.log del %tbuf%\%name%.log  
         
echo 开始备份(备份整个数据库).....    
  
exp banjin/banjin2015@banjin owner=(banjin,bjds) file='%tbuf%\%name%.dmp'  log='%tbuf%\%name%.log'  
  
echo 备份完毕!   
```