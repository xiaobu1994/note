
一、问题 通过IDEA从Git上导出Maven项目后， reload 项目 pom.xml文件产生多处dependency not found错误，同时无法关联相应jar包。(很奇怪Idea 不加载本地仓库，却去阿里云仓库下载)

![1.jpg](https://img-blog.csdnimg.cn/img_convert/7a327ee0ce2f57f5576f376a710117dd.png)

项目从本地Maven仓库关联jar包，使用Nexus管理。 选择local repository 然后点击update 点击OK

![1630160321(1).jpg](https://img-blog.csdnimg.cn/img_convert/c5df8c75183d32c2cf2a522ca7eac103.png)

二、勾选Always update snapshot（更新快照）,项目开始重新加载dependency，错误全部解决。

![1630160829.jpg](https://img-blog.csdnimg.cn/img_convert/9885202ef56ff69629065ff362911b28.png)

最后操作：pom.xml -> maven ->Generate Source And Update folds

三、上面的方式试过都不行。然后在Terminal 命令下执行了

```cmd
mvn compile
```

显示build成功,猜想是Idea抽风，果不其然过了一会就好了。。。

![2.jpg](https://img-blog.csdnimg.cn/img_convert/c0d66f7937593ed232bb74df04e1fdf3.png)

四、在maven lifecycle那选中site 右键Run Maven Build

![1.png](https://img-blog.csdnimg.cn/img_convert/3213c555977560986c28d31196c7eed5.png)

然后Reload All Maven Projects

![2.png](https://img-blog.csdnimg.cn/img_convert/4c281fa61ab68fad23edfda0172b58d4.png)

参考:

[idea Maven异常：Could not find artifact](https://blog.csdn.net/guanshanyue96/article/details/106136764)

[maven编译或打包时，本地仓库已经存在文件，仍然去远程下载，导致打包失败](https://blog.csdn.net/gbfmachunyan/article/details/97666700)

[IDEA Maven Plugins 里的插件报错，有红色波浪线](https://blog.csdn.net/qq_35553465/article/details/97652990)