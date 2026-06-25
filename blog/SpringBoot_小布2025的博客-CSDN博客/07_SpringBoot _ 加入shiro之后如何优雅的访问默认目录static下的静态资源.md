# SpringBoot | 加入shiro之后如何优雅的访问默认目录static下的静态资源

> 原创 于 2019-01-18 17:10:33 发布 · 公开 · 4.3k 阅读 · 2 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86543285

一、shiro路径拦截配置

```java
        // TODO 重中之重啊，过滤顺序一定要根据自己需要排序
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<>();
        // 需要验证的写 authc 不需要的写 anon
        filterChainDefinitionMap.put("/resources/**", "anon");
        //static开头的url可以匿名访问
        filterChainDefinitionMap.put("/static/**", "anon");
        filterChainDefinitionMap.put("/install", "anon");
        filterChainDefinitionMap.put("/hello", "anon");
        // anon：它对应的过滤器里面是空的,什么都没做
        log.info("##################从数据库读取权限规则，加载到shiroFilter中##################");
 
        // 不用注解也可以通过 API 方式加载权限规则
        Map<String, String> permissions = new LinkedHashMap<>();
        permissions.put("/users/find", "perms[user:find]");
        filterChainDefinitionMap.putAll(permissions);
        //所有url都必须认证通过才可以访问
        filterChainDefinitionMap.put("/**", "authc");
```

二、设置url默认访问的静态资源路径

```java
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
        registry.addResourceHandler("/**").addResourceLocations("classpath:/static/");
        registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");
    }
 
}
```

由于/**被shiro拦截只有通过static开头的url来访问static如： [http://localhost:8899/static/1.doc](http://localhost:8899/static/1.doc) 下的静态资源文件