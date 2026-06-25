# 优雅停止 SpringBoot 服务

> 原创 于 2020-01-16 16:55:14 发布 · 公开 · 227 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/104007717

```java
package com.xiaobu.controller;

import com.xiaobu.base.constant.Const;
import com.xiaobu.base.utils.UrlShorterUtils;
import com.xiaobu.entity.Url;
import com.xiaobu.mapper.UrlMapper;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/01/16 16:28
 * @description
 */
@RequestMapping("shutDown")
@RestController
public class ShutDownController implements ApplicationContextAware {

    private ApplicationContext context;


    @GetMapping("/index")
    public String getIndex() {
        return "OK";
    }


    /**
     * 功能描述:停止服务
     * @author xiaobu
     * @date 2020/1/16 16:55
     * @return java.lang.String
     * @version 1.0
     */
    @GetMapping("/shutDownContext")
    public String shutDownContext() {
        ConfigurableApplicationContext ctx = (ConfigurableApplicationContext) context;
        ctx.close();
        return "context is shutdown";
    }


    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }
}
```