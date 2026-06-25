# SpringBoot | 第二章：配置多环境以及上传文件

> 原创 于 2018-11-14 16:31:26 发布 · 公开 · 626 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84068345

一、创建个Springboot工程pom.xml配置如下：

```java
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
 
    <groupId>com.example</groupId>
    <artifactId>chapter</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging>
 
    <name>chapter</name>
    <description>Demo project for Spring Boot</description>
 
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
 
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>
 
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!-- mysql连接 -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>5.1.34</version>
        </dependency>
        <!-- lomback -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.16.10</version>
        </dependency>
        <!-- 热编译-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
        </dependency>
        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.1</version>
        </dependency>
        <!--freemarker -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-freemarker</artifactId>
            <version>2.0.2.RELEASE</version>
        </dependency>
        <!-- thymeleaf-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
        <!-- 引入fastjson插件 -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.32</version>
        </dependency>
 
    </dependencies>
 
 
 
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
 
 
</project>
```

二、application.properties配置如下：

```java
# 默认的 8080 我们将它改成 9090
# server.port=9090
# 未定义上下文路径之前 地址是 http://localhost:8080 定义了后 http://localhost:9090/chapter1 你能在tomcat做的事情，配置文件都可以
#server.servlet.context-path=/chapter1
spring.profiles.active=test
# mysql
spring.datasource.url=jdbc:mysql://localhost:3306/springbootdemo?characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=113506
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
#springboot自带的icon
spring.mvc.favicon.enabled=false
#热部署生效
spring.devtools.restart.enabled=true
#Ctrl+Shift+F9 重新加载
spring.thymeleaf.cache=false
#freemarker热部署
spring.freemarker.cache=false
spring.freemarker.settings.template_update_delay=0
#==================== 日志配合·标准  ============================
logging.config=classpath:logback-spring.xml
#设定ftl文件路径
spring.freemarker.template-loader-path=classpath:/templates
#设定静态文件路径，js,css等  访问时需要加/static
spring.mvc.static-path-pattern=/static/**
spring.mvc.servlet.path=
#==========================测试可以 改成true 会自动启动================
spring.auto.openurl=true
spring.web.loginurl=http://localhost:${server.port}/upload/toUpload
spring.web.googleexcute=C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe

#=====================文件上传======================================
# 是否支持批量上传   (默认值 true)
spring.servlet.multipart.enabled=true
# 上传文件的临时目录 （一般情况下不用特意修改）
spring.servlet.multipart.location=
# 上传文件最大为 1M （默认值 1M 根据自身业务自行控制即可）
spring.servlet.multipart.max-file-size=10MB
# 上传请求最大为 10M（默认值10M 根据自身业务自行控制即可）
spring.servlet.multipart.max-request-size=20MB
# 文件大小阈值，当大于这个阈值时将写入到磁盘，否则存在内存中，（默认值0 一般情况下不用特意修改）
spring.servlet.multipart.file-size-threshold=0





# 判断是否要延迟解析文件（相当于懒加载，一般情况下不用特意修改）
spring.servlet.multipart.resolve-lazily=false







```

三、多环境配置：

3.1、application-dev.properties配置：

```java
#默认是server.servlet.context-path=/
#server.servlet.context-path=/dev
server.port=8070
```

3.2、application-test.properties配置：

```java
#默认是server.servlet.context-path=/
#server.servlet.context-path=/test
server.port=8092
```

3.3、application-prod.properties配置：

```java
#默认是server.servlet.context-path=/
#server.servlet.context-path=/prod
server.port=8080
```

四、配置项目启动默认打开的页面：

