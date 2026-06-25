# bootstrap fileinput.js 文件上传 文件名称的问题

> 原创 于 2018-12-28 16:35:14 发布 · 公开 · 4.4k 阅读 · 1 · 4 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/85284785

修改fileinput.js中的_slugDefault方法

初始方法：

```java
_slugDefault: function (text) {
return isEmpty(text) ? '' : String(text).replace(/[\-\[\]\/\{}:;#%=\(\)\*\+\?\\\^\$\|<>&"']/g, '_');
}
```



修改后的方法：

```java
 //使特殊字符不被替换 
 _slugDefault: function (text) {
            return isEmpty(text) ? '' : String(text);
        },
```