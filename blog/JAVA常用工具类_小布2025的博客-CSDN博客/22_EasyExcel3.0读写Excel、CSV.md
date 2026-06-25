# EasyExcel3.0读写Excel、CSV

> 原创 已于 2022-11-24 09:42:57 修改 · 公开 · 2.1w 阅读 · 4 · 28 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/122701930

### EasyExcel3.0读写Excel、CSV

#### 依赖

```xml

<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>easyexcel</artifactId>
    <version>3.1.1</version>
</dependency>
```

#### 写工具类

```java
package com.xiaobu.util;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.EasyExcelFactory;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.context.WriteContextImpl;
import com.alibaba.excel.write.metadata.WriteSheet;
import com.alibaba.excel.write.metadata.WriteTable;
import com.alibaba.excel.write.metadata.style.WriteCellStyle;
import com.alibaba.excel.write.metadata.style.WriteFont;
import com.alibaba.excel.write.style.HorizontalCellStyleStrategy;
import com.xiaobu.entity.WidthAndHeightData;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;

import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

/**
 * @author 小布
 * @version 1.0.0
 * @date on  2021/5/27 16:36
 * {@link WriteContextImpl#finish(boolean onException) 会自动关闭流}
 */
public class EasyExcelUtils<T> {
    /**
     * 写单个表头
     */
    public static List<List<String>> simpleHead(String[] headArr) {
        List<List<String>> headTitles = new ArrayList<>();
        for (String s : headArr) {
            List<String> head = new ArrayList<>();
            head.add(s);
            headTitles.add(head);
        }
        return headTitles;
    }

    /**
     * horizontalCellStyleStrategy
     * 默认策略
     *
     * @return com.alibaba.excel.write.style.HorizontalCellStyleStrategy
     * @author 小布
     * @date 2022/1/17 17:13
     */
    public static HorizontalCellStyleStrategy horizontalCellStyleStrategy() {
        // 头的策略
        WriteCellStyle headWriteCellStyle = new WriteCellStyle();
        headWriteCellStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        WriteFont headWriteFont = new WriteFont();
        headWriteFont.setFontName("微软雅黑");
        headWriteFont.setFontHeightInPoints((short) 10);
        headWriteCellStyle.setWriteFont(headWriteFont);
        // 内容格式
        WriteCellStyle contentWriteCellStyle = new WriteCellStyle();
        WriteFont contentWriteFont = new WriteFont();
        contentWriteFont.setFontName("微软雅黑");
        contentWriteFont.setFontHeightInPoints((short) 9);
        contentWriteCellStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        contentWriteCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        contentWriteCellStyle.setHorizontalAlignment(HorizontalAlignment.CENTER);
        contentWriteCellStyle.setBorderBottom(BorderStyle.THIN);
        contentWriteCellStyle.setBorderLeft(BorderStyle.THIN);
        contentWriteCellStyle.setBorderRight(BorderStyle.THIN);
        contentWriteCellStyle.setBorderTop(BorderStyle.THIN);
        contentWriteCellStyle.setWriteFont(contentWriteFont);
        return new HorizontalCellStyleStrategy(headWriteCellStyle, contentWriteCellStyle);
    }


    /**
     * EasyExcel不支持Map的写入  将LinkedHashMap 转成 List<List<Object>>
     *
     * @param list list
     * @return java.util.List<java.util.List < java.lang.Object>>
     * @author 小布
     * @date 2022/1/25 9:10
     */
    public static List<List<Object>> map2List(List<LinkedHashMap<String, Object>> list) {
        List<List<Object>> excelList = new ArrayList<>();
        for (LinkedHashMap<String, Object> map : list) {
            List<Object> data = new ArrayList<>();
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                data.add(entry.getValue());
                // if (isImage(String.valueOf(entry.getValue()))) {
                //     // 设置超链接
                //     WriteCellData<String> hyperlink = new WriteCellData<>(String.valueOf(entry.getValue()));
                //     HyperlinkData hyperlinkData = new HyperlinkData();
                //     hyperlink.setHyperlinkData(hyperlinkData);
                //     hyperlinkData.setAddress(String.valueOf(entry.getValue()));
                //     hyperlinkData.setHyperlinkType(HyperlinkData.HyperlinkType.URL);
                //     data.add(hyperlink);
                // } else {
                //     data.add(entry.getValue());
                // }
            }
            excelList.add(data);
        }
        return excelList;
    }

    public static Boolean isImage(String value) {
        String s = value.toLowerCase();
        if (s.contains(".jpg")) {
            return true;
        }
        if (s.contains(".png")) {
            return true;
        }
        if (s.contains(".gif")) {
            return true;
        }
        return s.contains(".bmp");
    }

    public static List<List<Object>> map2ListMap(List<String> keysList, List<Map<String, Object>> list) {
        if (null == list || 0 == list.size()) {
            return new ArrayList<>();
        }
        List<List<Object>> excelList = new ArrayList<>();
        for (Map<String, Object> map : list) {
            List<Object> data = new ArrayList<>();
            for (String key : keysList) {
                data.add(map.getOrDefault(key.toLowerCase(Locale.ROOT), map.get(key)));
            }
            excelList.add(data);
        }
        return excelList;
    }

    public static HorizontalCellStyleStrategy horizontalCellStyleStrategyAuto() {
        // 头的策略
        WriteCellStyle headWriteCellStyle = new WriteCellStyle();
        headWriteCellStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        WriteFont headWriteFont = new WriteFont();
        headWriteFont.setFontName("等线");
        headWriteFont.setFontHeightInPoints((short) 11);
        headWriteCellStyle.setShrinkToFit(true);
        headWriteCellStyle.setWriteFont(headWriteFont);
        // 内容格式
        WriteCellStyle contentWriteCellStyle = new WriteCellStyle();
        WriteFont contentWriteFont = new WriteFont();
        contentWriteFont.setFontName("等线");
        contentWriteFont.setFontHeightInPoints((short) 11);
        contentWriteCellStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        contentWriteCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        contentWriteCellStyle.setHorizontalAlignment(HorizontalAlignment.LEFT);
        contentWriteCellStyle.setBorderBottom(BorderStyle.THIN);
        contentWriteCellStyle.setBorderLeft(BorderStyle.THIN);
        contentWriteCellStyle.setBorderRight(BorderStyle.THIN);
        contentWriteCellStyle.setBorderTop(BorderStyle.THIN);
        contentWriteCellStyle.setShrinkToFit(true);
        contentWriteCellStyle.setWriteFont(contentWriteFont);
        return new HorizontalCellStyleStrategy(headWriteCellStyle, contentWriteCellStyle);
    }

    /**
     * writeWithCustomizeCellStyle
     * 自定义的默认样式写数据
     *
     * @param out       out
     * @param sheetName sheetName
     * @param head      head
     * @param data      data
     * @author 小布
     * @date 2022/1/18 9:53
     */
    public void writeWithCustomize(OutputStream out, String sheetName, List<List<String>> head, List<T> data) throws IOException {
        try {
            EasyExcel.write(out, WidthAndHeightData.class)
                    .registerWriteHandler(horizontalCellStyleStrategy())
                    .sheet(sheetName).head(head)
                    .doWrite(data);
        } finally {
            out.close();
        }

    }

    /**
     * 默认的样式写文件
     */
    public void writeWithDefaultCellStyle(OutputStream out, String sheetName, String[] headArr, List<T> data) throws IOException {
        ExcelWriter excelWriter = null;
        try {
            excelWriter = EasyExcelFactory.write(out).build();
            // 动态添加表头，适用一些表头动态变化的场景
            WriteSheet sheet = new WriteSheet();
            sheet.setSheetName(sheetName);
            sheet.setSheetNo(0);
            // 创建一个表格，用于 Sheet 中使用
            WriteTable table = new WriteTable();
            table.setTableNo(1);
            table.setHead(simpleHead(headArr));
            // 写数据
            excelWriter.write(data, sheet, table);
        } finally {
            // 千万别忘记finish 会帮忙关闭流
            if (excelWriter != null) {
                excelWriter.finish();
            }
            out.close();
        }
    }

    /**
     * writeWithCustomizeExcludeColumn
     * 动态排除要写入的字段
     *
     * @param out                     out
     * @param sheetName               sheetName
     * @param head                    head
     * @param excludeColumnFiledNames excludeColumnFiledNames
     * @param data                    data
     * @author 小布
     * @date 2022/1/26 13:40
     */
    public void writeWithCustomizeExcludeColumn(OutputStream out, String sheetName, List<List<String>> head, Set<String> excludeColumnFiledNames, List<T> data) throws IOException {
        try {
            EasyExcel.write(out, WidthAndHeightData.class).excludeColumnFiledNames(excludeColumnFiledNames)
                    .registerWriteHandler(horizontalCellStyleStrategy())
                    .sheet(sheetName).head(head)
                    .doWrite(data);
        } finally {
            out.close();
        }

    }
}
```

