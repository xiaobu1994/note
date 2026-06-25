# 原子操作类AtomicInteger

> 原创 最新推荐文章于 2024-01-15 11:42:59 发布 · 公开 · 478 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86293237

一、普通的int型自增长测试

```java
package AtomicInteger;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/8/7 16:15
 */
public class IntValueIncrementTest {

    public static void main(String[] args) throws InterruptedException {
        intValueIncrement();
        Thread.sleep(5000);
        //39991 <40000
        System.out.println("最终的结果："+value);
    }

    private static int value=0;



    public static  synchronized void intValueIncrement(){
        ExecutorService service = Executors.newFixedThreadPool(10000);
        for(int i=0;i<10000;i++){
         service.execute(()->{
             for(int j=0;j<4;j++){
                 System.out.println(value++);
             }
         });
        }
    }
}
```

二、用volatile修饰的int自增长类型。

```java
package AtomicInteger;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/8/7 16:15
 */
public class IntVolatileValueIncrementTest {

    public static void main(String[] args) throws InterruptedException {
        intValueIncrement();
        Thread.sleep(5000);
        // 39993 <4000
        System.out.println("最终的结果：" + value);
    }
    private static volatile int value = 0;
    public static synchronized void intValueIncrement() {
        ExecutorService service = Executors.newFixedThreadPool(10000);
        for (int i = 0; i < 10000; i++) {
            service.execute(() -> {
                for (int j = 0; j < 4; j++) {
                    System.out.println(value++);
                }
            });
        }
    }
}
```

三、AtomicInteger原子操作类类型

```java
package AtomicInteger;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/8/7 16:08
 */
public class AtomicIntegerTest {
    public static final AtomicInteger atomicInteger = new AtomicInteger(0);

    public static void main(String[] args) throws InterruptedException {
        atomicIntegerTest();
        Thread.sleep(3000);
        //40000
        System.out.println("最终结果是" + atomicInteger.get());
    }

    private  static void atomicIntegerTest() {
        ExecutorService executorService = Executors.newFixedThreadPool(10000);
        for (int i = 0; i < 10000; i++) {
            executorService.execute(() -> {
                for (int j = 0; j < 4; j++) {
                    System.out.println(atomicInteger.getAndIncrement());
                }
            });
        }
        executorService.shutdown();
    }
}
```

---

```
volatile的作用：
```

1.保证此变量对所有的线程的可见性


2.禁止指令重排序优化。


结果表明还是会存在并发的问题。因为java的运算（自增）不是原子性的。



CAS(Compare And Swap  比较并交换 ) 的并发算法称为 无锁定算法所以不阻塞。

可以避免多线程的优先级倒置和死锁情况的发生，提升在高并发处理下的性能。