# CompletableFuture使用

> 原创 已于 2023-12-21 11:16:33 修改 · 公开 · 322 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/125521029

### CompletableFuture使用

```java
package com.xiaobu.juc.CompeletableFuture;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.util.StopWatch;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Random;
import java.util.concurrent.*;
import java.util.function.*;
import java.util.stream.Collectors;

/**
 * The type Completable future test.
 *
 * @author xiaobu
 * @className CompletableFutureTest.java
 * @createTime 2022年05月06日 10:07:00 get() 方法会抛出经检查的异常，可被捕获，自定义处理或者直接抛出。 <p> 而 join() 会抛出未经检查的异常。
 */
@Slf4j
public class CompletableFutureTest {
    /**
     * The constant fixedExecutorService.
     */
    public static ExecutorService fixedExecutorService = Executors.newFixedThreadPool(5);
    /**
     * junit测试多线程会有问题因为JUnit在主线程完成之后就会关闭JVM
     *
     * @see <a href="https://blog.csdn.net/fly910905/article/details/79210087">Junit单元测试不支持多线程测试--原因分析和问题解决</a>
     */
    StopWatch stopWatch = new StopWatch();

    /**
     * Gets user info.
     *
     * @return the user info
     */
    public static String getUserInfo() {
        try {
            TimeUnit.SECONDS.sleep(1L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "userInfo";
    }

    /**
     * Gets skill info.
     *
     * @return the skill info
     */
    public static String getSkillInfo() {
        try {
            TimeUnit.SECONDS.sleep(3L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "skillInfo";
    }

    /**
     * Before.
     */
    @Before
    public void before() {
        log.info("start");
        stopWatch.start();
    }

    /**
     * After.
     */
    @After
    public void after() {
        stopWatch.stop();
        log.info("end");
        // System.out.println("耗时= " + stopWatch.getTotalTimeSeconds());
        System.out.printf("耗时= %sS", stopWatch.getTotalTimeSeconds());
    }

    /**
     * 创建两个CompletableFuture执行异步任务
     */
    @SneakyThrows
    @Test
    public void testSupplyAsync() {
        //调用用户服务获取用户基本信息
        CompletableFuture<String> completableUserInfoFuture = CompletableFuture.supplyAsync(CompletableFutureTest::getUserInfo, fixedExecutorService);
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        CompletableFuture<String> completableSkillInfoFuture = CompletableFuture.supplyAsync(CompletableFutureTest::getSkillInfo);
        String userInfo = completableUserInfoFuture.get();
        log.info("userInfo ==> 【{}】", userInfo);
        String skillInfo = completableSkillInfoFuture.get();
        log.info("skillInfo ==> 【{}】", skillInfo);
        // CompletableFuture<Void> voidCompletableFuture = CompletableFuture.allOf(completableUserInfoFuture, completableSkillInfoFuture);

    }

    /**
     * allOf 等待所有的 CompletableFuture 结束。并且没有返回值
     */
    @SneakyThrows
    @Test
    public void testSupplyAsyncAndAllOf() {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start("testSupplyAsyncAndAllOf");
        //调用用户服务获取用户基本信息 1S
        CompletableFuture<String> completableUserInfoFuture = CompletableFuture.supplyAsync(CompletableFutureTest::getUserInfo, fixedExecutorService);
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        //这个3S
        CompletableFuture<String> completableSkillInfoFuture = CompletableFuture.supplyAsync(CompletableFutureTest::getSkillInfo);
        CompletableFuture<Void> voidCompletableFuture = CompletableFuture.allOf(completableUserInfoFuture, completableSkillInfoFuture);
        List<CompletableFuture<String>> completableFutureList = new ArrayList<>();
        completableFutureList.add(completableUserInfoFuture);
        completableFutureList.add(completableSkillInfoFuture);
        CompletableFuture<List<String>> completableFuture = voidCompletableFuture.thenApply(v -> {
            log.info("allOf ==> 【{}】", v);
            return completableFutureList.stream().map(CompletableFuture::join).collect(Collectors.toList());
        });
        stopWatch.stop();
        stopWatch.start("get");
        // 这里阻塞
        List<String> strings = completableFuture.get();
        System.out.println("strings = " + strings);
        stopWatch.stop();
        log.info("【testSupplyAsyncAndAllOf】::stopWatch.prettyPrint ==> 【{}】", stopWatch.prettyPrint());

    }

    /**
     * ThenRun方法
     * 做完第一个任务后，再做第二个任务。某个任务执行完成后，执行回调方法；但是前后两个任务没有参数传递，第二个任务也没有返回值
     */
    @SneakyThrows
    @Test
    public void testThenRun() {
        CompletableFuture<String> firstFuture = CompletableFuture.supplyAsync(() -> "first");
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        CompletableFuture<Void> thenRun = firstFuture.thenRun(() -> log.info("firstFuture thenRun"));
        log.info("firstFuture.get() ==> 【{}】", firstFuture.get());
        log.info("thenRun.get() ==> 【{}】", thenRun.get());
    }

    /**
     * thenAccept方法
     * 第一个任务执行完成后，执行第二个回调方法任务，会将该任务的执行结果，作为入参，传递到回调方法中，但是回调方法是没有返回值的。
     */
    @SneakyThrows
    @Test
    public void testThenAccept() {
        CompletableFuture<String> firstFuture = CompletableFuture.supplyAsync(() -> "first");
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        CompletableFuture<Void> thenAccept = firstFuture.thenAccept((s) -> {
            if (Objects.equals(s, "first")) {
                log.info("firstFuture thenAccept");
            } else {
                log.error("firstFuture thenAccept else");
            }
        });
        log.info("firstFuture.get() ==> 【{}】", firstFuture.get());
        log.info("thenAccept.get() ==> 【{}】", thenAccept.get());
    }

    /**
     * thenApply方法
     * 第一个任务执行完成后，执行第二个回调方法任务，会将该任务的执行结果，作为入参，传递到回调方法中，并且回调方法是有返回值的。
     */
    @SneakyThrows
    @Test
    public void testThenApply() {
        CompletableFuture<String> firstFuture = CompletableFuture.supplyAsync(() -> "first");
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        CompletableFuture<String> thenApply = firstFuture.thenApply((s) -> {
            if (Objects.equals(s, "first")) {
                return "thenApply success";
            } else {
                return "thenApply error";
            }
        });
        log.info("firstFuture.get() ==> 【{}】", firstFuture.get());
        log.info("thenApply.get() ==> 【{}】", thenApply.get());
    }

    // ###########################################################异常处理exceptionally和handle########################################

    /**
     * exceptionally方法
     * 某个任务执行异常时，执行的回调方法;并且有抛出异常作为参数，传递到回调方法。
     */
    @SneakyThrows
    @Test
    public void testExceptionally() {
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
                    throw new RuntimeException();
                })
                .exceptionally(ex -> "errorResultA")
                .thenApply(resultA -> resultA + " resultB")
                .thenApply(resultB -> resultB + " resultC")
                .thenApply(resultC -> resultC + " resultD");

        System.out.println(future.join());
    }

    /**
     * handle方法
     * handle 是执行任务完成时对结果的处理。
     * handle 方法和 thenApply 方法处理方式基本一样。不同的是 handle 是在任务完成后再执行，还可以处理异常的任务。thenApply 只可以执行正常的任务，任务出现异常则不执行 thenApply 方法。
     *
     * @throws Exception the exception
     */
    @Test
    public void handle() throws Exception {
        CompletableFuture<Integer> future = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                // int i = 10 / 0;
                return new Random().nextInt(10);
            }
        }).handle(new BiFunction<Integer, Throwable, Integer>() {
            @Override
            public Integer apply(Integer param, Throwable throwable) {
                int result = -1;
                if (throwable == null) {
                    result = param * 2;
                } else {
                    System.out.println(throwable.getMessage());
                }
                return result;
            }
        });
        System.out.println(future.get());
    }

    /**
     * whenComplete方法
     * whenComplete 方法是在任务完成后执行的回调方法。
     */
    @SneakyThrows
    @Test
    public void testWhenComplete() {
        CompletableFuture<String> firstFuture = CompletableFuture.supplyAsync(() -> {
            System.out.println("Thread.currentThread().getName() = " + Thread.currentThread().getName());
            return "firstFuture";
        });
        //模拟主线程其它操作耗时
        TimeUnit.SECONDS.sleep(2L);
        CompletableFuture<String> resFuture = firstFuture.whenComplete((a, throwable) -> {
            System.out.println("Thread.currentThread().getName() = " + Thread.currentThread().getName());
            System.out.println("上个任务执行完啦，还把" + a + "传过来");
        });
        // log.info("firstFuture.get() ==> 【{}】", firstFuture.get());
        log.info("resFuture.get() ==> 【{}】", resFuture.get());
    }

    /**
     * anyOf方法
     * runAfterEither
     */
    @SneakyThrows
    @Test
    public void testAnyOf() {
        // 两个CompletableFuture执行异步查询:
        CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "future1";
        });
        CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "future2";
        });
        // 用anyOf合并为一个新的CompletableFuture:
        CompletableFuture<Object> cfQuery = CompletableFuture.anyOf(future1, future2);
        // 两个CompletableFuture执行异步查询:
        CompletableFuture<Double> resFuture = cfQuery.thenApplyAsync((s) -> {
            return "future1".equals(s) ? 1.0 : 2.0;
        });
        log.info("future1.get() ==> 【{}】", future1.get());
        log.info("future2.get() ==> 【{}】", future2.get());
        log.info("resFuture.get() ==> 【{}】", resFuture.get());
    }

    /**
     * Run after either.
     */
    @Test
    public void runAfterEither() {
        // 两个CompletableFuture执行异步查询:
        CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "future1";
        });
        CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "future2";
        });
        CompletableFuture<Void> voidCompletableFuture = future1.runAfterEither(future2, () -> {
            log.info("有一个已经完成了。。。。。");
        });
        voidCompletableFuture.join();
    }


    /**
     * thenCombine 会把 两个 CompletionStage 的任务都执行完成后，把两个任务的结果一块交给 thenCombine 来处理
     *
     * @throws Exception the exception
     */
    @Test
    public void thenCombine() throws Exception {
        CompletableFuture<String> future1 = CompletableFuture.supplyAsync(new Supplier<String>() {
            @Override
            public String get() {
                try {
                    TimeUnit.SECONDS.sleep(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                return "hello future1";
            }
        });
        CompletableFuture<String> future2 = CompletableFuture.supplyAsync(new Supplier<String>() {
            @Override
            public String get() {
                return "hello future2";
            }
        });
        CompletableFuture<String> result = future1.thenCombine(future2, new BiFunction<String, String, String>() {
            @Override
            public String apply(String t, String u) {
                try {
                    TimeUnit.SECONDS.sleep(2);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                return t + " " + u;
            }
        });
        System.out.println(result.get());
    }

    /**
     * 当两个CompletionStage都执行完成后，把结果一块交给thenAcceptBoth来进行消耗
     */
    @Test
    public void thenAcceptBoth() {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 1;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f1=" + t);
                return t;
            }
        });

        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 2;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f2=" + t);
                return t;
            }
        });
        CompletableFuture<Void> voidCompletableFuture = f1.thenAcceptBoth(f2, new BiConsumer<Integer, Integer>() {
            @Override
            public void accept(Integer t, Integer u) {
                System.out.println("f1=" + t + ";f2=" + u + ";");
            }
        });
        try {
            voidCompletableFuture.get();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }


    /**
     * Apply to either.
     *
     * @throws Exception the exception
     */
    @Test
    public void applyToEither() throws Exception {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 2;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f1=" + t);
                return t;
            }
        });
        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 3;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f2=" + t);
                return t;
            }
        });

        CompletableFuture<Integer> result = f1.applyToEither(f2, new Function<Integer, Integer>() {
            @Override
            public Integer apply(Integer t) {
                System.out.println(t);
                return t * 2;
            }
        });

        System.out.println(result.get());
    }

    /**
     * Accept either. 两个CompletionStage，谁执行返回的结果快，
     *
     * @throws Exception the exception
     */
    @Test
    public void acceptEither() throws Exception {
        CompletableFuture<Integer> f1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 2;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f1=" + t);
                return t;
            }
        });
        CompletableFuture<Integer> f2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
            @Override
            public Integer get() {
                int t = 3;
                try {
                    TimeUnit.SECONDS.sleep(t);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("f2=" + t);
                return t;
            }
        });

        CompletableFuture<Void> result = f1.acceptEither(f2, new Consumer<Integer>() {
            @Override
            public void accept(Integer t) {
                System.out.println(t);
            }
        });
        log.info("【acceptEither】::result.get() ==> 【{}】", result.get());
    }
}


```

