# EntityUtils

> 原创 最新推荐文章于 2024-10-11 17:58:08 发布 · 公开 · 718 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/124674729

#### pom.xml

```xml
<!-- https://mvnrepository.com/artifact/org.apache.commons/commons-lang3 -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.9</version>
</dependency>


```

#### 工具类

```java
package com.xiaobu.util;


import cn.hutool.json.JSONUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Constructor;
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
 * @description V1.0 javabean 对象转换工具类
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
     * @param object 要强转的对象 , entityClass 强转后的类型
     * @return T
     * @author xiaobu
     * @date 2018/11/23 11:54
     * @descprition 对象类型强转
     */
    public static <T> T convertBean(Object object, Class<T> entityClass) {
        if (null == object) {
            return null;
        }
        String jsonStr = JSONUtil.toJsonStr(object);
        return JSONUtil.toBean(jsonStr, entityClass);
    }


    /**
     * @param object 要转话的对象
     * @return java.util.Map<?, ?>
     * @author xiaobu
     * @date 2018/11/23 11:57
     * @descprition 对象转为map
     */
    public static Map<?, ?> objectToMap(Object object) {
        return convertBean(object, Map.class);
    }


    /**
     * @param map map集合, t 对象
     * @return T
     * @author xiaobu
     * @date 2018/11/23 12:00
     * @descprition map转换对象
     */
    public static <T> T mapToBean(Map<String, Object> map, Class<T> t) throws InstantiationException, IllegalAccessException, InvocationTargetException {
        T instance = t.newInstance();
        org.apache.commons.beanutils.BeanUtils.populate(instance, map);
        return instance;
    }


    /**
     * 功能描述: Bean --> Map 1: 利用Introspector和PropertyDescriptor 将Bean --> Map
     *
     * @param obj Object
     * @return java.util.Map<java.lang.String, java.lang.String>
     * @author xiaobu
     * @date 2019/6/10 11:11
     */
    public static Map<String, String> transBean2Map(Object obj) {
        if (obj == null) {
            return null;
        }
        Map<String, String> map = new HashMap<>();
        try {
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                String key = property.getName();
                // 过滤class属性
                if (!"class".equals(key)) {
                    // 得到property对应的getter方法
                    Method getter = property.getReadMethod();
                    Object value = getter.invoke(obj);
                    map.put(key, value.toString());
                }

            }
        } catch (Exception e) {
            System.out.println("transBean2Map Error " + e);
        }

        return map;

    }

    /**
     * 将 Map对象转化为JavaBean
     *
     * @param map
     * @return Object对象
     * @author loulan
     */
    public static <T> T convertMap2Bean(Map map, Class T) throws Exception {
        if (map == null || map.size() == 0) {
            return null;
        }
        BeanInfo beanInfo = Introspector.getBeanInfo(T);
        T bean = (T) T.newInstance();
        PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
        for (int i = 0, n = propertyDescriptors.length; i < n; i++) {
            PropertyDescriptor descriptor = propertyDescriptors[i];
            String propertyName = descriptor.getName();
            //将字母大写，这里先注掉，因为本例子直接读取名字匹配即可。
            //String upperPropertyName = propertyName.toUpperCase();
            if (map.containsKey(propertyName)) {
                Object value = map.get(propertyName);
                //这个方法不会报参数类型不匹配的错误。
                BeanUtils.copyProperty(bean, propertyName, value);
//用这个方法对int等类型会报参数类型不匹配错误，需要我们手动判断类型进行转换，比较麻烦。
//descriptor.getWriteMethod().invoke(bean, value);
//用这个方法对时间等类型会报参数类型不匹配错误，也需要我们手动判断类型进行转换，比较麻烦。
//BeanUtils.setProperty(bean, propertyName, value);
            }
        }
        return bean;
    }

    /**
     * 将 JavaBean对象转化为 Map
     *
     * @param bean 要转化的类型
     * @return Map对象
     * @author loulan
     */
    public static Map convertBean2Map(Object bean) throws Exception {
        Class type = bean.getClass();
        Map returnMap = new HashMap();
        BeanInfo beanInfo = Introspector.getBeanInfo(type);
        //PropertyDescriptor:属性描述器
        PropertyDescriptor[] propertyDescriptors = beanInfo
                .getPropertyDescriptors();
        for (int i = 0, n = propertyDescriptors.length; i < n; i++) {
            PropertyDescriptor descriptor = propertyDescriptors[i];
            String propertyName = descriptor.getName();
            if (!propertyName.equals("class")) {
                Method readMethod = descriptor.getReadMethod();
                //利用反射
                Object result = readMethod.invoke(bean);
                if (result != null) {
                    returnMap.put(propertyName, result);
                } else {
                    returnMap.put(propertyName, "");
                }
            }
        }
        return returnMap;
    }

    /**
     * 将 List<Map>对象转化为List<JavaBean>
     *
     * @return Object对象
     * @author loulan
     */
    public static <T> List<T> convertListMap2ListBean(List<Map<String, Object>> listMap, Class T) throws Exception {
        List<T> beanList = new ArrayList<T>();
        for (Map<String, Object> map : listMap) {
            T bean = convertMap2Bean(map, T);
            beanList.add(bean);
        }
        return beanList;
    }

    /**
     * 将 List<JavaBean>对象转化为List<Map>
     *
     * @return Object对象
     * @author loulan
     */
    public static List<Map<String, Object>> convertListBean2ListMap(List<Object> beanList) throws Exception {
        List<Map<String, Object>> mapList = new ArrayList<>();
        for (Object bean : beanList) {
            Map map = convertBean2Map(bean);
            mapList.add(map);
        }
        return mapList;
    }
}


```