# JavaBean对象转换EntityUtils工具类

> 原创 最新推荐文章于 2024-10-11 17:58:08 发布 · 公开 · 4.7k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84393164

```java
package com.example.util;

import com.alibaba.fastjson.JSON;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.springframework.beans.BeanUtils;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/16 11:06
 * @description V1.0 javabean 对象转换工具类
 */
public class EntityUtils {

    /**
     * 数组集合转化为指定对象集合
     * 指定的实体对象必须包含所以字段的构造方法，数组的元素的顺序将和构造方法顺序和类型一一对应
     * @param list  集合
     * @param clazz c
     * @param <T>   类型
     * @return List<T>
     * @description 用于jpa查询自定义vo用的
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



    /**
     * @author xiaobu
     * @date 2018/11/23 11:54
     * @param object 要强转的对象 , entityClass 强转后的类型
     * @return T
     * @descprition   对象类型强转
     * @version 1.0
     */
    public static <T> T convertBean(Object object, Class<T> entityClass) {
        if(null == object) {
            return null;
        }
        return JSON.parseObject(JSON.toJSONString(object), entityClass);
    }




    /**
     * @author xiaobu
     * @date 2018/11/23 11:57
     * @param object 要转话的对象
     * @return java.util.Map<?,?>
     * @descprition   对象转为map
     * @version 1.0
     */
    public static Map<?, ?> objectToMap(Object object){
        return convertBean(object, Map.class);
    }



    /**
     * @author xiaobu
     * @date 2018/11/23 12:00
     * @param map map集合, t 对象
     * @return T
     * @descprition   map转换对象
     * @version 1.0
     */
    public static <T> T mapToObject(Map<String, Object> map, Class<T> t) throws InstantiationException, IllegalAccessException, InvocationTargetException {
        T instance = t.newInstance();
        org.apache.commons.beanutils.BeanUtils.populate(instance, map);
        return instance;
    }





    /**
     * @author xiaobu
     * @date 2018/11/23 12:30
     * @param source 资源对象, target 目标对象, ignoreProperties 赋值new String[]{}
     * @return T  target对象
     * @descprition   对象转换
     * @version 1.0
     */
    public static <T> T copy(Object source, Class<T> target, String...ignoreProperties){
        T targetInstance = null;
        try {
            targetInstance = target.newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        if(ArrayUtils.isEmpty(ignoreProperties)) {
            assert targetInstance != null;
            BeanUtils.copyProperties(source, targetInstance);
        }else {
            assert targetInstance != null;
            BeanUtils.copyProperties(source, targetInstance, ignoreProperties);
        }
        return targetInstance;

    }



    /**
     * @author xiaobu
     * @date 2018/11/23 12:32
     * @param list, target, ignoreProperties]
     * @return java.util.List<T>
     * @descprition   对象list转换
     * @version 1.0
     */
    public static <T, E> List<T> copyList(List<E> list, Class<T> target, String...ignoreProperties){
        List<T> targetList = new ArrayList<>();
        if(CollectionUtils.isEmpty(list)) {
            return targetList;
        }
        for(E e : list) {
            targetList.add(copy(e, target, ignoreProperties));
        }
        return targetList;
    }


}

```