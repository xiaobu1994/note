## 常用插件

1. Alibaba Java Coding Guidelines
2.  .ignore
3.  Maven Helper
4.  MyBatisCodeHelperPro (Marketplace Edition)
5.  RestfulToolkit-fix
6.  mybatis-log-plugin
7.  GrepConsole
8.  Save Actions
9.  JRebel
10. JRebel-MyBatisPlus-Extension
11. JProfiler
12. Key Promoter X
13. Presentation Assistant
14. Rainbow Brackets
15. HighlightBracketPair
16. Atom Material Icons


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