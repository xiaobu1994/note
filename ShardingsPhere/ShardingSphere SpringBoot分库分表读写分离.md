pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.5.4</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.xiaobu</groupId>
    <artifactId>shardingjdbc_demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>shardingjdbc_demo</name>
    <description>shardingjdbc_demo</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.4.2</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!-- 阿里druid数据库连接池 -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.1.17</version>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.8</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.2.6</version>
        </dependency>
        <!--for springboot-->
        <dependency>
            <groupId>org.apache.shardingsphere</groupId>
            <artifactId>sharding-jdbc-spring-boot-starter</artifactId>
            <version>4.1.1</version>
        </dependency>
        <!--namespace-->
        <dependency>
            <groupId>org.apache.shardingsphere</groupId>
            <artifactId>sharding-jdbc-spring-namespace</artifactId>
            <version>4.1.1</version>
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
spring.profiles.active=hikari
#spring.profiles.active=druid
```

application-hikari.properties

```properties
#当出现相同名字的类进行注册时，准许覆盖注册
spring.main.allow-bean-definition-overriding=true

# 分库分表 读写分离
server.port=8099
#打印sql
spring.shardingsphere.props.sql.show=true

spring.shardingsphere.datasource.names=master,master0,slave0,master1,slave1

# 需要指定类型不然报 NPE
spring.shardingsphere.datasource.master.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.master.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master.jdbc-url=jdbc:mysql://localhost:3306/master?characterEncoding=utf-8
spring.shardingsphere.datasource.master.username=root
spring.shardingsphere.datasource.master.password=root

# 需要指定类型不然报 NPE
spring.shardingsphere.datasource.master0.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.master0.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master0.jdbc-url=jdbc:mysql://localhost:3306/master0?characterEncoding=utf-8
spring.shardingsphere.datasource.master0.username=root
spring.shardingsphere.datasource.master0.password=root

spring.shardingsphere.datasource.slave0.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.slave0.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.slave0.jdbc-url=jdbc:mysql://localhost:3306/slave0?characterEncoding=utf-8
spring.shardingsphere.datasource.slave0.username=root
spring.shardingsphere.datasource.slave0.password=root

spring.shardingsphere.datasource.master1.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.master1.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master1.jdbc-url=jdbc:mysql://localhost:3306/master1?characterEncoding=utf-8
spring.shardingsphere.datasource.master1.username=root
spring.shardingsphere.datasource.master1.password=root

spring.shardingsphere.datasource.slave1.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.slave1.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.slave1.jdbc-url=jdbc:mysql://localhost:3306/slave1?characterEncoding=utf-8
spring.shardingsphere.datasource.slave1.username=root
spring.shardingsphere.datasource.slave1.password=root

#根据年龄分库
spring.shardingsphere.sharding.default-database-strategy.inline.sharding-column=age
spring.shardingsphere.sharding.default-database-strategy.inline.algorithm-expression=master$->{age % 2}
#根据id分表
spring.shardingsphere.sharding.tables.user.actual-data-nodes=master$->{0..1}.user$->{0..1}
spring.shardingsphere.sharding.tables.user.table-strategy.inline.sharding-column=id
spring.shardingsphere.sharding.tables.user.table-strategy.inline.algorithm-expression=user$->{id % 2}

#指定master0为主库，slave0为它的从库
spring.shardingsphere.sharding.master-slave-rules.master0.master-data-source-name=master0
spring.shardingsphere.sharding.master-slave-rules.master0.slave-data-source-names=slave0
#指定master1为主库，slave1为它的从库
spring.shardingsphere.sharding.master-slave-rules.master1.master-data-source-name=master1
spring.shardingsphere.sharding.master-slave-rules.master1.slave-data-source-names=slave1

