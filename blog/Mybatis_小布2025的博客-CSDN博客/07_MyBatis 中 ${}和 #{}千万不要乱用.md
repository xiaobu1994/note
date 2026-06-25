# MyBatis 中 ${}和 #{}千万不要乱用

> 原创 于 2019-07-26 12:42:15 发布 · 公开 · 3.3w 阅读 · 8 · 35 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/97380767

> 1、#{}是预编译处理，MyBatis在处理#{ }时，它会将sql中的#{ }替换为？，然后调用PreparedStatement的set方法来赋值，传入字符串后，会在值两边加上单引号，如上面的值 “4,44,514”就会变成“ ‘4,44,514’ ”；

> 2、 ${}是字符串替换，在处理{ }是字符串替换， MyBatis在处理{ }时,它会将sql中的$ { }替换为变量的值，传入的数据不会加两边加上单引号。

> 注意：使用${ }会导致sql注入，不利于系统的安全性！SQL注入：就是通过把SQL命令插入到Web表单提交或输入域名或页面请求的查询字符串，最终达到欺骗服务器执行恶意的SQL命令。常见的有匿名登录（在登录框输入恶意的字符串）、借助异常获取数据库信息等

```java
package com.xiaobu.mapper;

import com.xiaobu.base.mapper.MyMapper;
import com.xiaobu.entity.Country;

import java.util.List;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/27 19:21
 * @description V1.0
 */
public interface CountryMapper extends MyMapper<Country> {
    /**
     * 功能描述:通过#{}来进行查询
     *
     * @param ids id
     * @return java.util.List<com.xiaobu.entity.Country>
     * @author xiaobu
     * @date 2019/7/26 11:53
     * @version 1.0
     */
    List<Country> findList(String ids);

    /**
     * 功能描述:通过${}来进行查询
     *
     * @param ids id
     * @return java.util.List<com.xiaobu.entity.Country>
     * @author xiaobu
     * @date 2019/7/26 11:53
     * @version 1.0
     */
    List<Country> findList2(String ids);

    /**
     * 功能描述: 通过foreach来进行查询
     *
     * @param ids id
     * @return java.util.List<com.xiaobu.entity.Country>
     * @author xiaobu
     * @date 2019/7/26 11:53
     * @version 1.0
     */
    List<Country> findListByForEach(List<Integer> ids);
}

```

```xml
<?xml version="1.0" encoding="UTF-8" ?>


<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.xiaobu.mapper.CountryMapper">


    <select id="findList" resultType="com.xiaobu.entity.Country">
        select * from country where id in (#{ids} )
    </select>


    <select id="findList2" resultType="com.xiaobu.entity.Country">
        select * from country where id in (${ids} )
    </select>
    
    <select id="findListByForEach"  parameterType="List" resultType="com.xiaobu.entity.Country">
        select * from country where id in
        <foreach collection="list" index="index" item="item" open="(" separator="," close=")">
            #{item}
        </foreach>
    </select>
</mapper>
```

```java
 @Test
    public void  countTotal(){
        //统计总数 SELECT COUNT(Id) FROM country
        Example example = new Example(City.class);
        int count =countryMapper.selectCountByExample(example);
        System.out.println("count = " + count);

        //按条件查询  SELECT COUNT(Id) FROM country
        Country country = new Country();
        //country.setCountryname("1234");
        int conunt2 = countryMapper.selectCount(country);
        System.out.println("conunt2 = " + conunt2);
    }





    @Test
    public void  findList(){
        //Preparing: select * from country where id in ( '1,2,3')
        List<Country> countries = countryMapper.findList("1,2,3");
        //countries = [Country(countryname=Angola, countrycode=AO)]
        System.out.println("countries = " + countries);
        //报错   There is no getter for property named 'ids' in 'class java.lang.String
        List<Country> countries2 = countryMapper.findList2("1,2,3");
        System.out.println("countries2 = " + countries2);
    }



    @Test
    public void  findListByForeach(){
        //Preparing: select * from country where id in ( ? , ? , ? )
        //Parameters: 1(Integer), 2(Integer), 3(Integer)
        List<Integer> list = new ArrayList<>(3);
        list.add(1);
        list.add(2);
        list.add(3);
        List<Country> countries2 = countryMapper.findListByForEach(list);
        System.out.println("countries2 = " + countries2);
    }
```

> foreach 说明

1. item表示集合中每一个元素进行迭代时的别名，

2. index指 定一个名字，用于表示在迭代过程中，每次迭代到的位置，

3. open表示该语句以什么开始，

4. separator表示在每次进行迭代之间以什么符号作为分隔符，

5. close表示以什么结束。

6. collection指参数类型

