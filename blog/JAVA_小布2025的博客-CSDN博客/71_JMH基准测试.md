# JMH基准测试

> 原创 最新推荐文章于 2025-05-20 06:00:00 发布 · 公开 · 352 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/120419321

### 验证log使用占位符相对于String 字符串的拼接可以有效提升性能。

#### 测试代码

```java
package com.xiaobu.JMH;

import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.TimeUnit;

/**
 * @author 小布
 * @version 1.0.0
 * @className JmhLogPrint.java
 * @createTime 2021年09月22日 14:00:00
 */
@BenchmarkMode(Mode.AverageTime) // 测试完成时间
@OutputTimeUnit(TimeUnit.NANOSECONDS)
@Warmup(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS) // 预热 2 轮，每次 1s
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS) // 测试 5 轮，每次 3s
@Fork(1) // fork 1 个线程
@State(Scope.Thread) // 每个测试线程一个实例
@RestController
@RequestMapping("/log")
public class JmhLogPrint {

    private final Logger log = LoggerFactory.getLogger(JmhLogPrint.class);

    public static void main(String[] args) throws RunnerException {
        //1、启动基准测试：输出json结果文件（用于查看可视化图）
        Options opt = new OptionsBuilder()
                .include(JmhLogPrint.class.getSimpleName()) //要导入的测试类
                .result("D:\\JmhLogPrint.json") //输出测试结果的json文件
                .resultFormat(ResultFormatType.JSON)//格式化json文件
                .build();

        //2、执行测试
        new Runner(opt).run();
    }

    @Benchmark
    public void appendLogPrint() {
        StringBuilder sb = new StringBuilder();
        sb.append("Hello, ");
        sb.append("Java");
        sb.append(".");
        sb.append("Hello, ");
        sb.append("Redis");
        sb.append(".");
        sb.append("Hello, ");
        sb.append("MySQL");
        sb.append(".");
        log.info(sb.toString());
    }

    @Benchmark
    public void logPrintWithPlaceholder() {
        log.info("Hello, {}.Hello, {}.Hello, {}.", "Java", "Redis", "MySQL");
    }
}

```

#### 结果

```text
Benchmark                                Mode  Cnt       Score         Error  Units
JMH.JmhLogPrint.appendLogPrint           avgt    5  274846.463 ± 1204824.140  ns/op
JMH.JmhLogPrint.logPrintWithPlaceholder  avgt    5   51898.637 ±    9793.767  ns/op
```

直接使用 StringBuilder 拼接的方式显然要比使用占位符的方式性能要低

> 将json文件可视化工具