# mybatis-plus
mybatis-plus.mapper-locations=classpath:/mapper/*.xml
logging.level.com.xiaobu.mapper=debug
mybatis-plus.type-aliases-package=com.xiaobu.entity
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl


```
application-druid.properties

```properties
#当出现相同名字的类进行注册时，准许覆盖注册
spring.main.allow-bean-definition-overriding=true

# 分库分表 读写分离
server.port=8099
#打印sql
spring.shardingsphere.props.sql.show=true

spring.shardingsphere.datasource.names=master,master0,slave0,master1,slave1


# 需要指定类型不然报 NPE
spring.shardingsphere.datasource.master.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.master.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master.url=jdbc:mysql://localhost:3306/master?characterEncoding=utf-8
spring.shardingsphere.datasource.master.username=root
spring.shardingsphere.datasource.master.password=root

# 需要指定类型不然报 NPE
spring.shardingsphere.datasource.master0.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.master0.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master0.url=jdbc:mysql://localhost:3306/master0?characterEncoding=utf-8
spring.shardingsphere.datasource.master0.username=root
spring.shardingsphere.datasource.master0.password=root

spring.shardingsphere.datasource.slave0.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.slave0.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.slave0.url=jdbc:mysql://localhost:3306/slave0?characterEncoding=utf-8
spring.shardingsphere.datasource.slave0.username=root
spring.shardingsphere.datasource.slave0.password=root

spring.shardingsphere.datasource.master1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.master1.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.master1.url=jdbc:mysql://localhost:3306/master1?characterEncoding=utf-8
spring.shardingsphere.datasource.master1.username=root
spring.shardingsphere.datasource.master1.password=root

spring.shardingsphere.datasource.slave1.type=com.alibaba.druid.pool.DruidDataSource
spring.shardingsphere.datasource.slave1.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.slave1.url=jdbc:mysql://localhost:3306/slave1?characterEncoding=utf-8
spring.shardingsphere.datasource.slave1.username=root
spring.shardingsphere.datasource.slave1.password=root

#根据年龄分库
spring.shardingsphere.sharding.default-database-strategy.inline.sharding-column=age
spring.shardingsphere.sharding.default-database-strategy.inline.algorithm-expression=master$->{age % 2}
#根据id分表
spring.shardingsphere.sharding.tables.user.actual-data-nodes=master$->{0..1}.user$->{0..1}
spring.shardingsphere.sharding.tables.user.table-strategy.inline.sharding-column=id
spring.shardingsphere.sharding.tables.user.table-strategy.inline.algorithm-expression=user$->{id % 2}

#指定master0为主库，slave0为它的从库
spring.shardingsphere.sharding.master-slave-rules.master0.master-data-source-name=master0
spring.shardingsphere.sharding.master-slave-rules.master0.slave-data-source-names=slave0
#指定master1为主库，slave1为它的从库
spring.shardingsphere.sharding.master-slave-rules.master1.master-data-source-name=master1
spring.shardingsphere.sharding.master-slave-rules.master1.slave-data-source-names=slave1

# mybatis-plus
mybatis-plus.mapper-locations=classpath:mapper/*.xml
logging.level.com.xiaobu.mapper=debug
mybatis-plus.type-aliases-package=com.xiaobu.entity
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl


```
master.sql
```sql
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `car_park_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '停车场id',
  `no` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '测试分表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_order
-- ----------------------------
INSERT INTO `t_order` VALUES ('1', '1', '1', '1', '2021-08-26 08:59:47');

SET FOREIGN_KEY_CHECKS = 1;
```

master0.sql和master1.sql

```sql
DROP TABLE IF EXISTS `user0`;
DROP TABLE IF EXISTS `user1`;

CREATE TABLE `user0` (
  `id` bigint(32) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) DEFAULT NULL COMMENT '性别',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `user1` (
  `id` bigint(32) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) DEFAULT NULL COMMENT '性别',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

```
slave0.sql
```sql
/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50719
 Source Host           : localhost:3306
 Source Schema         : slave0

 Target Server Type    : MySQL
 Target Server Version : 50719
 File Encoding         : 65001

 Date: 24/08/2021 17:24:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user0
-- ----------------------------
DROP TABLE IF EXISTS `user0`;
CREATE TABLE `user0`  (
  `id` bigint(32) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user0
-- ----------------------------
INSERT INTO `user0` VALUES (2, '爸爸', '男', 30, NULL, NULL, NULL);
INSERT INTO `user0` VALUES (4, '爷爷', '男', 64, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for user1
-- ----------------------------
DROP TABLE IF EXISTS `user1`;
CREATE TABLE `user1`  (
  `id` bigint(32) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user1
-- ----------------------------
INSERT INTO `user1` VALUES (3, '妈妈', '女', 28, NULL, NULL, NULL);
INSERT INTO `user1` VALUES (5, '奶奶', '女', 62, NULL, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;

```

slave1.sql

```sql
/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50719
 Source Host           : localhost:3306
 Source Schema         : slave1

 Target Server Type    : MySQL
 Target Server Version : 50719
 File Encoding         : 65001

 Date: 24/08/2021 17:24:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user0
-- ----------------------------
DROP TABLE IF EXISTS `user0`;
CREATE TABLE `user0`  (
  `id` bigint(32) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user0
-- ----------------------------

-- ----------------------------
-- Table structure for user1
-- ----------------------------
DROP TABLE IF EXISTS `user1`;
CREATE TABLE `user1`  (
  `id` bigint(32) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '是否删除 1删除 0未删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user1
-- ----------------------------
INSERT INTO `user1` VALUES (1, '小小', '女', 3, NULL, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;

```

User

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
 * 
 * 
 * @author     xiaobu
 * @date  on  2021/8/24 16:23
 * @version JDK1.8.0_301
 * @description  
 * 
 */
