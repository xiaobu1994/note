# Spring Cloud Alibaba Nacos配置加载顺序

> 原创 于 2021-09-23 21:59:46 发布 · 公开 · 1k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120444337

### 项目代码

#### pom文件

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
    <artifactId>nacos-config-multiple</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>nacos-config-multiple</name>
    <description>nacos-config-multiple</description>
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
        <!-- 实现对 Actuator 的自动化配置 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
    </dependencies>

</project>

```

#### bootstrap.properties

```properties
spring.application.name=nacos-config-multiple
# Nacos Config 配置项，对应 NacosConfigProperties 配置属性类
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
spring.cloud.nacos.config.namespace=
spring.cloud.nacos.config.group=DEFAULT_GROUP
spring.cloud.nacos.config.name=${spring.application.name}
spring.cloud.nacos.config.file-extension=properties
# 拓展配置集数组，对应 Config 数组
spring.cloud.nacos.config.extension-configs[0].data-id=extension-dataId-01.properties
spring.cloud.nacos.config.extension-configs[0].group=DEFAULT_GROUP
spring.cloud.nacos.config.extension-configs[0].refresh=true
spring.cloud.nacos.config.extension-configs[1].data-id=extension-dataId-02.properties
spring.cloud.nacos.config.extension-configs[1].group=DEFAULT_GROUP
spring.cloud.nacos.config.extension-configs[1].refresh=true
# 共享配置集数组，对应 Config 数组
spring.cloud.nacos.config.shared-configs[0].data-id=shared-dataId-01.properties
spring.cloud.nacos.config.shared-configs[0].group=DEFAULT_GROUP
spring.cloud.nacos.config.shared-configs[0].refresh=true
spring.cloud.nacos.config.shared-configs[1].data-id=shared-dataId-02.properties
spring.cloud.nacos.config.shared-configs[1].group=DEFAULT_GROUP
spring.cloud.nacos.config.shared-configs[1].refresh=true
spring.profiles.active=dev


```

#### nacosData Id 为nacos-config-multiple, GROUP为 DEFAULT_GROUP, namespace为dev 配置集内容

```properties
#程序启动端口
server.port=8002
# 订单支付超时时长，单位：秒。
order.pay-timeout-seconds=6666
# 订单创建频率，单位：秒
order.create-frequency-seconds=7777
```

#### nacosDataId 为extension-dataId-01.properties, GROUP为 DEFAULT_GROUP, namespace为dev 配置集内容

```properties
#程序启动端口
server.port=8003
```

#### nacos Data Id 为extension-dataId-02.properties, GROUP为 DEFAULT_GROUP, namespace为dev 配置集内容

```properties
discovery.host=127.0.0.1:8848
```

#### nacos Data Id 为shared-dataId-01.properties, GROUP为 DEFAULT_GROUP, namespace为dev 配置集内容

```properties
log.level=Info

```

#### nacos Data Id 为shared-dataId-02.properties, GROUP为 DEFAULT_GROUP, namespace为dev 配置集内容

```properties
spring.datasource.username=root
spring.datasource.password=123
server.port=7777

```

#### 启动类NacosConfigMultipleApplication

```java
package com.xiaobu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.core.env.Environment;

/**
 * @author 小布
 */
@SpringBootApplication
public class NacosConfigMultipleApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(NacosConfigMultipleApplication.class, args);
        // 查看 Environment
        Environment environment = context.getEnvironment();
        // 打个端口看情况
        System.out.println(environment);
    }


}

```

### 结果

#### 打印信息 ：

```text
StandardServletEnvironment {
	activeProfiles = [dev], defaultProfiles = [
		default
	], propertySources = [MapPropertySource {
		name = 'server.ports'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-nacos-config-multiple-dev.properties,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-nacos-config-multiple.properties,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-nacos-config-multiple,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-extension-dataId-02.properties,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-extension-dataId-01.properties,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-shared-dataId-02.properties,DEFAULT_GROUP'
	}, EncryptableEnumerablePropertySourceWrapper {
		name = 'bootstrapProperties-shared-dataId-01.properties,DEFAULT_GROUP'
	}, ConfigurationPropertySourcesPropertySource {
		name = 'configurationProperties'
	}, EncryptablePropertySourceWrapper {
		name = 'servletConfigInitParams'
	}, EncryptablePropertySourceWrapper {
		name = 'servletContextInitParams'
	}, EncryptableMapPropertySourceWrapper {
		name = 'systemProperties'
	}, EncryptableSystemEnvironmentPropertySourceWrapper {
		name = 'systemEnvironment'
	}, EncryptablePropertySourceWrapper {
		name = 'random'
	}, EncryptableMapPropertySourceWrapper {
		name = 'springCloudClientHostInfo'
	}, EncryptableMapPropertySourceWrapper {
		name = 'applicationConfig: [classpath:/application.properties]'
	}, EncryptableMapPropertySourceWrapper {
		name = 'springCloudDefaultProperties'
	}, EncryptableMapPropertySourceWrapper {
		name = 'applicationConfig: [classpath:/bootstrap.properties]'
	}, {
		name = 'Management Server'
	}]
}
```

### 参考

[Nacos多配置加载和共享配置](https://blog.csdn.net/ooyhao/article/details/102745518) 