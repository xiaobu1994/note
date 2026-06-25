# apache服务安装与卸载

> 原创 于 2019-04-16 21:22:36 发布 · 公开 · 2.7k 阅读 · 1 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89341904

一、Define SRVROOT的意思是定义了一个名为SRVROOT的变量

```java
Define SRVROOT "E:/PHPWEB/Apache24"
```

- ServerRoot = Web服务器可执行文件/目录的路径

```java
ServerRoot "${SRVROOT}"
```

- DocumentRoot =服务器提供的文件的路径

```java
DocumentRoot "${SRVROOT}/htdocs"
```

- 该 `<Directory>` 指令用于配置特定目录的设置。

```java
<Directory "${SRVROOT}/htdocs">
```

- ServerAdmin 指令=服务器返回给客户端的错误信息中包含的管理员邮件地址

```java
ServerAdmin admin@example.com
```

- ServerName=IP地址

```java
ServerName  localhost:8090
```



二、设置监听端口

```java
Listen 8090
```

三、PHP配置

设置php路径

```java
PHPIniDir "E:/PHPWEB/php-5.6.37-Win32-VC11-x64"
```

设置phpmodule

```java
LoadModule php5_module "E:/PHPWEB/php-5.6.37-Win32-VC11-x64/php5apache2_4.dll"
```

设置文件后缀

```java
AddType application/x-httpd-php .php .html .htm
```

安装服务，进入bin目录

```java
httpd.exe -k install
```

卸载

```java
sc delete apache2.4
```

---

参考：

[ServerRoot，DocumentRoot和Directory之间的区别](https://stackoverflow.com/questions/5947947/difference-between-serverroot-documentroot-and-directory) 

[apache配置文件中的ServerName究竟指什么？](https://segmentfault.com/q/1010000007480637) 