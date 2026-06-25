# SpringBoot | 常用注解记录

> 原创 于 2018-11-22 17:34:11 发布 · 公开 · 193 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84344055

一、@PathVariable URL变量

在Web应用中URL通常不是一成不变的，例如微博两个不同用户的个人主页对应两个不同的URL: `http://weibo.com/user1` ， `http://weibo.com/user2` 。我们不可能对于每一个用户都编写一个被 `@RequestMapping` 注解的方法来处理其请求，也就是说，对于相同模式的URL（例如不同的用户的主页，它们仅仅是URL中的某一部分不同，为它们各自的用户名，我们说它们具有相同的模式）。

这样就出现了@PathVariable

```java
  /**
     * @author xiaobu
     * @date 2018/11/22 12:01
     * @param name 书籍名
     * @return java.lang.String
     * @descprition   {name} 自定义变量规则  变量中不可以包含分隔符 /
     *  {name:[a-zA-Z0-9_]+} 正则表达式只允许大、小写字母以及数字和_下划线
     * @version 1.0
     */
    @GetMapping("/bookName/{name:[a-zA-Z0-9_]+}")
    @ApiOperation("验证@PathVariable参数")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "name", value = "书籍名称", dataType = DataType.STRING, paramType = ParamType.PATH),
    })
    public String getName(@PathVariable String name) {
        return "bookName/"+name;
    }
```