JMH Visualizer： [https://jmh.morethan.io/](https://jmh.morethan.io/) 
JMH Visual Chart： [http://deepoove.com/jmh-visual-chart/](http://deepoove.com/jmh-visual-chart/) 

### String、StringBuilder及StringBuffer的JMH基准单元测试方法：

#### 测试代码

```java
package com.xiaobu.JMH;

import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.infra.Blackhole;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;

import java.util.concurrent.TimeUnit;

/**
 * @author 小布
 * @version 1.0.0
 * @className StringAppendJmhTest.java
 * @createTime 2021年09月22日 13:29:00
 */
@BenchmarkMode(Mode.AverageTime) // 测试完成时间
@OutputTimeUnit(TimeUnit.NANOSECONDS)
@Warmup(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS) // 预热 2 轮，每次 1s
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS) // 测试 5 轮，每次 3s
@Fork(3) //Fork出3个线程来测试
@State(Scope.Thread) // 每个测试线程分配1个实例
public class StringAppendJmhTest {
    @Param({"2", "10", "100", "1000"})
    private int count; //指定添加元素的不同个数，便于分析结果

    public static void main(String[] args) throws RunnerException {
        //1、启动基准测试：输出普通文件
//        Options opt = new OptionsBuilder()
//                .include(ArrayAndLinkedJmhTest.class.getSimpleName()) //要导入的测试类
//                .output("C:\\Users\\Administrator\\Desktop\\StringAppendJmhTest.log") //输出测试结果的普通txt文件
//                .build();


        //1、启动基准测试：输出json结果文件（用于查看可视化图）
        Options opt = new OptionsBuilder()
                .include(StringAppendJmhTest.class.getSimpleName()) //要导入的测试类
                .result("D:\\StringAppendJmhTest.json") //输出测试结果的json文件
                .resultFormat(ResultFormatType.JSON)//格式化json文件
                .build();

        //2、执行测试
        new Runner(opt).run();
    }

    @Setup(Level.Trial) // 初始化方法，在全部Benchmark运行之前进行
    public void init() {
        System.out.println("Start...");
    }

    @Benchmark
    public void stringAppendTest(Blackhole blackhole) {
        String str = "";
        for (int i = 0; i < count; i++) {
            str = str + "Justin";
        }
        blackhole.consume(str);
    }

    @Benchmark
    public void stringBufferAppendTest(Blackhole blackhole) {
        StringBuffer strBuffer = new StringBuffer();
        for (int i = 0; i < count; i++) {
            strBuffer.append("Justin");
        }
        blackhole.consume(strBuffer);
    }

    @Benchmark
    public void stringBuilderAppendTest(Blackhole blackhole) {
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < count; i++) {
            strBuilder.append("Justin");
        }
        blackhole.consume(strBuilder);
    }

    @TearDown(Level.Trial) // 结束方法，在全部Benchmark运行之后进行
    public void clear() {
        System.out.println("End...");
    }

}
```

#### 测试结果：

字符串拼接性能：StringBuilder > StringBuffer > String

```text
Benchmark                                        (count)  Mode  Cnt       Score      Error  Units
JMH.StringAppendJmhTest.stringAppendTest               2  avgt   15      39.152 ±   40.463  ns/op
JMH.StringAppendJmhTest.stringAppendTest              10  avgt   15     139.626 ±    1.233  ns/op
JMH.StringAppendJmhTest.stringAppendTest             100  avgt   15    8031.421 ±  276.464  ns/op
JMH.StringAppendJmhTest.stringAppendTest            1000  avgt   15  712191.266 ± 5927.205  ns/op
JMH.StringAppendJmhTest.stringBufferAppendTest         2  avgt   15      21.510 ±    9.480  ns/op
JMH.StringAppendJmhTest.stringBufferAppendTest        10  avgt   15     166.773 ±  274.604  ns/op
JMH.StringAppendJmhTest.stringBufferAppendTest       100  avgt   15    1159.299 ±  103.268  ns/op
JMH.StringAppendJmhTest.stringBufferAppendTest      1000  avgt   15   10173.023 ± 1148.979  ns/op
JMH.StringAppendJmhTest.stringBuilderAppendTest        2  avgt   15      16.613 ±    0.347  ns/op
JMH.StringAppendJmhTest.stringBuilderAppendTest       10  avgt   15      89.340 ±    0.731  ns/op
JMH.StringAppendJmhTest.stringBuilderAppendTest      100  avgt   15    1029.786 ±   11.204  ns/op
JMH.StringAppendJmhTest.stringBuilderAppendTest     1000  avgt   15    9151.069 ±  126.842  ns/op
```

### Commons Lang StringUtils.replace performance vs String.replace

#### 测试代码

```java
package com.xiaobu.JMH;

import org.apache.commons.lang3.StringUtils;
import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.infra.Blackhole;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;

import java.util.concurrent.TimeUnit;

/**
 * @author 小布
 * @version 1.0.0
 * @className StringReplaceBenchmark.java
 * @createTime 2021年09月22日 14:24:00
 */
@BenchmarkMode(Mode.AverageTime) // 测试完成时间
@OutputTimeUnit(TimeUnit.NANOSECONDS)
@Warmup(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS) // 预热 2 轮，每次 1s
@Measurement(iterations = 5, time = 3, timeUnit = TimeUnit.SECONDS) // 测试 5 轮，每次 3s
@Fork(1) // fork 1 个线程
@State(Scope.Thread) // 每个测试线程一个实例
public class StringReplaceBenchmark {

    private static final String SHORT_STRING_NO_MATCH = "ABC";
    private static final String SHORT_STRING_ONE_MATCH = "a'BC";
    private static final String SHORT_STRING_SEVERAL_MATCHES = "'a'b'c'";
    private static final String LONG_STRING_NO_MATCH =
            "ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABC";
    private static final String LONG_STRING_ONE_MATCH =
            "ABCABCABCABCABCABCABCABCABCABCABCa'BCABCABCABCABCABCABCABCABCABCABCABCABC";
    private static final String LONG_STRING_SEVERAL_MATCHES =
            "ABCABCa'BCABCABCABCABCABC'ABCABCABCa'BCABCABCABCABCABCa'BCABCABCABCABCABCABC";

    public static void main(String[] args) throws RunnerException {
        Options options = new OptionsBuilder().include(StringReplaceBenchmark.class.getSimpleName()).build();
        new Runner(options).run();
    }

    @Benchmark
    public void shortStringNoMatch(Blackhole blackhole) {
        blackhole.consume(SHORT_STRING_NO_MATCH.replace("'", "''"));
    }

    @Benchmark
    public void shortStringNoMatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(SHORT_STRING_NO_MATCH, "'", "''"));
    }

    @Benchmark
    public void longStringNoMatch(Blackhole blackhole) {
        blackhole.consume(LONG_STRING_NO_MATCH.replace("'", "''"));
    }

    @Benchmark
    public void longStringNoMatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(LONG_STRING_NO_MATCH, "'", "''"));
    }

    @Benchmark
    public void shortString1Match(Blackhole blackhole) {
        blackhole.consume(SHORT_STRING_ONE_MATCH.replace("'", "''"));
    }

    @Benchmark
    public void shortString1MatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(SHORT_STRING_ONE_MATCH, "'", "''"));
    }

    @Benchmark
    public void longString1Match(Blackhole blackhole) {
        blackhole.consume(LONG_STRING_ONE_MATCH.replace("'", "''"));
    }

    @Benchmark
    public void longString1MatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(LONG_STRING_ONE_MATCH, "'", "''"));
    }

    @Benchmark
    public void shortStringNMatch(Blackhole blackhole) {
        blackhole.consume(SHORT_STRING_SEVERAL_MATCHES.replace("'", "''"));
    }

    @Benchmark
    public void shortStringNMatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(SHORT_STRING_SEVERAL_MATCHES, "'", "''"));
    }

    @Benchmark
    public void longStringNMatch(Blackhole blackhole) {
        blackhole.consume(LONG_STRING_SEVERAL_MATCHES.replace("'", "''"));
    }

    @Benchmark
    public void longStringNMatchUtils(Blackhole blackhole) {
        blackhole.consume(StringUtils.replace(LONG_STRING_SEVERAL_MATCHES, "'", "''"));
    }
}

```

#### 测试结果：

```text
Benchmark                                           Mode  Cnt     Score      Error  Units
JMH.StringReplaceBenchmark.longString1Match         avgt    5  1542.101 ± 8069.146  ns/op
JMH.StringReplaceBenchmark.longString1MatchUtils    avgt    5   408.031 ± 1984.070  ns/op
JMH.StringReplaceBenchmark.longStringNMatch         avgt    5   790.396 ± 1068.888  ns/op
JMH.StringReplaceBenchmark.longStringNMatchUtils    avgt    5   310.045 ±  815.440  ns/op
JMH.StringReplaceBenchmark.longStringNoMatch        avgt    5   172.684 ±  322.380  ns/op
JMH.StringReplaceBenchmark.longStringNoMatchUtils   avgt    5    21.944 ±    0.323  ns/op
JMH.StringReplaceBenchmark.shortString1Match        avgt    5   160.640 ±    2.932  ns/op
JMH.StringReplaceBenchmark.shortString1MatchUtils   avgt    5    89.461 ±  340.988  ns/op
JMH.StringReplaceBenchmark.shortStringNMatch        avgt    5   296.488 ±   56.479  ns/op
JMH.StringReplaceBenchmark.shortStringNMatchUtils   avgt    5    71.800 ±   12.094  ns/op
JMH.StringReplaceBenchmark.shortStringNoMatch       avgt    5    97.064 ±   26.855  ns/op
JMH.StringReplaceBenchmark.shortStringNoMatchUtils  avgt    5     5.018 ±    0.910  ns/op

Process finished with exit code 0

```

字符串replace性能：Commons Lang StringUtils.replace > String.replace(java8)

> 在现代 Java 中(JDK>1.8)，情况不再如此。String.replace在Java-9 中从正则表达式到 StringBuilder 进行了改进，在Java-13 中进行了更多改进，以直接分配目标byte[]数组提前计算其确切大小。由于使用了内部 JDK 特性，例如分配未初始化数组的能力、访问 String 编码器的能力以及使用String避免复制的私有构造函数的能力，当前实现不太可能被第三方实现击败。

参考：

[Java–☀️面试官：讲一下String、StringBuilder及StringBuffer区别？❤️‍【⭐初学者面试必备⭐】](https://blog.csdn.net/JustinQin/article/details/120050806) 

[为什么要用JMH？何时应该用？](https://www.zhihu.com/question/276455629) 

[Commons Lang StringUtils.replace performance vs String.replace](https://stackoverflow.com/questions/16228992/commons-lang-stringutils-replace-performance-vs-string-replace) 

[JMH-大厂是如何使用JMH进行Java代码性能测试的？必须掌握！](https://zhuanlan.zhihu.com/p/197257423) 