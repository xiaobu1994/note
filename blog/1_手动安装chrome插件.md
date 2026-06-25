# 手动安装chrome插件

> 原创 于 2020-04-02 09:18:58 发布 · 公开 · 2.7k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/105261995

一、打包chrome插件

进入 **chrome://extensions/** 勾选开发者模式 然后选择要打包的插件,复制插件id 然后在电脑找到插件的位置.
一般在C:\Users\admin\AppData\Local\Google\Chrome\User Data\Default\Extensions目录下。

ID为 jajilbjjinjmgcibalaakngmkilboobh， 版本号为1.0.4_0

填写下扩展程序根目录:C:\Users\admin\AppData\Local\Google\Chrome\User Data\Default\Extensions\jajilbjjinjmgcibalaakngmkilboobh\1.0.4_0私钥文件可以不填。

[外链图片转存中…(img-aoR2vtlf-1585792868871)]

然后你会发现在ID：jajilbjjinjmgcibalaakngmkilboobh目录下会出现1.0.4_0.crx和1.0.4_0.pem。

[外链图片转存中…(img-sCOKqvN2-1585792868873)]

二、安装

方法一

- 2.1 直接把刚才的.crx文件在 **chrome://extensions/** 界面拖拽进去(这个新版本chrome的好像不支持)。

方法二

- 2.2 把.crx文件修改成.rar文件，解压然后在 **chrome://extensions/** 选择加载已解压的扩展程序。扩展程序出现在你扩展程序列表表示已成功。

---

推荐两个下载离线.crx文件的网址

[crx4chrome 不需要扶墙](https://www.crx4chrome.com/) 

[chrome-extension-downloader 需扶墙 根据id下载](https://chrome-extension-downloader.com/) 