### 读

```java
package com.xiaobu.entity;

import cn.hutool.json.JSONUtil;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.DependsOn;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author 小布
 * @version 1.0.0
 * @date on  2021/6/17 16:31
 */
@Slf4j
@DependsOn("springContextUtils")
public class ExcelListener<T> extends AnalysisEventListener<T> {
    /**
     * 默认给一万 过大效率会变低
     */
    private static final int BATCH_COUNT = 10000;
    List<T> list = new ArrayList<>();
    /**
     * 是否保存数据
     */
    Boolean saveData;
    List<String> headList = new ArrayList<>();

    public ExcelListener() {
    }

    @Override
    public void invoke(T data, AnalysisContext context) {
        log.info("解析到一条数据:{}", JSONUtil.toJsonStr(data));
        list.add(data);
        // 把BATCH_COUNT倍数的数据全部save
        if (saveData && list.size() >= BATCH_COUNT) {
            saveData();
            list.clear();
        }
    }

    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        if (saveData) {
            // 把最后的数据统一保存起来 有可能数据不是BATCH_COUNT的整数倍
            saveData();
        }
    }

    /**
     * 读取表头 考虑表头信息如何处理
     */
    @Override
    public void invokeHeadMap(Map<Integer, String> headMap, AnalysisContext context) {
        super.invokeHeadMap(headMap, context);
        for (Map.Entry<Integer, String> entry : headMap.entrySet()) {
            headList.add("item" + (entry.getKey() + 1));
        }
    }

    /**
     * 加上存储数据库
     */
    private void saveData() {
        log.info("{}条数据，开始存储数据库！", list.size());
        log.info("存储数据库成功！");
    }

    public List<String> getHeadList() {
        return headList;
    }
}
```