@Data
@TableName(value = "user")
public class User implements Serializable {
    private static final long serialVersionUID = -4483026544018918705L;
    /**
     * 主键
     */
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    /**
     * 姓名
     */
    @TableField(value = "`name`")
    private String name;

    /**
     * 性别
     */
    @TableField(value = "sex")
    private String sex;

    /**
     * 年龄
     */
    @TableField(value = "age")
    private Integer age;

    /**
     * 创建时间
     */
    @TableField(value = "create_time")
    private Date createTime;

    /**
     * 更新时间
     */
    @TableField(value = "update_time")
    private Date updateTime;

    /**
     * 是否删除 1删除 0未删除
     */
    @TableField(value = "`status`")
    private Boolean status;

    public User(Long id, String name, String sex, Integer age) {
        this.id = id;
        this.name = name;
        this.sex = sex;
        this.age = age;
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
 * 
 * 
 * @author     xiaobu
 * @date  on  2021/8/26 9:04
 * @version JDK1.8.0_301
 * @description  
 * 
 */
/**
    * 测试默认数据库
    */
@Data
@TableName(value = "t_order")
public class Order implements Serializable {
    private static final long serialVersionUID = 4092312802808793209L;
    @TableId(value = "id", type = IdType.INPUT)
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

UserMapper
```java
package com.xiaobu.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaobu.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * The interface User mapper.
 *
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on 2021/8/24 16:23
 * @description
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {


    /**
     * Insert list int.
     *
     * @param list the list
     * @return the int
     */
    int insertList(@Param("list")List<User> list);

    /**
     * Select all list.
     *
     * @return the list
     */
    List<User> selectAll();


}
```
OrderMapper

```java
package com.xiaobu.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.xiaobu.entity.Order;
import org.apache.ibatis.annotations.Mapper;

/**
 * 
 * 
 * @author     xiaobu
 * @date  on  2021/8/26 9:04
 * @version JDK1.8.0_301
 * @description  
 * 
 */
@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
```
UserMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaobu.mapper.UserMapper">
  <resultMap id="BaseResultMap" type="com.xiaobu.entity.User">
    <!--@mbg.generated-->
    <id column="id" jdbcType="BIGINT" property="id" />
    <result column="name" jdbcType="VARCHAR" property="name" />
    <result column="sex" jdbcType="VARCHAR" property="sex" />
    <result column="age" jdbcType="INTEGER" property="age" />
    <result column="create_time" jdbcType="TIMESTAMP" property="createTime" />
    <result column="update_time" jdbcType="TIMESTAMP" property="updateTime" />
    <result column="status" jdbcType="BOOLEAN" property="status" />
  </resultMap>
  <sql id="Base_Column_List">
    <!--@mbg.generated-->
    id, `name`, sex, age, create_time, update_time, `status`
  </sql>

<!--auto generated by MybatisCodeHelper on 2021-08-24-->
    <!--suppress SqlResolve -->
  <insert id="insertList">
        INSERT INTO user(
        id,
        name,
        sex,
        age,
        create_time,
        update_time,
        status
        )VALUES
        <foreach collection="list" item="element" index="index" separator=",">
            (
            #{element.id,jdbcType=BIGINT},
            #{element.name,jdbcType=VARCHAR},
            #{element.sex,jdbcType=VARCHAR},
            #{element.age,jdbcType=INTEGER},
            #{element.createTime,jdbcType=TIMESTAMP},
            #{element.updateTime,jdbcType=TIMESTAMP},
            #{element.status,jdbcType=BOOLEAN}
            )
        </foreach>
    </insert>

<!--auto generated by MybatisCodeHelper on 2021-08-24-->
    <!--suppress SqlResolve -->
  <select id="selectAll" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List"/>
        from user
    </select>

    <!--auto generated by MybatisCodeHelper on 2021-08-24-->
</mapper>
```


OrderMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.xiaobu.mapper.OrderMapper">
  <resultMap id="BaseResultMap" type="com.xiaobu.entity.Order">
    <!--@mbg.generated-->
    <!--@Table t_order-->
    <id column="id" jdbcType="VARCHAR" property="id" />
    <result column="name" jdbcType="VARCHAR" property="name" />
    <result column="car_park_id" jdbcType="VARCHAR" property="carParkId" />
    <result column="no" jdbcType="VARCHAR" property="no" />
    <result column="create_time" jdbcType="TIMESTAMP" property="createTime" />
  </resultMap>
  <sql id="Base_Column_List">
    <!--@mbg.generated-->
    id, `name`, car_park_id, `no`, create_time
  </sql>
</mapper>
```


UserService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.User;
import com.xiaobu.mapper.UserMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * The type User service.
 *
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on 2021/8/24 16:23
 * @description
 */
@Service
public class UserService extends ServiceImpl<UserMapper, User> {
    /**
     * Insert list int.
     *
     * @param list the list
     * @return the int
     */
    public  int insertList(List<User> list){
        return super.baseMapper.insertList(list);
    }

    /**
     * Select all list.
     *
     * @return the list
     */
    public List<User> selectAll(){
        return super.baseMapper.selectAll();
    }

}

```

OrderService

```java
package com.xiaobu.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.xiaobu.entity.Order;
import com.xiaobu.mapper.OrderMapper;
import org.springframework.stereotype.Service;
/**
 * 
 * 
 * @author     xiaobu
 * @date  on  2021/8/26 9:04
 * @version JDK1.8.0_301
 * @description  
 * 
 */
@Service
public class OrderService extends ServiceImpl<OrderMapper, Order> {

}

```
UserController

```java
package com.xiaobu.controller;


import com.google.common.collect.Lists;
import com.xiaobu.entity.User;
import com.xiaobu.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import java.util.List;


/**
 * The type User controller.
 *
 * @author xiaobu
 * @Description: 接口测试
 */
@RestController
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 模拟插入数据
     */
    List<User> userList = Lists.newArrayList();
    /**
     * 初始化插入数据
     */
    @PostConstruct
    private void getData() {
        userList.add(new User(1L,"小小", "女", 3));
        userList.add(new User(2L,"爸爸", "男", 30));
        userList.add(new User(3L,"妈妈", "女", 28));
        userList.add(new User(4L,"爷爷", "男", 64));
        userList.add(new User(5L,"奶奶", "女", 62));
    }

    /**
     * Save user object.
     *
     * @return the object
     * @Description: 批量保存用户
     */
    @PostMapping("save-user")
    public Object saveUser() {
        return userService.insertList(userList);
    }

    /**
     * List user object.
     *
     * @return the object
     * @Description: 获取用户列表
     */
    @GetMapping("list-user")
    public Object listUser() {
        return userService.list();
    }


}

```

MybatisPlusConfig

```java
package com.xiaobu.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.autoconfigure.ConfigurationCustomizer;
import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.apache.shardingsphere.api.config.masterslave.LoadBalanceStrategyConfiguration;
import org.apache.shardingsphere.api.config.masterslave.MasterSlaveRuleConfiguration;
import org.apache.shardingsphere.api.config.sharding.KeyGeneratorConfiguration;
import org.apache.shardingsphere.api.config.sharding.ShardingRuleConfiguration;
import org.apache.shardingsphere.api.config.sharding.TableRuleConfiguration;
import org.apache.shardingsphere.api.config.sharding.strategy.InlineShardingStrategyConfiguration;
import org.apache.shardingsphere.shardingjdbc.api.ShardingDataSourceFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.*;

/**
 * The type Mybatis plus config.
 *
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on 2021/8/24 9:08
 * @description
 */
@EnableTransactionManagement
@Configuration
@MapperScan("com.xiaobu.mapper")
public class MybatisPlusConfig {

    @Bean("master")
    @ConfigurationProperties(prefix = "spring.shardingsphere.datasource.master")
    public DataSource master() {
        return DataSourceBuilder.create().build();

    }

    /**
     * Master 0 data source.
     * 如果用druid 改成 return new DruidDataSource(); 即可
     * @return the data source
     */
    @Bean("master0")
    @ConfigurationProperties(prefix = "spring.shardingsphere.datasource.master0")
    public DataSource master0() {
        return DataSourceBuilder.create().build();

    }

    /**
     * Master 1 data source.
     *
     * @return the data source
     */
    @Bean("master1")
    @ConfigurationProperties(prefix = "spring.shardingsphere.datasource.master1")
    public DataSource master1() {
        return DataSourceBuilder.create().build();
    }

    /**
     * Slave 0 data source.
     *
     * @return the data source
     */
    @Bean("slave0")
    @ConfigurationProperties(prefix = "spring.shardingsphere.datasource.slave0")
    public DataSource slave0() {
        return DataSourceBuilder.create().build();
    }

    /**
     * Slave 1 data source.
     *
     * @return the data source
     */
    @Bean("slave1")
    @ConfigurationProperties(prefix = "spring.shardingsphere.datasource.slave1")
    public DataSource slave1() {
        return DataSourceBuilder.create().build();
    }


    /**
     * Dynamic data source data source.
     *
     * @return the data source
     * @throws SQLException the sql exception
     */
    @Bean("dynamicDataSource")
    public DataSource dynamicDataSource() throws SQLException {
        // 配置真实数据源
        Map<String, DataSource> dataSourceMap = new HashMap<>(8);
        //配置默认数据库
        dataSourceMap.put("master", master());
        dataSourceMap.put("master0", master0());
        dataSourceMap.put("master1", master1());
        dataSourceMap.put("slave0", slave0());
        dataSourceMap.put("slave1", slave1());
        List<String> slave0List = new ArrayList<>();
        slave0List.add("slave0");
        List<String> slave1List = new ArrayList<>();
        slave1List.add("slave1");
        // 主从策略
        LoadBalanceStrategyConfiguration loadBalanceStrategyConfiguration = new LoadBalanceStrategyConfiguration("round_robin");
        MasterSlaveRuleConfiguration master0SlaveRuleConfiguration = new MasterSlaveRuleConfiguration("master0", "master0", slave0List, loadBalanceStrategyConfiguration);
        MasterSlaveRuleConfiguration master1SlaveRuleConfiguration = new MasterSlaveRuleConfiguration("master1", "master1", slave1List, loadBalanceStrategyConfiguration);
        // 打开shardingsphere sql日志
        Properties properties = new Properties();
        properties.setProperty("sql.show", Boolean.TRUE.toString());
        // 配置分片规则 分库分表 读写分离
        ShardingRuleConfiguration shardingRuleConfig = new ShardingRuleConfiguration();
        //配置默认数据库
        shardingRuleConfig.setDefaultDataSourceName("master");
        shardingRuleConfig.getMasterSlaveRuleConfigs().add(master0SlaveRuleConfiguration);
        shardingRuleConfig.getMasterSlaveRuleConfigs().add(master1SlaveRuleConfiguration);
        // 配置消息表分库分表
        shardingRuleConfig.getTableRuleConfigs().add(getUserRuleConfiguration());
        // 获取数据源对象
        return ShardingDataSourceFactory.createDataSource(dataSourceMap, shardingRuleConfig, properties);
    }

    /**
     * Gets user rule configuration.
     *
     * @return the user rule configuration
     */
    TableRuleConfiguration getUserRuleConfiguration() {
        //对user表进行分库分表
        TableRuleConfiguration result = new TableRuleConfiguration("user", "master$->{0..1}.user$->{0..1}");
        //age分库
        result.setDatabaseShardingStrategyConfig(new InlineShardingStrategyConfiguration("age", "master$->{age % 2}"));
        //id分表
        result.setTableShardingStrategyConfig(new InlineShardingStrategyConfiguration("id", "user->{id % 3}"));
        result.setKeyGeneratorConfig(new KeyGeneratorConfiguration("SNOWFLAKE", "id"));
        return result;
    }

    /**
     * Data source transaction manager data source transaction manager.
     *
     * @param dynamicDataSource the dynamic data source
     * @return the data source transaction manager
     */
    @Bean
    public DataSourceTransactionManager dataSourceTransactionManager(@Qualifier("dynamicDataSource") DataSource dynamicDataSource) {
        DataSourceTransactionManager dataSourceTransactionManager = new DataSourceTransactionManager();
        dataSourceTransactionManager.setDataSource(dynamicDataSource);
        return dataSourceTransactionManager;
    }

    /**
     * Sql session template sql session template.
     *
     * @return the sql session template
     * @throws Exception the exception
     */
    @Bean
    public SqlSessionTemplate sqlSessionTemplate() throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory());
    }

