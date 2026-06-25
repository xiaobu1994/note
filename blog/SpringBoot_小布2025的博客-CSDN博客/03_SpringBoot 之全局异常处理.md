# SpringBoot 之全局异常处理

> 原创 于 2019-06-04 13:39:54 发布 · 公开 · 441 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/90767356

#### 全局异常捕获

方式一、继承  ErrorController + @ControllerAdvice + @ExceptionHandle 处理一切异常

1. 捕获404异常

```java
package com.xiaobu.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/3 20:20
 * @description 捕获404异常
 */
@Slf4j
@Controller
public class NotFoundException implements ErrorController {
    @Override
    public String getErrorPath() {
        return "/error";
    }

    @RequestMapping(value = {"/error"})
    @ResponseBody
    public ErrorResponseEntity error(HttpServletRequest request, HttpServletResponse response) {
        return new ErrorResponseEntity(404,"not found");
    }
}

```

1. 捕获其它异常

```java
package com.xiaobu.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/28 9:16
 * @description V1.0 捕获除了404之外的异常
 */
@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {


    /**
     * 功能描述:捕获异常
     *
     * @param ex Exception
     * @return java.lang.Object
     * @author xiaobu
     * @date 2019/6/3 20:28
     * @version 1.0
     */
    @ExceptionHandler(value = {Exception.class})
    @ResponseBody
    public ErrorResponseEntity error(Exception ex) {
        return new ErrorResponseEntity(500, ex.toString());
    }
}

```

异常信息返回实体类

```java
package com.xiaobu.exception;

import lombok.Data;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/28 9:10
 * @description V1.0 异常处理消息返回实体类
 */
@Data
public class ErrorResponseEntity {
    private int code;
    private String message;

    public ErrorResponseEntity(int code){
        this.code = code;
    }

    public ErrorResponseEntity(int code, String message) {
        this.code=code;
        this.message = message;
    }
}

```

方式二、WebServerFactoryCustomizer以及继承BasicErrorController

1. WebServerFactoryCustomizer配置ErrorPages

```java
package com.xiaobu.config;

import org.springframework.boot.web.server.ConfigurableWebServerFactory;
import org.springframework.boot.web.server.ErrorPage;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

/**
 * 自定义的异常页面配置
 * @author xiaobu
 */
@Component
public class ErrorPagesConfig {

    /**
     * 自定义异常处理路径
     */
    @Bean
    public WebServerFactoryCustomizer<ConfigurableWebServerFactory> webServerFactoryCustomizer() {
        //第二种写法：java8 lambda写法
        return (factory -> {
            factory.addErrorPages(new ErrorPage(HttpStatus.UNAUTHORIZED, "/error/401"));
            factory.addErrorPages(new ErrorPage(HttpStatus.FORBIDDEN, "/error/403"));
            factory.addErrorPages(new ErrorPage(HttpStatus.NOT_FOUND, "/error/404"));
            factory.addErrorPages(new ErrorPage(HttpStatus.METHOD_NOT_ALLOWED, "/error/405"));
            factory.addErrorPages(new ErrorPage(Throwable.class, "/error/500"));
            factory.addErrorPages(new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/error/500"));
        });

    }
}

```

1. 继承BasicErrorController

```java
package com.xiaobu.exception;

import org.springframework.boot.autoconfigure.web.ErrorProperties;
import org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController;
import org.springframework.boot.web.servlet.error.DefaultErrorAttributes;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/2/21 11:56
 * @description V1.0  new ModelAndView("error/401", model) 不一定是error路径也可以设置其它路径
 */
@Controller
public class MyErrorController extends BasicErrorController {
    public MyErrorController() {
        super(new DefaultErrorAttributes(), new ErrorProperties());
    }




    @RequestMapping(produces = "text/html", value = "/401")
    public ModelAndView errorHtml401(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(getStatus(request).value());
        Map<String, Object> model = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        model.put("msg", "自定义错误信息");
        return new ModelAndView("error/401", model);
    }

    @RequestMapping(produces = "text/html", value = "/403")
    public ModelAndView errorHtml403(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(getStatus(request).value());
        Map<String, Object> model = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        model.put("msg", "自定义错误信息");
        return new ModelAndView("error/403", model);
    }

    /**
     *     * 定义404的ModelAndView
     *     * @param request
     *     * @param response
     *     * @return
     */
    @RequestMapping(produces = "text/html", value = "/404")
    public ModelAndView errorHtml404(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(getStatus(request).value());
        Map<String, Object> model = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        model.put("msg", "自定义错误信息");
        return new ModelAndView("error/404", model);
    }

    @RequestMapping(produces = "text/html", value = "/405")
    public ModelAndView errorHtml405(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(getStatus(request).value());
        Map<String, Object> model = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        model.put("msg", "自定义错误信息");
        return new ModelAndView("error/405", model);
    }



    @RequestMapping(produces = "text/html", value = "/500")
    public ModelAndView errorHtml500(HttpServletRequest request, HttpServletResponse response) {
        response.setStatus(getStatus(request).value());
        Map<String, Object> model = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        model.put("msg", "自定义错误信息");
        return new ModelAndView("error/500", model);
    }

    /**
     *     * 定义500的错误JSON信息
     *     * @param request
     *     * @return
     */
    @RequestMapping(value = "/500")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> error500(HttpServletRequest request) {
        Map<String, Object> body = getErrorAttributes(request, isIncludeStackTrace(request, MediaType.TEXT_HTML));
        HttpStatus status = getStatus(request);
        return new ResponseEntity<Map<String, Object>>(body, status);
    }
}
```