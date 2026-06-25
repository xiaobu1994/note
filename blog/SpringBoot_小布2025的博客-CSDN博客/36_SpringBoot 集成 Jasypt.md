# SpringBoot 集成 Jasypt

> 原创 于 2021-09-16 11:28:25 发布 · 公开 · 470 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120325598

Pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.xiaobu</groupId>
        <artifactId>SpringBoot-Learn</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <groupId>com.xiaobu</groupId>
    <artifactId>Jasypt_demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>Jasypt_demo</name>
    <description>Jasypt_demo</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <!-- mybatis-plus-->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.4.2</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.ulisesbocchio</groupId>
            <artifactId>jasypt-spring-boot-starter</artifactId>
            <version>3.0.3</version>
        </dependency>
        <!-- 实现对 Spring MVC 的自动化配置 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
        </dependency>
        <!-- lomback -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.16.10</version>
        </dependency>
        <!-- 实现对 Spring MVC 的自动化配置 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
    <build>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
        </resources>
        <finalName>Jasypt_demo</finalName>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

application.properties

```properties
#数据库相关配置
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/master?useSSL=false&useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&serverTimezone=GMT%2b8
#开发的时候把密钥放在dev里面 部署的时候用命令部署 注释 盐  jasypt.encryptor.password=jasypt
#spring.profiles.active=dev
```

application-dev.properties

```properties
#数据库相关配置
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/master?useSSL=false&useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&serverTimezone=GMT%2b8
#开发需要把这个注释取消，部署的话用命令去部署把这个注释
jasypt.encryptor.password=jasypt
# 默认加密方式PBEWithMD5AndDES,可以更改为PBEWithMD5AndTripleDES
jasypt.encryptor.algorithm=PBEWithMD5AndDES
jasypt.encryptor.iv-generator-classname=org.jasypt.iv.NoIvGenerator
spring.datasource.username=ENC(4Lw58IJx6tzBNkPN7bzqMQ==)
spring.datasource.password=ENC(WISJ8j9K9WDd8O5dyAjYQA==)
my-password=ENC(WISJ8j9K9WDd8O5dyAjYQA==)
str=123
```

application-prod.properties

```properties
#打包 输入加密所需的salt(盐)
#run maven执行
#clean package -Djasypt.encryptor.password=jasypt
# 命令行执行
# mvn clean package "-Djasypt.encryptor.password=jasypt"
#部署 输入加密所需的salt(盐)
#java -jar "-Djasypt.encryptor.password=jasypt" Jasypt_demo.jar --spring.profiles.active=prod
# 加密所需的salt(盐)
#jasypt.encryptor.password=jasypt
# 默认加密方式PBEWithMD5AndDES,可以更改为PBEWithMD5AndTripleDES
#开发需要把这个注释取消，部署的话用命令去部署把这个注释
#jasypt.encryptor.password=jasypt
#数据库相关配置
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/master?useSSL=false&useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&serverTimezone=GMT%2b8
jasypt.encryptor.algorithm=PBEWithMD5AndDES
jasypt.encryptor.iv-generator-classname=org.jasypt.iv.NoIvGenerator
spring.datasource.username=ENC(4Lw58IJx6tzBNkPN7bzqMQ==)
spring.datasource.password=ENC(WISJ8j9K9WDd8O5dyAjYQA==)
my-password=ENC(WISJ8j9K9WDd8O5dyAjYQA==)
str=666
```

启动类

```java
package com.xiaobu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author 小布
 */
@SpringBootApplication
public class JasyptDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(JasyptDemoApplication.class, args);
    }

}

```

Order

```java
package com.xiaobu.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @className Order.java
 * @author 小布
 * @version 1.0.0
 * @createTime 2021年09月15日 15:19:00
 */

/**
 * 测试分表
 */
@Data
@TableName(value = "master.t_order")
public class Order implements Serializable {
    private static final long serialVersionUID = 4092312802808793209L;
    @TableId(value = "id", type = IdType.AUTO)
    private String id;

    /**
     * 名称
     */
    @TableField(value = "`name`")
    private String name;

    /**
     * 停车场id
     */
    @TableField(value = "car_park_id")
    private String carParkId;

    /**
     * 订单号
     */
    @TableField(value = "`no`")
    private String no;

    /**
     * 创建时间
     */
    @TableField(value = "create_time")
    private Date createTime;

}
```

OrderMapper

```java
package com.xiaobu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaobu.entity.Order;
import org.apache.ibatis.annotations.Mapper;

/**
 * @author 小布
 * @version 1.0.0
 * @className OrderMapper.java
 * @createTime 2021年09月15日 15:19:00
 */
@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
```

OrderMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaobu.mapper.OrderMapper">
    <resultMap id="BaseResultMap" type="com.xiaobu.entity.Order">
        <!--@mbg.generated-->
        <!--@Table master.t_order-->
        <id column="id" jdbcType="VARCHAR" property="id"/>
        <result column="name" jdbcType="VARCHAR" property="name"/>
        <result column="car_park_id" jdbcType="VARCHAR" property="carParkId"/>
        <result column="no" jdbcType="VARCHAR" property="no"/>
        <result column="create_time" jdbcType="TIMESTAMP" property="createTime"/>
    </resultMap>
    <sql id="Base_Column_List">
        <!--@mbg.generated-->
        id, `name`, car_park_id, `no`, create_time
    </sql>
</mapper>
```

IndexController

```java
package com.xiaobu.controller;

import com.xiaobu.entity.Order;
import com.xiaobu.mapper.OrderMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * @author 小布
 * @version 1.0.0
 * @className IndexController.java
 * @createTime 2021年09月15日 16:52:00
 */
@RestController
public class IndexController {
    @Autowired
    private OrderMapper orderMapper;
    @Value("${str}")
    private String str;

    @GetMapping("list")
    public String list() {
        List<Order> orders = orderMapper.selectList(null);
        return orders.toString();
    }

    @GetMapping("str")
    public String str() {
        return str;
    }
}

```

用IdeaHttp Client 测试

http://localhost:8080/list
结果如下：

```properties
GET http://localhost:8080/list

HTTP/1.1 200 
Content-Type: text/plain;charset=UTF-8
Content-Length: 81
Date: Thu, 16 Sep 2021 02:56:03 GMT
Keep-Alive: timeout=60
Connection: keep-alive

[Order(id=1, name=1, carParkId=1, no=1, createTime=Thu Aug 26 08:59:47 CST 2021)]

Response code: 200; Time: 346ms; Content length: 81 bytes

```

参考:
[SpringBoot 集成 Jasypt 对数据库加密以及踩坑](https://linjinp.blog.csdn.net/article/details/107563064) 