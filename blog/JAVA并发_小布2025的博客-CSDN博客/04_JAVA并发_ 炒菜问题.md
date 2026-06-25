# JAVA并发| 炒菜问题

> 原创 已于 2023-02-28 17:59:10 修改 · 公开 · 423 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/93636804

## 炒菜问题

> 买菜和买配料先后顺序不一定，但炒菜一定在这两个的后面

### 用CountDownLatch实现

```java
package com.xiaobu.learn.concurrent;

import com.google.common.util.concurrent.ThreadFactoryBuilder;

import java.util.concurrent.*;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/25 14:36
 * @description submit 有返回值， execute没有 submit最终还是执行了 execute方法
 */
public class CountDownLatchDemo {

    public static void main(String[] args) {
        CountDownLatch countDownLatch = new CountDownLatch(2);
        test(countDownLatch);
        //test1(countDownLatch);
    }


    public static void test(CountDownLatch countDownLatch) {
        ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("scheduler-pool-%d").build();
        ThreadPoolExecutor executor = new ThreadPoolExecutor(3, 10, 60L, TimeUnit.SECONDS, new ArrayBlockingQueue<>(3), threadFactory);
        executor.execute(() -> {
                    System.out.println(Thread.currentThread().getName() + "执行买菜");
                    countDownLatch.countDown();
                }
        );

        executor.execute(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买配料");
            countDownLatch.countDown();
        });

        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        executor.execute(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName() + "执行炒菜");
            }
        });
        executor.shutdown();
    }


    /**
     * 功能描述:显示创建线程实现
     *
     * @param countDownLatch countDownLatch
     * @return void
     * @author xiaobu
     * @date 2019/6/25 16:39
     * @version 1.0
     */
    public static void test1(CountDownLatch countDownLatch) {
        new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买菜");
            countDownLatch.countDown();
        }).start();

        new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买配料");
            countDownLatch.countDown();
        }).start();

        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName() + "执行炒菜");
            }
        }).start();
    }


}


```

### 用AtomicInteger实现

```java
package com.xiaobu.learn.concurrent;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/25 16:18
 * @description 用自旋实现
 */
public class AtomicIntegerDemo {
    private static final AtomicInteger atomicInteger = new AtomicInteger(0);

    public static void main(String[] args) {

        new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买菜");
            atomicInteger.getAndIncrement();
        }).start();

        new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买配料");
            atomicInteger.getAndIncrement();

        }).start();

        while (true) {
            if (atomicInteger.get() == 2) {
                new Thread(() -> {
                    System.out.println(Thread.currentThread().getName() + "执行炒菜");
                }).start();
                break;
            }
        }


        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName() + "执行炒菜");
            }
        }).start();

    }
}


```

### 用join实现

```java
package com.xiaobu.learn.concurrent;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/6/25 17:40
 * @description
 */
public class JoinDemo {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买菜");
        });

        Thread t2 = new Thread(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买配料");

        });


        Thread t3 = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    t1.join();
                    t2.join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + "执行炒菜");
            }
        });
        t1.start();
        t2.start();
        t3.start();
    }
}

```

#### 用CyclicBarrier实现

```java
package com.xiaobu.juc.CyclicBarrier;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.*;

/**
 * @author 小布
 * @className Test.java
 * @createTime 2022年04月01日 15:37:00
 */
@Slf4j
public class CyclicBarrierTest {

    static ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%d").build();
    static ThreadPoolExecutor executor = new ThreadPoolExecutor(2, 10, 60L, TimeUnit.SECONDS, new ArrayBlockingQueue<>(3), threadFactory);

    public static void main(String[] args) {
        test();
    }

    public static void test() {
        CyclicBarrier cyclicBarrier = new CyclicBarrier(2, () -> System.out.println(Thread.currentThread().getName() + "开始炒菜。。。"));
        try {
            executor.execute(() -> {
                log.info("当前时间：【{}】【test】::cyclicBarrier ==> 【{}】 开始买菜", System.currentTimeMillis(), Thread.currentThread().getName());
                try {
                    cyclicBarrier.await();
                } catch (InterruptedException | BrokenBarrierException e) {
                    e.printStackTrace();
                }
            });
            executor.execute(() -> {
                log.info("当前时间：【{}】【test】::cyclicBarrier ==> 【{}】 开始买配料", System.currentTimeMillis(), Thread.currentThread().getName());
                try {
                    cyclicBarrier.await();
                } catch (InterruptedException | BrokenBarrierException e) {
                    e.printStackTrace();
                }
            });
        } finally {
            executor.shutdown();
        }


    }

}

```

