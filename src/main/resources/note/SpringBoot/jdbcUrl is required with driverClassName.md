> spring.datasource.url 数据库的 JDBC URL。

> spring.datasource.jdbc-url 用来重写自定义连接池

# jdbcUrl is required with driverClassName 这是HikariDataSource报的没有配置jdbc-url导致的

## com.zaxxer.hikari.HikariDataSource

（Spring Boot 2.0 以上，默认使用此数据源）

如果是单个库，直接用

```properties
spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.url=jdbc:oracle:thin:@localhost :1521:oracle
spring.datasource.username=oracle
spring.datasource.password=oracle
```

如果是多个就需要自定义了

```properties
# master
spring.datasource.master.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.master.jdbc-url=jdbc:oracle:thin:@localhost :1521:oracle
spring.datasource.master.username=oracle
spring.datasource.master.password=oracle
# slave
spring.datasource.slave.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.slave.jdbc-url=jdbc:oracle:thin:@172.22.7.17 :1521:oracle
spring.datasource.slave.username=oracle
```

## com.alibaba.druid.pool.DruidDataSource

如果用的阿里的就要将jdbc-url改成url

```properties
# master
spring.datasource.master.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.master.url=jdbc:oracle:thin:@localhost :1521:oracle
spring.datasource.master.username=oracle
spring.datasource.master.password=oracle
# slave
spring.datasource.slave.driver-class-name=oracle.jdbc.driver.OracleDriver
spring.datasource.slave.url=jdbc:oracle:thin:@172.22.7.17 :1521:oracle
spring.datasource.slave.username=oracle
```

## shardingsphere使用

需要指定数据库连接池datasource的type 不然

org\apache\shardingsphere\shardingjdbc\spring\boot\SpringBootConfiguration.class报NPE

```java 
DataSource result = DataSourceUtil.getDataSource(dataSourceProps.get("type").toString(), dataSourceProps);
```

shardingsphere的版本为 4.1.1

```xml 
<dependency>
            <groupId>org.apache.shardingsphere</groupId>
            <artifactId>sharding-jdbc-spring-boot-starter</artifactId>
            <version>4.1.1</version>
        </dependency>
        <!--namespace-->
        <dependency>
            <groupId>org.apache.shardingsphere</groupId>
            <artifactId>sharding-jdbc-spring-namespace</artifactId>
            <version>4.1.1</version>
        </dependency>
```