    /**
     * Sql session factory sql session factory.
     *
     * @return the sql session factory
     * @throws Exception the exception
     */
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        MybatisSqlSessionFactoryBean sqlSessionFactory = new MybatisSqlSessionFactoryBean();
        sqlSessionFactory.setDataSource(dynamicDataSource());
        MybatisConfiguration configuration = new MybatisConfiguration();
        configuration.setJdbcTypeForNull(JdbcType.NULL);
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setCacheEnabled(false);
        sqlSessionFactory.setConfiguration(configuration);
        return sqlSessionFactory.getObject();
    }

    /**
     * 新的分页插件,一缓和二缓遵循mybatis的规则,需要设置 MybatisConfiguration#useDeprecatedExecutor = false 避免缓存出现问题(该属性会在旧插件移除后一同移除)
     *
     * @return the mybatis plus interceptor
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        //向Mybatis过滤器链中添加分页拦截器
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        //还可以添加i他的拦截器
        return interceptor;
    }

    /**
     * Configuration customizer configuration customizer.
     *
     * @return the configuration customizer
     */
    @Bean
    public ConfigurationCustomizer configurationCustomizer() {
        return configuration -> configuration.setUseDeprecatedExecutor(false);
    }

}

```

KeyIdConfig

```java
package com.xiaobu.config;

