# 记一下对String#intern的理解

> 原创 于 2019-10-22 17:06:01 发布 · 公开 · 245 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/102686431

String类型的常量池有两种方式:

- 直接使用双引号声明出来的String对象会直接存储在常量池中。

- 如果不是用双引号声明的String对象，可以使用String提供的intern方法。intern 方法会从字符串常量池中查询当前字符串是否存在，若不存在就会将当前字符串放入常量池中

```java
package com.xiaobu.test.StringDemo;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/4/30 16:04
 * @description V1.0
 */
public class StringDemo2 {
    public static void main(String[] args) {
        test1();
        test2();
        test3();

    }


    /**
     * 功能描述:两个对象不同
     * @author xiaobu
     * @date 2019/10/16 16:55
     * @return void
     * @version 1.0
     */
    private static void test1() {
        //生成了两个对象，Heap中一个对象，常量池中一个对象 地址指向由栈s1引用指向堆String obj
        String s1 = new String("1");
        //执行之前常量池已经存在 "1"了
        s1.intern();
        //由栈s2引用指向常量池
        String s2 = "1";
        System.out.println(s1 == s2);
    }

    private static void test2() {
        //堆中生成了两个new String("1") 对象，一个 new String("11)对象，常量池生成了 "1"对象，还有一个由s3指向堆中new String("11)对象的引用。
        String s3 = new String("1") + new String("1");
        //s3中的“11”字符串放入 String 常量池中，在执行 s3.intern()之前 常量池是没有"11"的。
        s3.intern();
        String s4 = "11";
        System.out.println(s3 == s4);
    }

    private static void test3() {
        //堆中生成了两个new String("1") 对象，一个 new String("11)对象，常量池生成了 "1"对象，还有一个由s3指向堆中new String("11)对象的引用。
        String s5 = new String("1") + new String("1");
       //在常量池中创建"11"对象，在执行String s6 = "11"前常量池中没有"11"对象。
        String s6 = "11";
        //常量池已经存在"11"对象，所以只是内容相同但两个引用不同
        s5.intern();
        System.out.println(s5 == s6);
    }


}

```

 ![1.jpg](./assets/4_1.png)

> jdk6 字符串常量池存放在Perm区， jdk7之后转移到了Heap区。

总结:

- 将String常量池 从 Perm 区移动到了 Java Heap区

- String#intern 方法时，如果存在堆中的对象，会直接保存对象的引用，而不会重新创建对象。

[参考:深入解析String#intern](https://tech.meituan.com/2014/03/06/in-depth-understanding-string-intern.html) 