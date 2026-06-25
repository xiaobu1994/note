# POI 导出工具类

> 原创 最新推荐文章于 2024-08-18 23:51:42 发布 · 公开 · 392 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/82259996

```java
package com.minisay.base.util;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.xssf.streaming.SXSSFCell;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 利用开源组件POI动态导出EXCEL文档,此工具使用到泛型，所以不能声明为静态，使用前必须实例化
 *
 * @param <T> 应用泛型，代表任意一个符合javabean风格的类
 *            <p/>
 *            注意这里为了简单起见，boolean型的属性xxx的get器方式为getXxx(),而不是isXxx()
 *            <p/>
 *            byte[]表jpg格式的图片数据
 */

public class ExcelExportUtil<T> {
    private final static Pattern PATTERN = Pattern.compile("^//d+(//.//d+)?$");

    /**

     * 这是一个通用的方法，利用了JAVA的反射机制，可以将放置在JAVA集合中并且符号一定条件的数据以EXCEL 的形式输出到指定IO设备上
     * @param title  表格标题名
     * @param headers 表格属性列名数组
     * @param properties 需要导出的属性值，需要和列名保持对应
     * @param columnWidths 列宽，需要和列名保持对应
     * @param dataset 需要显示的数据集合,集合中一定要放置符合javabean风格的类的对象。此方法支持的
     *            javabean属性的数据类型有基本数据类型及String,Date,byte[](图片数据)
     * @param out  与输出设备关联的流对象，可以将EXCEL文档导出到本地文件或者网络中
     * @param pattern 如果有时间数据，设定输出格式。默认为"yyy-MM-dd"
     */
    /**
     * 这是一个通用的方法，利用了JAVA的反射机制，可以将放置在JAVA集合中并且符号一定条件的数据以EXCEL 的形式输出到指定IO设备上
     *
     * @param title        表格标题名
     * @param headers      表格属性列名数组
     * @param properties   需要导出的属性值，需要和列名保持对应
     * @param columnWidths 列宽，需要和列名保持对应
     */

    public static void exportExcelByLine(String filePath, String title, String[] headers, ArrayList<String[]> properties, int[] columnWidths) {


        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();

        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet(title);

        // 设置表格默认列宽度为15个字节
//        sheet.setDefaultColumnWidth((short) 25);
        sheet.setDefaultColumnWidth(25);

        //设置每一列的宽度
        for (short i = 0; i < columnWidths.length; i++) {
            sheet.setColumnWidth(i, columnWidths[i] * 256);  //设置列宽，20个字符
        }

        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();

        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);

        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);

        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);

        style.setBorderRight(HSSFCellStyle.BORDER_THIN);

        style.setBorderTop(HSSFCellStyle.BORDER_THIN);

        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        // 生成一个字体
        HSSFFont font = workbook.createFont();

        font.setColor(HSSFColor.VIOLET.index);

        font.setFontHeightInPoints((short) 12);

        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

        // 把字体应用到当前的样式
        style.setFont(font);

        // 生成并设置另一个样式
        HSSFCellStyle style2 = workbook.createCellStyle();

        style2.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);

        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);

        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);

        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);

        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);

        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        // 生成另一个字体

        HSSFFont font2 = workbook.createFont();

        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);

        // 把字体应用到当前的样式

        style2.setFont(font2);


        // 声明一个画图的顶级管理器
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
//
//        // 定义注释的大小和位置,详见文档
//        HSSFComment comment = patriarch.createComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
//
//        // 设置注释内容
//        comment.setString(new HSSFRichTextString("可以在POI中添加注释！"));
//
//        // 设置注释作者，当鼠标移动到单元格上是可以在状态栏中看到该内容.
//        comment.setAuthor("李超");


        //产生表格标题行
        HSSFRow row = sheet.createRow(0);

        for (int i = 0; i < headers.length; i++) {
            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);
        }

        if (properties != null && properties.size() > 0) {
            int rowNum = properties.size();
            int columNum = properties.get(0).length;
            for (int j = 0; j < rowNum; j++) {
                HSSFRow rowj = sheet.createRow(j + 1);
                for (int i = 0; i < headers.length; i++) {
                    HSSFCell cell = rowj.createCell(i);
                    cell.setCellStyle(style2);
                    HSSFRichTextString text = new HSSFRichTextString(properties.get(j)[i]);
                    cell.setCellValue(text);
                }
            }
        }


        try {
            String sep = System.getProperty("file.separator");
            // 设置输入流
            FileOutputStream fOut = new FileOutputStream(filePath + sep + title + ".xls");
            workbook.write(fOut);
            fOut.flush();
            // 操作结束，关闭文件
            fOut.close();

        } catch (IOException e) {
            e.printStackTrace();
        }


    }

    /**
     * @param title        excel的标题
     * @param headers      excel的表头名
     * @param properties   excel的属性
     * @param columnWidths excel的每行的宽度
     * @param dataset      要导出的数据
     * @param out          输出流
     * @param pattern      时间格式
     */
    public void exportExcel(String title, String[] headers, String[] properties, int[] columnWidths,

                            Collection<T> dataset, OutputStream out, String pattern) {

        if (pattern == null) {
            pattern = "yyy-MM-dd";
        }
        // 声明一个工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();

        // 生成一个表格
        HSSFSheet sheet = workbook.createSheet(title);

        // 设置表格默认列宽度为15个字节
//        sheet.setDefaultColumnWidth((short) 25);
        sheet.setDefaultColumnWidth(25);

        //设置每一列的宽度
        for (short i = 0; i < columnWidths.length; i++) {
            sheet.setColumnWidth(i, columnWidths[i] * 256);  //设置列宽，20个字符
        }

        // 生成一个样式
        HSSFCellStyle style = workbook.createCellStyle();

        // 设置这些样式
        style.setFillForegroundColor(HSSFColor.SKY_BLUE.index);

        style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);

        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);

        style.setBorderRight(HSSFCellStyle.BORDER_THIN);

        style.setBorderTop(HSSFCellStyle.BORDER_THIN);

        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        // 生成一个字体
        HSSFFont font = workbook.createFont();

        font.setColor(HSSFColor.VIOLET.index);

        font.setFontHeightInPoints((short) 12);

        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

        // 把字体应用到当前的样式
        style.setFont(font);

        // 生成并设置另一个样式
        HSSFCellStyle style2 = workbook.createCellStyle();

        style2.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);

        style2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

        style2.setBorderBottom(HSSFCellStyle.BORDER_THIN);

        style2.setBorderLeft(HSSFCellStyle.BORDER_THIN);

        style2.setBorderRight(HSSFCellStyle.BORDER_THIN);

        style2.setBorderTop(HSSFCellStyle.BORDER_THIN);

        style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);

        style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        // 生成另一个字体

        HSSFFont font2 = workbook.createFont();

        font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);

        HSSFFont font3 = workbook.createFont();

        font3.setColor(HSSFColor.BLUE.index);

        // 把字体应用到当前的样式

        style2.setFont(font2);


        // 声明一个画图的顶级管理器
        HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
//
//        // 定义注释的大小和位置,详见文档
//        HSSFComment comment = patriarch.createComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
//
//        // 设置注释内容
//        comment.setString(new HSSFRichTextString("可以在POI中添加注释！"));
//
//        // 设置注释作者，当鼠标移动到单元格上是可以在状态栏中看到该内容.
//        comment.setAuthor("李超");


        //产生表格标题行
        HSSFRow row = sheet.createRow(0);

        for (int i = 0; i < headers.length; i++) {

            HSSFCell cell = row.createCell(i);
            cell.setCellStyle(style);
            HSSFRichTextString text = new HSSFRichTextString(headers[i]);
            cell.setCellValue(text);

        }


        //遍历集合数据，产生数据行

        Iterator<T> it = dataset.iterator();

        int index = 0;

        while (it.hasNext()) {

            index++;

            row = sheet.createRow(index);

            T t = (T) it.next();

            //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值

//            Field[] fields = t.getClass().getDeclaredFields();

            for (int i = 0; i < properties.length; i++) {

                HSSFCell cell = row.createCell(i);

                cell.setCellStyle(style2);

                String fieldName = properties[i];

                String getMethodName = "get"

                        + fieldName.substring(0, 1).toUpperCase()

                        + fieldName.substring(1);

                try {

                    Class tCls = t.getClass();

                    Method getMethod = tCls.getMethod(getMethodName,

                            new Class[]{});

                    Object value = getMethod.invoke(t, new Object[]{});
                    if (value == null) {
                        continue;
                    }
                    //判断值的类型后进行强制类型转换

                    String textValue = null;
                    if (value instanceof Boolean) {

                        boolean bValue = (Boolean) value;

                        textValue = "男";

                        if (!bValue) {

                            textValue = "女";

                        }

                    } else if (value instanceof Date) {

                        Date date = (Date) value;

                        SimpleDateFormat sdf = new SimpleDateFormat(pattern);

                        textValue = sdf.format(date);

                    } else if (value instanceof byte[]) {

                        // 有图片时，设置行高为60px;

                        row.setHeightInPoints(60);
                        // 设置图片所在列宽度为80px,注意这里单位的一个换算
//                        sheet.setColumnWidth(i, (short) (35.7 * 80));
                        // sheet.autoSizeColumn(i);
                        byte[] bsValue = (byte[]) value;
                        HSSFClientAnchor anchor = new HSSFClientAnchor(0, 0,
                                1023, 255, (short) 6, index, (short) 6, index);
                        anchor.setAnchorType(2);
                        patriarch.createPicture(anchor, workbook.addPicture(
                                bsValue, HSSFWorkbook.PICTURE_TYPE_JPEG));
                    } else {
                        //其它数据类型都当作字符串简单处理
                        textValue = value.toString();
                    }
                    //如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                    if (textValue != null) {
                        Matcher matcher = PATTERN.matcher(textValue);
                        if (matcher.matches()) {
                            //是数字当作double处理
                            cell.setCellValue(Double.parseDouble(textValue));
                        } else {
                            HSSFRichTextString richString = new HSSFRichTextString(textValue);
                            richString.applyFont(font3);
                            cell.setCellValue(richString);
                        }
                    }
                } catch (SecurityException | NoSuchMethodException | IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
                    e.printStackTrace();
                } finally {
                    //清理资源
                }
            }
        }
        try {
            workbook.write(out);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @param title  sheet名
     * @param headers   列名
     * @param properties  要导出的数据的字段
     * @param columnWidths excel的列狂
     * @param dataset 数据
     * @param out  输出流
     * @param pattern  时间格式
     */
    public void exportExcelX(String title, String[] headers, String[] properties, int[] columnWidths,
                             Collection<T> dataset, OutputStream out, String pattern) {
        if (pattern == null) {
            pattern = "yyy-MM-dd";
        }
        // 声明一个工作薄
        SXSSFWorkbook workbook = new SXSSFWorkbook(100);
        // 生成一个表格
        SXSSFSheet sheet = (SXSSFSheet) workbook.createSheet(title);
        // 设置表格默认列宽度为15个字节
//        sheet.setDefaultColumnWidth((short) 25);
        sheet.setDefaultColumnWidth(25);
        //设置每一列的宽度
        for (short i = 0; i < columnWidths.length; i++) {
            sheet.setColumnWidth(i, columnWidths[i] * 256);  //设置列宽，20个字符
        }
        // 生成一个样式
        CellStyle style = workbook.createCellStyle();
        // 生成一个字体
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        // 把字体应用到当前的样式
        style.setFont(font);
        // 生成并设置另一个样式
        CellStyle style2 = workbook.createCellStyle();
        // 生成另一个字体
        Font font2 = workbook.createFont();
        // 把字体应用到当前的样式
        style2.setFont(font2);
        //产生表格标题行
        SXSSFRow row = (SXSSFRow) sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            SXSSFCell cell = (SXSSFCell) row.createCell(i);
            cell.setCellStyle(style);
            cell.setCellValue(headers[i]);
        }
        //遍历集合数据，产生数据行
        Iterator<T> it = dataset.iterator();
        int index = 0;
        while (it.hasNext()) {
            index++;
            row = (SXSSFRow) sheet.createRow(index);
            T t = (T) it.next();
            //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
//            Field[] fields = t.getClass().getDeclaredFields();
            for (int i = 0; i < properties.length; i++) {
                SXSSFCell cell = (SXSSFCell) row.createCell(i);
                cell.setCellStyle(style2);
                String fieldName = properties[i];
                String getMethodName = "get"
                        + fieldName.substring(0, 1).toUpperCase()
                        + fieldName.substring(1);
                try {
                    Class tCls = t.getClass();
                    Method getMethod = tCls.getMethod(getMethodName,
                            new Class[]{});
                    Object value = getMethod.invoke(t, new Object[]{});
                    if (value == null) {
                        continue;
                    }
                    //判断值的类型后进行强制类型转换
                    String textValue = null;
                    if (value instanceof Boolean) {
                        boolean bValue = (Boolean) value;
                        textValue = "男";
                        if (!bValue) {
                            textValue = "女";
                        }
                    } else if (value instanceof Date) {
                        Date date = (Date) value;
                        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                        textValue = sdf.format(date);
                    } else if (value instanceof byte[]) {
                        // 有图片时，设置行高为60px;
                        row.setHeightInPoints(60);
                    } else {
                        //其它数据类型都当作字符串简单处理
                        textValue = value.toString();
                    }
                    //如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                    if (textValue != null) {
                        Matcher matcher = PATTERN.matcher(textValue);
                        if (matcher.matches()) {
                            //是数字当作double处理
                            cell.setCellValue(Double.parseDouble(textValue));
                        } else {
                            cell.setCellValue(textValue);
                        }
                    }
                } catch (SecurityException | InvocationTargetException | IllegalAccessException | IllegalArgumentException | NoSuchMethodException e) {
                    e.printStackTrace();
                } finally {
                    //清理资源
                }
            }
        }
        try {
            workbook.write(out);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     *
     * @param title  标题
     * @param headers 列名
     * @param properties  分页导出
     * @param columnWidths 列宽
     * @param dataset  要导出的数据
     * @param pattern  时间格式
     */
    public void exportExcelX(String title, String[] headers, String[] properties, int[] columnWidths,
                             Collection<T> dataset, SXSSFWorkbook workbook , String pattern) {
        if (pattern == null) {
            pattern = "yyy-MM-dd";
        }
        // 声明一个工作薄

        // 生成一个表格
        SXSSFSheet sheet = (SXSSFSheet) workbook.createSheet(title);
        // 设置表格默认列宽度为15个字节
//        sheet.setDefaultColumnWidth((short) 25);
        sheet.setDefaultColumnWidth(25);
        //设置每一列的宽度
        for (short i = 0; i < columnWidths.length; i++) {
            sheet.setColumnWidth(i, columnWidths[i] * 256);  //设置列宽，20个字符
        }
        // 生成一个样式
        CellStyle style = workbook.createCellStyle();
        // 生成一个字体
        Font font = workbook.createFont();
        font.setFontHeightInPoints((short) 12);
        // 把字体应用到当前的样式
        style.setFont(font);
        // 生成并设置另一个样式
        CellStyle style2 = workbook.createCellStyle();
        // 生成另一个字体
        Font font2 = workbook.createFont();
        // 把字体应用到当前的样式
        style2.setFont(font2);
        //产生表格标题行
        SXSSFRow row = (SXSSFRow) sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            SXSSFCell cell = (SXSSFCell) row.createCell(i);
            cell.setCellStyle(style);
            cell.setCellValue(headers[i]);
        }
        //遍历集合数据，产生数据行
        Iterator<T> it = dataset.iterator();
        int index = 0;
        while (it.hasNext()) {
            index++;
            row = (SXSSFRow) sheet.createRow(index);
            T t = (T) it.next();
            //利用反射，根据javabean属性的先后顺序，动态调用getXxx()方法得到属性值
//            Field[] fields = t.getClass().getDeclaredFields();
            for (int i = 0; i < properties.length; i++) {
                SXSSFCell cell = (SXSSFCell) row.createCell(i);
                cell.setCellStyle(style2);
                String fieldName = properties[i];
                String getMethodName = "get"
                        + fieldName.substring(0, 1).toUpperCase()
                        + fieldName.substring(1);
                try {
                    Class tCls = t.getClass();
                    Method getMethod = tCls.getMethod(getMethodName,
                            new Class[]{});
                    Object value = getMethod.invoke(t, new Object[]{});
                    if (value == null) {
                        continue;
                    }
                    //判断值的类型后进行强制类型转换
                    String textValue = null;
                    if (value instanceof Boolean) {
                        boolean bValue = (Boolean) value;
                        textValue = "男";
                        if (!bValue) {
                            textValue = "女";
                        }
                    } else if (value instanceof Date) {
                        Date date = (Date) value;
                        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                        textValue = sdf.format(date);
                    } else if (value instanceof byte[]) {
                        // 有图片时，设置行高为60px;
                        row.setHeightInPoints(60);
                    } else {
                        //其它数据类型都当作字符串简单处理
                        textValue = value.toString();
                    }
                    //如果不是图片数据，就利用正则表达式判断textValue是否全部由数字组成
                    if (textValue != null) {
                        Matcher matcher = PATTERN.matcher(textValue);
                        if (matcher.matches()) {
                            //是数字当作double处理
                            cell.setCellValue(Double.parseDouble(textValue));
                        } else {
                            cell.setCellValue(textValue);
                        }
                    }
                } catch (SecurityException | NoSuchMethodException | IllegalAccessException | IllegalArgumentException| InvocationTargetException e) {
                    e.printStackTrace();
                } finally {
                    //清理资源
                }
            }

        }

    }

}


```