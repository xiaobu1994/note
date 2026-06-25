# Spring的BeanUtils的copyProperties方法使用注意事项

> 原创 最新推荐文章于 2024-07-17 03:28:53 发布 · 公开 · 2k 阅读 · 2 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/102388870

```java
package com.demo;

import lombok.Data;
import org.springframework.beans.BeanUtils;

import java.util.Arrays;
import java.util.List;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/10/8 10:04
 * @description
 */
public class BeanUtilsTest {


    @Data
    private static class CopyTest1 {

        private String outerName;

        private CopyTest1.InnerClass innerClass;

        private List clazz;


        @Data
        private static class InnerClass {

            public String innerName;
        }

    }


    @Data
    private static class CopyTest2 {

        private String outerName;

        private CopyTest2.InnerClass innerClass;

        private List clazz;


        @Data
        static class InnerClass {

            private String innerName;
        }

    }

    public static void main(String[] args) {
        CopyTest1 copyTest1 = new CopyTest1();
        copyTest1.outerName = "outer xiaobu";
        CopyTest1.InnerClass innerClass = new CopyTest1.InnerClass();
        innerClass.innerName = "inner xiaobu";
        copyTest1.innerClass = innerClass;
        copyTest1.clazz = Arrays.asList(1, 2, 3);
        System.out.println("copyTest1 = " + copyTest1);
        CopyTest2 copyTest2 = new CopyTest2();
        //未copy内部类的属性
        BeanUtils.copyProperties(copyTest1, copyTest2);
        System.out.println("copy内部类的属性前copyTest2 = " + copyTest2);
        CopyTest2.InnerClass innerClass2 = new CopyTest2.InnerClass();
        copyTest2.innerClass = innerClass2;
        BeanUtils.copyProperties(innerClass, innerClass2);
        System.out.println("copy内部类的属性后copyTest2 = " + copyTest2);

    }

}

```

总结

1. Spring的BeanUtils的CopyProperties方法需要对应的属性有getter和setter方法；

2. 如果存在属性完全相同的内部类，但是不是同一个内部类，即分别属于各自的内部类，则spring会认为属性不同，不会copy；

3. 泛型只在编译期起作用，不能依靠泛型来做运行期的限制；

4. 最后，spring和apache的copy属性的方法源和目的参数的位置正好相反，所以导包和调用的时候都要注意一下。

> 泛型只在编译期起作用，不能依靠泛型来做运行期的限制

```java
package com.demo;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/10/8 14:54
 * @description
 */
public class Demo {
    public static void main(String[] args) throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {
        ArrayList<Integer> list = new ArrayList<Integer>();
        list.add(111);
        list.add(222);
        list.add("xiaobu");  //编译器报错
        Class clazz3 = Class.forName("java.util.ArrayList");//获取ArrayList的字节码文件
        Method m = clazz3.getMethod("add", Object.class);//获取add() 方法，Object.class 代表任意对象类型的数据
        m.invoke(list,"xiaobu");//通过反射添加字符串类型元素数据
        System.out.println(list);//运行结果：[111, 222, xiaobu]
    }
}

```