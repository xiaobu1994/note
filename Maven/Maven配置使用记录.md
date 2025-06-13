
## maven setting 元素解释

```xml 
<localRepository>D:\apache-maven-3.3.9\repository</localRepository> #本地仓库路径
<interactiveMode>true</interactiveMode> #是否需要和用户交互以获得输入。如果Maven需要和用户交互以获得输入，则设置成true，反之则应为false。默认为true。
<usePluginRegistry>false</usePluginRegistry> #Maven是否需要使用plugin-registry.xml文件来管理插件版本。如果需要让Maven使用文件${user.home}/.m2/plugin-registry.xml来管理插件版本，则设为true。默认为false。
<offline>false</offline> #Maven是否需要在离线模式下运行。如果构建系统需要在离线模式下运行，则为true，默认为false。当由于网络设置原因或者安全因素，构建服务器不能连接远程仓库的时候，该配置就十分有用。
<pluginGroups/> #插件组
<proxies/> #通过安全认证的代理访问因特网
<servers></servers> # 1.定义jar包下载的Maven仓库 2. 定义部署服务器
<mirrors></mirrors> #仓库列表配置的下载镜像列表
<profiles></profiles> #用于定义属性键值对的。当该profile是激活状态的时候，properties下面指定的属性都可以在pom.xml中使用
<repositories></repositories> #用于定义远程仓库的，当该profile是激活状态的时候，这里面定义的远程仓库将作为当前pom的远程仓库
<activeProfiles></activeProfiles> #激活配置
```

## servers：

```xml
<!--配置服务端的一些设置。一些设置如安全证书不应该和pom.xml一起分发。这种类型的信息应该存在于构建服务器上的settings.xml文件中。-->
<servers>
    <!--服务器元素包含配置服务器时需要的信息 -->
    <server>
        <!--这是server的id（注意不是用户登陆的id），该id与distributionManagement中repository元素的id相匹配。-->
        <id>server001</id>
        <!--鉴权用户名。鉴权用户名和鉴权密码表示服务器认证所需要的登录名和密码。 -->
        <username>my_login</username>
        <!--鉴权密码 。鉴权用户名和鉴权密码表示服务器认证所需要的登录名和密码。密码加密功能已被添加到2.1.0 +。详情请访问密码加密页面-->
        <password>my_password</password>
        <!--鉴权时使用的私钥位置。和前两个元素类似，私钥位置和私钥密码指定了一个私钥的路径（默认是${user.home}/.ssh/id_dsa）以及如果需要的话，一个密语。将来passphrase和password元素可能会被提取到外部，但目前它们必须在settings.xml文件以纯文本的形式声明。 -->
        <privateKey>${usr.home}/.ssh/id_dsa</privateKey>
        <!--鉴权时使用的私钥密码。-->
        <passphrase>some_passphrase</passphrase>
        <!--文件被创建时的权限。如果在部署的时候会创建一个仓库文件或者目录，这时候就可以使用权限（permission）。这两个元素合法的值是一个三位数字，其对应了unix文件系统的权限，如664，或者775。 -->
        <filePermissions>664</filePermissions>
        <!--目录被创建时的权限。 -->
        <directoryPermissions>775</directoryPermissions>
    </server>
</servers>
```

## 常用 servers设置

```xml

<servers>

    <server>
        <id>nexus-snapshots</id>
        <username>username</username>
        <password>password</password>
    </server>

</servers>
```

## mirrors：

```xml

<mirrors>
    <mirror>
        <!--该镜像的唯一标识符。id用来区分不同的mirror元素。  -->
        <id>alimaven</id>
        <name>aliyun maven</name>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <!--此处配置所有的构建均从私有仓库中下载 *代表所有 所有的jar都从镜像仓库下载 这样导致第三方的下载不了 而且这个mirror只能配置一个，也可以写central -->
        <mirrorOf>central</mirrorOf>
    </mirror>
</mirrors>
  ```

## profiles、repositories、pluginRepositories：

### 注意: profile的加载顺序是按profiles 里面的顺序来的 和activeProfiles的顺序没有关系

