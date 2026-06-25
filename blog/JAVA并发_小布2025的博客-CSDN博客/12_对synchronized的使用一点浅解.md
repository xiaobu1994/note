# 对synchronized的使用一点浅解

> 原创 最新推荐文章于 2023-02-10 23:00:27 发布 · 公开 · 246 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/106944036

synchronized是Java中的关键字，是一种同步锁。它修饰的对象有以下几种：

1. 修饰一个代码块，被修饰的代码块称为同步语句块，其作用的范围是大括号{}括起来的代码，作用的对象是调用这个代码块的对象；

2. 修饰一个方法，被修饰的方法称为同步方法，其作用的范围是整个方法，作用的对象是调用这个方法的对象；

3. 修改一个静态的方法，其作用的范围是整个静态方法，作用的对象是这个类的所有对象；

4. 修改一个类，其作用的范围是synchronized后面括号括起来的部分，作用主的对象是这个类的所有对象。

一、修饰代码块

```java
package com.xiaobu.synchronizedTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description  一个线程访问一个对象中的synchronized(this)同步代码块时，其他试图访问该对象的线程将被阻塞。
 */
public class SyncThreadDemo1 implements Runnable {
      private static int count;

    public SyncThreadDemo1() {
        count = 0;
    }

    public  void run() {
        synchronized(this) {
            for (int i = 0; i < 5; i++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count++));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }



    /**
     * SyncThread1:0
     * SyncThread1:1
     * SyncThread1:2
     * SyncThread1:3
     * SyncThread1:4
     * SyncThread2:5
     * SyncThread2:6
     * SyncThread2:7
     * SyncThread2:8
     * SyncThread2:9
     */
    public static void main(String[] args) {
        SyncThreadDemo1 syncThread = new SyncThreadDemo1();
        Thread thread1 = new Thread(syncThread,"SyncThread1");
        Thread thread2 = new Thread(syncThread, "SyncThread2");
        thread1.start();
        thread2.start();
    }
}
```

```java
package com.xiaobu.synchronizedTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description 锁不同的对象
 */
public class SyncThreadDemo2 implements Runnable {
      private static int count;

    public SyncThreadDemo2() {
        count = 0;
    }

    public  void run() {
        synchronized(this) {
            for (int i = 0; i < 5; i++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count++));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    /**
     * SyncThread2:0
     * SyncThread1:1
     * SyncThread2:2
     * SyncThread1:2
     * SyncThread2:3
     * SyncThread1:4
     * SyncThread2:5
     * SyncThread1:5
     * SyncThread1:6
     * SyncThread2:6
     * synchronized锁定的是对象，这时会有两把锁分别锁定syncThread1对象和syncThread2对象，
     * 而这两把锁是互不干扰的，不形成互斥，所以两个线程可以同时执行
     */
    public static void main(String[] args) {
        Thread thread1 = new Thread(new SyncThreadDemo2(),"SyncThread1");
        Thread thread2 = new Thread(new SyncThreadDemo2(), "SyncThread2");
        thread1.start();
        thread2.start();
    }
}
```

```java
package com.xiaobu.synchronizedTest;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description
 */
public class SyncThreadAtomicIntegerDemo implements Runnable {
    private static AtomicInteger count;

    public SyncThreadAtomicIntegerDemo() {
        count = new AtomicInteger(0);
    }

    @Override
    public  void run() {
        synchronized(this) {
            for (int i = 0; i < 5; i++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count.incrementAndGet()));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * SyncThread1:1
     * SyncThread2:2
     * SyncThread1:3
     * SyncThread2:4
     * SyncThread1:5
     * SyncThread2:6
     * SyncThread1:7
     * SyncThread2:8
     * SyncThread1:9
     * SyncThread2:10
     * 
     * 原本是线程不安全的 AtomicInteger是原子类 导致数据的安全性
     */
    public static void main(String[] args) {
        SyncThreadAtomicIntegerDemo syncThread = new SyncThreadAtomicIntegerDemo();
        Thread thread1 = new Thread(new SyncThreadAtomicIntegerDemo(),"SyncThread1");
        Thread thread2 = new Thread(new SyncThreadAtomicIntegerDemo(), "SyncThread2");
        thread1.start();
        thread2.start();
    }
}
```

二、多个线程访问synchronized和非synchronized代码块

