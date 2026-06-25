# 记录一次GC:overhead limit exceeded

> 原创 于 2019-05-22 17:36:37 发布 · 公开 · 2.7k 阅读 · 0 · 4 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/90448491

## 堆内存参数

> 1、-Xms ：表示java虚拟机堆区内存初始内存分配的大小，通常为操作系统可用内存的1/64大小即可，但仍需按照实际情况进行分配。有可能真的按照这样的一个规则分配时，设计出的软件还没有能够运行得起来就挂了。
> 2、-Xmx： 表示java虚拟机堆区内存可被分配的最大上限，通常为操作系统可用内存的1/4大小。但是开发过程中，通常会将 -Xms 与 -Xmx两个参数的配置相同的值，其目的是为了能够在java垃圾回收机制清理完堆区后不需要重新分隔计算堆区的大小而浪费资源。
> 一般来讲对于堆区的内存分配只需要对上述两个参数进行合理配置即可，但是如果想要进行更加精细的分配还可以对堆区内存进一步的细化，那就要用到下面的三个参数了-XX:newSize、-XX:MaxnewSize、-Xmn。当然这源于对堆区的进一步细化分：新生代、中生代、老生代。java中每新new一个对象所占用的内存空间就是新生代的空间，当java垃圾回收机制对堆区进行资源回收后，那些新生代中没有被回收的资源将被转移到中生代，中生代的被转移到老生代。而接下来要讲述的三个参数是用来控制新生代内存大小的。

tomcat下catalina.bat文件设置

```
set JAVA_OPTS=-Xms512m -Xmx1024m
```

## 新生代参数

> 1、-XX:newSize：表示新生代初始内存的大小，应该小于 -Xms的值；
> 2、-XX:MaxnewSize：表示新生代可被分配的内存的最大上限；当然这个值应该小于 -Xmx的值；
> 3、-Xmn：至于这个参数则是对 -XX:newSize、-XX:MaxnewSize两个参数的同时配置，也就是说如果通过-Xmn来配置新生代的内存大小，那么-XX:newSize = -XX:MaxnewSize = -Xmn，虽然会很方便，但需要注意的是这个参数是在JDK1.4版本以后才使用的。Sun官方推荐配置为整个堆的3/8。

> 上面所述即为java虚拟机对外提供的可配置堆区的参数，接下来讲述java虚拟机对非堆区内存配置的两个参数：

## 非堆区内存参数 方法区(永久代)jdk8之后移除

> 1、-XX:PermSize：表示非堆区初始内存分配大小，其缩写为permanent size（持久化内存）
> 2、-XX:MaxPermSize：表示对非堆区分配的内存的最大上限。

> 这里面非常要注意的一点是：在配置之前一定要慎重的考虑一下自身软件所需要的非堆区内存大小，因为此处内存是不会被java垃圾回收机制进行处理的地方。并且更加要注意的是 最大堆内存与最大非堆内存的和绝对不能够超出操作系统的可用内存。

## 元空间参数设置 jdk8增加

```
-XX:MetaspaceSize=N //设置 Metaspace 的初始（和最小大小）
-XX:MaxMetaspaceSize=N //设置 Metaspace 的最大大小
```

### GC overhead limit exceeded

> GC占用了多余98%（默认值）的CPU时间却只回收了少于2%（默认值）的堆空间。目的是为了让应用终止，给开发者机会去诊断问题。一般是应用程序在有限的内存上创建了大量的临时对象或者弱引用对象，从而导致该异常。虽然加大内存可以暂时解决这个问题，但是还是强烈建议去优化代码，后者更加有效。

### windows下设置tomcat的JVM的内存大小以及内存快照

在tomcat的bin目录下catalina.bat设置参数

1. -XX:+HeapDumpOnOutOfMemoryError

> 可以让JVM在出现内存溢出时Dump出当前的内存转储快照。

1. -XX:HeapDumpPath=D:/heapdump

> 内存快照文件的存储路径

```
set JAVA_OPTS=-Xms50m -Xmx50m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=D:/heapdump
```

### 使用JProfiler进行内存分析

方法一、

1. 下载 [JProfiler](https://www.ej-technologies.com/products/jprofiler/overview.html)

2. 用JProfiler打开.hprof文件,操作步骤如下
   2.1. 段落标题选择大对象，然后点击show in Graph
    ![1](./assets/2_1.jpeg)

   2.2. 定位内存泄露的位置
    ![2](./assets/2_2.jpeg)

    ![3](./assets/2_3.jpeg)

3. 错误代码展示
    ![1558517472(1)](./assets/2_4.jpeg)

方法二、
选择Biggest Objects右键选择Use Selected Instances再选择 Incommingreference
 ![4](./assets/2_5.jpeg)

### 使用JProfiler搭配idea分析项目

1. 配置JProfiler软件
    ![1](./assets/2_6.jpeg)

2. 使用JProfiler启动项目
    ![2](./assets/2_7.jpeg)

### 使用jmap来生成dump文件

> [pid] ==>2844

```java
jmap -dump:format=b,file=D:/heapdump/726.hprof 2844
```

### 使用jstat分析应用程序的资源和性能的情况

> [jvm 性能调优工具之 jstat](https://www.jianshu.com/p/213710fb9e40) 