```xml

<profiles>
    <profile>
        <!--        profile 的id需要唯一  不同的profile对应的repository id可以相同-->
        <id>nexus</id>
        <!--远程仓库列表，它是Maven用来填充构建系统本地仓库所使用的一组远程项目。  -->
        <repositories>
            <!--发布版本仓库-->
            <repository>
                <id>nexus</id>
                <!--name随便-->
                <name>Nexus Release Snapshot Repository</name>
                <!--地址是nexus中repository（Releases/Snapshots）中对应的地址-->
                <url>http://ip:8081/repository/maven-releases/</url>
                <!--true或者false表示该仓库是否为下载某种类型构件（发布版，快照版）开启。 -->
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
            </repository>
        </repositories>
        <!--发现插件的远程仓库列表。仓库是两种主要构件的家。第一种构件被用作其它构件的依赖。这是中央仓库中存储的大部分构件类型。另外一种构件类型是插件。-->
    </profile>
    <profile>
        <id>nexus2</id>
        <!--远程仓库列表，它是Maven用来填充构建系统本地仓库所使用的一组远程项目。  -->
        <repositories>
            <!--发布版本仓库-->
            <repository>
                <id>nexus</id>
                <!--name随便-->
                <name>Nexus Release Snapshot Repository</name>
                <!--地址是nexus中repository（Releases/Snapshots）中对应的地址-->
                <url>http://ip:8082/repository/maven-releases/</url>
                <!--true或者false表示该仓库是否为下载某种类型构件（发布版，快照版）开启。 -->
                <releases>
                    <enabled>true</enabled>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                </snapshots>
            </repository>
        </repositories>
        <!--发现插件的远程仓库列表。仓库是两种主要构件的家。第一种构件被用作其它构件的依赖。这是中央仓库中存储的大部分构件类型。另外一种构件类型是插件。-->
    </profile>

    <!--设置maven编译器级别-->
    <profile>
        <id>jdk18</id>
        <activation>
            <!--profile默认是否激活的标识 -->
            <activeByDefault>true</activeByDefault>
            <!--activation有一个内建的java版本检测，如果检测到jdk版本与期待的一样，profile被激活。 -->
            <jdk>1.8</jdk>
        </activation>
        <properties>
            <maven.compiler.source>1.8</maven.compiler.source>
            <maven.compiler.target>1.8</maven.compiler.target>
            <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
        </properties>
    </profile>
</profiles>
  ```

## activeProfiles：

```xml
  <!--激活配置-->
<activeProfiles>
    <!--profile下的id-->
    <activeProfile>nexus</activeProfile>
    <activeProfile>nexus2</activeProfile>
</activeProfiles>
```

## maven 仓库的优先级

> 本地仓库 > 私服 （profile）> 远程仓库（repository）和 镜像 （mirror） > 中央仓库 （central）

这里的远程仓库指的是 Pom.xml设置的

```xml
<!--配置远程仓库-->
<repositories>
    <repository>
        <id>foo</id>
        <name>Public Repositories</name>
        <url>http://dev.xxx.wiki:8081/nexus/content/groups/public/</url>
    </repository>
</repositories>
```

## Idea 中使用Profile的问题

![1630111556(1).jpg](https://img-blog.csdnimg.cn/img_convert/d846c57fdb57cde2b4e094cd9e53e3ac.png)

> 如果这里只勾选一个 这idea只会从这个私服里面去下载。 如果需要全部的私服就需要全部勾选.

## Idea执行maven 命令
1、Debug/Run Maven

Idea Debug/Run Maven mvn help:effective-settings(用于查看当前生效的POM内容**指的是idea配置的maven配置**)

![1630112038(1).jpg](https://img-blog.csdnimg.cn/img_convert/4ad6e7662cc20198519ce7917f861c72.png)

输入:

```cmd 
help:effective-settings
```

![1630209764(1).jpg](https://img-blog.csdnimg.cn/img_convert/b7275469d54329d4df82fef1ea76705d.png)


![1630210066(1).jpg](https://img-blog.csdnimg.cn/img_convert/6f7c55b2248ba50bce1960671ab96239.png)

等价于

![1630210191(1).jpg](https://img-blog.csdnimg.cn/img_convert/c3e20a03ad8781699a51511712661c6a.png)



2、 Terminal命令
或者在Idea 的Terminal 执行相应的maven 命令(**指的是maven setting.xml配置的maven配置**) 因为Terminal 等价于CMD操作

![1630214334(1).jpg](https://img-blog.csdnimg.cn/img_convert/e23598c4e66076c32d7c6f1f49d13180.png)

如果出现报错则在下面窗口打开Terminal

![1630131545(1).jpg](https://img-blog.csdnimg.cn/img_convert/7fa43bf56f25b0b3b9734844694a2ef5.png)

> 重新配置完setting.xml文件Idea直接reload 项目即可 无需操作(重新加载修改的内容)

参考:

[maven官网mirror配置指南](http://maven.apache.org/guides/mini/guide-mirror-settings.html)

[maven全局配置文件settings.xml详解](https://www.cnblogs.com/jingmoxukong/p/6050172.html)

[Maven之setting.xml解析](https://www.jianshu.com/p/648b0aa1e6b0)

[maven仓库中心mirrors配置多个下载中心(执行最快的镜像)](https://blog.csdn.net/www1056481167/article/details/60139851)

[Maven settings配置中的mirrorOf](https://liuzh.blog.csdn.net/article/details/21560089)

[记录maven配置 mirrorOf 坑](https://blog.csdn.net/LD799989470LD/article/details/80257725)