```java
package com.xiaobu.juc.CompletableFuture;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.*;

/**
 * @author xiaobu
 * @className CompletableFutureTest.java
 * @createTime 2022年05月06日 10:07:00
 * whenComplete回调不会阻塞主线程
 * Future 会阻塞主线程
 */
@Slf4j
public class CompletableFutureDemo3 {
    public static ExecutorService fixedExecutorService = Executors.newFixedThreadPool(5);

    public static void main(String[] args) throws Exception {
        try {
            futureTest();
            completableFutureTest();
            log.info("【main】::主线程 ");
            TimeUnit.SECONDS.sleep(5);
        } finally {
            fixedExecutorService.shutdown();
        }

    }

    private static void completableFutureTest() {
        log.info("【main】:: CompletableFuture start!");
        CompletableFuture.supplyAsync(() -> {
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return "CompletableFuture finished";
        }).whenComplete((r, t) -> {
            log.info("【main】::r ==> [{}],t ==> [{}]", r, t);
        });
    }

    private static void futureTest() throws InterruptedException, ExecutionException {
        log.info("【main】::Future start!");
        Future<?> future = fixedExecutorService.submit(() -> {
            TimeUnit.SECONDS.sleep(1);
            return "Future finished";
        });
        log.info("【main】::future.get() ==> [{}]", future.get());
    }


}


```

参考：
[CompletableFuture 使用详解](https://www.jianshu.com/p/6bac52527ca4) 