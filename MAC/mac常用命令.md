
## Homebrew常用命令

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 查看 Homebrew 版本
 ```shell
 brew -v
 ```

#### 列出已安装的软件
```shell
 brew list
 ```
#### 2.3. 安装软件包
```shell
 brew install 包名
 ```

#### 2.4. 卸载软件包
```shell
brew uninstall 包名
```
 
#### 2.5. Homebrew自身更新以及更新Homebrew 安装的所有软件包，并将它们升级到最新版本
```shell
brew update && brew upgrade
```

### 查看哪些包已经过时

```shell
brew outdated
```    

#### 更新指定包

```shell
 brew upgrade node
```

#### 锁定或取消锁定
```shell
brew pin $FORMULA      # 锁定某个包
brew unpin $FORMULA    # 取消锁定
```

####  查看哪些包可清理
```shell
 brew cleanup -n
 ```

#### 清理所有
```shell
brew cleanup
```

#### 查看端口是否通
```shell
nc -vz -w 2 119.29.135.95 21
```
#### 看ip
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
```
lsof -i tcp:3306
```


#### 2.看到进程的PID，可以将进程杀死。
```
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

## Redis

#### 启动redis

```shell
brew services start redis
```

#### redis 客户端
