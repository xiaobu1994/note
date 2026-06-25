# 使用Stream 操作list集合

> 原创 于 2019-06-25 19:32:51 发布 · 公开 · 9.1k 阅读 · 2 · 5 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/93647020

```java
package com.xiaobu.demo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/4/23 9:34
 * @description V1.0
 */
public class StreamDemo {
    public static void main(String[] args) {
        test3();
        test1();
        List<String> list1 = new ArrayList<String>();
        list1.add("1");
        list1.add("2");
        list1.add("3");
        list1.add("5");
        list1.add("6");

        List<String> list2 = new ArrayList<String>();
        list2.add("2");

        System.out.println("===差集===");
        List<String> reduce1 = list1.stream().filter(item -> !list2.contains(item)).collect(Collectors.toList());
        //并行流
        reduce1.parallelStream().forEach(System.out::println);

        System.out.println("===交集===");
        List<String> reduce2 = list1.stream().filter(list2::contains).collect(Collectors.toList());
        reduce2.forEach(System.out::println);

        System.out.println("===去重并集===");
        list1.addAll(list2);
        List<String> reduce3 = list1.stream().distinct().collect(Collectors.toList());
        System.out.println("reduce3 = " + reduce3);

        list1 = list1.stream().distinct().sorted().collect(Collectors.toList());
        System.out.println("list1 = " + list1);

        //Collectors.joining() 按倒序拼接成字符串  listStr = 65321
        String listStr = list1.stream().distinct().sorted(Comparator.reverseOrder()).collect(Collectors.joining());
        System.out.println("listStr = " + listStr);
        //按正序拼接成字符串   listStr = [1,2,3,5,6]
        listStr = list1.stream().distinct().sorted().collect(Collectors.joining(",", "[", "]"));
        System.out.println("listStr = " + listStr);
    }


    public static void test1() {
        List<Integer> list1 = new ArrayList<>();
        list1.add(1);
        list1.add(2);
        list1.add(3);

        List<Integer> list2 = new ArrayList<>();
        list2.add(3);
        list2.add(4);
        list2.add(5);

        System.out.println("====求交集===");

        List<Integer> list = list1.stream().filter(list2::contains).collect(Collectors.toList());
        list.forEach(System.out::println);

        System.out.println("====求差集===");
        list = list1.stream().filter(t -> !list2.contains(t)).collect(Collectors.toList());
        list.forEach(System.out::println);

        System.out.println("====求去重并集===");
        list.addAll(list1);
        list.addAll(list2);
        list = list.stream().distinct().collect(Collectors.toList());
        list.forEach(System.out::println);
    }


    public static void test3() {
        List<String> names1 = new ArrayList<String>();
        names1.add("Google ");
        names1.add("Runoob ");
        names1.add("Taobao ");
        names1.add("Baidu ");
        names1.add("Sina ");
        //逆序
        Collections.sort(names1, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return o2.compareTo(o1);
            }
        });
        System.out.println("names1 = " + names1);
    }
}


```