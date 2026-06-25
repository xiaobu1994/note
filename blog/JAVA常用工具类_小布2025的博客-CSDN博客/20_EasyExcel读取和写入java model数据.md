# EasyExcel读取和写入java model数据

> 原创 最新推荐文章于 2026-03-26 17:31:26 发布 · 公开 · 4.3k 阅读 · 0 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89084125

Pom.xml

```
<dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>easyexcel</artifactId>
            <version>2.0.2</version>
        </dependency>
```

一、JAVA Model

```java
package com.xiaobu.entity.vo;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.metadata.BaseRowModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/12/13 14:28
 * @description V1.0
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class MaterialVo2 extends BaseRowModel implements Serializable {

    private static final long serialVersionUID = -915961683240343754L;

    private String id;

    @ExcelProperty(value = "物料sn",index =0)
    private String materialSn;

    @ExcelProperty(value = "物料类型",index =1)
    private  String materialType;

    @ExcelProperty(value = "采购订单号",index =2)
    private String orderNumber;

    @ExcelProperty(value = "行项目号",index =3)
    private String itemNumber;

    @ExcelProperty(value = "供应商",index =4)
    private  String supplier;

    @ExcelProperty(value = "需求单位",index =5)
    private  String applicantId;

    @ExcelProperty(value = "计划单价",index =6)
    private double planPrice;

    @ExcelProperty(value = "采购单价",index =7)
    private double purPrice;

    @ExcelProperty(value = "物料状态",index =8)
    private int materialState;

    //质检员
    @ExcelProperty(value = "质检员",index =9)
    private  String  assessorw;

    @ExcelProperty(value = "采购人",index =10)
    private String buyer ;

    @ExcelProperty(value = "操作人",index =11)
    private String userId;


    //计量单位
    @ExcelProperty(value = "计量单位",index =12)
    private  String count;

    @ExcelProperty(value = "创建时间",index =13)
    private long createTime = System.currentTimeMillis();

    @ExcelProperty(value = "物料描述",index =14)
    private  String description;

    @ExcelProperty(value = "单个SN对应数量",index =15)
    private int  amount=1;

    @ExcelProperty(value = "计划打包金额",index =16)
    private double planTotal;


    @ExcelProperty(value = "采购打包金额",index =17)
    private double totalPrice;

}
```

二、mapper方法

```java
<?xml version="1.0" encoding="UTF-8" ?>

<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.xiaobu.mapper.MaterialMapper">

    <resultMap type="com.xiaobu.entity.vo.MaterialVo" id="materialvos">
        <id property="materialSn" column="materialSn"/>
        <result property="materialType" column="materialType"/>
        <result property="orderNumber" column="orderNumber"/>
        <result property="itemNumber" column="itemNumber"/>
    </resultMap>

    <select id="findAll" resultMap="materialvos">
        select materialSn,materialType,orderNumber,itemNumber,supplier
        from xg_material
    </select>


    <resultMap type="com.xiaobu.entity.vo.MaterialVo2" id="materialvo2s">
        <id property="materialSn" column="materialSn"/>
        <result property="materialType" column="materialType"/>
        <result property="orderNumber" column="orderNumber"/>
        <result property="itemNumber" column="itemNumber"/>
        <result property="supplier" column="supplier"/>
        <result property="applicantId" column="applicantId"/>
        <result property="planPrice" column="planPrice"/>
        <result property="purPrice" column="purPrice"/>
        <result property="materialState" column="materialState"/>
        <result property="assessorw" column="assessorw"/>
        <result property="buyer" column="buyer"/>
        <result property="userId" column="userId"/>
        <result property="userId" column="userId"/>
        <result property="count" column="count"/>
        <result property="createTime" column="createTime"/>
        <result property="description" column="description"/>
        <result property="amount" column="amount"/>
        <result property="planTotal" column="planTotal"/>
        <result property="totalPrice" column="totalPrice"/>
    </resultMap>

    <select id="findAll2" resultType="com.xiaobu.entity.vo.MaterialVo2">
        select materialSn,
               materialType,
               orderNumber,
               itemNumber,
               supplier,
               applicantId,
               planPrice,
               purPrice,
               materialState,
               assessorw,
               buyer,
               userId,
               count,
               createTime,
               description,
               amount,
               planTotal,
               totalPrice
        from xg_material
        order by createTime
        limit 0,100;
    </select>
    <insert id="insertMaterialVo2">
        insert into xg_material (materialSn, materialType, orderNumber, itemNumber, supplier, applicantId, planPrice,
                                 purPrice, materialState, assessorw, buyer, userId,
                                 count, createTime, description, amount, planTotal, totalPrice,id)
        values (#{materialSn}, #{materialType}, #{orderNumber}, #{itemNumber}, #{supplier}, #{applicantId},
                #{planPrice}, #{purPrice}, #{materialState},
                #{assessorw}, #{buyer}, #{userId}, #{count}, #{createTime}, #{description}, #{amount}, #{planTotal},
                #{totalPrice},#{id})
    </insert>

</mapper>
```

三、读取和写入