import org.apache.shardingsphere.core.strategy.keygen.SnowflakeShardingKeyGenerator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on  2021/8/24 20:48
 * @description
 */
@Configuration
public class KeyIdConfig {
    @Bean("userKeyGenerator")
    public SnowflakeShardingKeyGenerator userKeyGenerator() {
        return new SnowflakeShardingKeyGenerator();
    }


}

```

UserTest

```java
package com.xiaobu.junit;

import com.google.common.collect.Lists;
import com.xiaobu.entity.User;
import com.xiaobu.service.UserService;
import org.apache.shardingsphere.core.strategy.keygen.SnowflakeShardingKeyGenerator;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on  2021/8/24 10:33
 * @description
 */
@SpringBootTest
public class UserTest {
    @Autowired
    private UserService userService;

    @Resource
    private SnowflakeShardingKeyGenerator userKeyGenerator;


    @Test
    public void InsertForEach() {
        List<User> userList = Lists.newArrayList();
        userList.add(new User(  (Long)userKeyGenerator.generateKey(),"小小", "女", 3));
        userList.add(new User((Long)userKeyGenerator.generateKey(),"爸爸", "男", 30));
        userList.add(new User((Long)userKeyGenerator.generateKey(),"妈妈", "女", 28));
        userList.add(new User((Long)userKeyGenerator.generateKey(),"爷爷", "男", 64));
        userList.add(new User((Long)userKeyGenerator.generateKey(),"奶奶", "女", 62));
/*
        userList.add(new User(1L,"小小", "女", 3));
        userList.add(new User(2L,"爸爸", "男", 30));
        userList.add(new User(3L,"妈妈", "女", 28));
        userList.add(new User(4L,"爷爷", "男", 64));
        userList.add(new User(5L,"奶奶", "女", 62));
*/
        userService.insertList(userList);
    }


    @Test
    public void selectAll() {
        List<User> users = userService.selectAll();
        System.out.println("users = " + users);
    }
}

```

OrderTest

```java
package com.xiaobu.junit;

import com.xiaobu.entity.Order;
import com.xiaobu.mapper.OrderMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

/**
 * @author xiaobu
 * @version JDK1.8.0_301
 * @date on  2021/8/24 10:33
 * @description
 */
@SpringBootTest
public class OrderTest {
    @Autowired
    private OrderMapper orderMapper;


    @Test
    public void selectAll() {
        List<Order> orders = orderMapper.selectList(null);
        System.out.println("orders = " + orders);
    }
}

```

# 注意实体类的TableName不设置或者设置为
@TableName(value = "user")

orderMapper.xml user 非实际的 master0.user0或master1.user1
## 需要手动设置主键的值 即使mysql设置自动增长也无效


shardingsphere 4.1 需要设置SQL sessionfactory 否则报
>Property 'sqlSessionFactory' or 'sqlSessionTemplate' are required