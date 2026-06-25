# 驱动程序无法通过使用安全套接字层(SSL)加密与 SQL Server 建立安全连接。错误:SQL Server 未返回响应。连接已关闭。

> 原创 于 2018-12-11 16:30:47 发布 · 公开 · 3.6w 阅读 · 11 · 26 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84957254

项目连服务器的sqlserver2005报这个错误，网上一直没找到答案。 被这个问题困扰了一天了，特此记录一下。

环境jdk1.8测试连接测试数据库都正常。

一个是win7sqlserver2014

一个是win7 sqlserver2005



但是测试连接xp sqlserver2005 也报相同的错误

据说server2003连接时也会报这样的错误。。。

本人对应的jdk目录。C:\Program Files\Java\jdk1.8.0_171\jre\lib\security\java.security
经测试    把jdk下面的java.security中的<span style="color:#e579b6;">, 3DES_EDE_CBC</span>去掉 （启用旧的算法）可以连上windows server 2003的sqlserver2005

xp 也可以连通了。

如果是服务器上面的话，需要把jre下面对应的java.security的<span style="color:#e579b6;">, 3DES_EDE_CBC</span>去掉。启用旧的算法。

相关文档。

[https://www.java.com/en/configure_crypto.html](https://www.java.com/en/configure_crypto.html) 

[https://docs.microsoft.com/zh-cn/sql/connect/jdbc/using-ssl-encryption?view=sql-server-2017](https://docs.microsoft.com/zh-cn/sql/connect/jdbc/using-ssl-encryption?view=sql-server-2017) 



[https://blogs.msdn.microsoft.com/jdbcteam/2008/09/09/the-driver-could-not-establish-a-secure-connection-to-sql-server-by-using-secure-sockets-layer-ssl-encryption/](https://blogs.msdn.microsoft.com/jdbcteam/2008/09/09/the-driver-could-not-establish-a-secure-connection-to-sql-server-by-using-secure-sockets-layer-ssl-encryption/) 