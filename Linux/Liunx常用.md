<!-- 查看80端口是否被占用 -->

netstat -anp|grep 80 

lsof -i:80

<!-- nginx目录 -->

cd  /usr/local/nginx/sbin

<!-- 启动nginx -->

/usr/local/nginx/sbin/nginx 

/usr/local/nginx/sbin/nginx -s   stop

/usr/local/nginx/sbin/nginx -t


ps -ef |grep nginx

ps aux | grep nginx



sudo netstat -tuln | grep 8080


netstat -tulnp | grep nginx


lsof -i:9090

netstat -anp|grep 9090


nohup java -jar /root/javaapp/vivillage-0.1.jar &


<!-- 查看opt磁盘的大小 -->
df -h /opt


