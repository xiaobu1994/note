# Git 常用命令总结（三）

> 原创 于 2018-11-08 17:17:28 发布 · 公开 · 178 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83864359

一、分支的应用（一般都是在分支上工作，然后和master合并）：

1.1、创建分支并切换到分支

```java
git checkout -b dev
```

相当于执行了两条命令

```java
$ git branch dev
$ git checkout dev
```

1.2、查看分支

```java
git branch
```

1.3分支提交数据

```java
$ git add demo.txt 
 
$ git commit -m "branch test"
```

二、合并分支由master来提交到版本库。

2.1、切回到master。

```java
 git checkout master
```

2.2、合并分支。 `--no-ff` 参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并

```java
git merge --no-ff -m "merge with no-ff" dev
```

2.3查看分支历史。

```java
git log --graph --pretty=oneline --abbrev-commit
```

---

三、删除本地git仓库

3.1、先删除.git文件

```bash
rm -rf  .git
```

3.2、删除其它文件

```cobol
rm -rf *
```

---

查看分支：gitbranch

创建分支：git branch <name>

切换分支：gitcheckout<name>

创建+切换分支：git checkout -b <name>

合并某分支到当前分支：gitmerge<name>

删除分支：git branch -d <name>

Ctrl+c 退出当前执行的命令

q 退出git log模式