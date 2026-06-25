# Sptingboot AOP实现多数据源切换(Hive Impala oracle)

> 原创 于 2021-04-29 16:17:26 发布 · 公开 · 438 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/116271467

pom文件

```xml
   <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.4.2</version>
        </dependency>
   <dependency>
            <groupId>org.springframework.data</groupId>
            <artifactId>spring-data-hadoop</artifactId>
            <version>2.4.0.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.apache.phoenix</groupId>
            <artifactId>phoenix-core</artifactId>
            <version>4.14.0-cdh5.14.2</version>
        </dependency>
        <dependency>
            <groupId>org.apache.hbase</groupId>
            <artifactId>hbase-client</artifactId>
            <version>1.4.4</version>
        </dependency>

        <!-- 添加hive依赖 -->
        <dependency>
            <groupId>org.apache.hive</groupId>
            <artifactId>hive-jdbc</artifactId>
            <version>2.1.1</version>
        </dependency>
        <!-- lomback -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.16.10</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <!--springBoot的aop-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>
        <!-- oracle -->
        <dependency>
            <groupId>com.oracle</groupId>
            <artifactId>ojdbc6</artifactId>
            <version>11.2.0.2.0</version>
        </dependency>
        <dependency>
            <groupId>com.cloudera</groupId>
            <artifactId>ImpalaJDBC41</artifactId>
            <version>2.5.41</version>
        </dependency>




  <resources>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
        </resources>
```

jdbc.properties

```properties

# MybatisPlus
#配置自定义的类型
mybatis-plus.type-handlers-package=com.xiaobu.handlers
mybatis-plus.type-aliases-package=com.xiaobu.**.entity
mybatis-plus.mapper-locations=classpath*:com/xiaobu/**/xml/*.xml
#mybatis-plus配置控制台打印完整带参数SQL语句
mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl
# master
#spring.datasource.master.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.master.jdbc-url=jdbc:oracle:thin:@172.22.7.127 :1521:orcl
spring.datasource.master.username=orcl
spring.datasource.master.password=orcl
# slave
#spring.datasource.slave.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.slave.jdbc-url=jdbc:oracle:thin:@172.22.7.127 :1521:orcl
spring.datasource.slave.username=orcl
spring.datasource.slave.password=orcl
#impala  自己打包
spring.datasource.impala.driver-class-name=com.cloudera.impala.jdbc41.Driver
spring.datasource.impala.jdbc-url=jdbc:impala://172.25.6.99:21050/impala;AuthMech=3;
spring.datasource.impala.username=impala
spring.datasource.impala.password=impala
##  Hikari 连接池配置 ------ 前缀和驱动设置保持一致，后面需要和HikariConfig的属性名保持一致 是通过get set方法来实现的 spring.datasource.impala.hikari.minimum-idle=5 多了个hikari导致属性赋值不进去
## 最小空闲连接数量
spring.datasource.impala.minimum-idle=5
## 空闲连接存活最大时间，默认600000（10分钟）
spring.datasource.impala.idle-timeout=180000
## 连接池最大连接数，默认是10
spring.datasource.impala.maximum-pool-size=10
## 此属性控制从池返回的连接的默认自动提交行为,默认值：true
spring.datasource.impala.auto-commit=true
## 连接池name
spring.datasource.impala.pool-name=MyHikariCP_Impala
## 此属性控制池中连接的最长生命周期，值0表示无限生命周期，默认1800000即30分钟
spring.datasource.impala.max-lifetime=1800000
## 数据库连接超时时间,默认30秒，即30000
spring.datasource.impala.connection-timeout=30000
spring.datasource.impala.connection-test-query=SELECT 1
#hive
spring.datasource.hive.jdbc-url=jdbc:hive2://172.25.6.11:10000/hive
spring.datasource.hive.username=hive
spring.datasource.hive.password=hive
spring.datasource.hive.driver-class-name=org.apache.hive.jdbc.HiveDriver
#连接池的属性可以按照spring.datasource.hive的形式添加
```

数据源注解

```java

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD, ElementType.TYPE})
public @interface DynamicRoute {

    /**
     * 主数据源
     * @return 数据源名称
     * @since 1.0.0
     */
    String value() default "";

}
```

数据源

