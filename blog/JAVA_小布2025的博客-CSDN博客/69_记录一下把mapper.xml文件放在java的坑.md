# 记录一下把mapper.xml文件放在java的坑

> 原创 最新推荐文章于 2024-10-17 09:03:58 发布 · 公开 · 2.2k 阅读 · 0 · 4 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/117823330

把mapper.xml文件放入java文件中
一、需要在pom文件指定resource

```xml
<build>
  <resources>
      <resource>
          <!-- xml放在java目录下-->
          <directory>src/main/java</directory>
          <includes>
              <include>**/*.xml</include>
          </includes>
      </resource>
      <!--指定资源的位置（xml放在resources下，可以不用指定）-->
      <resource>
          <directory>src/main/resources</directory>
      </resource>
  </resources>
</build>
```

二、xml路径扫描需要配置为classpath* 不然扫描到一个含有资源的文件夹之后它会立即返回，导致其他的mapper.xml的方法报找不到方法。

```properties
mybatis-plus.mapper-locations=classpath*:com/xiaobu/**/xml/*.xml
```

不用classpath*有两种方式
一、直接在resource文件夹下创建同目录来存放xml 编译之后mapper文件和mapper.xml文件就会在通过文件夹
然后不需要配置xml的路径 mapperScan会自动扫描同一个文件夹的xml文件。

二、就是在把所有的xml文件放在同一个文件夹下 这样用classpath就能实现。

所以可以确认classpath 只要扫描到了所需要的资源就会返回，这样可能导致其它资源扫描不到。
classpath*会加载所有的并返回。
参考：

[springboot项目中classpath路径到底指哪里？](https://blog.csdn.net/wppwpp1/article/details/106628669) 
[Spring加载resource时classpath*:与classpath:的区别](https://blog.csdn.net/kkdelta/article/details/5507799) 