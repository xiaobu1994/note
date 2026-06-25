# JVM--GC相关记录

> 原创 于 2022-12-20 10:43:01 发布 · 公开 · 512 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/128381749

针对 HotSpot VM 的实现，它里面的 GC 其实准确分类只有两大种：

部分收集 (Partial GC)：

- 新生代收集（Minor GC / Young GC）：只对新生代进行垃圾收集；

- 老年代收集（Major GC / Old GC）：只对老年代进行垃圾收集。需要注意的是 Major GC 在有的语境中也用于指代整堆收集； 混合收集（Mixed GC）：对整个新生代和部分老年代进行垃圾收集。

- 整堆收集 (Full GC)：收集整个 Java 堆和方法区。

#### 这是JDK1.8默认收集器

命令查看

```shell
java -XX:+PrintCommandLineFlags -version
```

结果:

```shell
java -XX:+PrintCommandLineFlags -version
-XX:InitialHeapSize=255449920 -XX:MaxHeapSize=4087198720 -XX:+PrintCommandLineFlags -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation -XX:+UseParallelGC
java version "1.8.0_351"
Java(TM) SE Runtime Environment (build 1.8.0_351-b10)
Java HotSpot(TM) 64-Bit Server VM (build 25.351-b10, mixed mode)
```

jdk1.8 默认垃圾收集器ParallelScavenge（新生代）+Parallel Old（老年代）

- 新生代:Eden 空间、From Survivor0(“From”) 区、To Survivor1(“To”) 区 占堆的1/3

- Eden、From、To区默认比例是8:1:1

- 老年代： 占堆的2/3

### GC(Allocation Failure) 日志分析

> GC(Allocation Failure)是因为在年轻代中没有足够的空间能够存储新的数据了。

```shell
10.240: [GC (Allocation Failure) [PSYoungGen: 2097664K->55234K(2446848K)] 2182542K->140129K(8039424K), 0.1030998 secs] [Times: user=1.57 sys=0.12, real=0.10 secs] 
```

> 10.240:虚拟机运行了 110.240s

> PSYoungGen: 2097664K->55234K(2446848K) 年轻代减少了 2097664-55234=2,042,430K 年轻代的总大小：2446848K

> 2182542K->140129K(8039424K)  堆由2182542-140129=2,042,413K 总堆大小：8039424K

2,042,430-2,042,413=17K 表明17K的内存由年轻代转移到了老年代

> 0.1030998 secs 表明该内存区域GC耗时

[Times: user=1.57sys=0.12, real=0.10 secs]

> user=1.57 CPU工作在用户态所花费的时间, sys=0.12 CPU工作在内核态所花费的时间, real=0.10 secs 此次GC事件中所花费的总时间

```shell
[Full GC (Ergonomics) [PSYoungGen: 932352K->685805K(1864192K)] [ParOldGen: 5592278K->5592278K(5592576K)] 6524630K->6278084K(7456768K), [Metaspace: 107385K->107385K(1150976K)], 8.6867896 secs] [Times: user=447.43 sys=4.52, real=8.69 secs] 
```

PSYoungGen: 932352K->685805K(1864192K)   新生代由932352-685805=246,547K 新生代总大小为1864192K

ParOldGen: 5592278K->5592278K(5592576K)   老年代由5592278-5592278=0 老年代总大小为5592576K

6524630K->6278084K(7456768K)  堆大小由6524630-6278084=246,546K 总堆大小为7456768K

新生代减少的减去堆总共减少的246,547-246,546=1K 即为新生代移到了老年代的内存

老年代已经放不下新的对象了，导致FULL GC。

- real：指的是在此次GC事件中所花费的总时间；

- user：指的是CPU工作在用户态所花费的时间；

- sys：指的是CPU工作在内核态所花费的时间。

#### JVM配置

```shell
-Xms8g -Xmx8g -XX:MetaspaceSize=1g  XX:+PrintGCDetails -XX:+PrintGCApplicationStoppedTime -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${LOG_PATH} -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=50M -XX:+PrintGCTimeStamps -Xloggc:${LOG_PATH}${GC_LOG}
```

