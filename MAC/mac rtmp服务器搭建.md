 #### 查看nginx的信息
 
```
brew info nginx-full
```

#### 位置
```
/opt/homebrew/etc/nginx/
```

#### 重新加载配置文件:
```
nginx -s reload
```  


重新加载日志:

```
nginx -s reopen
```

停止 nginx:
```
nginx -s stop
```

有序退出 nginx:
```
nginx -s quit
```

4.重启nginx
```
nginx -s reload
```

安装 ngnix
```
brew tap denji/homebrew-nginx
```

安装rtmp-module   
```
brew install nginx-full --with-rtmp-module
```













#### 卸载nginx-full 

```
brew uninstall nginx-full  
```  
</br>
安装nginx-full
 ```
 brew install nginx-full --with-rtmp-module  
```