```java
package com.xiaobu.synchronizedTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description
 * countAdd是一个synchronized的，printCount是非synchronized的。
 * 从上面的结果中可以看出一个线程访问一个对象的synchronized代码块时，
 * 别的线程可以访问该对象的非synchronized代码块而不受阻塞。
 */
public class SyncThreadCounter implements Runnable {
    private int count;

    public SyncThreadCounter() {
        count = 0;
    }

    public void countAdd() {
        synchronized(this) {
            for (int i = 0; i < 5; i ++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count++));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    //非synchronized代码块，未对count进行读写操作，所以可以不用synchronized
    public void printCount() {
        for (int i = 0; i < 5; i ++) {
            try {
                System.out.println(Thread.currentThread().getName() + " count:" + count);
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public void run() {
        String threadName = Thread.currentThread().getName();
        if (threadName.equals("A")) {
            countAdd();
        } else if (threadName.equals("B")) {
            printCount();
        }
    }

    /**
     * B count:0
     * A:0
     * B count:1
     * A:1
     * B count:2
     * A:2
     * A:3
     * B count:4
     * A:4
     * B count:5
     */
    public static void main(String[] args) {
        SyncThreadCounter counter = new SyncThreadCounter();
        Thread thread1 = new Thread(counter, "A");
        Thread thread2 = new Thread(counter, "B");
        thread1.start();
        thread2.start();
    }
}
```

三、指定要给某个对象加锁

当有一个明确的对象作为锁时，就可以用类似下面这样的方式写程序。

```java
public void method3(SomeObject obj)
{
   //obj 锁定的对象
   synchronized(obj)
   {
      // todo
   }
}

```

当没有明确的对象作为锁，只是想让一段代码同步时，可以创建一个特殊的对象来充当锁：

```java
class Test implements Runnable
{
   private byte[] lock = new byte[0];  // 特殊的instance变量
   public void method()
   {
      synchronized(lock) {
         // todo 同步代码块
      }
   }

   public void run() {

   }
}
```

> 说明：零长度的byte数组对象创建起来将比任何对象都经济――查看编译后的字节码：生成零长度的byte[]对象只需3条操作码，而Object lock = new Object()则需要7行操作码。

四、修饰一个方法

```java
public synchronized void method()
{
   // todo
}
```

<==>等价于

```java

public  void method()
{
    synchronized(this){
       // todo
    }
}
```

修饰静态方法

```java
package com.xiaobu.synchronizedTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description  synchronized 修饰静态方法相当于锁的对象是类的实例，即锁定的是这个类的所有对象
 */
public class SyncThreadStaticDemo1 implements Runnable {
      private static int count;

    public SyncThreadStaticDemo1() {
        count = 0;
    }

    public static synchronized void method() {
            for (int i = 0; i < 5; i++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count++));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
    }


    @Override
    public void run() {
        method();
    }

    /**
     * SyncThread1:0
     * SyncThread1:1
     * SyncThread1:2
     * SyncThread1:3
     * SyncThread1:4
     * SyncThread2:5
     * SyncThread2:6
     * SyncThread2:7
     * SyncThread2:8
     * SyncThread2:9
     */
    public static void main(String[] args) {
        SyncThreadStaticDemo1 syncThread = new SyncThreadStaticDemo1();
        Thread thread1 = new Thread(syncThread,"SyncThread1");
        Thread thread2 = new Thread(syncThread, "SyncThread2");
        thread1.start();
        thread2.start();
    }
}
```

五、修饰一个类

```java
package com.xiaobu.synchronizedTest;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/24 10:53
 * @description  synchronized 修饰类，即锁定的是这个类的所有对象
 */
public class SyncThreadStaticDemo2 implements Runnable {
      private static int count;

    public SyncThreadStaticDemo2() {
        count = 0;
    }

    public static void method() {
        synchronized (SyncThreadStaticDemo2.class){
            for (int i = 0; i < 5; i++) {
                try {
                    System.out.println(Thread.currentThread().getName() + ":" + (count++));
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    @Override
    public void run() {
        method();
    }

    /**
     * SyncThread1:0
     * SyncThread1:1
     * SyncThread1:2
     * SyncThread1:3
     * SyncThread1:4
     * SyncThread2:5
     * SyncThread2:6
     * SyncThread2:7
     * SyncThread2:8
     * SyncThread2:9
     */
    public static void main(String[] args) {
        SyncThreadStaticDemo2 syncThread = new SyncThreadStaticDemo2();
        Thread thread1 = new Thread(syncThread,"SyncThread1");
        Thread thread2 = new Thread(syncThread, "SyncThread2");
        thread1.start();
        thread2.start();
    }
}
```

> SyncThreadStaticDemo1和SyncThreadStaticDemo2是等价的

参考:

[Java中Synchronized的用法](https://blog.csdn.net/luoweifu/article/details/46613015) 