# Spring Cloud Alibaba Nacos使用jasypt配置加密

> 原创 于 2021-09-17 17:08:50 发布 · 公开 · 6.9k 阅读 · 2 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120352927

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
    <artifactId>nacos-config-jasypt</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>nacos-config-jasypt</name>
    <description>nacos-config-jasypt</description>
    <properties>
        <!--        解决mvn compile 编码GBK的不可映射字符-->
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

        <!--        jasypt-->
        <dependency>
            <groupId>com.github.ulisesbocchio</groupId>
            <artifactId>jasypt-spring-boot-starter</artifactId>
            <version>3.0.3</version>
        </dependency>
        <!-- 方便等会写单元测试 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>

```

bootstrap.properties

```properties
# Nacos Config 配置项，对应 NacosConfigProperties 配置属性类
spring.application.name=nacos-config-jasypt
# Nacos 服务器地址
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
# 使用的 Nacos 的命名空间，默认为 null
spring.cloud.nacos.config.namespace=
# 使用的 Nacos 配置分组，默认为 DEFAULT_GROUP
spring.cloud.nacos.config.group=DEFAULT_GROUP
# 使用的 Nacos 配置集的 dataId，默认为 spring.application.name
spring.cloud.nacos.config.name=
# 使用的 Nacos 配置集的 dataId 的文件拓展名，同时也是 Nacos 配置集的配置格式，默认为 properties
spring.cloud.nacos.config.file-extension=properties


```

启动类NacosConfigJasyptApplication

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
public class NacosConfigJasyptApplication {
    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(NacosConfigJasyptApplication.class, args);
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

Nacosnacos-config-jasypt 配置集内容

```properties
#jasypt配置项
jasypt.encryptor.password=jasypt
# 默认加密方式PBEWithMD5AndDES,可以更改为PBEWithMD5AndTripleDES
jasypt.encryptor.algorithm=PBEWithMD5AndDES
#加密的代码
my-password=ENC(dY3ZXhFrW9sicIXYkZS+K9ApRXpOWCEJ)
```

执行NacosConfigJasyptApplicationTests中的#print方法，解密结果如下：

```properties
root1=
```

启动启动类NacosConfigJasyptApplication，访问 [http://localhost:8080/jasypt/test](http://localhost:8080/jasypt/test) 返回结果 root1

修改nacos的配置集后

```properties
#jasypt配置项
jasypt.encryptor.password=jasypt
# 默认加密方式PBEWithMD5AndDES,可以更改为PBEWithMD5AndTripleDES
jasypt.encryptor.algorithm=PBEWithMD5AndDES
#加密的代码
my-password=ENC(S9dBjTJFhlRlu0mSmFLVczZ+FYx2b502)

```

访问 [http://localhost:8080/jasypt/test](http://localhost:8080/jasypt/test) 返回结果 root2