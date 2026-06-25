# Spring Cloud Alibaba Nacos自动刷新配置文件

> 原创 于 2021-09-17 17:08:00 发布 · 公开 · 829 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120352871

Pom文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.xiaobu</groupId>
        <artifactId>spring-cloud-alibaba-nacos-config-demo</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>
    <artifactId>nacos-config-refresh</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>nacos-config-refresh</name>
    <description>nacos-config-refresh</description>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <spring.boot.version>2.2.4.RELEASE</spring.boot.version>
        <spring.cloud.version>Hoxton.SR1</spring.cloud.version>
        <spring.cloud.alibaba.version>2.2.0.RELEASE</spring.cloud.alibaba.version>
    </properties>
    <!--
        引入 Spring Boot、Spring Cloud、Spring Cloud Alibaba 三者 BOM 文件，进行依赖版本的管理，防止不兼容。
        在 https://dwz.cn/mcLIfNKt 文章中，Spring Cloud Alibaba 开发团队推荐了三者的依赖关系
     -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-parent</artifactId>
                <version>${spring.boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring.cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <dependency>
                <groupId>com.alibaba.cloud</groupId>
                <artifactId>spring-cloud-alibaba-dependencies</artifactId>
                <version>${spring.cloud.alibaba.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!--    这个文件的依赖冲突不能exclude否则连不上nacos-->
    <dependencies>
        <!-- 引入 SpringMVC 相关依赖，并实现对其的自动配置 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- 引入 Spring Cloud Alibaba Nacos Discovery 相关依赖，将 Nacos 作为注册中心，并实现对其的自动配置 -->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <!-- 引入 Spring Cloud Alibaba config 相关依赖 -->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        </dependency>
    </dependencies>

</project>

```

在nacos新建两个配置集dev prod 对应的属性和下面的bootstrap-dev.properties、bootstrap-prod.properties配置一致。

bootstrap.properties

```properties
spring.profiles.active=dev
spring.application.name=nacos-config
## 使用的 Nacos 的命名空间，默认为 null
#spring.cloud.nacos.config.namespace=
## Nacos 服务器地址
#spring.cloud.nacos.config.server-addr=127.0.0.1:8848
## 使用的 Nacos 配置集的 dataId，默认为 spring.application.name
#spring.cloud.nacos.config.name=
## 使用的 Nacos 配置分组，默认为 DEFAULT_GROUP
#spring.cloud.nacos.config.group=DEFAULT_GROUP
## 使用的 Nacos 配置集的 dataId 的文件拓展名，同时也是 Nacos 配置集的配置格式，默认为 properties
#spring.cloud.nacos.config.file-extension=properties

```

bootstrap-dev.properties

```properties
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
#nacos的命名空间
spring.cloud.nacos.config.namespace=3aafe1ff-9715-4c49-9b98-fcd5492d7050
# 使用的 Nacos 配置分组，默认为 DEFAULT_GROUP
spring.cloud.nacos.config.group=DEFAULT_GROUP
# 使用的 Nacos 配置集的 dataId，默认为 spring.application.name
spring.cloud.nacos.config.name=
spring.cloud.nacos.config.file-extension=properties

```

bootstrap-prod.properties

```properties
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
#nacos的命名空间
spring.cloud.nacos.config.namespace=afe0f112-ae2e-49cd-96e7-f89abd581a39
# 使用的 Nacos 配置分组，默认为 DEFAULT_GROUP
spring.cloud.nacos.config.group=DEFAULT_GROUP
# 使用的 Nacos 配置集的 dataId，默认为 spring.application.name
spring.cloud.nacos.config.name=
spring.cloud.nacos.config.file-extension=properties

```

启动类NacosConfigRefreshApplication

```java
package com.xiaobu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * The type Nacos config refresh application.
 *
 * @author 小布
 */
@SpringBootApplication
public class NacosConfigRefreshApplication {
    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(NacosConfigRefreshApplication.class, args);
    }

    @LoadBalanced
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }


    /**
     * The type Test controller.
     */
    @RestController
    public static class TestController {

        @Autowired
        private RestTemplate restTemplate;

        /**
         * Hello string.
         *
         * @param name the name
         * @return the string
         */
        @GetMapping("/hello/{name}")
        public String hello(@PathVariable String name) {
            return restTemplate.getForObject("http://nacos-provider/hello/" + name, String.class);
        }
    }
}

```

测试类：NacosConfigJasyptApplicationTests

```java
package com.xiaobu;

import org.jasypt.encryption.StringEncryptor;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class NacosConfigJasyptApplicationTests {

    @Autowired
    private StringEncryptor encryptor;
    @Value("${my-password:}")
    private String myPassword;

    @Value("${jasypt.encryptor.password:}")
    private String jasyptEncryptorPassword;
    @Value("${jasypt.encryptor.algorithm:}")
    private String jasyptEncryptorAlgorithm;

    @Before
    public void before() {
        System.out.println("jasyptEncryptorPassword = " + jasyptEncryptorPassword);
        System.out.println("jasyptEncryptorAlgorithm = " + jasyptEncryptorAlgorithm);
    }

    @Test
    public void encode() {
        // 第一个加密
        String password1 = "root1";
        String encrypt = encryptor.encrypt(password1);
        System.out.println("my-password=" + "ENC(" + encrypt + ")");
        // 第二个加密
        String password2 = "root2";
        String encPwd2 = encryptor.encrypt(password2);
        System.out.println("my-password=" + "ENC(" + encPwd2 + ")");
        //my-password=ENC(dY3ZXhFrW9sicIXYkZS+K9ApRXpOWCEJ)
        //my-password=ENC(S9dBjTJFhlRlu0mSmFLVczZ+FYx2b502)
    }

    @Test
    public void print() {
        System.out.println(myPassword);
    }
}

