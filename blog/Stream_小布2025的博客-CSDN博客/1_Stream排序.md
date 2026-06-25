# Stream排序

> 原创 于 2021-08-23 16:03:14 发布 · 公开 · 1.2k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/119871492

### List排序

```java
package com.xiaobu.sort;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/24 22:17
 * @description V1.0   sorted(Comparator.reverseOrder()) 逆序 默认是正序
 */
public class SortDemo1 {
    public static void main(String[] args) {
        sortAsc();
        sortDesc();


    }

    /**
     * @author xiaobu
     * @date 2019/6/24 22:31
     * @return void
     * @descprition 正序排列
     * @version 1.0
     */
    public static void sortAsc() {
        List<Integer> list = new ArrayList<>();
        list.add(50);
        list.add(45);
        list.add(25);
        list.add(98);
        list.add(32);
        List<Integer> collect = list.stream().sorted().collect(Collectors.toList());
        System.out.println("list<Integer>元素正序：" + collect);
    }

    /**
     * @author xiaobu
     * @date 2019/6/24 22:31
     * @return void
     * @descprition 逆序排列
     * @version 1.0
     */
    public static void sortDesc() {
        List<Integer> list = new ArrayList<>();
        list.add(50);
        list.add(45);
        list.add(25);
        list.add(98);
        list.add(32);
        List<Integer> collect = list.stream().sorted(Comparator.reverseOrder()).collect(Collectors.toList());
        System.out.println("list<Integer>元素逆序：" + collect);
    }


}

```

### set排序

```java
package com.xiaobu.streamDemo;

import java.util.Comparator;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Stream;

/**
 * The type Stream demo 3.
 *
 * @author tanhongwei
 * @version JDK1.8.0_301
 * @date on 2021/8/23 14:14
 * @description
 */
public class StreamDemo3 {

    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        setSortAsc();
        setSortDesc();
    }

    /**
     * Sets sort asc.
     */
    public static void setSortAsc() {
        Set<Integer> set = new HashSet<>();
        set.add(1);
        set.add(2);
        set.add(3);
        set.add(4);
        Stream<Integer> sortedAsc = set.stream().sorted();
        sortedAsc.forEach(System.out::println);
    }

    /**
     * Sets sort desc.
     */
    public static void setSortDesc() {
        Set<Integer> set = new HashSet<>();
        set.add(1);
        set.add(2);
        set.add(3);
        set.add(4);
        Stream<Integer> sortedDesc = set.stream().sorted(Comparator.reverseOrder());
        sortedDesc.forEach(System.out::println);
    }

}

```

### Array排序

```java
  /**
     * Arr sort asc.
     */
    public static void arrSortAsc() {
        int[] arr = {1, 2, 3, 4};
        IntStream arrSorted = Arrays.stream(arr).sorted();
        arrSorted.forEach(System.out::println);
    }

    /**
     * Gets max value in arr.
     */
    public static void getMaxValueInArr() {
        int[] arr = {1, 2, 3, 4};
        int max = Arrays.stream(arr).max().getAsInt();
        System.out.println("max = " + max);
    }
```

### 对象属性排序

```java
package com.xiaobu.streamDemo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * The type Stream demo 3.
 *
 * @author tanhongwei
 * @version JDK1.8.0_301
 * @date on 2021/8/23 14:14
 * @description
 */
public class PersonStreamSort {

    /**
     * The type Person.
     */
    @Data
    public static class Person {
        private String name;

        private BigDecimal salary;

        /**
         * Instantiates a new Person.
         */
        public Person() {
        }

        /**
         * Instantiates a new Person.
         *
         * @param name   the name
         * @param salary the salary
         */
        public Person(String name, BigDecimal salary) {
            this.name = name;
            this.salary = salary;
        }
    }

    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        Person p1 = new Person("张三", new BigDecimal("50.0"));
        Person p2 = new Person("王五", new BigDecimal("25.0"));
        Person p3 = new Person("李四", new BigDecimal("68.0"));
        Person p4 = new Person("李四", new BigDecimal("17.0"));
        Person p5 = new Person("张三", new BigDecimal("45.0"));
        List<Person> list = new ArrayList<>();
        list.add(p1);
        list.add(p2);
        list.add(p3);
        list.add(p4);
        list.add(p5);
        sortAsc(list);
        sortDesc(list);
    }

    /**
     * Sort asc.
     *
     * @param list the list
     */
    public static void sortAsc(List<Person> list) {
        List<Person> collect = list.stream().sorted(Comparator.comparing(Person::getSalary)).collect(Collectors.toList());
        System.out.println("元素的属性值正序：" + collect);
    }


    /**
     * Sort desc.
     *
     * @param list the list
     */
    public static void sortDesc(List<Person> list) {
        List<Person> collect = list.stream().sorted(Comparator.comparing(Person::getSalary).reversed()).collect(Collectors.toList());
        System.out.println("元素的属性值倒序：" + collect);
    }

}

```