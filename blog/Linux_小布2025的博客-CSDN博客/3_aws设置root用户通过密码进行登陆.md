# aws设置root用户通过密码进行登陆

> 原创 于 2019-03-19 14:48:12 发布 · 公开 · 1.2w 阅读 · 2 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/88661849

一、设置root密码

```java
sudo passwd root
```

3.然后会提示你输入new password。输入一个你要设置的root的密码，需要你再输入一遍进行验证。

4.接下来，切换到root身份，输入如下命令：

```java
su root
```


5.使用root身份编辑亚马逊云主机的ssh登录方式，找到 PasswordAuthentication no，把no改成yes。把PermitRootLogin forced-commands-only 把forced-commands-only改成yes 输入：

```java
vim /etc/ssh/sshd_config
```


6.接下来，要重新启动下sshd(centos6)，如下命令：


```java
service sshd restart
```



PermitRootLogin限定root用户的登录方式。

| 参数类别 | 是否允许ssh登陆 | 登录方式 | 交互shell |
|:---:|:---:|:---:|:---:|
| yes | 允许 | 没有限制 | 没有限制 |
| without-password | 允许 | 除密码以外 | 没有限制 |
| forced-commands-only | 允许 | 仅允许使用密钥 | 仅允许已授权的命令 |
| no | 不允许 | N/A | N/A |