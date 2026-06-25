# SpringBoot属性注入的几种方式

> 原创 于 2021-04-27 21:55:48 发布 · 公开 · 655 阅读 · 0 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/116211175

jdbc.properties

```properties
jdbc.driverClassName=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://127.0.0.1:3306/test
jdbc.username=root
jdbc.password=root
```

一、简单暴力用value

```java
package com.xiaobu.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

import javax.sql.DataSource;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 21:19
 * @description   使用spring中的value注解对每个属性进行注入,用bean注解将返回值添加到容器中
 */
@Configuration
@PropertySource("classpath:jdbc.properties")
public class JdbcConfiguration {
    @Value("${jdbc.url}")

    String url;

    @Value("${jdbc.driverClassName}")

    String driverClassName;

    @Value("${jdbc.username}")

    String username;

    @Value("${jdbc.password}")
    String password;

    @Bean
    public DataSource dataSource() {
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setUrl(url);
        dataSource.setDriverClassName(driverClassName);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }


}

```

JdbcProperties

```java
@Data
@ConfigurationProperties(prefix = "jdbc")   //这里需要定义出在application文件中定义属性值得前缀信息
public class JdbcProperties {
    private String url;

    private String driverClassName;

    private String username;

    private String password;
}

```

二、属性注入 (最常用的方式)

```java
package com.xiaobu.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 21:19
 * @description   属性注入 (最常用的方式)
 */
@Configuration
//@PropertySource("classpath:jdbc.properties") //配不配置无所谓
@EnableConfigurationProperties(JdbcProperties.class)
public class AttributeJdbcConfiguration {

    @Autowired
    private JdbcProperties jdbcProperties;
    @Bean
    public DataSource dataSource() {
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setUrl(jdbcProperties.getUrl());
        dataSource.setDriverClassName(jdbcProperties.getDriverClassName());
        dataSource.setUsername(jdbcProperties.getUsername());
        dataSource.setPassword(jdbcProperties.getPassword());
        return dataSource;
    }



}

```

三、构造方法注入 这里不需要添加@Autowired注解,也不需要在添加@Bean注解,在要使用数据源的类,使用他的构造方法进行注入

```java
package com.xiaobu.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 21:19
 * @description   构造方法注入  这里不需要添加@Autowired注解,也不需要在添加@Bean注解,在要使用数据源的类,使用他的构造方法进行注入
 */
@Configuration
//@PropertySource("classpath:jdbc.properties") //配不配置无所谓
@EnableConfigurationProperties(JdbcProperties.class)
public class ConstructionMethodJdbcConfiguration {

    //@Autowired
    private JdbcProperties jdbcProperties;


    public ConstructionMethodJdbcConfiguration(JdbcProperties jdbcProperties) {
        this.jdbcProperties = jdbcProperties;
    }
}

```

四、通过bean方法的形参进行注入 在方法上的形参上进行定义要注入的数据源,方法对数据源初始化处理后,通过bean注解将方法的返回值注入到容器中

```java
package com.xiaobu.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 21:19
 * @description   通过bean方法的形参进行注入  在方法上的形参上进行定义要注入的数据源,方法对数据源初始化处理后,通过bean注解将方法的返回值注入到容器中
 */
@Configuration
//@PropertySource("classpath:jdbc.properties") //配不配置无所谓
@EnableConfigurationProperties(JdbcProperties.class)
public class FormalParametersJdbcConfiguration {

    @Bean
    public DataSource dataSource(JdbcProperties jdbcProperties) {
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setUrl(jdbcProperties.getUrl());
        dataSource.setDriverClassName(jdbcProperties.getDriverClassName());
        dataSource.setUsername(jdbcProperties.getUsername());
        dataSource.setPassword(jdbcProperties.getPassword());
        return dataSource;
    }
}

```

五、 最优雅的注入

直接将配置注解添加到方法上,这是因为DataSource内部也是有set方法.进行自动注入.

但是,也是需要有前提的:必须保证注入的有set方法,并且set方法的名字和配制文件中的属性名需要是一样的.这里使用的是datasource中内部的set方法

```java
package com.xiaobu.config;

import com.alibaba.druid.pool.DruidDataSource;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 21:19
 * @description 直接将配置注解添加到方法上, 这是因为DataSource内部也是有set方法.进行自动注入.
 * 但是,也是需要有前提的:必须保证注入的有set方法,并且set方法的名字和配制文件中的属性名需要是一样的.这里使用的是datasource中内部的set方法
 */
@Configuration
//@PropertySource("classpath:jdbc.properties") //配不配置无所谓
public class ElegantJdbcConfiguration {

    @Bean
    @ConfigurationProperties(prefix = "jdbc")
    public DataSource dataSource() {
        return new DruidDataSource();
    }
}

```

参考:

[springboot属性注入的四种方式](https://blog.csdn.net/Ru_yin_hai/article/details/98939615) 