# JAVA字符串格式化-String.format()的使用

> 原创 最新推荐文章于 2024-11-23 18:39:43 发布 · 公开 · 905 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84345559

一、String.format()的基本使用

```java
package StringTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/22 17:16
 * @description V1.0 String.format(）的应用
 */
public class Demo2 {
    public static void main(String[] args) {
        //%s占位符 %n是换行
        String  str=String.format("Hi,%s", "admin");
        System.out.println(str);
        str=String.format("Hi,%s:%s.%s", "张三","李四","王五");
        System.out.println(str);
        System.out.printf("Hi,%s:%s.%s %n", "张三","李四","王五");
        str = String.format("Hi,%s:%s.%s", "张三", "李四", "王五");
        System.out.println(str);
    }
}
```

---

结果如下：

```
Hi,admin
Hi,张三:李四.王五
Hi,张三:李四.王五 
Hi,张三:李四.王五
```

---

```html
slf4j有个类似的功能
```

```java
# void info(String var1, Object var2);
slf4j有一个common logger没有的功能，字符串中的{}会被替换

  log.info("Hello {}","world"); ==> Hello world
```