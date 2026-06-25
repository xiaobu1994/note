# Linux的常用命令

> 原创 于 2023-03-08 10:33:32 发布 · 公开 · 460 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/129398354

## 一、cd命令（用于切换目录的常用命令）

##### 切换到目录/root/opt

```text
cd /root/opt
```

##### 切换到当前目录下的path目录中，“.”表示当前目录

```text
cd ./path

```

##### 切换到上层目录中的path目录中，“…”表示上一层目录

```text
cd ../path

```

## 二、ls命令（list的简写 ，寓意查看的意思）

> > -l ：列出长数据串，包含文件的属性与权限数据等 -a ：列出全部的文件，连同隐藏文件（开头为.的文件）一起列出来（常用） -d ：仅列出目录本身，而不是列出目录的文件数据 -h ：将文件容量以较易读的方式（GB，kB等）列出来 -R ：连同子目录的内容一起列出（递归列出），等于该目录下的所有文件都会显示出来 可以联合使用 ls -lh 列出文件属性、权限、以及以易读的方法展示出来(后面不追加文件名则默认输出当前目录下的所有文件)
> > 查看当前目录下有多少个文件
> 
> 

```text
ls -l|grep "^-"| wc -l 

```

查看当前目录下有多少个文件夹

```text
ls -l|grep "^d"| wc -l 

```

查看当前目录下有多少个文件夹和文件（不递归）

```text
ls -l |wc -l 
```

查看当前目录下的文件信息

```text
ll
```

查看本机盘符

```text
df -h 
```

当前文件大小

```shell
du -sh * 
```

看所在当前路径

```text
pwd 
```

## 三、mkdir命令

##### 建立文件夹

```text

mkdir japan
```

##### 递归建立文件夹

```text
mkdir -p japan/cangjk

```

## 四、cp命令（copy之意） cp [options] source dest

-a ：将文件的特性一起复制 -p ：连同文件的属性一起复制，而非使用默认方式，与-a相似，常用于备份 -i ：若目标文件已经存在时，在覆盖时会先询问操作的进行 -r ：递归持续复制，用于目录的复制行为

##### 连同文件的所有特性把文件file1复制成文件file2如果有相同的文件会询问是否替换

```text
cp -ip 1.txt 2.txt ./Tool

```

注意：用户使用该指令复制目录时，必须使用参数"-r"或者"-R"。

## 五、rm命令（remove之意）

-f 不询问 直接删除 -r 将目录及以下之档案亦逐一删除

删除当前目录的所有文件（包括文件夹但不包括当前的目录）

```text
 rm -rf *
```

文件夹名 删除文件夹必须用

```text
rm -r

```

## 六、mv命令常用于改名或者移动文件【剪切】

```text
mv aaa bbb
```

改名

```text
mv info/ logs
```

将info目录放入logs目录中。注意，如果logs目录不存在，则该命令将info改名为logs。

## 七、find命令 语法： find [搜索范围][选项][条件]

在根目录下查找名为install.log文件

```text
find / -name install.log  

```

模糊查询

```text
find / -name '*mysql*'

```

忽略大小写查找文件

```text
find /root -inname install.log
```

其中-mtime 文件修改时间 -atime 文件访问时间 -ctime 改变文件属性时间

+10 10天前 10 10天 -10 10天内

```text
find /var/log -mtime +10
```

查找文件大于20M的文件 zip格式：

```text
find /etc -size +20M
```

##### 新建空白文件

```text
touch CN/SZ

```

```text
touch CN/GD

```

##### 压缩 -r递归处理

```text
zip -r jp.zip jp
```

gz格式：

##### 压缩为gz格式，原文件不保留

```text
gzip [原文件]
```

##### 压缩.gz格式，原文件保留

```text
gzip -c 原文件 > 压缩文件
```

##### 压缩目录：

```text
gzip -r 目录
```

解压：

```text
guzip [文件]
```

```text
guzip -r [目录]
```

3.tar

##### 打包

```text
tar -cvf 打包文件名 原文件

```

##### 解压

```text
tar -xvf jp.tar 4.tar.gz

```

##### 打包

```text
tar -zcvf 压缩包名.tar.gz 原文件

```

##### 解压

```text
tar -zxvf 压缩包名.tar.gz

```

## 八、tail 命令

看文件的最后一百行

```text
tail -100 xx.log 
```

## vim的使用

> 用vi编辑器，用vi编辑器打开一个文件例如：vi work.c
> 然后就进入work.c文件里了，之后就是vi编辑器的使用方法了。
> 刚进去的时候是命令状态，此时按i进入编辑状态，你可以编写内容。写完之后按esc，进入命令模式，再按shift +;即英文: 输入wq就保存并退出了。
> :（英文冒号）就进入了底线命令模式。
> q 退出程序
> w 保存文件

#### 终止当前命令

```shell
ctr+c  
```

#### 清屏

```shell
ctr+l
```

#### 查看java进程相关信息

指令： ps
作用： 主要是查看服务器的进程信息
选项含义：
-e：等价于 ‘-A’ ，表示列出全部的进程
-f：显示全部的列（显示全字段）
grep命令是查找
中间的|是管道命令 是指ps命令与grep同时执行

```shell
ps -ef|grep java

```

#### 查看java虚拟机的进程信息

-l：显示主类的完整包名，如果进程执行的是JAR文件，也会显示JAR文件的完整路径。
-v：显示Java虚拟机启动时传递的JVM参数

```shell
jps -l -v
```

#### 显示堆各个区域内存使用和垃圾回收的统计信息

```shell
jstat -gc pid 
```