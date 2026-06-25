# 第五篇: 路由网关(zuul)(Greenwich版本)

> 原创 最新推荐文章于 2025-06-13 18:50:44 发布 · 公开 · 910 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83859342

一、在前面的基础上新建个module，service-zuul。

1.1、在父工程下添加该module



```java
 <modules>
        <module>eureka-server</module>
        <module>eureka-client</module>
        <module>service-ribbon</module>
        <module>service-feign</module>
        <module>service-zuul</module>
    </modules>
```

1.2、在service.zuul工程下设置与父工程的关系，该pom.xml如下所示：

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <artifactId>service-zuul</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>service-zuul</name>
    <description>zuul for Spring Boot</description>

    <parent>
        <groupId>com.example</groupId>
        <artifactId>chapter2</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <!-- client-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
    <!-- zuul-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
  <!-- 热编译-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
        </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

    <repositories>
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>


</project>
```

1.3、启动类ServiceZuulApplication配置如下：

```java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

/**
 * @author xiaobu
 * @EnableZuulProxy 开启zuul功能
 * <p>
 * 是如果选用的注册中心是eureka，那么就推荐@EnableEurekaClient，
 * 如果是其他的注册中心，那么推荐使用@EnableDiscoveryClient。
 */
@EnableEurekaClient
@EnableDiscoveryClient
@EnableZuulProxy
@SpringBootApplication
public class ServiceZuulApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServiceZuulApplication.class, args);
    }
}
```

1.4、配置文件application.properties内容如下

```java
eureka.client.service-url.defaultZone=http://localhost:8001/eureka/
server.port=8006
#请求路径和服务名
zuul.routes.xiaobu.path=/xiaobu/**
zuul.routes.xiaobu.service-id=service-ribbon
#请求路径和服务名
zuul.routes.admin.path=/admin/**
zuul.routes.admin.service-id=service-feign

spring.application.name=service-zuul

#热部署生效
spring.devtools.restart.enabled=true
```

1.5访问 [http://localhost:8006/xiaobu/test?name=admin](http://localhost:8006/xiaobu/test?name=admin) 出现如下结果：

 <img src="./assets/06_1.jpeg" alt="" style="max-height:39px; box-sizing:content-box;" />

1.6访问 [http://localhost:8006/admin/test?name=admin](http://localhost:8006/admin/test?name=admin) 出现结果如下：

 <img src="./assets/06_2.jpeg" alt="" style="max-height:56px; box-sizing:content-box;" />

这样路由就起到效果了。

---

二、zuul还可以起到拦截的作用。

2.1、定义个MyFilter实现ZuulFilter.

```java
package com.example.filter;

import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;
import com.netflix.zuul.exception.ZuulException;
import io.micrometer.core.instrument.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/7 14:28
 * @description V1.0 zuul过滤器
 */
@Component
public class MyFilter extends ZuulFilter {
    private static Logger logger = LoggerFactory.getLogger(MyFilter.class);
    /**
     * @author xiaobu
     * @date 2018/11/7 14:57
     * @return java.lang.String
     * @descprition pre：路由之前  routing：路由之时 post： 路由之后 error：发送错误调用
     * @version 1.0
     */
    @Override
    public String filterType() {
        return "pre";
    }

    /**
     * @author xiaobu
     * @date 2018/11/7 15:01
     * @return int
     * @descprition   过滤的顺序
     * @version 1.0
     */
    @Override
    public int filterOrder() {
        return 0;
    }

    /**
     * @author xiaobu
     * @date 2018/11/7 14:59
     * @return boolean
     * @descprition  true表示为需要过滤
     * @version 1.0
     */
    @Override
    public boolean shouldFilter() {
        return true;
    }


    @Override
    public Object run() throws ZuulException {
        RequestContext requestContext = RequestContext.getCurrentContext();
        HttpServletRequest request=requestContext.getRequest();
        String token=request.getParameter("token");
        //字符串替换替换
        logger.info(String.format("%s >>> %s", request.getMethod(), request.getRequestURL().toString()));
        if(StringUtils.isBlank(token)){
            requestContext.setSendZuulResponse(false);
            requestContext.setResponseStatusCode(401);
            try {
                requestContext.getResponse().setContentType("text/html;charset=UTF-8");
                requestContext.getResponse().getWriter().print("令牌是空的。");
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        logger.info("ok");
        return null;
    }
}
```

2.2、访问 [http://localhost:8006/admin/test?name=admin](http://localhost:8006/admin/test?name=admin) 结果如下所示：

 <img src="./assets/06_3.jpeg" alt="" style="max-height:35px; box-sizing:content-box;" />

---

源码地址： [https://github.com/xiaobu1994/springcloud2018-11-08](https://github.com/xiaobu1994/springcloud2018-11-08) 