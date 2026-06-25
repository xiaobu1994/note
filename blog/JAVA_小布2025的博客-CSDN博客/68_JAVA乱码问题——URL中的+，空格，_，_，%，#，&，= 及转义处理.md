# JAVA乱码问题——URL中的+，空格，/，?，%，#，&，= 及转义处理

> 原创 最新推荐文章于 2025-01-24 21:26:51 发布 · 公开 · 6.9k 阅读 · 0 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83652639

解决办法：将这些字符转化成服务器可以识别的字符，对应关系如下：

下表中列出了一些URL特殊符号及编码

| + | URL 中+号表示空格 | %2B |
|:---:|:---:|:---:|
| 空格 | URL中的空格可以用+号或者编码 | %20 |
| / | 分隔目录和子目录 | %2F |
| ? | 分隔实际的URL和参数 | %3F |
| % | 指定特殊字符 | %25 |
| # | 表示书签 | %23 |
| & | URL 中指定的参数间的分隔符 | %26 |
| = | URL 中指定参数的值 | %3D |

进行编码的时候把字符串用可识别的字符替换一下

```java
        BASE64Encoder base64Encoder = new BASE64Encoder();
        String encoderStr = base64Encoder.encode(Objects.requireNonNull(bytes));
        //为防止在url传输的时候问题。
        return encoderStr.replaceAll("/", "-").replaceAll("\\+", "_");
```

解码之前也要替换回来

```java
            BASE64Decoder base64De = new BASE64Decoder();
            byte[] b = null;
            sn=sn.replaceAll("-", "/").replaceAll("_", "+");
            b = base64De.decodeBuffer(sn);
```