#### 查看端口是否通

```shell
nc -vz -w 2 119.29.135.95 21
```
#### 看IP

```shell
ifconfig
```

#### 设定2023年9月3日23:15分关机：

```shell
sudo shutdown -h 2309032315
```

#### 设定2023年9月3日23:15分重启：

```shell
sudo shutdown -r 2309032315
```

#### 设定2023年9月3日23:15分睡眠：
```shell
sudo shutdown -s 2309¬032315
```


#### 重启

```shell
sudo shutdown -r now
```
#### 解压缩和压缩

```shell
zip -r 1.zip 1.exe 
```

```shell
unzip 1.zip
```


#### 1.查看端口被哪个程序占用
```shell
lsof -i tcp:3306
```


#### 2.看到进程的PID，可以将进程杀死。

```shell
sudo kill -9 PID
```

#### 查询

```shell
find ~ -iname  "adb*"
```

在整个文件系统（/）中查找名为 powerlevel10k 的文件或目录，并把错误信息丢弃。
```shell
find / -name "powerlevel10k " 2>/dev/null
```