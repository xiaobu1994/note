# 利用多线程（用到原子类AtomicInteger）往数据库批量插入大量数据

> 原创 最新推荐文章于 2026-06-14 11:09:23 发布 · 公开 · 1.8k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83383830

```
package duocharu;

import com.minisay.base.util.OJDBCUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/10/18 12:23
 * @descrption  oracle 多个线程插入
 */
public class MyThread extends Thread {
    private static AtomicInteger index = new AtomicInteger(0);
    private static long time1 = 0;

    public void run() {
        Connection conn =null;
        PreparedStatement preparedStatement=null;
        int i = index.getAndIncrement();
        try {
            conn= OJDBCUtils.getConn();
            assert conn != null;
            conn.setAutoCommit(false);
            String sql = "INSERT  INTO  tb_demo1(id) values(?)";
            preparedStatement= conn.prepareStatement(sql);
            int count = 10000000;
            for (int j = i * count; j < (i + 1) * count; j++) {
                preparedStatement.setInt(1, j + 1);
                preparedStatement.addBatch();
                if ((j % 50000 == 0 && j != 0) || j == (count - 1)) {
                    preparedStatement.executeBatch();
                    conn.commit();
                    preparedStatement.clearBatch();
                }
            }
            preparedStatement.executeBatch();
            preparedStatement.clearBatch();
            conn.commit();
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            OJDBCUtils.closeStatement(preparedStatement);
            OJDBCUtils.closeConnection(conn);
        }
        System.out.println("当前线程：" + Thread.currentThread().getName() + "_" + i + " 耗时:" + (System.currentTimeMillis() - time1) / 1000 + " s");

    }

    public static void main(String[] args) {

        time1 = System.currentTimeMillis();
        System.out.println("当前时间：" + time1);
            MyThread myThread1 = new MyThread();
            MyThread myThread2 = new MyThread();
            MyThread myThread3 = new MyThread();
            MyThread myThread4 = new MyThread();
            MyThread myThread5 = new MyThread();
            MyThread myThread6 = new MyThread();
            MyThread myThread7 = new MyThread();
            MyThread myThread8 = new MyThread();
            MyThread myThread9 = new MyThread();
            MyThread myThread10 = new MyThread();
            myThread1.start();
            myThread2.start();
            // myThread3.start();
            // myThread4.start();
            // myThread5.start();
            // myThread6.start();
            // myThread7.start();
            // myThread8.start();
            // myThread9.start();
            // myThread10.start();


    }
}

```

经过测试oracle单个线程和多个线程插入效率差不多，但是mysql就有明显的差别