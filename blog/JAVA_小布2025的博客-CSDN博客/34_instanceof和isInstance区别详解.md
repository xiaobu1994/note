# instanceof和isInstance区别详解

> 原创 最新推荐文章于 2024-07-13 12:28:45 发布 · 公开 · 911 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86064593

对obj.instanceof(class)，在编译时编译器需要知道类的具体类型

对class.isInstance(obj)，编译器在运行时才进行类型检查，故可用于反射，泛型中