#### 显示Java堆的如下信息

```shell
jmap -heap pid
```

```text
Heap Configuration:
MinHeapFreeRatio         = 0
MaxHeapFreeRatio         = 100
MaxHeapSize              = 12884901888 (12288.0MB)
NewSize                  = 4294967296 (4096.0MB)
MaxNewSize               = 4294967296 (4096.0MB)
OldSize                  = 8589934592 (8192.0MB)
NewRatio                 = 2
SurvivorRatio            = 8
MetaspaceSize            = 1073741824 (1024.0MB)
CompressedClassSpaceSize = 1073741824 (1024.0MB)
MaxMetaspaceSize         = 17592186044415 MB
G1HeapRegionSize         = 0 (0.0MB)

Heap Usage:
PS Young Generation
Eden Space:
capacity = 3221225472 (3072.0MB)
used     = 1827898984 (1743.220314025879MB)
free     = 1393326488 (1328.779685974121MB)
56.745452930529915% used
From Space:
capacity = 536870912 (512.0MB)
used     = 72443664 (69.08766174316406MB)
free     = 464427248 (442.91233825683594MB)
13.493683934211731% used
To Space:
capacity = 536870912 (512.0MB)
used     = 0 (0.0MB)
free     = 536870912 (512.0MB)
0.0% used
PS Old Generation
capacity = 8589934592 (8192.0MB)
used     = 134181224 (127.9651870727539MB)
free     = 8455753368 (8064.034812927246MB)
1.562075037509203% used

36483 interned Strings occupying 3541232 bytes.
```

#### 显示堆各个区域内存使用和垃圾回收的统计信息

```shell
jstat -gc pid
```

结果：

> S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU    CCSC   CCSU   YGC     YGCT    FGC    FGCT     GCT
> 
> 40960.0 3584.0  0.0   3456.0 422912.0 160413.2  699392.0   51690.4   77568.0 73798.3 9472.0 8810.5     23    0.705   0      0.000    0.705

-gc选项

- S0C：年轻代中第一个Survivor区的容量，单位为KB。

- S1C：年轻代中第二个Survivor区的容量，单位为KB。

- S0U：年轻代中第一个Survivor区已使用大小，单位为KB。

- S1U：年轻代中第二个Survivor区已使用大小，单位为KB。

- EC：年轻代中Eden区的容量，单位为KB。

- EU：年轻代中Eden区已使用大小，单位为KB。

- OC：老年代的容量，单位为KB。

- OU：老年代已使用大小，单位为KB。

- MC：元空间的容量，单位为KB。

- MU：元空间已使用大小，单位为KB。

- CCSC：压缩类的容量，单位为KB。

- CCSU：压缩类已使用大小，单位为KB。

- YGC：Young GC的次数。

- YGCT：Young GC所用的时间。

- FGC：Full GC的次数。

- FGCT：Full GC的所用的时间。

- GCT：GC的所用的总时间。

### 打印当前指定java进程中已经设定的所有JVM参数信息

```shell
jinfo -flags pid
```

结果：

```text
Non-default VM flags: -XX:CICompilerCount=18 -XX:GCLogFileSize=52428800 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=null -XX:InitialHeapSize=17179869184 -XX:MaxHeapSize=17179869184 -XX:MaxNewSize=5726273536 -XX:MetaspaceSize=2147483648 -XX:MinHeapDeltaBytes=524288 -XX:NewSize=5726273536 -XX:NumberOfGCLogFiles=10 -XX:OldSize=11453595648 -XX:+PrintGC -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseFastUnorderedTimeStamps -XX:+UseParallelGC
Command line:  -Xms16g -Xmx16g -XX:MetaspaceSize=2g -Djava.awt.headless=false -XX:+PrintGCDetails -XX:+PrintGCApplicationStoppedTime -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/log/ymsadmin/dev/ -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=50M -XX:+PrintGCTimeStamps -Xloggc:/log/admin/dev/test-service-gc.log
```