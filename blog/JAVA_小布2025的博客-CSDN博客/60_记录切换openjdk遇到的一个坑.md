# 记录切换openjdk遇到的一个坑

> 原创 最新推荐文章于 2026-01-12 10:31:41 发布 · 公开 · 820 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/108082846

卸载原先的oracle jdk 并配置open jdk的环境变量

执行 java -version 命令时提示：

```properties
Error: opening registry key 'Software\JavaSoft\Java Runtime Environment'
Error: could not find java.dll
Error: Could not find Java SE Runtime Environment.
```

解决方法:

Path系统环境变量中，把%JAVA_HOME%\bin调整到最前面

参考:

[JAVA_HOME环境变量失效的解决办法](https://www.cnblogs.com/yjmyzz/p/3521554.html) 