#### 用CompeletableFuture实现

```java
package com.xiaobu.juc.CompletableFuture;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

/**
 * The type Future list test.
 *
 * @author xiaobu
 * @className StirFryProblems.java
 * @createTime 2023年02月28日 13:54:00
 */
@Slf4j
public class StirFryProblems {
    static ThreadPoolExecutor executor;

    static {
        ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%d").build();
        executor = new ThreadPoolExecutor(2, 10, 60L, TimeUnit.SECONDS, new ArrayBlockingQueue<>(3), threadFactory);
    }

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            // stirFryRunAfterBoth();
            // stirFryThenAcceptBoth();
            // stirFryThenCombine();
            stirFryAllOf();
            System.out.println("\r\n");
        }

        executor.shutdown();

    }


    private static void stirFryRunAfterBoth() {
        CompletableFuture<Void> voidCompletableFuture1 = CompletableFuture.runAsync(() -> System.out.println(Thread.currentThread().getName() + "执行买菜。。。"), executor);
        CompletableFuture<Void> voidCompletableFuture2 = CompletableFuture.runAsync(() -> System.out.println(Thread.currentThread().getName() + "执行配料。。。"), executor);
        CompletableFuture<Void> voidCompletableFuture = voidCompletableFuture1.runAfterBoth(voidCompletableFuture2, () -> System.out.println(Thread.currentThread().getName() + "执行炒菜。。。"));
        try {
            voidCompletableFuture.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }

    private static void stirFryThenAcceptBoth() {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(() -> {
            int t = 1;
            try {
                TimeUnit.SECONDS.sleep(t);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            log.info("当前时间【{}】【stirFryThenAcceptBoth】::执行买菜。。。 ==> 【{}】", System.currentTimeMillis(), Thread.currentThread().getName());
            return t;
        }, executor);

        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(() -> {
            int t = 2;
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            log.info("当前时间【{}】【stirFryThenAcceptBoth】::执行配料。。。 ==> 【{}】", System.currentTimeMillis(), Thread.currentThread().getName());
            return t;
        }, executor);
        CompletableFuture<Void> voidCompletableFuture = f1.thenAcceptBoth(f2, (integer, integer2) -> System.out.println(Thread.currentThread().getName() + "执行炒菜。。。"));
        try {
            voidCompletableFuture.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }

    private static void stirFryThenCombine() {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(() -> {
            int t = 1;
            try {
                TimeUnit.SECONDS.sleep(t);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "执行买菜。。。");
            return t;
        }, executor);

        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(() -> {
            int t = 2;
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + "执行配料。。。");
            return t;
        }, executor);
        CompletableFuture<Integer> voidCompletableFuture = f1.thenCombineAsync(f2, (f, v) -> {
            System.out.println(Thread.currentThread().getName() + "执行炒菜。。。");
            return f + v;
        });
        try {
            voidCompletableFuture.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }


    private static void stirFryAllOf() {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(() -> {
            System.out.println(Thread.currentThread().getName() + "执行买菜。。。");
            return 1;
        }, executor);

        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(() -> {
            System.out.println(Thread.currentThread().getName() + "执行配料。。。");
            return 2;
        }, executor);
        List<CompletableFuture<Integer>> list = new ArrayList<>();
        list.add(f1);
        list.add(f2);
        CompletableFuture[] futures = list.toArray(new CompletableFuture[0]);
        CompletableFuture<Void> voidCompletableFuture = CompletableFuture.allOf(futures).whenComplete((unused, throwable) -> System.out.println(Thread.currentThread().getName() + "执行炒菜。。。"));
        try {
            voidCompletableFuture.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        executor.shutdown();
    }

}

```