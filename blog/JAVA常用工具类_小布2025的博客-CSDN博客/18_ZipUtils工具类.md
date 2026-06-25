# ZipUtils工具类

> 原创 最新推荐文章于 2025-05-15 10:55:06 发布 · 公开 · 1k 阅读 · 0 · 1 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/103277167

```java
package com.xiaobu.base.util;

import lombok.extern.slf4j.Slf4j;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/7/25 10:54
 * @description zip压缩解压工具类
 */
@Slf4j
public class ZipUtil {

    private static final int BUFFER_SIZE = 4096;

    /**
     * 功能描述:压缩单个文件
     *
     * @param filePath, outPut
     * @return void
     * @author xiaobu
     * @date 2019/7/25 10:55
     * @version 1.0  file.getName().split("\\.")[0].concat(".zip") windows情况
     */
    public static void compressSingleFile(String filePath, String outPut) {
        try {
            File file = new File(filePath);
            String zipFileName = file.getName().split("\\.")[0].concat(".zip");
            System.out.println("zipFileName:" + zipFileName);
            System.out.println("1234 = " + outPut + File.separator + zipFileName);
            FileOutputStream fos = new FileOutputStream(outPut + File.separator + zipFileName);
            ZipOutputStream zos = new ZipOutputStream(fos);
            zos.putNextEntry(new ZipEntry(file.getName()));
            byte[] bytes = Files.readAllBytes(Paths.get(filePath));
            zos.write(bytes, 0, bytes.length);
            zos.closeEntry();
            zos.close();
        } catch (FileNotFoundException ex) {
            System.err.format("The file %s does not exist", filePath);
        } catch (IOException ex) {
            System.err.println("I/O error: " + ex);
        }
    }


    /**
     * 功能描述:压缩多个文件
     *
     * @param files, outputStream]
     * @return void
     * @author xiaobu
     * @date 2019/11/27 15:34
     * @version 1.0
     */
    public static void compressZip(List<File> files, OutputStream outputStream) {
        ZipOutputStream zipOutStream = null;
        try {
            //-- 包装成ZIP格式输出流
            zipOutStream = new ZipOutputStream(new BufferedOutputStream(outputStream));
            // -- 设置压缩方法
            zipOutStream.setMethod(ZipOutputStream.DEFLATED);
            //-- 将多文件循环写入压缩包
            for (int i = 0; i < files.size(); i++) {
                File file = files.get(i);
                FileInputStream filenputStream = new FileInputStream(file);
                byte[] data = new byte[(int) file.length()];
                filenputStream.read(data);
                //-- 添加ZipEntry，并ZipEntry中写入文件流，这里，加上i是防止要下载的文件有重名的导致下载失败
                zipOutStream.putNextEntry(new ZipEntry(file.getName()));
                zipOutStream.write(data);
                filenputStream.close();
                zipOutStream.closeEntry();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (Objects.nonNull(zipOutStream)) {
                    zipOutStream.flush();
                    zipOutStream.close();
                }
                if (Objects.nonNull(outputStream)) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    /**
     * 功能描述:解压
     *
     * @param zipFilePath, destDirectory]
     * @return void
     * @author xiaobu
     * @date 2019/11/27 15:26
     * @version 1.0
     */
    public static void unzip(String zipFilePath, String destDirectory) throws IOException {
        File destDir = new File(destDirectory);
        if (!destDir.exists()) {
            destDir.mkdir();
        }
        ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath));
        ZipEntry entry = zipIn.getNextEntry();
        // iterates over entries in the zip file
        while (entry != null) {
            String filePath = destDirectory + File.separator + entry.getName();
            if (!entry.isDirectory()) {
                // if the entry is a file, extracts it
                extractFile(zipIn, filePath);
            } else {
                // if the entry is a directory, make the directory
                File dir = new File(filePath);
                dir.mkdir();
            }
            zipIn.closeEntry();
            entry = zipIn.getNextEntry();
        }
        zipIn.close();
    }


    public static void extractFile(ZipInputStream zipIn, String filePath) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
        byte[] bytesIn = new byte[BUFFER_SIZE];
        int read = 0;
        while ((read = zipIn.read(bytesIn)) != -1) {
            bos.write(bytesIn, 0, read);
        }
        bos.close();
    }


    public static void main(String[] args) {
/*        String filePath = "D:\\thw\\8888老地方大饼专卖店2019-07-24现场工作.xlsx";
        String outPut = "D:\\thw";
        compressSingleFile(filePath,outPut);*/
      /*  File file1 = new File("D:\\thw\\1.ftl");
        File file2 = new File("D:\\thw\\2.ftl");
        List<File> files = new ArrayList<>();
        files.add(file1);
        files.add(file2);
        try {
            FileOutputStream fileOutputStream = new FileOutputStream("D:\\thw\\1.zip");
            compressZip(files, fileOutputStream);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }*/
        long beginTime = System.currentTimeMillis();
        String zipPath = "D:\\thw\\test.zip";
        String destPath = "D:\\thw\\test";
        try {
            unzip(zipPath, destPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(System.currentTimeMillis() - beginTime);
    }

}

```