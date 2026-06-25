# Java复制文件的4种方式

> 原创 最新推荐文章于 2025-01-09 21:25:18 发布 · 公开 · 291 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/107785229



1. 使用FileStreams复制

```java
    @SneakyThrows
    public static void copyFileByFileStreams(File source, File dest){
        try (InputStream inputStream = new FileInputStream(source);
             OutputStream outputStream = new FileOutputStream(dest);) {
            byte[] buf = new byte[1024];
            int buffRead;
            while ((buffRead = inputStream.read(buf)) > 0) {
                outputStream.write(buf, 0, buffRead);
            }
        }
    }

```

1. 使用FileChannel复制

```java
    @SneakyThrows
    public static void copyFileByFileChannel(File source, File dest) {
        try (FileChannel inputChannel = new FileInputStream(source).getChannel();
             FileChannel outputChannel = new FileOutputStream(dest).getChannel();) {
            outputChannel.transferFrom(inputChannel, 0, inputChannel.size());
        }
    }
```

1. 使用Commons IO复制

```java
 @SneakyThrows
    public static void copyFileUsingJava7Files(File source, File dest) {
        Files.copy(source.toPath(), dest.toPath());
    }
```

1. 使用Java7的Files类复制

```java
    @SneakyThrows
    private static void copyFileUsingApacheCommonsIO(File source, File dest)  {
        FileUtils.copyFile(source, dest);
    }
```