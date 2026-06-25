# JAVA8 | 字符串替换

> 原创 最新推荐文章于 2025-02-26 15:20:33 发布 · 公开 · 4.8k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/94549329

> java9之前http://commons.apache.org/proper/commons-lang/下的StringUtils.replace()效率明显高于jdk自带的replace()方法

```java
 /**
     * 功能描述:比自带的string替换要高效
     * @author xiaobu
     * @date 2019/7/3 9:34
     * @param str, searchString, replacement]
     * @return java.lang.String
     * @version 1.0
     */
    public static String repalce(String str,String searchString,String replacement){
        return StringUtils.replace(str, searchString, replacement);
    }
```

> maven依赖

```xml
<dependency>
  <groupId>org.apache.commons</groupId>
  <artifactId>commons-lang3</artifactId>
  <version>3.9</version>
</dependency>
```