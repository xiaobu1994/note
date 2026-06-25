# org.junit.jupiter.api.Test和org.junit.Test

> 原创 于 2022-05-08 20:56:37 发布 · 公开 · 2.6k 阅读 · 0 · 4 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/124654441

### org.junit.jupiter.api.Test和org.junit.Test

> spring boot 2.2之前使用的是 Junit4 org.junit.Test

```java
package com.example.demo1;

import org.junit.Test;

import org.junit.runner.RunWith;

import org.springframework.boot.test.context.SpringBootTest;

import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class Demo1ApplicationTests {
    @Test

    public void contextLoads() {
    }
```

> spring boot 2.2之后使用的是 Junit5 org.junit.jupiter.api.Test

```java
package com.example.demo;

import org.junit.jupiter.api.Test;

import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class Demo1ApplicationTests {
    @Test

    public void contextLoads() {
    }
```