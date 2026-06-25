# synchronized实现原理

> 原创 最新推荐文章于 2025-09-02 23:50:44 发布 · 公开 · 179 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86082640

一、synchronized作用于实例方法。

```java
package com.xiaobu.note.Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/8 16:15
 * @description V1.0  synchronized作用于实例方法 同一个对象
 */
public class Demo1 implements Runnable{
    private static int count;

    private synchronized void increase(){
        count++;
    }
    @Override
    public void run() {
        for (int i=0;i<50000;i++){
           increase();
        }

    }

    /**
     * 结果：count = 100000
     * 两个线程访问的同一个对象
     * 只有执行完该代码块才能释放该对象锁，下一个线程才能执行并锁定该对象。
     */
    public static void main(String[] args) throws InterruptedException {
        Demo1 instance = new Demo1();
        Thread thread1 = new Thread(instance);
        Thread thread2 = new Thread(instance);
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        System.out.println("count = " + count);

    }
}
```

二、修饰实例方法。

```java
package Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/8 16:15
 * @description V1.0  synchronized作用于实例方法 不同的对象
 */
public class Demo2 implements Runnable{
    private static int count;

    private synchronized void increase(){
        count++;
    }
    @Override
    public void run() {
        for (int i=0;i<50000;i++){
           increase();
        }

    }

    /**
     * 结果：count = 86136
     *虽然使用synchronized修饰了increase方法，但却new了两个不同的实例对象，
     * 这也就意味着存在着两个不同的实例对象锁
     */
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(new Demo2());
        Thread thread2 = new Thread(new Demo2());
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        System.out.println("count = " + count);

    }
}
```

三、修饰静态实例方法。

```java
package Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/8 16:15
 * @description V1.0  synchronized作用于静态实例方法 同个对象(类的class对象)
 */
public class Demo3 implements Runnable{
    private static int count;

    private synchronized static void increase(){
        count++;
    }
    @Override
    public void run() {
        for (int i=0;i<50000;i++){
           increase();
        }

    }

    /**
     * 结果：count = 100000
     *访问静态 synchronized 方法占用的锁是当前类的class对象
     * 而访问非静态 synchronized 方法占用的锁是当前实例对象锁
     */
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(new Demo3());
        Thread thread2 = new Thread(new Demo3());
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        System.out.println("count = " + count);

    }
}
```

四、修饰同步代码块。

```java
package Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/8 16:15
 * @description V1.0  synchronized作用于同步代码块 效果与demo1等价
 */
public class Demo4 implements Runnable{
    private static final Demo4 instance = new Demo4();
    private static int count;

    @Override
    public void run() {
        //将instance改成this也是一样的效果
        synchronized (instance){
            for (int i=0;i<50000;i++){
                count++;
            }
        }


    }

    /**
     * 结果：count = 100000
     */
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(instance);
        Thread thread2 = new Thread(instance);
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        System.out.println("count = " + count);

    }
}
```



```java
package Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/8 16:15
 * @description V1.0  synchronized作用于同步代码块 效果与demo2等价
 */
public class Demo5 implements Runnable{
    private static int count;

    @Override
    public void run() {
        //将instance改成this也是一样的效果
        synchronized (Demo5.class){
            for (int i=0;i<50000;i++){
                count++;
            }
        }


    }

    /**
     * 结果：count = 100000
     */
    public static void main(String[] args) throws InterruptedException {
        Thread thread1 = new Thread(new Demo5());
        Thread thread2 = new Thread(new Demo5());
        thread1.start();
        thread2.start();
        thread1.join();
        thread2.join();
        System.out.println("count = " + count);

    }
}
```



```java
package com.xiaobu.JUC.Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/9/25 14:05
 * @description 如果一个类中定义了一个synchronized的static函数A，
 *  也定义了一个synchronized的instance函数B，
 *  那么这个类的同一对象Obj,在多线程中分别访问A和B两个方法时，不会构成同步，
 *  因为它们的锁都不一样。B方法的锁是Obj这个对象，而A的锁是Obj所属的那个Class。
 */
public class SynchronizedDemo {

    /**
     *定义一个synchronized的static函数A
     */
    public static synchronized  void A(){

    }


    /**
     *定义一个synchronized的instance函数B
     */
    public  synchronized  void B(){

    }

}
```

验证 synchronized为可重入锁

```java
package com.xiaobu.JUC.Synchronized;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/9/24 16:37
 * @description 验证 synchronized为可重入锁
 */
public class ReentrantTest {
    public static void main(String[] args) {
/*
  A
  B
 */
        A();
    }

    public static synchronized void A() {
        System.out.println("A");
        B();
    }

    public static synchronized void B() {
        System.out.println("B");
    }


}
```