```java
public class DataSourceType {

    public static final String MASTER = "master";

    public static final String SLAVE = "slave";

    public static final String IMPALA = "impala";

    public static final String HIVE = "hive";

}
```

```java
public class DynamicDataSource extends AbstractRoutingDataSource {
    @Override
    protected Object determineCurrentLookupKey() {
        return DataBaseContextHolder.getDataSourceType();
    }
}
```

数据源切换

```java
public class DataBaseContextHolder {
    private static final ThreadLocal<String> contextHolder = new ThreadLocal<>();

    public static void setDataSourceType(String type) {
        if (type == null) {
            throw new NullPointerException();
        }
        System.out.println("切换数据源" + type);
        contextHolder.set(type);
    }

    public static String getDataSourceType() {
        String type = contextHolder.get();
        return type;
    }

    public static void clearDataSourceType() {
        contextHolder.remove();
    }
}
```

数据源配置

```java

@Configuration
@PropertySource("classpath:config/jdbc.properties")
@MapperScan("com.xiaobu.mapper")
public class DataSourceConfig {


    @Bean(name = "datasourceMaster")
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource.master")
    public DataSource datasourceMaster() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "datasourceSlave")
    @ConfigurationProperties(prefix = "spring.datasource.slave")
    public DataSource datasourceSlave() {
        return DataSourceBuilder.create().build();
    }


    /**
     * 三种返回DataSource的方式都可以 因为默认是HikariDataSource
     */
    @Bean(DataSourceConstants.DS_KEY_IMPALA)
    @ConfigurationProperties(prefix = "spring.datasource.impala")
    public DataSource impalaDataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
        // return DataSourceBuilder.create().build();
        // return  new HikariDataSource(); 
    }


    @Bean(name = "hive")
    @ConfigurationProperties(prefix = "spring.datasource.hive")
    public DataSource hiveDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    public DynamicDataSource dynamicDataSource(@Qualifier("datasourceMaster") DataSource ds1, @Qualifier("datasourceSlave") DataSource ds2, @Qualifier("impala") DataSource impalaDataSource, @Qualifier("hive") DataSource hiveDataSource) {
        Map<Object, Object> targetDataSource = new HashMap<>(16);
        targetDataSource.put(DataSourceType.MASTER, ds1);
        targetDataSource.put(DataSourceType.SLAVE, ds2);
        targetDataSource.put(DataSourceType.IMPALA, impalaDataSource);
        targetDataSource.put(DataSourceType.HIVE, hiveDataSource);
        DynamicDataSource dataSource = new DynamicDataSource();
        dataSource.setTargetDataSources(targetDataSource);
        dataSource.setDefaultTargetDataSource(ds1);
        return dataSource;
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        MybatisSqlSessionFactoryBean sqlSessionFactory = new MybatisSqlSessionFactoryBean();
        ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sqlSessionFactory.setDataSource(dynamicDataSource());
        MybatisConfiguration configuration = new MybatisConfiguration();
        configuration.setJdbcTypeForNull(JdbcType.NULL);
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setCacheEnabled(false);
        sqlSessionFactory.setConfiguration(configuration);
        TypeHandler<?>[] typeHandlers = new TypeHandler[]{stringTypeCustomizeHandler};
        sqlSessionFactory.setTypeHandlers(typeHandlers);
        sqlSessionFactory.setMapperLocations(resolver.getResources("classpath*:com/xiaobu/mapper/xml/*.xml"));
        return sqlSessionFactory.getObject();
    }

    @Bean
    public DataSourceTransactionManager transactionManager(DynamicDataSource dynamicDataSource) {
        return new DataSourceTransactionManager(dynamicDataSource);
    }

}
```

AOP切面

