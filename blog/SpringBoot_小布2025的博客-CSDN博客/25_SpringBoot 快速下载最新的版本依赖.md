# SpringBoot 快速下载最新的版本依赖

> 原创 于 2021-01-07 14:22:49 发布 · 公开 · 869 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/112308828

```xml
    <repositories>
        <!-- 设置远程仓库-->
        <repository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <!-- https://repo.spring.io/milestone  这是里程碑版本-->
            <url>https://repo.spring.io/milestone</url>
            <!-- 快照版本的不从这下-->
          <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </repository>
    </repositories>
     <!--指定远程插件仓库地址 -->
    <pluginRepositories>
        <pluginRepository>
            <id>spring-snapshots</id>
            <url>http://repo.spring.io/snapshot</url>
        </pluginRepository>
        <pluginRepository>
            <id>spring-milestones</id>
            <url>http://repo.spring.io/milestone</url>
        </pluginRepository>
    </pluginRepositories>
```

添加阿里云镜像

```
<?xml version="1.0" encoding="UTF-8"?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

          
  <localRepository>D:\dev\repository</localRepository>

        <mirrors>
          <!-- 阿里云仓库 -->
         <mirror>
              <id>alimaven</id>
              <mirrorOf>central</mirrorOf>
             <name>aliyun maven</name>
             <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
         </mirror> 
     
     </mirrors> 


</settings>

```

创建个bat文件清除maven仓库下载时产生的垃圾（D:\repository 换成你的）

```
@echo off
set REPOSITORY_PATH=D:\repository
rem 开始删除... 
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*lastUpdated*"') do (
    del /s /q %%i
)
rem 删除完成!!
pause

```