#### web下载

注意要关闭流只能在外面关也就是执行完excelWriter.finish()之后 在这里用try-with-resource 语法糖可能会导致先关闭流然后执行excelWriter.finish();导致数据无法写入

正确示例：

```java
    public void exportData(HttpServletResponse response,) {
        ExcelWriter excelWriter = null;
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        String fileName = "export.xlsx";
        // 设置文件头：最后一个参数是设置下载文件名
        response.setHeader("Content-Disposition", "attachment;fileName=" + new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        // 设置文件ContentType类型，这样设置，会自动判断下载文件类型
        try {
            excelWriter = EasyExcel.write(response.getOutputStream(), WidthAndHeightData.class).registerWriteHandler(EasyExcelUtils.horizontalCellStyleStrategy()).build();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // 千万别忘记finish 会帮忙关闭流
            if (excelWriter != null) {
                excelWriter.finish();
            }
        }
    }
```

错误示例：

```java
    public void exportData(HttpServletResponse response) {
        ExcelWriter excelWriter = null;
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        String fileName = "export.xlsx";
        // 设置文件头：最后一个参数是设置下载文件名
        response.setHeader("Content-Disposition", "attachment;fileName=" + new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        // 设置文件ContentType类型，这样设置，会自动判断下载文件类型
        try (OutputStream out = response.getOutputStream()) {
            excelWriter = EasyExcel.write(out, WidthAndHeightData.class).registerWriteHandler(EasyExcelUtils.horizontalCellStyleStrategy()).build();
            int index = 0;
          
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // 千万别忘记finish 会帮忙关闭流
            if (excelWriter != null) {
                excelWriter.finish();
            }
        }
    }

```

编译后的源码(可以看出流先关闭了然后写数据导致excel没有数据)

```java
    public void exportData(HttpServletResponse response) {
        ExcelWriter excelWriter = null;
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        String fileName = "export.xlsx";
        response.setHeader("Content-Disposition", "attachment;fileName=" + new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        try {
            OutputStream out = response.getOutputStream();
            Throwable var6 = null;

            try {
                excelWriter = ((ExcelWriterBuilder)EasyExcel.write(out, WidthAndHeightData.class).registerWriteHandler(EasyExcelUtils.horizontalCellStyleStrategy())).build();
                List<List<String>> head = EasyExcelUtils.simpleHead(headArr);
                    WriteSheet writeSheet = ((ExcelWriterSheetBuilder)EasyExcel.writerSheet(index, dataSourceName).head(head)).build();
                    excelWriter.write(lists, writeSheet);
                out.flush();
            } catch (Throwable var47) {
                var6 = var47;
                throw var47;
            } finally {
                if (out != null) {
                    if (var6 != null) {
                        try {
                            out.close();
                        } catch (Throwable var46) {
                            var6.addSuppressed(var46);
                        }
                    } else {
                        out.close();
                    }
                }

            }
        } catch (IOException var49) {
            var49.printStackTrace();
        } finally {
            if (excelWriter != null) {
                excelWriter.finish();
            }

        }

    }

```

#### 下载csv

> https://github.com/alibaba/easyexcel/issues/2609

```java
public void exportCsvData(HttpServletResponse response){
        ExcelWriter excelWriter=null;
        response.setContentType("text/csv;charset=utf-8");
        response.setCharacterEncoding("utf-8");
        String fileName="export.csv";
        // 设置文件头：最后一个参数是设置下载文件名
        response.setHeader("Content-Disposition","attachment;fileName="+new String(fileName.getBytes(StandardCharsets.UTF_8),StandardCharsets.ISO_8859_1));
        // 设置文件ContentType类型，这样设置，会自动判断下载文件类型
        try{
        excelWriter=EasyExcel.write(response.getOutputStream(),WidthAndHeightData.class).excelType(ExcelTypeEnum.CSV).charset(Charset.forName("GBK")).registerWriteHandler(EasyExcelUtils.horizontalCellStyleStrategy()).build();
        }catch(IOException e){
        e.printStackTrace();
        }finally{
        // 千万别忘记finish 会帮忙关闭流
        if(excelWriter!=null){
        excelWriter.finish();
        }
        }
        }
```