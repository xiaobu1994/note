```text
netstat  -aon|findstr  8888

tasklist|findstr 8000   哪个进程使用了这个pid

taskkill /pid 8728  -t  -f 删掉

taskkill /IM  nginx.exe  /F

shutdown -r -t 0  立即重启电脑

shutdown -s -t 0  立即关闭电脑

shutdown /a 取消关机命令

windows任务管理器下Nginx的进程命令

tasklist /fi "imagename eq nginx.exe"

查看那个pid执行了java程序

jvisualvm

鼠标光标停留在行尾时,按Shift+Home选中一行。鼠标光标停留在行首时,按Shift+End就可以选中一行。在其他编辑器中也同样适用

按住Alt键不放，用鼠标左键从第一行的开头处按住向下拉，直到所有行

松开Alt键和鼠标左键，你会发现光标变成了一条跨越所有行的竖线


```