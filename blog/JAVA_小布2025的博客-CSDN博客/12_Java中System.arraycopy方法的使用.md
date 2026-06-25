# Java中System.arraycopy方法的使用

> 转载 最新推荐文章于 2025-04-03 21:05:54 发布 · 公开 · 267 阅读 · 0 · 0 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/88889262

转： [Java中System.arraycopy方法的使用](https://blog.csdn.net/huangbaokang/article/details/75284550) 

```java
package com.xiaobu.demo;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/3/1 16:57
 * @description V1.0
 * 
 * src:源数组； 
 * srcPos:源数组要复制的起始位置； 
 * dest:目的数组； 
 * destPos:目的数组放置的起始位置； 
 * length:复制的长度。 
 * 注意：src and dest都必须是同类型或者可以进行转换类型的数组．
 */
public class Demo1 {
    public static void main(String[] args) {
        test();
    }



    public static   void test(){
        String[] src = new String[]{"hello", "huang", "bao", "kang"};
        String[] dest = new String[5];
        System.arraycopy(src, 0, dest, 0, 4);
        for (String str : dest) {
            System.out.println(str);
        }
        System.out.println("=========华丽的分割线=========");
        System.arraycopy(src, 0, src, 1, 3);
        for (String str : src) {
            System.out.println(str);
        }
    }

}
```