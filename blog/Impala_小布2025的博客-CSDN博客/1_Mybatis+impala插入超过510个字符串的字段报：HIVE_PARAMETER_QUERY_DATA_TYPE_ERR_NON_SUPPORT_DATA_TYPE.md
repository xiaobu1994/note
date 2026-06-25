# Mybatis+impala插入超过510个字符串的字段报：HIVE_PARAMETER_QUERY_DATA_TYPE_ERR_NON_SUPPORT_DATA_TYPE

> 原创 于 2021-06-02 16:53:57 发布 · 公开 · 1.2k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/117474377

自定义个TypeHandler 然后把setParameter的setString改成setObject

```java

@Component
@MappedTypes(String.class)
@MappedJdbcTypes(JdbcType.VARCHAR)
public class StringTypeCustomizeHandler implements TypeHandler<String> {
    @Override
    public void setParameter(PreparedStatement preparedStatement, int i, String s, JdbcType jdbcType) throws SQLException {
        preparedStatement.setObject(i, s);
    }

    @Override
    public String getResult(ResultSet resultSet, String s) throws SQLException {
        return resultSet.getString(s);
    }

    @Override
    public String getResult(ResultSet resultSet, int i) throws SQLException {
        return resultSet.getString(i);
    }

    @Override
    public String getResult(CallableStatement callableStatement, int i) throws SQLException {
        return callableStatement.getString(i);
    }
}
```

springboot中指定TypeHandler的路径

```properties
#用到了mybatis-plus
mybatis-plus.type-handlers-package=com.xiaobu.handlers
```

SqlSessionFactory也需要指定

```java
    @Autowired
    StringTypeCustomizeHandler stringTypeCustomizeHandler;

        TypeHandler<?>[]  typeHandlers=new TypeHandler[]{stringTypeCustomizeHandler};
        sqlSessionFactory.setTypeHandlers(typeHandlers);
```

然后mapper.xml里面指定类型

```xml

    <result column="name" typeHandler="com.xiaobu.handlers.StringTypeCustomizeHandler" property="name" />

                #{name,typeHandler=com.xiaobu.handlers.StringTypeCustomizeHandler}

```

[https://community.cloudera.com/t5/Support-Questions/HIVE-PARAMETER-QUERY-DATA-TYPE-ERR-NON-SUPPORT-DATA-TYPE/td-p/58674](HIVE_PARAMETER_QUERY_DATA_TYPE_ERR_NON_SUPPORT_DATA_TYPE) 