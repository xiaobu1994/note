# linux cpu飙高排查

> 原创 于 2023-03-08 15:33:31 发布 · 公开 · 609 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/129404707

linux定位cpu飙高原因

1. jps+top 定位应用进程 pid

2. top -Hp {pid}找到线程 tid

3. 将 tid 转换成十六进制 printf “%x\n” {tid}

4. jstack 打印堆栈信息

5. 过滤出我们想要的

#### jps+top 定位应用进程 pid

jps或ps -ef |grepjava查看java进程id

```text
jps
```

结果：

```text
57152 abc.jar
83383 efg.jar
6438 Jps
67081 Bootstrap
```

找到pid为83383

> P – 以 CPU 占用率大小的顺序排列进程列表
> 
> M – 以内存占用率大小的顺序排列进程列表

top 查看cpu使用情况

```text
top
```

结果：

```text
PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 83383 root  20   0   50.5g  17.2g  25868 S  5917  6.9 657064:19 java```

```

#### top -Hp {pid}找到线程 tid

> -p	指定特定的pid进程号进行观察
> 
> -H 显示线程列表

```text
top -Hp 83383
```

结果:

```text
 PID  USER   PR  NI  VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND

 83799 root  20  0   50.5g  17.2g  25868 R 79.7  6.9   6357:37 java

```

tid 为 83799

#### 将 tid 转换成十六进制

```text
printf "%x\n" 83799
```

结果:

```text
14751n
```

#### jstack 打印堆栈信息

```text
jstack 83383 | grep  14751n -A10
```

```text
"THREAD-ID=241" #241 prio=5 os_prio=0 tid=0x00007f3ce403d800 nid=0x1472a runnable [0x00007f3ba82c0000]
   java.lang.Thread.State: RUNNABLE

```