# Spring Data JPA |自定义非实体类的映射

> 原创 于 2018-11-16 17:42:07 发布 · 公开 · 5.7k 阅读 · 1 · 5 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84142415

一、首先是实体类的定义：

```java
package com.example.entity;
 
import lombok.*;
 
import javax.persistence.*;
import java.io.Serializable;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/13 10:51
 * @description V1.0
 */
@Entity
@Table(name = "test_book")
@NoArgsConstructor
@Setter
@Getter
@ToString
public class Book implements Serializable {
    private static final long serialVersionUID = 6214167880862325845L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
 
    @Column(name="name",columnDefinition=("varchar(50)  default null comment '名称'"))
    private String name;
    @Column(name="author",columnDefinition=("varchar(252)  default null comment '作者'"))
    private String author;
 
 
}
```

二、自定义非实体类的定义：

```java
package com.example.entity.vo;
 
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
 
import java.io.Serializable;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/16 10:05
 * @description V1.0
 */
@Getter
@Setter
@ToString
public class BookVo implements Serializable {
    private static final long serialVersionUID = 294655766971777057L;
 
    public BookVo (String name, String author) {
        super();
        this.name = name;
        this.author = author;
    }
 
    private String name;
 
    private String author;
}
```

三、使用HQL方式查询：

```java
 List<BookVo> list = bookRepository.findByHql("select new com.example.entity.vo.BookVo (b.name,b.author) from Book b");
```

四、使用SQL方式查询（需要把结果通过反射转为对应的自定义的非实体类）

```java
       List<Object[]> list1 = bookRepository.findListBySql("select b.name,b.author from test_book b");
       for(Object[] objects:list1){
           System.out.println(Arrays.toString(objects));
       }
        List<BookVo> vos = EntityUtils.castEntity(list1,BookVo.class);
        System.out.println(vos);
```

五、EntityUtils工具类的内容如下：

```java
package com.example.util;
 
import lombok.extern.slf4j.Slf4j;
 
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/16 11:06
 * @description V1.0
 */
@Slf4j
public class EntityUtils {
 
    /**
     * 数组集合转化为指定对象集合
     * 指定的实体对象必须包含所以字段的构造方法，数组的元素的顺序将和构造方法顺序和类型一一对应
     *
     * @param list  集合
     * @param clazz c
     * @param <T>   类型
     * @return List<T>
     */
    public static <T> List<T> castEntity(List<Object[]> list, Class<T> clazz) {
        List<T> returnList = new ArrayList<>();
        if (list.size() == 0) {
            return returnList;
        }
        Class[] c2 = null;
        Constructor[] constructors = clazz.getConstructors();
        for (Constructor constructor : constructors) {
            Class[] tClass = constructor.getParameterTypes();
            if (tClass.length == list.get(0).length) {
                c2 = tClass;
                break;
            }
        }
        //构造方法实例化对象
        for (Object[] o : list) {
            Constructor<T> constructor = null;
            try {
                constructor = clazz.getConstructor(c2);
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            }
            try {
                assert constructor != null;
                returnList.add(constructor.newInstance(o));
            } catch (InstantiationException | IllegalAccessException | InvocationTargetException e) {
                e.printStackTrace();
            }
        }
 
        return returnList;
    }
}
 
```

---

六、查询的字段名须和实体的属性一一对应