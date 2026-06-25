# Future和FutureTask的区别以及使用场景

> 原创 已于 2022-04-18 20:48:06 修改 · 公开 · 996 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/124258866

### Future和FutureTask的区别以及使用场景

> 

- Future 是一个接口，无法直接创建对象，需配合线程池使用.submit()方法返回值Future来保存执行结果；而使用.execute()方法传入Runnable接口无返回值

- FutureTask 是一个类，可以直接创建对象，其实现了RunnableFuture接口（继承Future接口）

##### Future应用

```java
package com.xiaobu.juc;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * @author 小布
 * @className CallableAndFuture.java 单个线程的Future和Callable
 * @createTime 2022年04月18日 14:54:00
 */
public class CallableAndFuture {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newCachedThreadPool();
        Future<Integer> result = executor.submit(() -> {
            System.out.println("子线程在进行计算");
            Thread.sleep(3000);
            int sum = 0;
            for (int i = 0; i < 100; i++) {
                sum += i;
            }
            return sum;
        });
        executor.shutdown();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e1) {
            e1.printStackTrace();
        }
        System.out.println("主线程在执行任务");
        try {
            System.out.printf("task运行结果:%d\n", result.get());
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }

        System.out.println("所有任务执行完毕");
    }
}


```

##### FutureList的应用

> 多个线程并发执行，并发执行结果放入FutureList中 放入的顺序和输出的顺序是一致的

```java
package com.xiaobu.juc;


import com.xiaobu.util.ParallelUtils;
import lombok.SneakyThrows;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * @author 小布
 * @CallableAndFutureList2.java 多个线程并发执行，并发执行结果放入FutureList中 放入的顺序和输出的顺序是一致的
 * @date on  2021/6/22 8:57
 */
public class CallableAndFutureList2 {
    /**
     * 结果：
     * task1
     * task2
     * task3
     */
    @SneakyThrows
    public static void main(String[] args) {
        ThreadPoolExecutor threadPoolExecutor = ParallelUtils.getThreadPoolExecutor(4);
        List<Callable<String>> task = new ArrayList<>();
        task.add(() -> "task1");
        task.add(() -> "task2");
        task.add(() -> "task3");
        List<Future<String>> futures = threadPoolExecutor.invokeAll(task);
        for (Future<String> future : futures) {
            System.out.println(future.get());
        }
        threadPoolExecutor.shutdown();
    }
}




```

```java
package com.xiaobu.juc;


import com.xiaobu.util.DateTimeUtils;
import com.xiaobu.util.ParallelUtils;
import lombok.SneakyThrows;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * @author 小布
 * @CallableAndFutureList.java 多个异步任务放入线程池，并且获取结果
 * @date on  2021/6/22 8:57
 */
public class CallableAndFutureList {
    @SneakyThrows
    public static void main(String[] args) {
        ThreadPoolExecutor threadPoolExecutor = ParallelUtils.getThreadPoolExecutor(4);
        List<Callable<String>> task = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            Callable<String> callable = () -> "当前时间：" + DateTimeUtils.getCurrentLongDateTimeStr() + "，当前线程：" + Thread.currentThread().getName() + "==>随机数：" + new Random().nextInt(100);
            task.add(callable);
        }
        List<Future<String>> futures = threadPoolExecutor.invokeAll(task);
        for (Future<String> future : futures) {
            System.out.println(future.get());
        }
        threadPoolExecutor.shutdown();
    }
}




```

##### FutureTask应用

```java
package com.xiaobu.juc;


import java.util.concurrent.*;

/**
 * @author 小布
 * @date on  2021/6/22 8:57
 */
public class CallableAndFutureTask {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newCachedThreadPool();
        Callable<Integer> callable = () -> {
            System.out.println("子线程在进行计算");
            Thread.sleep(3000);
            int sum = 0;
            for (int i = 0; i < 100; i++) {
                sum += i;
            }
            return sum;
        };
        FutureTask<Integer> future = new FutureTask<>(callable);
        executor.submit(future);
        try {
            executor.shutdown();
            Thread.sleep(5000);
            System.out.println("主线程在执行任务");
            System.out.printf("task运行结果:%d\n", future.get());

        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }
}




```