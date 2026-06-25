# EasyExcel3.0读(日期、数字或者自定义格式转换)

> 原创 已于 2023-09-06 15:05:25 修改 · 公开 · 2.1k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 GEO检测 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/132715719

### EasyExcel 3.0读(日期、数字或者自定义格式转换)

#### 依赖

```xml
        <dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>easyexcel</artifactId>
    <version>3.2.1</version>
</dependency>
```

#### 对象

```java
package com.xiaobu.entity.vo;

import com.alibaba.excel.annotation.format.DateTimeFormat;
import com.alibaba.excel.annotation.format.NumberFormat;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author tanhongwei1
 * @version 1.0.0
 * @className TestNumberData.java
 * @createTime 2023年08月31日 11:22:00
 */
@Data
public class TestNumberData implements Serializable {
    private static final long serialVersionUID = 7783147140174424666L;
    private String name;
    // @ExcelProperty(converter = StringDoubleConverter.class)
    @NumberFormat
    private Double money;

    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    // @ExcelProperty(converter = DateStringConverter.class)
    private Date employmentDate;
}

```

### 文件内容

test_number.xlsx

```text
NAME	MONEY	EMPLOYMENT_DATE
隔壁老王	11.9	2023/8/30 14:36
隔壁老王	2	2023-08-30 14:36:07
隔壁老王	3	2023-08-30 14:36:07
隔壁老王	4	2023-08-30 14:36:07
隔壁老王	5.12	2023-08-30 14:36:07
隔壁老王	6	2023-08-30 14:36:07
隔壁老王	7	2023-08-30 14:36:07
隔壁老王	8	2023-08-30 14:36:07
隔壁老王	9	2023-08-30 14:36:07
隔壁老王	10	2023-08-30 14:36:07
隔壁老王	11	2023-08-30 14:36:07
隔壁老王	12	2023-08-30 14:36:08
隔壁老王	13	2023-08-30 14:36:09
隔壁老王	14	2023-08-30 14:36:10
隔壁老王	15	2023-08-30 14:36:11

```

### 读 代码

```java
@Test
public void testNumber() {
        String fileName = "D:\\log\\test_number.xlsx";
        // 读取sheet
        EasyExcel.read(fileName, TestNumberData.class, new PageReadListener<TestNumberData>(dataList -> {
        for (TestNumberData data : dataList) {
        log.info("读取到一条数据{}", JSONUtil.toJsonStr(data));
        // bean.update(data);
        }
        log.info("【simpleUpdate】::dataList ==> 【{}】", dataList);
        })).sheet().doRead();
        }
```