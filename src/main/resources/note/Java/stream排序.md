​
一、 基础类型排序

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
     * @descprition  正序排列
     * @version 1.0
     */
    public static void sortAsc(){
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
     * @descprition  逆序排列
     * @version 1.0
     */
    public static void sortDesc(){
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


二、根据某个属性排序

```java
package com.xiaobu.sort;

import lombok.Data;

import java.math.BigDecimal;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/24 22:03
 * @description V1.0
 */
@Data
public class Person {
    private String name;

    private BigDecimal salary;

    public Person(){}

    public Person(String name,BigDecimal salary){
        this. name = name;
        this.salary =salary;
    }
}

```
```java
package com.xiaobu.sort;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/24 22:02
 * @description V1.0  Comparator.comparing()根据属性排序
 */
public class SortDemo {
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
     * @author xiaobu
     * @date 2019/6/24 22:46
     * @param list List<Person>
     * @return void
     * @descprition
     * @version 1.0
     */
    public static void  sortAsc(List<Person> list){
        List<Person> collect = list.stream().sorted(Comparator.comparing(Person::getSalary).reversed()).collect(Collectors.toList());
        System.out.println("元素的属性值倒序："+collect);
    }


    /**
     * @author xiaobu
     * @date 2019/6/24 22:46
     * @param list List<Person>
     * @return void
     * @descprition
     * @version 1.0
     */
    public static void sortDesc(List<Person> list){
     List<Person> collect=list.stream().sorted(Comparator.comparing(Person::getSalary)).collect(Collectors.toList());
        System.out.println("元素的属性值倒序："+collect);
    }
}
```

三、分组排序

```java
package com.xiaobu.demo;

import lombok.Data;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/6/23 21:25
 * @description
 */
@Data
public class Person {
    private String name;

    private Integer age;
}

```

```java
package com.xiaobu.demo;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/6/22 20:53
 * @description
 */
public class Demo1 {
    public static void main(String[] args) {
        testInteger();
        testString();
        test2();
        groupByTest();
    }

    public static void testInteger() {
        List<Map<String, Integer>> list = new ArrayList<>();
        Map<String, Integer> map1 = new HashMap<>(16);
        map1.put("id", 1);
        map1.put("age", 1);
        Map<String, Integer> map2 = new HashMap<>(16);
        map2.put("id", 1);
        map2.put("age", 1);
        Map<String, Integer> map3 = new HashMap<>(16);
        map3.put("id", 2);
        map3.put("age", 1);
        list.add(map1);
        list.add(map2);
        list.add(map3);
        LinkedHashMap<Integer, List<Map<String, Integer>>> integerMap = list.stream()
                .sorted(Comparator.comparingInt(map -> (Integer) map.get("id")))
                .collect(Collectors.groupingBy(map -> (Integer) map.get("id"), LinkedHashMap::new, Collectors.toList()));
        //正常输出
        System.out.println("integerMap = " + integerMap);
    }

    public static void testString() {
        List<Map<String, String>> list = new ArrayList<>();
        Map<String, String> map1 = new HashMap<>(16);
        map1.put("id", "1");
        map1.put("age", "1");
        Map<String, String> map2 = new HashMap<>(16);
        map2.put("id", "1");
        map2.put("age", "1");
        Map<String, String> map3 = new HashMap<>(16);
        map3.put("id", "2");
        map3.put("age", "1");
        list.add(map1);
        list.add(map2);
        list.add(map3);
        LinkedHashMap<String, List<Map<String, String>>> stringMap = list.stream()
                .sorted(Comparator.comparing(map -> map.get("id")))
                .collect(Collectors.groupingBy(map -> map.get("id"), LinkedHashMap::new, Collectors.toList()));
        //正常输出
        System.out.println("stringMap = " + stringMap);
    }

    public static void test2() {
        List<Map<String, Object>> dataList = new ArrayList<>();
        Map<String, Object> map1 = new HashMap<>(16);
        map1.put("id", "1");
        map1.put("name", "1");
        Map<String, Object> map2 = new HashMap<>(16);
        map2.put("id", "1");
        map2.put("name", "2");
        Map<String, Object> map3 = new HashMap<>(16);
        map3.put("id", "2");
        map3.put("name", "3");
        dataList.add(map1);
        dataList.add(map2);
        dataList.add(map3);
        Map<String, List<Map<String, Object>>> listLinkedHashMap = new LinkedHashMap<>();
        Map<String, List<Map<String, Object>>> temp = dataList.stream().collect(Collectors.groupingBy(map -> (String) map.get("id")));
        temp.entrySet().stream().sorted(Map.Entry.comparingByKey()).forEachOrdered(e -> listLinkedHashMap.put(e.getKey(), e.getValue()));
        System.out.println("listLinkedHashMap = " + listLinkedHashMap);
        //comparingInt和comparing 会报错 要明确的指定类型  Exception in thread "main" java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer
        LinkedHashMap<Integer, List<Map<String, Object>>> ageMap = dataList.stream()
                .sorted(Comparator.comparingInt(map -> (Integer) map.get("id")))
                .collect(Collectors.groupingBy(map -> (Integer) map.get("id"), LinkedHashMap::new, Collectors.toList()));
        System.out.println("ageMap = " + ageMap);
    }

    /**
     * 分组
     */
    private static void groupByTest() {
        List<Person> persons = new ArrayList<>();
        for (int i = 1; i <= 40; i++) {
            Random r = new Random();
            Person person = new Person();
            person.setName("abel-" + i);
            person.setAge(25 + r.nextInt(50));
            persons.add(person);
        }
        //将list 排序，并按照排序后的结果进行有序分组 不会报错
        LinkedHashMap<Integer, List<Person>> ageMap = persons.stream().sorted(Comparator.comparingInt(Person::getAge)).collect(Collectors.groupingBy(Person::getAge, LinkedHashMap::new, Collectors.toList()));
        System.out.println("ageMap = " + ageMap);
    }
}
```