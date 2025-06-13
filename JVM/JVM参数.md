## JVM参数

```text
-XX:MetaspaceSize=128m （元空间默认大小）
-XX:MaxMetaspaceSize=128m （元空间最大大小）
-Xms1024m （堆默认大小）
-Xmx1024m （堆最大大小）
-Xmn256m （新生代大小）
-Xss256k （棧最大深度大小）
-XX:SurvivorRatio=8 （新生代分区比例 8:2）
-XX:+UseConcMarkSweepGC （指定使用的垃圾收集器，这里使用CMS收集器）
-XX:+PrintGCDetails （打印详细的GC日志） 
XX:+HeapDumpOnOutOfMemoryError （参数表示当JVM发生OOM时，自动生成DUMP文件） 
-XX:HeapDumpPath=D: （将heapdump文件存放在D盘） 
```

## idea java类设置 java options

![1.jpg](http://ww1.sinaimg.cn/large/0062Ue2Wgy1gtp8uwibo5j60w20gmtfu02.jpg)

![2.jpg](http://ww1.sinaimg.cn/large/0062Ue2Wgy1gtp8z01dvsj60mb0cddjr02.jpg)

![3.jpg](http://ww1.sinaimg.cn/large/0062Ue2Wgy1gtp8z7hpuvj60y80gqqay02.jpg)

## SpringBoot 启动参数设置

> SpringBoot会用JVM自身默认的配置策略。默认情况下 最大堆内存占用物理内存的1/4，如果应用程序超过该上限，则会抛出OutOfMemoryError异常。初始堆内存大小为物理内存的1/64。

> 如果应用程序运行在手机上或物理内存小于192M时，最大堆内存为物理内存的1/2，初始堆内存大小为物理内存的1/64， 但当初始堆内存最小为8MB，则为8MB。

> 默认空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制；空余堆内存大于70%时，JVM会减少堆直到 -Xms的最小限制。因

## idea设置java options

```text
-XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=128m -Xms1024m -Xmx1024m -Xmn256m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC
```

## idea设置java options

```text
-Xms5m -Xmx5m -XX:+HeapDumpOnOutOfMemoryError -XX:+HeapDumpOnOutOfMemoryError  -XX:HeapDumpPath=D:
```

## 启动jar

```text
java -jar -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=128m -Xms1024m -Xmx1024m -Xmn256m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC newframe-1.0.0.jar
```

## 查看系统默认内存设置

linux

```text
java -XX:+PrintFlagsFinal -version | grep HeapSize
```

window

```text
java -XX:+PrintFlagsFinal -version | findstr HeapSize
```




