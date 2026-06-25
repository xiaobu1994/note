# 调用bat文件工具类

> 原创 最新推荐文章于 2025-01-13 10:30:00 发布 · 公开 · 312 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/86712708

```java
package com.xiaobu.base.util;

import java.io.IOException;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2019/1/30 9:07
 * @description V1.0 调用bat文件并关闭cmd窗口
 */
public class CmdUtils {

    /**
     * @author xiaobu
     * @date 2019/1/30 9:13
     * @param path bat文件路径
     * @descprition   调用bat文件
     * @version 1.0
     */
    public static void dispatchBat(String path){
        //执行批处理文件
        String strcmd = "cmd /c start  "+path;
        Runtime rt = Runtime.getRuntime();
        Process ps = null;
        try {
            ps = rt.exec(strcmd);
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        try {
            assert ps != null;
            ps.waitFor();
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        int i = ps.exitValue();
        if (i == 0) {
            System.out.println("执行完成.");
        } else {
            System.out.println("执行失败.");
        }
        ps.destroy();
    }


    /**
     * @author xiaobu
     * @date 2019/1/30 9:14
     * @descprition  关闭cmd命令窗口
     * @version 1.0
     */
    public static void killProcess() {
        Runtime rt = Runtime.getRuntime();
        try {
            rt.exec("cmd.exe /C start wmic process where name='cmd.exe' call terminate");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
```