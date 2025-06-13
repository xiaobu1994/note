```text

查看端口具体被那个进程占用
lsof -i :9000

再使用以下命令查看详细信息
ps -aux | grep 9000   ：

杀掉进程
kill -9 [PID]


nohup java -jar ROOT.jar &

java -jar ROOT.jar &



```