```

Nacos nacos-configdev 配置集内容

```properties
server.port=8002
# 订单支付超时时长，单位：秒。
order.pay-timeout-seconds=8888
# 订单创建频率，单位：秒
order.create-frequency-seconds=9990
```

Nacos nacos-config prod 配置集内容

```properties
server.port=8002
# 订单支付超时时长，单位：秒。
order.pay-timeout-seconds=60
# 订单创建频率，单位：秒
order.create-frequency-seconds=8882
```

NacosConfigRefreshApplication启动类

```java
package com.xiaobu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

/**
 * The type Nacos config refresh application.
 *
 * @author 小布
 */
@SpringBootApplication
public class NacosConfigRefreshApplication {
    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(NacosConfigRefreshApplication.class, args);
    }

    @LoadBalanced
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }


    /**
     * The type Test controller.
     */
    @RestController
    public static class TestController {

        @Autowired
        private RestTemplate restTemplate;

        /**
         * Hello string.
         *
         * @param name the name
         * @return the string
         */
        @GetMapping("/hello/{name}")
        public String hello(@PathVariable String name) {
            return restTemplate.getForObject("http://nacos-provider/hello/" + name, String.class);
        }
    }
}

```

OrderProperties配置类

```java
package com.xiaobu.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @author 小布
 */
@Component
@ConfigurationProperties(prefix = "order")
public class OrderProperties {

    /**
     * 订单支付超时时长，单位：秒。
     */
    private Integer payTimeoutSeconds;

    /**
     * 订单创建频率，单位：秒
     */
    private Integer createFrequencySeconds;

    public Integer getPayTimeoutSeconds() {
        return payTimeoutSeconds;
    }

    public OrderProperties setPayTimeoutSeconds(Integer payTimeoutSeconds) {
        this.payTimeoutSeconds = payTimeoutSeconds;
        return this;
    }

    public Integer getCreateFrequencySeconds() {
        return createFrequencySeconds;
    }

    public OrderProperties setCreateFrequencySeconds(Integer createFrequencySeconds) {
        this.createFrequencySeconds = createFrequencySeconds;
        return this;
    }

}

```

EnvironmentChangeListener 监听器

```java
package com.xiaobu.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.context.environment.EnvironmentChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.stereotype.Component;

/**
 * The type Environment change listener.
 *
 * @author 小布
 */
@Component
public class EnvironmentChangeListener implements ApplicationListener<EnvironmentChangeEvent> {

    /**
     * The Logger.
     */
    private final Logger logger = LoggerFactory.getLogger(getClass());

    /**
     * The Environment.
     */
    @Autowired
    private ConfigurableEnvironment environment;

    /**
     * On application event.
     * 修改了nacos配置参数点击发布就会进入 onApplicationEvent方法
     *
     * @param event the event
     */
    @Override
    public void onApplicationEvent(EnvironmentChangeEvent event) {
        for (String key : event.getKeys()) {
            logger.info("[onApplicationEvent][key({}) 最新 value 为 {}]", key, environment.getProperty(key));
        }
    }

}

```

ConfigController控制器

```java
package com.xiaobu.controller;

import com.alibaba.fastjson.JSONObject;
import com.xiaobu.config.OrderProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * @author 小布
 */
@RestController
@RequestMapping("/config")
@RefreshScope
public class ConfigController {

    private final Logger logger = LoggerFactory.getLogger(getClass());
    @Autowired
    private OrderProperties orderProperties;
    @Value(value = "${order.pay-timeout-seconds}")
    private Integer payTimeoutSeconds;
    @Value(value = "${order.create-frequency-seconds}")
    private Integer createFrequencySeconds;

    /**
     * 测试 @ConfigurationProperties 注解的配置属性类
     */
    @GetMapping("/test01")
    public OrderProperties test01() {
        return orderProperties;
    }

    /**
     * 测试 @Value 注解的属性
     */
    @GetMapping("/test02")
    public Map<String, Object> test02() {
        return new JSONObject().fluentPut("payTimeoutSeconds", payTimeoutSeconds)
                .fluentPut("createFrequencySeconds", createFrequencySeconds);
    }

    @GetMapping("/logger")
    public void logger() {
        logger.debug("[logger][测试一下]");
    }


}

```

启动NacosConfigRefreshApplication启动类，访问 [http://localhost:8080/jasypt/test](http://localhost:8080/jasypt/test) 返回结果

```json
{
  "payTimeoutSeconds": 8888,
  "createFrequencySeconds": 9990
}
```

修改nacos dev的配置集后,修改后会执行EnvironmentChangeListener中#onApplicationEvent方法

```properties
#程序启动端口
server.port=8002
# 订单支付超时时长，单位：秒。
order.pay-timeout-seconds=6666
# 订单创建频率，单位：秒
order.create-frequency-seconds=7777

```

启动NacosConfigRefreshApplication启动类 访问 [http://localhost:8080/jasypt/test](http://localhost:8080/jasypt/test) 返回结果

```json
{
  "payTimeoutSeconds": 6666,
  "createFrequencySeconds": 7777
}
```

参考：
[芋道 Spring Cloud Alibaba 配置中心 Nacos 入门](https://www.iocoder.cn/Spring-Cloud-Alibaba/Nacos-Config/?self) 