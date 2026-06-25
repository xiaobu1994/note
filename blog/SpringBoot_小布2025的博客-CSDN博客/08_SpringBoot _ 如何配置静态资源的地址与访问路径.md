# SpringBoot | 如何配置静态资源的地址与访问路径

> 原创 于 2019-01-18 13:53:15 发布 · 公开 · 3.2k 阅读 · 1 · 3 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86538053

一、spring.mvc.static-path-pattern

```java
#这表示只有静态资源的访问路径为/static/**时，才会处理请求 e.g:localhost:9001/static/1.txt
#spring.mvc.static-path-pattern=/static/**

```

二、spring.resources.static-locations



```java
#这表示按照下面路径的顺序依次查找，才会处理请求 e.g:localhost:9001/1.txt
#spring.resources.static-locations=classpath:/static,classpath:/upload
```

项目结构：

 ![](./assets/08_1.png)

访问 [http://localhost:9001/1.txt](http://localhost:9001/1.txt) 出现如下结果表明访问成功。

 <img src="./assets/08_2.png" alt="" style="max-height:281px; box-sizing:content-box;" />

三、静态资源的Bean配置



```java
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/14 12:46
 * @description V1.0
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
 
 
   /**
     * @author xiaobu
     * @date 2019/1/18 13:51
     * @param registry  registry
     * @descprition  等价于 http://localhost:9001/1.txt 依次在static upload目录下找1.txt文件
     * @version 1.0
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**").addResourceLocations("classpath:/static/","classpath:/upload/");
    }
 
	}
```





---

易混淆的点：

项目路径：
#默认是server.servlet.context-path=/

#server.servlet.context-path=/test