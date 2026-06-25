# JAVA多线程插入MYSQL数据库

> 原创 最新推荐文章于 2025-02-12 15:52:37 发布 · 公开 · 1.9k 阅读 · 0 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/111031496

一、十个线程依次插入200个表

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

drop TABLE random_code_1;


CREATE TABLE `random_code_1` (
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


```

二、两个线程分批插入四十个表 五个库

```java
/**
     * 
     * @param threadNum 线程个数
     * @param index 表名下标
     */
    public void insertDatabase1(int threadNum, int index) {
        AtomicInteger atomicIndex = new AtomicInteger(index);
        long indexNum = (index - 1) * COUNT + 1;
        AtomicLong atomicI = new AtomicLong(indexNum);
        AtomicLong atomicId = new AtomicLong(indexNum);
        final CountDownLatch cdl = new CountDownLatch(threadNum);
        long startTime = System.currentTimeMillis();
        ThreadPoolExecutor executor = new ThreadPoolExecutor(threadNum, 4, 60, TimeUnit.SECONDS, new ArrayBlockingQueue<>(50000), threadFactory);
        AtomicLong count = new AtomicLong(0);
        for (int k = 1; k <= threadNum; k++) {
            final List<RandomCode>[] randomCodeList = new List[]{new ArrayList<>()};
            executor.execute(() -> {
                try {
                    String tableName = TABLE_PRE + atomicIndex.get();
                    for (long i = atomicI.get(); i < atomicI.get() + COUNT / threadNum; i++) {
                        long id = atomicId.getAndIncrement();
                        RandomCode randomCode = new RandomCode();
                        randomCode.setId(id);
                        randomCodeList[0].add(randomCode);
                        if (i % 10000 == 0) {
                            count.getAndIncrement();
                            primaryMapper.insertRandomCaodeList(tableName, randomCodeList[0]);
                            randomCodeList[0] = null;
                            randomCodeList[0] = new ArrayList<>();
                            log.info("往表{}提交第{}次数据", tableName, count);
                        }

                    }

                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    cdl.countDown();

                }
            });
        }
        try {
            cdl.await();
            long spendtime = System.currentTimeMillis() - startTime;
            System.out.println(threadNum + "个线程花费时间:" + spendtime / 1000 + "S");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        executor.shutdown();
    }
```

```java
    @Test
    public   void insertDatabase1() {
        for (int i = 1; i <=40 ; i++) {
            randomCodeService.insertDatabase1(2, i);
        }
    }

```

```java
package com.xiaobu.entity.vo;

import com.xiaobu.entity.RandomCode;
import com.xiaobu.mapper.primary.PrimaryMapper;
import lombok.extern.slf4j.Slf4j;

import java.util.AbstractCollection;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/12/8 13:46
 * @description
 */
@Slf4j
public class PrimaryTask implements Runnable {
    /**
     * 数据访问层
     */
    private PrimaryMapper primaryMapper;

    /**
     * 插入的数据
     */
    private List<RandomCode> list;

    /**
     * 表名
     */
    private String tabelName;


    private AtomicLong count;

    public PrimaryTask(PrimaryMapper primaryMapper, String tabelName, AtomicLong count) {
        this.primaryMapper = primaryMapper;
        this.tabelName = tabelName;
        this.count = count;
    }


    @Override
    public void run() {
        this.list = new ArrayList<>();
        AtomicLong insertAcount = new AtomicLong(0);
        for (long i = this.count.get(); i <= this.count.get() + 50000000 / 2; i++) {
            RandomCode randomCode = new RandomCode();
            randomCode.setId(this.count.getAndIncrement());
            this.list.add(randomCode);
            if (i % 10000 == 0) {
                insertAcount.incrementAndGet();
                try {
                    this.primaryMapper.insertRandomCaodeList(this.tabelName, this.list);
                    log.info("在{}表第{}批次插入成功", this.tabelName, insertAcount.get());
                } catch (Exception e) {
                    log.info("在{}表第{}批次插入失败", this.tabelName, insertAcount.get());
                }
                this.list = null;
                this.list = new ArrayList<>();
            }
        }

    }
}

```

```java
public void excuteTask(int threadNum, int index) {
        AtomicInteger atomicIndex = new AtomicInteger(index);
        final CountDownLatch cdl = new CountDownLatch(threadNum);
        long indexNum = (index - 1) * COUNT + 1;
        AtomicLong atomicId = new AtomicLong(indexNum);
        long startTime = System.currentTimeMillis();
        ThreadPoolExecutor executor = new ThreadPoolExecutor(threadNum, 4, 60, TimeUnit.SECONDS, new ArrayBlockingQueue<>(50000), threadFactory);
        for (int k = 1; k <= threadNum; k++) {
            String tableName = TABLE_PRE + atomicIndex.get();
            PrimaryTask primaryTask = new PrimaryTask(primaryMapper, tableName,atomicId);
            executor.execute(primaryTask);
        }
        try {
            cdl.await();
            long spendtime = System.currentTimeMillis() - startTime;
            System.out.println(threadNum + "个线程花费时间:" + spendtime / 1000 + "S");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        executor.shutdown();
    }
```

```java
    @Test
    public void excuteTask() {
        randomCodeService.excuteTask(2, 1);
    }
```