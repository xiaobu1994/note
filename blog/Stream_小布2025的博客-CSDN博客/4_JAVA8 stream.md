# JAVA8 stream

> 原创 于 2019-10-11 15:33:27 发布 · 公开 · 245 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/102502318

什么是Stream？
Stream（流）是一个来自数据源的元素队列并支持聚合操作

- 元素是特定类型的对象，形成一个队列。 Java中的Stream并不会存储元素，而是按需计算。

- 数据源 流的来源。 可以是集合，数组，I/O channel， 产生器generator 等。

- 聚合操作 类似SQL语句一样的操作， 比如filter, map, reduce, find, match, sorted等。
  和以前的Collection操作不同， Stream操作还有两个基础的特征：

Pipelining: 中间操作都会返回流对象本身。 这样多个操作可以串联成一个管道， 如同流式风格（fluentstyle）。 这样做可以对操作进行优化， 比如延迟执行(laziness)和短路( short-circuiting)。
内部迭代： 以前对集合遍历都是通过Iterator或者For-Each的方式, 显式的在集合外部进行迭代， 这叫做外部迭代。 Stream提供了内部迭代的方式， 通过访问者模式(Visitor)实现。
生成流
在Java8 中, 集合接口有两个方法来生成流：

- stream() − 为集合创建串行流。

- parallelStream() − 为集合创建并行流。

#### forEach

forEach方法 来迭代流中的每个数据。

```java
  /**
     * 功能描述:迭代
     * @author xiaobu
     * @date 2019/10/11 10:06
     * @return void
     * @version 1.0
     */
    public static void forEach(){
        List<String> stringList = Arrays.asList("A", "B", "C");
        stringList.stream().forEach(System.out::println);
        // 等价于==>stringList.forEach(System.out::println);
    }
```

#### map

map方法用于映射每个元素到对应的结果

```java
 /**
     * 功能描述: map() 将Integer转换成字符串输出
     *
     * @return void
     * @author xiaobu
     * @date 2019/10/11 9:47
     * @version 1.0
     */
    public static void map() {
        Integer[] integers = {1, 2, 3};
        Stream<Integer> stream = Arrays.stream(integers);
        stream.map(str -> Integer.toString(str)).forEach(System.out::println);
        List<String> stringList = stream.map(integer -> Integer.toString(integer)).collect(Collectors.toList());
        System.out.println("stringList = " + stringList);
    }
```

#### filter

filter 方法用于通过设置的条件过滤出元素。

```java
    /**
     * 功能描述: 输出首字母包含A的字符串
     * @author xiaobu
     * @date 2019/10/11 10:17
     * @return void
     * @version 1.0
     */
    public static void filter() {
        List<String> stringList = Arrays.asList("ABC", "DEF", "HIJ");
        stringList.stream().filter(str -> str.startsWith("A")).forEach(System.out::println);
    }

```

#### limit

limit 方法用于获取指定数量的流。

```java
 /**
     * 功能描述:forEach 输出随机生成的10个随机数  limit 方法用于获取指定数量的流
     *
     * @return void
     * @author xiaobu
     * @date 2019/10/11 9:58
     * @version 1.0
     */
    public static void limit() {
        ThreadLocalRandom random = ThreadLocalRandom.current();
        random.ints().limit(10).forEach(System.out::println);
    }
```

#### sorted

sorted 方法用于对流进行排序

```java
   /**
     * 功能描述:按照正序输出
     * @author xiaobu
     * @date 2019/10/11 10:24
     * @return void
     * @version 1.0
     */
    public static void sorted(){
        List<String> stringList = Arrays.asList("ABC", "DEF", "HIJ");
        stringList.stream().sorted().forEach(System.out::println);
    }
```

#### summaryStatistics

一些产生统计结果的收集器。

```java
    /**
     * 功能描述:数据统计
     * @author xiaobu
     * @date 2019/10/11 13:59
     * @return void
     * @version 1.0
     */
    public static void statistics(){
        List<Integer> integers = Arrays.asList(2, 3, 5, 7, 9);
      IntSummaryStatistics summaryStatistics= integers.stream().mapToInt(x -> x).summaryStatistics();
        System.out.println("summaryStatistics.getMax() = " + summaryStatistics.getMax());
        System.out.println("summaryStatistics.getAverage() = " + summaryStatistics.getAverage());
        System.out.println("summaryStatistics.getCount() = " + summaryStatistics.getCount());
        System.out.println("summaryStatistics.getMin() = " + summaryStatistics.getMin());
        System.out.println("summaryStatistics.getSum() = " + summaryStatistics.getSum());
    }
```

#### reduce

```java
 public static void main(String[] args) {
        // 字符串连接，concat = "ABCD"
        String concat = Stream.of("A", "B", "C", "D").reduce("", String::concat);
        System.out.println("concat = " + concat);
        //求最小值，minValue = -3.0
        double minValue = Stream.of(-1.5, 1.0, -3.0, -2.0).reduce(Double.MAX_VALUE, Double::min);
        System.out.println("minValue = " + minValue);
        // 求和，sumValue = 10, 有起始值
        int sumValue = Stream.of(1, 2, 3, 4).reduce(2, Integer::sum);
        System.out.println("有起始值sumValue = " + sumValue);
        // 求和，sumValue = 10, 无起始值
        sumValue = Stream.of(1, 2, 3, 4).reduce(Integer::sum).get();
        System.out.println("无起始值sumValue = " + sumValue);
        // 过滤，字符串连接，concat = "ace"
        concat = Stream.of("a", "B", "c", "D", "e", "F").
                filter(x -> x.compareTo("Z") > 0).
                reduce("", String::concat);
        System.out.println("concat = " + concat);
        //转大写
        List<String> output = Stream.of("a", "b", "C", "D").
                map(String::toUpperCase).
                collect(Collectors.toList());
        System.out.println("output = " + output);
    }
```