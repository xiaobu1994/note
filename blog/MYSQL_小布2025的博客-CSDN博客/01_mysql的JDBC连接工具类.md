# mysql的JDBC连接工具类

> 原创 最新推荐文章于 2025-11-02 14:13:47 发布 · 公开 · 412 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83383567

```
package com.minisay.base.util;

import java.sql.*;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/10/17 16:52
 * @descrption mysql的JDBC工具类
 */
public class JDBCUtils {
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/demo";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "113506";


    static {
        /**
         * 驱动注册
         */
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }

    }

    /**
     * 获取 Connetion
     *
     * @return conn
     */
    public static Connection getConnection()  {
        try {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return  null;
    }

    /**
     * 释放资源
     *
     * @param conn 连接对象
     * @param  preparedStatement 预编译对象
     * @param rs 结果集
     */
    public static void colseResource(Connection conn, PreparedStatement preparedStatement, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(preparedStatement);
        closeConnection(conn);
    }

    /**
     * 释放连接 Connection
     *
     * @param conn 连接对象
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        //等待垃圾回收
        conn = null;
    }

    /**
     * 释放语句执行者 preparedStatement
     *
     * @param preparedStatement 预编译
     */
    public static void closeStatement(PreparedStatement preparedStatement) {
        if (preparedStatement != null) {
            try {
                preparedStatement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        //等待垃圾回收
        preparedStatement = null;
    }

    /**
     * 释放结果集 ResultSet
     *
     * @param rs
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        //等待垃圾回收
        rs = null;
    }
}


```