```java
package com.xiaobu.easyexcel;

import com.alibaba.excel.ExcelReader;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.metadata.Sheet;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.xiaobu.base.utils.UUIDUtils;
import com.xiaobu.entity.Material;
import com.xiaobu.entity.vo.MaterialVo2;
import com.xiaobu.mapper.MaterialMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import tk.mybatis.mapper.entity.Example;

import java.io.*;
import java.util.List;

import static org.apache.tomcat.util.file.ConfigFileLoader.getInputStream;

//import com.xiaobu.mapper.Demo1Mapper;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/12/12 14:24
 * @description V1.0  E:\Practise\SpringBoot
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class EasyExcelDemo1 {


    @Autowired
    private MaterialMapper materialMapper;


    /**
     * 功能描述:导出java model的数据
     *
     * @return void
     * @author xiaobu
     * @date 2019/4/8 9:14
     * @version 1.0 两种方式获取ExcelWriter 一个是通过
     * public ExcelWriter(OutputStream outputStream, ExcelTypeEnum typeEnum) {
     * this(outputStream, typeEnum, true);
     * }
     * public ExcelWriter(OutputStream outputStream, ExcelTypeEnum typeEnum, boolean needHead) {
     * this.excelBuilder = new ExcelBuilderImpl((InputStream)null, outputStream, typeEnum, needHead, (WriteHandler)null);
     * }
     * <p>
     * ExcelWriter writer = new ExcelWriter(out, ExcelTypeEnum.XLSX,true);
     * <p>
     * 另外是通过EasyExcelFactory.getWriter 最终还是调用的ExcelWriter带有是否需要表头和excel版本的构造方法
     * public static ExcelWriter getWriter(OutputStream outputStream) {
     * return new ExcelWriter(outputStream, ExcelTypeEnum.XLSX, true);
     * }
     * <p>
     * public static ExcelWriter getWriter(OutputStream outputStream, ExcelTypeEnum typeEnum, boolean needHead) {
     * return new ExcelWriter(outputStream, typeEnum, needHead);
     * }
     * <p>
     * new ExcelWriter(outputStream, typeEnum, needHead)
     * <p>
     */
    @Test
    public void writeExcelByPage() {
        try {
            OutputStream out = new FileOutputStream("E:\\Practise\\demo1.xlsx");
            //最直接的方法
            ExcelWriter writer = new ExcelWriter(out, ExcelTypeEnum.XLSX, true);
            Sheet sheet = new Sheet(1, 0, MaterialVo2.class, "第一个sheet", null);
            List<MaterialVo2> materialVos = materialMapper.findAll2();
            System.out.println("materialVos = " + materialVos);
            writer.write(materialVos, sheet);
            writer.finish();
            try {
                out.close();
                System.out.println(" demo1.xlsx生成成功。。。。");
            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * 功能描述:读取java model的excel数据
     *
     * @return void
     * @author xiaobu
     * @date 2019/4/8 9:13
     * @version 1.0 两种方式，一个是通过ExcelReader的构造方法获取
     * <p>
     * public ExcelReader(InputStream in, Object customContent, AnalysisEventListener eventListener) {
     * this(in, customContent, eventListener, true);x
     * }
     * <p>
     * public ExcelReader(InputStream in, Object customContent, AnalysisEventListener eventListener, boolean trim) {
     * ExcelTypeEnum excelTypeEnum = ExcelTypeEnum.valueOf(in);
     * this.validateParam(in, eventListener);
     * this.analyser = new ExcelAnalyserImpl(in, excelTypeEnum, customContent, eventListener, trim);
     * }
     * <p>
     * 第二种是通过EasyExcelFactory.getReader获取
     * public static ExcelReader getReader(InputStream in, AnalysisEventListener listener) {
     * return new ExcelReader(in, (Object)null, listener);
     * }
     * 最终还是调用的
     * public ExcelReader(InputStream in, Object customContent, AnalysisEventListener eventListener, boolean trim)
     */
    @Test
    public void saxReadSheetsV2007() {
        InputStream inputStream = null;
        try {
            inputStream = getInputStream("E:\\Practise\\demo1.xlsx");
            AnalysisEventListener<MaterialVo2> listener = new AnalysisEventListener<MaterialVo2>() {

                @Override
                public void invoke(MaterialVo2 m, AnalysisContext context) {

                    System.err.println("Row:" + context.getCurrentRowNum() + " Data:" + m);
                    String id = UUIDUtils.getUUID();
                    m.setId(id);
                    materialMapper.insertMaterialVo2(m);

                }

                @Override
                public void doAfterAllAnalysed(AnalysisContext context) {
                    System.err.println("doAfterAllAnalysed...");
                }
            };
            ExcelReader excelReader = new ExcelReader(inputStream, null, listener);
            // ExcelReader excelReader = EasyExcelFactory.getReader(inputStream, listener);
            // 第二个参数为表头行数，按照实际设置
            excelReader.read(new Sheet(1, 1, MaterialVo2.class));
            // 解析每行结果在listener中处理
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                assert inputStream != null;
                inputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


 

}

```



```
 public void export(HttpServletResponse response) {
      List<TestUser> testUsers=  testUserMapper.selectAll(null);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8");
        response.setCharacterEncoding("utf-8");
// 这里URLEncoder.encode可以防止中文乱码 当然和easyexcel没有关系
        String fileName = "用户.xlsx";
        try {
            //fileName = URLEncoder.encode(fileName, "UTF-8");
            // 设置文件头：最后一个参数是设置下载文件名
            response.setHeader("Content-Disposition", "attachment;fileName=" + new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
            //response.setHeader("Content-Disposition", "attachment;fileName=" + fileName);
            // 设置文件ContentType类型，这样设置，会自动判断下载文件类型
            EasyExcel.write(response.getOutputStream(), TestUser.class).sheet("模板").doWrite(testUsers);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
```