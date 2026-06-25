# JDBC多线程插入大量数据.md

> 原创 最新推荐文章于 2026-06-23 16:23:37 发布 · 公开 · 803 阅读 · 0 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/110863843

```java
package com.xiaobu.base.util;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import lombok.extern.slf4j.Slf4j;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicLong;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/12/8 9:07
 * @description
 */
@Slf4j
public class MultiTableInport {
    private static final String TABLE_PRE = "random_code_";
    private static final Long COUNT=50000000L;
    private static ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%s").build();

    public static void multiTableInport(){
        for (int index = 1; index < 201; index++) {
            long atomic=(index-1)*COUNT;
            AtomicLong atomicIndex = new AtomicLong(atomic);
            String tableName = TABLE_PRE + index;
            multiThreadImport(10,tableName,atomicIndex);
        }
    }

    public static void multiThreadImport(final int threadNum,String tableName,AtomicLong atomicIndex) {
        final CountDownLatch cdl = new CountDownLatch(threadNum);
        long starttime = System.currentTimeMillis();
        ThreadPoolExecutor executor = new ThreadPoolExecutor(threadNum, 15, 60, TimeUnit.SECONDS, new ArrayBlockingQueue<>(50000), threadFactory);
        for (int k = 1; k <= threadNum; k++) {
            executor.execute(() -> {
                Connection conn = JDBCUtils.getConnection();
                PreparedStatement preparedStatement = null;
                try {
                    assert conn != null;
                    conn.setAutoCommit(false);
                    String sql = "INSERT  INTO  " + tableName + "(id) values(?)";
                    preparedStatement = conn.prepareStatement(sql);
                    for (long i = 1; i <= COUNT / threadNum; i++) {
                        long id = atomicIndex.incrementAndGet();
                        preparedStatement.setLong(1, id);
                        preparedStatement.addBatch();
                        if (i % 10000 == 0) {
                            preparedStatement.executeBatch();
                            conn.commit();
                            preparedStatement.clearBatch();
                        }
                    }
                    preparedStatement.executeBatch();
                    preparedStatement.clearBatch();
                    conn.commit();
                    preparedStatement.close();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    cdl.countDown();
                    JDBCUtils.closeStatement(preparedStatement);
                    JDBCUtils.closeConnection(conn);
                }
            });
        }
        try {
            cdl.await();
            long spendtime = System.currentTimeMillis() - starttime;
            System.out.println(threadNum + "个线程花费时间:" + spendtime/1000+"S");
            log.info("{}个线程花费时间:{}S" ,threadNum , spendtime/1000);

        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        executor.shutdown();
    }

    public static void main(String[] args) {
        multiTableInport();
    }
}

```

```sql
CREATE TABLE `random_code_1` (
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

```