```java
package com.example.common;
 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
 
/**
 * 设置运行项目默认打开的界面
 * @author tanhw119214  on  2018/6/14 14:41
 */
@Component
public class MyCommandRunner implements CommandLineRunner {
    private static Logger logger = LoggerFactory.getLogger(MyCommandRunner.class);
    @Value("${spring.web.loginurl}")
    private String loginUrl;
 
    @Value("${spring.web.googleexcute}")
    private String googleExcutePath;
 
    @Value("${spring.auto.openurl}")
    private boolean isOpen;
 
    @Override
    public void run(String... args) throws Exception {
        if(isOpen){
            String cmd = googleExcutePath +" "+ loginUrl;
            Runtime run = Runtime.getRuntime();
            try{
                run.exec(cmd);
                logger.debug("启动浏览器打开项目成功");
            }catch (Exception e){
                e.printStackTrace();
                logger.error(e.getMessage());
            }
        }
    }
}
```

五、控制器定义如下：

```java
package com.example.controller;
 
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Base64Utils;
import org.springframework.util.ClassUtils;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/14 9:40
 * @description V1.0 文件上传控制器  @RequestMapping("${server.servlet.context-path}/upload") 等价于
 * http://localhost:8092/test/test/upload/toUpload
 * 若设置了server.servlet.context-path=/test
 * 控制器也不需要加${server.servlet.context-path=/test}
 * springboot 默认追加了。
 */
@RequestMapping("/upload")
@Controller
@Slf4j
public class UploadController {
 
   /* @Value("${server.servlet.context-path}")
    protected String adminPath;*/
 
    /**
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/14 10:23
     * @descprition 进入上传页面
     * @version 1.0
     */
    @GetMapping("/toUpload")
    public String toUpload(Model model) {
        return "/upload";
    }
 
    /**
     * @param file, request
     * @return java.util.Map<java.lang.String   ,   java.lang.String>
     * @author xiaobu
     * @date 2018/11/14 11:38
     * @descprition 上传单个文件
     * @version 1.0
     */
    @PostMapping("/upload1")
    @ResponseBody
    public Map<String, String> upload1(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        //获取项目的路径
        String uploadDir = Objects.requireNonNull(Objects.requireNonNull(ClassUtils.getDefaultClassLoader()).getResource("")).getPath();
        System.out.println("uploadDir:" + uploadDir);
        uploadDir = uploadDir.substring(1);
        String path = "static/upload/";
        String filepath = uploadDir + path;
        System.out.println("uploadDir ==========" + uploadDir);
        log.info("[文件大小]:=============" + file.getSize());
        log.info("[文件名称]:=============" + file.getOriginalFilename());
        log.info("[文件类型]:=============" + file.getContentType());
        try {
            file.transferTo(new File(filepath + file.getOriginalFilename()));
        } catch (IOException e) {
            e.printStackTrace();
        }
        Map<String, String> map = new HashMap<>();
        map.put("文件大小", file.getSize() + "");
        map.put("文件名称", file.getOriginalFilename());
        map.put("文件类型", file.getContentType());
        return map;
    }
 
 
    /**
     * @param files 上传的文件
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/11/14 11:38
     * @descprition 上传多个文件
     * @version 1.0
     */
    @PostMapping("/upload2")
    @ResponseBody
    public String upload2(@RequestParam("file") MultipartFile[] files) {
        String sep = System.getProperty("file.separator");
        String uploadDir = Objects.requireNonNull(Objects.requireNonNull(ClassUtils.getDefaultClassLoader()).getResource("")).getPath();
        System.out.println("uploadDir:" + uploadDir);
        uploadDir = uploadDir.substring(1);
        String path = "static/upload/";
        String filepath = uploadDir + path;
        System.out.println("static" + sep + "upload");
        List<Map<String, String>> list = new ArrayList<>();
        for (MultipartFile file : files) {
            log.info("[文件大小]:=============" + file.getSize());
            log.info("[文件名称]:=============" + file.getOriginalFilename());
            log.info("[文件类型]:=============" + file.getContentType());
            try {
                file.transferTo(new File(filepath + file.getOriginalFilename()));
            } catch (IOException e) {
                e.printStackTrace();
            }
            Map<String, String> map = new HashMap<>();
            map.put("文件大小", file.getSize() + "");
            map.put("文件名称", file.getOriginalFilename());
            map.put("文件类型", file.getContentType());
            list.add(map);
        }
        //JSON.toJSONString(list) 把list转换成String
        //JSONArray.parseArray(String) 把String转成JSONArray
        JSONArray jsonArray = JSONArray.parseArray(JSON.toJSONString(list));
        return jsonArray.toString();
    }
 
 
    /**
     * @param base64 base64字符串
     * @author xiaobu
     * @date 2018/11/14 11:36
     * @descprition base64转图片
     * @version 1.0
     */
    @PostMapping("/upload3")
    @ResponseBody
    public String upload3(String base64) {
        System.out.println("base64的长度==========>>" + base64.length());
        String uploadDir = Objects.requireNonNull(Objects.requireNonNull(ClassUtils.getDefaultClassLoader()).getResource("")).getPath();
        System.out.println("uploadDir:" + uploadDir);
        uploadDir = uploadDir.substring(1);
        String path = "static/upload/";
        String filepath = uploadDir + path;
        // TODO BASE64 方式的 格式和名字需要自己控制（如 png 图片编码后前缀就会是 data:image/png;base64,）
        final File tempFile = new File(filepath + "test.jpg");
        // TODO 防止有的传了 data:image/png;base64, 有的没传的情况
        String[] d = base64.split("base64,");
        final byte[] bytes = Base64Utils.decodeFromString(d.length > 1 ? d[1] : d[0]);
        try {
            FileCopyUtils.copy(bytes, tempFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "图片上传成功！";
 
    }
 
 
    /**
     * 下载
     *
     * @param res
     */
    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public void download(HttpServletResponse res, HttpServletRequest request) {
        String downLoadDir = Objects.requireNonNull(Objects.requireNonNull(ClassUtils.getDefaultClassLoader()).getResource("")).getPath();
        System.out.println("downLoadDir:" + downLoadDir);
        downLoadDir = downLoadDir.substring(1);
        String path = "static/img/";
        String downLoadPath = downLoadDir + path;
        String fileName = "777.png";
        res.setHeader("content-type", "application/octet-stream");
        res.setContentType("application/octet-stream");
        res.setHeader("Content-Disposition", "attachment;filename=" + fileName);
        byte[] buff = new byte[1024];
        BufferedInputStream bis = null;
        OutputStream os = null;
        try {
            os = res.getOutputStream();
            bis = new BufferedInputStream(new FileInputStream(new File(downLoadPath + fileName)));
            int i = bis.read(buff);
            while (i != -1) {
                os.write(buff, 0, buff.length);
                os.flush();
                i = bis.read(buff);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (bis != null) {
                try {
                    bis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        System.out.println("success");
    }
}
```

六、前端上传页面：

```java
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>文件上传</title>
</head>
<link rel="icon" type="image/x-icon" href="/static/img/favicon.ico">
<body>
 
<h2>单一文件上传示例</h2>
<div>
    <form method="POST" enctype="multipart/form-data" action="/upload/upload1">
        <p>
            文件1：<input type="file" name="file"/>
            <input type="submit" value="上传"/>
        </p>
    </form>
</div>
 
<hr/>
<h2>批量文件上传示例</h2>
 
<div>
    <form method="POST" enctype="multipart/form-data"
          action="/upload/upload2">
        <p>
            文件1：<input type="file" name="file"/>
        </p>
        <p>
            文件2：<input type="file" name="file"/>
        </p>
        <p>
            <input type="submit" value="上传"/>
        </p>
    </form>
</div>
 
<hr/>
<h2>Base64文件上传</h2>
<div>
    <form method="POST" action="/upload/upload3">
        <p>
            BASE64编码：<textarea name="base64" rows="10" cols="80"></textarea>
            <input type="submit" value="上传"/>
        </p>
    </form>
</div>
 
</body>
</html>
```