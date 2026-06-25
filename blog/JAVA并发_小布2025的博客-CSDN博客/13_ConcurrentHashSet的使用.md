# ConcurrentHashSet的使用

> 原创 于 2020-07-07 11:18:49 发布 · 公开 · 5k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/107177504

方法一、使用google的ConcurrentHashSet

首先引入maven依赖

```xml
        <dependency>
            <groupId>com.google.guava</groupId>
            <artifactId>guava</artifactId>
            <version>18.0</version>
        </dependency>
```

使用示例

```java
package com.xiaobu.demo;

import com.google.common.collect.Sets;
import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.xiaobu.base.constant.Const;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StopWatch;

import java.util.Set;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/28 9:06
 * @description
 */
@Slf4j
public class BoxCodeTest {



    private static final int initialCapacity = 1000000;

   private static Set<String> codeSet = Sets.newConcurrentHashSet();
    private static CountDownLatch countDownLatch = new CountDownLatch(initialCapacity);
    private static AtomicLong atomicLong = new AtomicLong(900000000000L);
    private static ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%s").build();
    private static ThreadPoolExecutor executor = new ThreadPoolExecutor(5,5 , 60, TimeUnit.SECONDS, new ArrayBlockingQueue<>(initialCapacity),threadFactory);



    public synchronized  static void test(){

        for (int i = 0; i <initialCapacity ; i++) {
            executor.execute(() -> {
                String plaintext = Const.SERVER_PORT_METHOD_NAME+ Const.CODE_PRE +  atomicLong.getAndIncrement();
                codeSet.add(plaintext);
                countDownLatch.countDown();
                log.info("当前线程:{},==>plaintext ={}",Thread.currentThread().getName(),plaintext);
            });
        }
        executor.shutdown();
    }

    public  static void main(String[] args) {

        StopWatch stopWatch = new StopWatch();
        stopWatch.start("计时开始");
        test();
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopWatch.stop();
        log.info(stopWatch.prettyPrint());
        log.info("耗时 = {}" ,stopWatch.getTotalTimeSeconds()+"S");
        log.info("codeSet.size() = {}" ,codeSet.size());
    }
}
```

方法二、使用ConcurrentHashMap的keySet()方法

```java
package com.xiaobu.demo;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.xiaobu.base.constant.Const;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StopWatch;

import java.util.Set;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/28 9:06
 * @description
 */
@Slf4j
public class BoxCodeTest2 {

    private static final int initialCapacity = 10000000;

   private static ConcurrentHashMap<String, String> map = new ConcurrentHashMap<String,String>();

    private static CountDownLatch countDownLatch = new CountDownLatch(initialCapacity);
    private static AtomicLong atomicLong = new AtomicLong(900000000000L);
    private static ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%s").build();

    private static ThreadPoolExecutor executor = new ThreadPoolExecutor(5,5 , 60, TimeUnit.SECONDS, new ArrayBlockingQueue<>(initialCapacity),threadFactory);

    public synchronized  static void test(){
        for (int i = 0; i <initialCapacity ; i++) {
            executor.execute(() -> {
                String plaintext = Const.SERVER_PORT_METHOD_NAME+ Const.CODE_PRE +  atomicLong.getAndIncrement();
                map.put(plaintext,plaintext);
                countDownLatch.countDown();
                log.info("当前线程:{},==>plaintext ={}",Thread.currentThread().getName(),plaintext);
            });
        }
        executor.shutdown();
    }

    public  static void main(String[] args) {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start("计时开始");
        test();
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        stopWatch.stop();
        log.info(stopWatch.prettyPrint());
        log.info("耗时 = {}" ,stopWatch.getTotalTimeSeconds()+"S");
        Set<String> codeSet = map.keySet();
        log.info("codeSet.size() = {}" ,codeSet.size());
    }
}
```