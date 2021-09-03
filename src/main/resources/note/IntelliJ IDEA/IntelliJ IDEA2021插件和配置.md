## 常用插件

```text
1、 .ignore
2、 Alibaba Java Coding Guidelines
3、 Atom Material Icons
4、 codota
5、 GrepConsole
6、 HighlightBracketPair
7、 IDE Eval Reset
8、 Atom Material Icons
9、 javadocs
10、 rainbow-brackets
11、 jrebel
12、 jrebel-mybatisplus-extension
13、 Key-Promoter-X
14、 Maven Helper
15、 MyBatisCodeHelperPro ​(Marketplace Edition)​
16、 Presentation Assistant
17、 RestfulToolkit-fix
18、 SequenceDiagram
19、 string-manipulation
20、 Translation
21、 save action
22、 mybatis-log-plugin
23、 Statistic
24、 StopCoding
25、 jprofiler


```

### javadoc 设置

![javac.png](https://img-blog.csdnimg.cn/img_convert/d69f502e26f34e9d472f71a5917f59b2.png)

### save action 设置

![1.png](https://img-blog.csdnimg.cn/img_convert/aab748d652fe7914cadfe9597f0f86d8.png)

![2.png](https://img-blog.csdnimg.cn/img_convert/8a602f7941832cdba9ef3499687574e3.png)

![3png.png](https://img-blog.csdnimg.cn/img_convert/9f558d72e449171f77892f91e78e06de.png)

## 自定义IntelliJIdea的log config路径

```text
idea.config.path=E:/Tool/IntelliJ IDEA 2021.2/.IntelliJIdea/config

idea.system.path=E:/Tool/IntelliJ IDEA 2021.2/.IntelliJIdea/system

idea.plugins.path=E:/Tool/IntelliJ IDEA 2021.2/.IntelliJIdea/config/plugins

idea.log.path=E:/Tool/IntelliJ IDEA 2021.2/.IntelliJIdea/system/log

-Duser.name=xiaobu

```

## 设置IntelliJIdea的 bin下面idea64.exe.vmoptions

```text
-Xmx3072m
-XX:ReservedCodeCacheSize=1024m
-Xms512m
-XX:+UseG1GC
-XX:SoftRefLRUPolicyMSPerMB=50
-XX:CICompilerCount=2
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-ea
-Dsun.io.useCanonCaches=false
-Djdk.http.auth.tunneling.disabledSchemes=""
-Djdk.attach.allowAttachSelf=true
-Djdk.module.illegalAccess.silent=true
-Dkotlinx.coroutines.debug=off
-Dsplash=true
-Duser.name=xiaobu

```