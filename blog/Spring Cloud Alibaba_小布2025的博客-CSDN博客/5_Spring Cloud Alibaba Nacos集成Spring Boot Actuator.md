# Spring Cloud Alibaba Nacos集成Spring Boot Actuator

> 原创 于 2021-09-23 21:59:00 发布 · 公开 · 2.4k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120444328

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
    <artifactId>nacos-config-actuator</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>nacos-config-actuator</name>
    <description>nacos-config-actuator</description>
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
# Nacos Config 配置项，对应 NacosConfigProperties 配置属性类
spring.application.name=nacos-config-actuator
# Nacos 服务器地址
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
# 使用的 Nacos 的命名空间，默认为 null
spring.cloud.nacos.config.namespace=3aafe1ff-9715-4c49-9b98-fcd5492d7050
# 使用的 Nacos 配置分组，默认为 DEFAULT_GROUP
spring.cloud.nacos.config.group=DEFAULT_GROUP
# 使用的 Nacos 配置集的 dataId，默认为 spring.application.name 需要copy一份 nacos-config相同的配置 dataId改成nacos-config-actuator
spring.cloud.nacos.config.name=
# 使用的 Nacos 配置集的 dataId 的文件拓展名，同时也是 Nacos 配置集的配置格式，默认为 properties
spring.cloud.nacos.config.file-extension=properties


```

#### application.properties

```properties
# Health 端点配置项，对应 HealthProperties 配置类
# 何时显示完整的健康信息。默认为 NEVER 都不展示。可选 WHEN_AUTHORIZED 当经过授权的用户；可选 ALWAYS 总是展示。
management.endpoint.health.show-details=ALWAYS
# Actuator HTTP 配置项，对应 WebEndpointProperties 配置类
# 需要开放的端点。默认值只打开 health 和 info 两个端点。通过设置 * ，可以开放所有端点。
management.endpoints.web.exposure.include=*

```

#### 启动类NacosConfigActuatorApplication

```java
package com.xiaobu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * The type Nacos config refresh application.
 *
 * @author 小布
 */
@SpringBootApplication
public class NacosConfigActuatorApplication {
    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(NacosConfigActuatorApplication.class, args);
    }


}

```

#### 控制器 ActuatorController

```java
package com.xiaobu.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author 小布
 */
@RestController
@RequestMapping("/actuator")
@RefreshScope
public class ActuatorController {


    /**
     * @NacosValue(value = "${order.pay-timeout-seconds}")
     */
    @Value(value = "${order.pay-timeout-seconds}")
    private Integer payTimeoutSeconds;
    /**
     * @NacosValue(value = "${order.create-frequency-seconds}")
     */
    @Value(value = "${order.create-frequency-seconds}")
    private Integer createFrequencySeconds;


    @GetMapping("/test")
    public String test() {
        return String.format("order.pay-timeout-seconds:%s,order.create-frequency-seconds:%s", payTimeoutSeconds, createFrequencySeconds);
    }

}

```

#### nacosData Id 为nacos-config-actuator GROUP为 DEFAULT_GROUP 配置集内容

```properties
#程序启动端口
server.port=8002
# 订单支付超时时长，单位：秒。
order.pay-timeout-seconds=6666
# 订单创建频率，单位：秒
order.create-frequency-seconds=7777
```

### 测试

访问 [http://localhost:8002/actuator/nacos-config](http://localhost:8002/actuator/nacos-config) 

得到

```json
{
  "NacosConfigProperties": {
    "serverAddr": "127.0.0.1:8848",
    "encode": null,
    "group": "DEFAULT_GROUP",
    "prefix": null,
    "fileExtension": "properties",
    "timeout": 3000,
    "maxRetry": null,
    "configLongPollTimeout": null,
    "configRetryTime": null,
    "enableRemoteSyncConfig": false,
    "endpoint": null,
    "namespace": "3aafe1ff-9715-4c49-9b98-fcd5492d7050",
    "accessKey": null,
    "secretKey": null,
    "contextPath": null,
    "clusterName": null,
    "name": "",
    "sharedConfigs": null,
    "extensionConfigs": null,
    "refreshEnabled": true,
    "extConfig": null,
    "sharedDataids": null,
    "configServiceProperties": {
      "name": "",
      "secretKey": "",
      "contextPath": "",
      "namespace": "3aafe1ff-9715-4c49-9b98-fcd5492d7050",
      "fileExtension": "properties",
      "enableRemoteSyncConfig": "false",
      "configLongPollTimeout": "",
      "configRetryTime": "",
      "encode": "",
      "serverAddr": "127.0.0.1:8848",
      "maxRetry": "",
      "group": "DEFAULT_GROUP",
      "clusterName": "",
      "accessKey": "",
      "endpoint": ""
    },
    "refreshableDataids": null
  },
  "RefreshHistory": [],
  "Sources": [
    {
      "lastSynced": "2021-09-23 09:58:30",
      "dataId": "nacos-config-actuator.properties"
    },
    {
      "lastSynced": "2021-09-23 09:58:30",
      "dataId": "nacos-config-actuator"
    }
  ]
}
```

> NacosConfigProperties–>Nacos配置项
> RefreshHistory": [],–> //Nacos配置集的刷新历史
> “Sources”: []–> //Nacos配置集的更新时间

访问 [http://localhost:8002/actuator/nacos-config](http://localhost:8002/actuator/nacos-config) 

可以查看Nocas配置中心的链接状态等信息

```json
{
  "status": "UP",
  "components": {
    "discoveryComposite": {
      "status": "UP",
      "components": {
        "discoveryClient": {
          "status": "UP",
          "details": {
            "services": [
              "nacos-config-actuator"
            ]
          }
        }
      }
    },
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 377486307328,
        "free": 362160472064,
        "threshold": 10485760
      }
    },
    "nacosConfig": {
      "status": "UP"
    },
    "nacosDiscovery": {
      "status": "UP"
    },
    "ping": {
      "status": "UP"
    },
    "refreshScope": {
      "status": "UP"
    }
  }
}
```

> “nacosConfig”: {“status”: “UP”} 表明处于连接状态

