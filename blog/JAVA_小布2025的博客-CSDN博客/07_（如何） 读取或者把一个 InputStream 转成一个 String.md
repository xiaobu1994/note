# （如何） 读取或者把一个 InputStream 转成一个 String

> 原创 最新推荐文章于 2022-08-14 07:08:52 发布 · 公开 · 511 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89182871

```java
package com.xiaobu.test.InputStream;

import org.apache.commons.io.IOUtils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/4/10 13:54
 * @description V1.0
 */
public class Demo1 {
    public static void main(String[] args) throws IOException {
        InputStream inputStream = new FileInputStream("C:\\Users\\tanhw119214\\Desktop\\2019.txt");
        //方式一
        StringWriter writer = new StringWriter();
        IOUtils.copy(inputStream, writer, "GBK");
        String theString = writer.toString();
        System.out.println("theString = " + theString);
        // 方式二
        String sty = IOUtils.toString(inputStream, "GBK");
        System.out.println("sty = " + sty);

    }
}
```