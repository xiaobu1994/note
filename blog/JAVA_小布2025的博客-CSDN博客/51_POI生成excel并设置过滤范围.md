# POI生成excel并设置过滤范围

> 原创 最新推荐文章于 2026-06-12 15:01:31 发布 · 公开 · 1.4k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/105707423

```java
package com.xiaobu.poi;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;

import java.awt.Color;
import java.io.FileOutputStream;

/**  1048576  设置excel筛选的  SXSSFWorkbook的最大100w  生成的表格边框有效（过时方法）
 */
public class TestExcel {
    public static void main(String[] args) throws Throwable {
        // keep 100 rows in memory, exceeding rows will be flushed to disk
        Workbook wb = new SXSSFWorkbook(100);
        Sheet sh = wb.createSheet();
        for(int rownum = 0; rownum < 10; rownum++){
            Row row = sh.createRow(rownum);
            for(int cellnum = 0; cellnum < 10; cellnum++){
                Cell cell = row.createCell(cellnum);
				XSSFCellStyle xssfCellStyle = (XSSFCellStyle) wb.createCellStyle();
				xssfCellStyle.setFillForegroundColor(new XSSFColor(Color.YELLOW));
				xssfCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
				xssfCellStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
				xssfCellStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
				xssfCellStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
				xssfCellStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
				cell.setCellStyle(xssfCellStyle);
				//设置过滤范围
				CellRangeAddress cellRangeAddress=	CellRangeAddress.valueOf("A1:R1");
				//设置过滤
				sh.setAutoFilter(cellRangeAddress);
               // System.out.println(new CellReference(cell) );//org.apache.poi.ss.util.CellReference [A1]
                //  'A1'
                String address = new CellReference(cell).formatAsString();
                cell.setCellValue(address);
            }
        }
        FileOutputStream out = new FileOutputStream("E:/sxssf.xlsx");
        System.out.println(123);
        wb.write(out);
        out.close();
    }
}

```