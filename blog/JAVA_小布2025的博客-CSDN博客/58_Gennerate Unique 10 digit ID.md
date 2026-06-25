# Gennerate Unique 10 digit ID

> 原创 最新推荐文章于 2022-07-24 20:44:37 发布 · 公开 · 1k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/107175782

```java
package com.xiaobu.base.util;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.atomic.AtomicReference;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/6/22 10:39
 * @description V1.0  生成10位的唯一数字码
 */
@Slf4j
public class UniqueIdUtils {
    private static final long LIMIT = 10000000000L;
    private static long last = 0;
    private static AtomicReference<Long> currentTime = new AtomicReference<>(System.currentTimeMillis());

    /**
     * 功能描述: 生成10位不重复的数字  Unique 10 digit ID
     * @author xiaobu
     * @date 2020/6/23 17:45
     * @return long
     * @version 1.0
     */
    public static long generateUniqueNumberCode() {
        // 10 digits.
        long id = System.currentTimeMillis() % LIMIT;
        if ( id <= last ) {
            id = (last + 1) % LIMIT;
        }
        return last = id;
    }



    /**
     * 功能描述:生成10位不重复的数字码
     * @author xiaobu
     * @date 2020/7/7 10:16
     * @return java.lang.Long
     * @version 1.0
    */
    public static Long get10DigitId() {
        return currentTime.accumulateAndGet(System.currentTimeMillis(), (prev, next) -> next > prev ? next : prev + 1) % 10000000000L;
    }

}



```