##  Mysql通用查询日志


查看通用查询日志

```sql
show variables like '%general%';
```

查看通用日志的输出格式：

```sql
show variables like '%log_output%';
```

配置文件设置

```properties
#为1表示开启通用日志查询，值为0表示关闭通用日志查询
general_log=1
#设置通用日志的输出格式为文件和表
log_output=FILE,TABLE

```

## Mysql慢查询

命令行设置

查询是否开启慢查询
```sql
show variables like 'slow_query_log%';
```



查询超时时间
```sql
show variables like 'long_query_time%';
```

开启慢查询
```sql
set global slow_query_log=1;
```
设置超时时间
```sql
set global long_query_time=3;
```


配置文件配置(开启慢查询和设置超时时间)
```properties
slow_query_log=1
slow_query_log_file=/var/lib/mysql/slow-log.log
long_query_time=3
```


两种方式都配置成功。使用命令行开启，重启服务后慢查询就会失效；修改配置文件的方式，会一直生效。