```java
package com.xiaobu.aspect;

import com.xiaobu.dynamic.DataBaseContextHolder;
import com.xiaobu.dynamic.DynamicRoute;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2021/4/27 10:19
 * @description
 * 不设置优先级@Order(-1) 如果service方法添加了事务 会导致事务AOP方法先执行，导致事务里面的连接是先前的那个数据源的
 * 即使后面切换了数据源也没有用，必须先切换数据源然后再开启事务。
 */
@Aspect
@Component
@EnableAspectJAutoProxy
@Order(-1)

public class DataSourceAspect {

    /**
     * 日志实例
     * @since 1.0.0
     */
    private static final Logger LOG = LoggerFactory.getLogger(DataSourceAspect.class);

    /**
     * 拦截注解指定的方法
     */
    @Pointcut("@within(com.xiaobu.dynamic.DynamicRoute)||@annotation(com.xiaobu.dynamic.DynamicRoute)")
    public void pointCut() {
        //
    }

    /**
     * 拦截处理
     *
     * @param point point 信息
     * @return result
     * @throws Throwable if any
     */
    @Around("pointCut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        try {
            // 获取当前拦截的方法签名
            String signatureShortStr = point.getSignature().toShortString();

            Method method = getCurrentMethod(point);
            DynamicRoute route = method.getAnnotation(DynamicRoute.class);
            String value = route.value();

            // 设置
            DataBaseContextHolder.setDataSourceType(value);

            return point.proceed();
        } finally {
            LOG.info("清空类型");
            DataBaseContextHolder.clearDataSourceType();
        }

    }


    /**
     * 获取当前方法信息
     *
     * @param point 切点
     * @return 方法
     */
    private Method getCurrentMethod(ProceedingJoinPoint point) {
        try {
            Signature sig = point.getSignature();
            MethodSignature msig = (MethodSignature) sig;
            Object target = point.getTarget();
            return target.getClass().getMethod(msig.getName(), msig.getParameterTypes());
        } catch (NoSuchMethodException e) {
            throw new RuntimeException(e);
        }
    }

}
```

多线程有可能导致数据源混乱 eg:

```java
Callable<List<Map<String, Object>>> task1 = () -> {
            // 设置当前线程数据源
            DynamicDataSourceContextHolder.setContextKey(DataSourceConstants.DS_KEY_EDA_PRO_SYS);
            List<Map<String, Object>> menuLists = null;
            try {
                // 查询数据库方法

            } finally {
                // 强制清空本地线程，防止内存泄漏，手动调用push可调用此方法确保清除
                DynamicDataSourceContextHolder.removeContextKey();
            }
            return null;
        };
```

#### 数据源切面不配置优先级添加事务注解导致连接错乱(反例)

##### Controller

```java
 @GetMapping("testDs")
    public RestResponse<Map<String, Object>> testDs() {
        dataService.alertPartitionByTableName(Constants.TABLE, DateTimeUtils.getCurrentShortDateStr(), "1", "conditionId");
        User user=new User();
        user.setName("admin");
        user.setAge(18);
       userService.insertSelective(user);
        return RestResponse.ok();
    }
```

##### UserService

```java
    @DS(DataSourceConstants.MASTER)
// @Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class)
public void insertSelective(User user) {
        userMapper.insertSelective(user);
        }
```

##### DataService

```java
    public void alertPartitionByTableName(String tableName, String creatDate, String datasource, String conditionId) {
        dataMapper.alertPartitionByTableName(tableName, creatDate, datasource, conditionId);
    }
```

两个增加@Transactional(propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class) 或@Transactional(rollbackFor =
Exception.class)或者insertSelective单个 增加事务注解 都报错：

```text
Creating a new SqlSession
SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@b699162] was not registered for synchronization because synchronization is not active
JDBC Connection [HikariProxyConnection@1393836353 wrapping com.cloudera.impala.impala.common.ImpalaJDBCConnection@5ccf727a] will not be managed by Spring
Closing non transactional SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@b699162]
切换数据源master
Creating a new SqlSession
Registering transaction synchronization for SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@150d2dfa]
JDBC Connection [HikariProxyConnection@893017478 wrapping com.cloudera.impala.impala.common.ImpalaJDBCConnection@5ccf727a] will be managed by Spring
Releasing transactional SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@150d2dfa]
Transaction synchronization deregistering SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@150d2dfa]
Transaction synchronization closing SqlSession [org.apache.ibatis.session.defaults.DefaultSqlSession@150d2dfa]
org.springframework.jdbc.UncategorizedSQLException: 
### Error updating database.  Cause: java.sql.SQLException: Error message not found: . Can't find resource for bundle java.util.PropertyResourceBundle, key 
### The error may involve defaultParameterMap
### The error occurred while setting parameters
### SQL: INSERT INTO User。。。。      
### Cause: java.sql.SQLException: Error message not found: . Can't find resource for bundle java.util.PropertyResourceBundle, key
```