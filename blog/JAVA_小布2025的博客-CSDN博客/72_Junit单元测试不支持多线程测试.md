# Junit单元测试不支持多线程测试

> 原创 最新推荐文章于 2022-11-28 17:00:40 发布 · 公开 · 402 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/125760427

### 问题现象

> 没有输出到9999就结束了 说明子线程还没结束任务，整个程序就被强迫结束了。

```java
package com.xiaobu.juc;

import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;

/**
 * @author tanhongwei1
 * @version 1.0.0
 * @className JunitTest.java
 * @createTime 2022年07月13日 10:47:00
 */
public class JunitTest {

    @SneakyThrows
    @Test
    public void test() {
        DoWork dw = new DoWork();
        Thread t = new Thread(dw);
        t.start();
    }

    class DoWork implements Runnable {
        @Override
        public void run() {
            try {
                for (int i = 0; i < 10000; i++) {
                    long milliSecond = System.currentTimeMillis();
                    System.out.println("i=" + i + "，milliSecond=" + milliSecond);// 输出循环次数和当前的系统时间
                }
            } finally {
                System.out.println("finally");
            }
        }

    }
}

```

### 解决方式

> 完整输出

```java
package com.xiaobu.juc;

import lombok.SneakyThrows;
import org.junit.jupiter.api.Test;

import java.util.concurrent.CountDownLatch;

/**
 * @author tanhongwei1
 * @version 1.0.0
 * @className JunitTest.java
 * @createTime 2022年07月13日 10:47:00
 */
public class JunitTestFix {
    private final CountDownLatch countDownLatch = new CountDownLatch(1);

    @SneakyThrows
    @Test
    public void test() {
        DoWork dw = new DoWork();
        Thread t = new Thread(dw);
        t.start();
        countDownLatch.await();
    }

    class DoWork implements Runnable {
        @Override
        public void run() {
            try {
                for (int i = 0; i < 10000; i++) {
                    long milliSecond = System.currentTimeMillis();
                    System.out.println("i=" + i + "，milliSecond=" + milliSecond);// 输出循环次数和当前的系统时间
                }
            } finally {
                countDownLatch.countDown();
            }
        }

    }
}

```

参考:

[Junit单元测试不支持多线程测试–原因分析和问题解决](https://blog.csdn.net/fly910905/article/details/79210087) 