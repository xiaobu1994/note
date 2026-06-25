# LockSupport中的park() 和 unpark()与Object中的wait()和notify()

> 原创 最新推荐文章于 2025-10-28 22:01:20 发布 · 公开 · 326 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/101444258

```java
package com.demo.Interruput;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/9/25 17:36
 * @description 说明：park和wait的区别。wait让线程阻塞前，必须通过synchronized获取同步锁。
 */
public class WaitTest {

    public static void main(String[] args) {
        ThreadA threadA = new ThreadA("A");
        synchronized (threadA){
            try {
                System.out.println(Thread.currentThread().getName() + " start");
                threadA.start();
                System.out.println(Thread.currentThread().getName() + " block");
                threadA.wait();
                System.out.println(Thread.currentThread().getName() + " continue");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }

    static class ThreadA extends Thread{

        public ThreadA(){}
        public ThreadA(String name){
            super(name);
        }

        @Override
        public void run() {
            synchronized (this){
                System.out.println("通知notify");
                notify();
            }
        }
    }
}

```

```java
package com.demo.Interruput;

import java.util.concurrent.locks.LockSupport;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/9/25 17:36
 * @description
 */
public class LockSupportTest {

    private static Thread mainThread;

    public static void main(String[] args) {
        ThreadA threadA = new ThreadA("A");
        mainThread = Thread.currentThread();
        System.out.println(Thread.currentThread().getName() + " start");
        threadA.start();
        System.out.println(Thread.currentThread().getName() + " block");
        LockSupport.park(mainThread);
        System.out.println(Thread.currentThread().getName() + " continue");
    }

    static class ThreadA extends Thread {

        public ThreadA() {
        }

        public ThreadA(String name) {
            super(name);
        }

        @Override
        public void run() {
            System.out.println(Thread.currentThread().getName() + " wakeup others");
            LockSupport.unpark(mainThread);
        }
    }
}

```