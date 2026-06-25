# springcloud 配置 spring.cloud.config.uri 无效

> 原创 最新推荐文章于 2023-03-08 10:33:28 发布 · 公开 · 1.3k 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/112462987

学习springcloud 配置一个config-client，需要配置一个config-server的地址。

在application.properties中配置了spring.cloud.config.uri=http://localhost:7002。没有按网上的例子配置成8888.

结果发现这个配置总是不生效，还是访问默认配置的8888.

网上找答案，果然有人跟我遇到同样的问题，增加一个bootstrap.properties配置文件。在这个文件增加配置spring.cloud.config.uri

bootstrap.properties 优先级高于 application.properties

这样果然生效。