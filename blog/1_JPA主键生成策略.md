# JPA主键生成策略

> 原创 于 2019-03-27 16:16:08 发布 · 公开 · 1.3k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/88846741

### JPA四种策略

- TABLE：使用一个特定的数据库表格来保存主键。

- SEQUENCE：根据底层数据库的序列来生成主键，条件是数据库支持序列。

- IDENTITY：主键由数据库自动生成（主要是自动增长型）

- AUTO：主键由程序控制。

### @GeneratedValue的源码,默认是AUTO方式

```java
@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface GeneratedValue {
    GenerationType strategy() default GenerationType.AUTO;
 
    String generator() default "";
}
```



```java
public enum GenerationType {
    TABLE,
    SEQUENCE,
    IDENTITY,
    AUTO;
 
    private GenerationType() {
    }
}
```



### Sequence 策略

一些数据库，比如 Oralce，有一种内置的叫做“序列” （sequence）的机制来生成主键。为了调用这个序列，需要使用 @javax.persistence.SequenceGenerator 这个注解。



```java
@Entity 
public class PK_Sequence implements Serializable { 
   private static final long serialVersionUID = 1L; 
   @SequenceGenerator(name="PK_SEQ_TBL",sequenceName="PK_SEQ_NAME") 
   @Id 
   @GeneratedValue(strategy = GenerationType.SEQUENCE,generator="PK_SEQ_TBL") 
   private Long id; 
// Getters and Setters 
}
```



@SequenceGenerator 注解的定义

```java
@Target(value = {ElementType.TYPE, ElementType.METHOD, ElementType.FIELD}) 
@Retention(value = RetentionPolicy.RUNTIME) 
public @interface SequenceGenerator { 
 
   public String name(); 
 
   public String sequenceName() default ""; 
 
   public String catalog() default ""; 
 
   public String schema() default ""; 
 
   public int initialValue() default 1; 
 
   public int allocationSize() default 50; 
}
```

从定义中可以看出这个注解可以用在类上，也可以用在方法和字段上，其中 name 属性指定的是所使用的生成器；sequenceName 指定的是数据库中的序列；initialValue 指定的是序列的初始值，和 @TableGenerator 不同是它的缺省值 1；allocationSize 指定的是持久化引擎 (persistence engine) 从序列 (sequence) 中读取值时的缓存大小，它的缺省值是 50。



### Identity 策略

一些数据库，如mysql,sqlserver用一个 Identity 列来生成主键，使用这个策略生成主键的时候，只需要在 @GeneratedValue 中用 strategy 属性指定即可。如下所示：

```java
@Entity 
public class PK_Identity implements Serializable { 
   private static final long serialVersionUID = 1L; 
   @Id 
   @GeneratedValue(strategy = GenerationType.IDENTITY) 
   private Long id; 
// Getters and Setters 
}
```



### Auto 策略

使用 AUTO 策略就是将主键生成的策略交给持久化引擎 (persistence engine) 来决定，由它自己选择从 Table 策略，Sequence 策略和 Identity 策略三种策略中选择合适的主键生成策略。不同的持久化引擎 (persistence engine) 使用不同的策略，在 galss fish 中使用的是 Table 策略。

```java
@Entity 
public class PK_Auto implements Serializable { 
   private static final long serialVersionUID = 1L; 
   @Id 
   @GeneratedValue(strategy = GenerationType.AUTO) 
   private Long id; 
 
  // Getters and Setters 
   }
```

或则只使用：

@Generated Value

或者干脆什么都不写，因为缺省得主键生成策略就是 AUTO。



### Table 策略 (Table strategy)

这种策略中，持久化引擎 (persistence engine) 使用关系型数据库中的一个表 (Table) 来生成主键。这种策略可移植性比较好，因为所有的关系型数据库都支持这种策略。不同的 J2EE 应用服务器使用不同的持久化引擎。

下面用一个例子来说明这种表生成策略的使用：

```java
@Entity 
 public class PrimaryKey_Table { 
 
 @TableGenerator(name = "PK_SEQ", 
 table = "SEQUENCE_TABLE", 
                pkColumnName  = "SEQUENCE_NAME", 
                valueColumnName  = "SEQUENCE_COUNT") 
 
 @Id 
    @GeneratedValue(strategy =GenerationType.TABLE,generator="PK_SEQ") 
    private Long id; 
 
 //Getters and Setters 
//为了方便，类里面除了一个必需的主键列，没有任何其他列，以后类似
             
 }
```



首先，上面使用 @javax.persistence.TableGenerator 这个注解来指定一个用来生成主键的表 (Table)，这个注解可以使用在实体类上，也可以像这个例子一样使用在主键字段上。

其中，在这个例子中，name 属性“PK_SEQ” 标示了这个生成器，也就是说这个生成器的名字是 PK_SEQ。这个 Table 属性标示了用哪个表来存贮生成的主键，在这个例子中，用“ SEQUENCE_TABLE” 来存储主键，数据库中有对应的 SEQUENCE_TABLE 表。其中 pkColumnName 属性用来指定的是生成器那个表中的主键，也就是 SEQUENCE_TABLE 这个表的主键的名字。属性 valueColumnName 指定列是用来存储最后生成的那个主键的值。

也可以使用持久化引擎提供的缺省得 Table，例如：

```java
public class PK implements Serializable { 
   private static final long serialVersionUID = 1L; 
  
   @Id 
   @GeneratedValue(strategy = GenerationType.TABLE) 
   
   private Long id; 
// Getters and Setters 
}
```



### hibernate主键策略生成器

- native: 对于 oracle 采用 Sequence 方式，对于MySQL 和 SQL Server 采用identity（自增主键生成机制），native就是将主键的生成工作交由数据库完成，hibernate不管

- 采用128位的uuid算法生成主键，uuid被编码为一个32位16进制数字的字符串。占用空间大（字符串类型）。

- assigned: 在插入数据的时候主键由程序处理（即程序员手动指定），等同于JPA中的AUTO。

- identity: 使用SQL Server 和 MySQL 的自增字段，这个方法不能放到 Oracle 中，Oracle 不支持自增字段，要设定sequence（MySQL 和 SQL Server 中很常用）。 等同于JPA中的INDENTITY。

- increment: 这个是由Hibernate在内存中生成主键，每次增量为1。可以跨数据库。插入数据的时候hibernate会给主键添加一个自增的主键，但是一个hibernate实例就维护一个计数器，所以在多个实例运行的时候不能使用这个方法。

increment策略：

```less
    @Id
    @GeneratedValue(generator="increment")
    @GenericGenerator(name="increment",strategy="increment")
```

native策略：

```java
@Id
    @GeneratedValue(generator = "NativeGenerator")
    @GenericGenerator(name = "NativeGenerator", strategy = "native")
```

identity策略：

```java
	
	@Id
    @GeneratedValue(generator = "IDGenerator")
    @GenericGenerator(name = "IDGenerator", strategy = "identity")
```

等价于JPA中的IDENTITY策略

```java
@Id
@GeneratedValue(strategy=GenerationType.IDENTITY)
```



assigned策略：

```java
	@Id
    @GeneratedValue(generator="paymentableGenerator")
    @GenericGenerator(name="paymentableGenerator", strategy="assigned")
```

等价于JPA中的AUTO策略

```java
@Id  
@GeneratedValue(GenerationType.AUTO) 
```

uuid策略：

```java
    @Id
    @GeneratedValue(generator = "paymentableGenerator")
    @GenericGenerator(name = "paymentableGenerator", strategy = "uuid")
```