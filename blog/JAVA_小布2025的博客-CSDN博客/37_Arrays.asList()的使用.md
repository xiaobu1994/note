# Arrays.asList()的使用

> 原创 最新推荐文章于 2025-05-09 15:16:47 发布 · 公开 · 974 阅读 · 2 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/94553713

> 
> 
> 1. Arrays.asList()将数组转换为集合后,底层其实还是数组，它返回的是Arrays的一个内部类，体现了适配器模式。
> 
> 2. 传递的数组必须是对象数组，而不是基本类型。
> 
> 3. 当传入一个原生数据类型数组时，Arrays.asList() 的真正得到的参数就不是数组中的元素，而是数组对象本身！此时List 的唯一元素就是这个数组。
> 
> 4. 使用集合的修改方法:add()、remove()、clear()会抛出UnsupportedOperationException异常。
> 
> 

```java
package com.xiaobu.learn.array;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/7/3 10:14
 * @description
 *
 */
public class ArrayDemo1 {
    public static void main(String[] args) {
        //test();
        testAddAndRemove();
        //newalist();
    }


    /**
     * 功能描述: 传递的数组必须是对象数组，而不是基本类型。
     * 当传入一个原生数据类型数组时，Arrays.asList() 的真正得到的参数就不是数组中的元素，
     * 而是数组对象本身！此时List 的唯一元素就是这个数组，这也就解释了上面的代码。
     * @author xiaobu
     * @date 2019/7/3 10:22
     * @return void
     * @version 1.0
     */
    public static void test(){
        int[] myArray = {1,2,3};
        List list = Arrays.asList(myArray);
        System.out.println("list.size() = " + list.size());
        System.out.println("list.get(0) = " + list.get(0));
        int[] array = (int[]) list.get(0);
        System.out.println("array[0] = " + array[0]);
        //ArrayIndexOutOfBoundsException
        System.out.println("list.get(1) = " + list.get(1));
    }

    /**
     * 功能描述:Arrays.asList(myArray) 其底层还是数组不能调用add remove以及clear等方法
     * @author xiaobu
     * @date 2019/7/3 10:30
     * @return void
     * @version 1.0
     */
    public static void testAddAndRemove(){
        int[] myArray = {1,2,3};
        List list = Arrays.asList(myArray);
        //UnsupportedOperationException
        list.add(4);
        //UnsupportedOperationException
        list.remove(1);
        System.out.println("list = " + list);
    }



    /**
     * 功能描述:当传入一个原生数据类型数组时，Arrays.asList() 的真正得到的参数
     *  就不是数组中的元素，而是数组对象本身！
     * @author xiaobu
     * @date 2019/7/3 10:38
     * @return void
     * @version 1.0
     */
    public  static void newalist(){
        int[] myArray = {1,2,3};
        List list = new ArrayList<>(Arrays.asList(myArray));
        System.out.println("list = " + list);
        //add 之后list大小为2
        list.add(4);
        System.out.println("list = " + list);
        //报错 IndexOutOfBoundsException
        list.remove(2);
        System.out.println("list = " + list);
        list.clear();
        System.out.println("list = " + list);
    }
}

```

### 手动创建list

1. 最简易的方法

```java
        List list2 = new ArrayList<>(Arrays.asList(1,2,3));
```

1. 使用java8 stream创建

```java
        Integer [] myArray = { 1, 2, 3 };
        List list = Arrays.stream(myArray).collect(Collectors.toList());
        System.out.println("list = " + list);
       //基本类型也可以实现转换（依赖boxed的装箱操作）
       int [] myArray2 = { 1, 2, 3 };
       List myList = Arrays.stream(myArray2).boxed().collect(Collectors.toList());
      System.out.println("myList = " + myList);
```