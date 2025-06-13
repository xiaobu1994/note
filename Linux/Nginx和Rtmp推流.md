ssh root@47.96.140.250  -p 22
liangzaiA.1

#安装编译nginx环境包
yum install gcc -y
yum install pcre pcre-devel -y
yum install openssl openssl-devel -y
yum install wget -y

# 下载nginx和 g
cd /opt 

mkdir nginx

cd nginx
# 下载nginx
wget https://nginx.org/download/nginx-1.18.0.tar.gz
#解压
tar -zxvf nginx-1.18.0.tar.gz 
# 下载nginx-rtmp-module
git clone https://github.com/arut/nginx-rtmp-module.git


# 编译nginx

cd /opt/nginx/nginx-1.18.0

./configure --prefix=/usr/local/nginx --add-module=/opt/nginx/nginx-rtmp-module --with-http_ssl_module

make

make install

# 启动nginx

cd /usr/local/nginx/sbin

./nginx

# 查看nginx进程
ps -ef |grep nginx


# 查看nginx是否启动成功
curl localhost:80

sudo yum install lsof

lsof -i:80

lsof -i:1935

sudo netstat -tuln | grep 80

# 备份conf文件

cp -i nginx.conf nginx.conf.bak

# 上传文件  nginx.conf



<!-- 启动nginx -->

/usr/local/nginx/sbin/nginx 

<!-- 关闭 -->
/usr/local/nginx/sbin/nginx -s stop

<!-- 查看配置 -->

/usr/local/nginx/sbin/nginx -t

<!-- 查看配置是否正常 -->
/usr/local/nginx/sbin/nginx -s reload


# 创建文件夹

cd /opt/nginx

mkdir m3u8File
mkdir vod
mkdir rec

chmod 777 m3u8File
chmod 777 vod
chmod 777 rec



http://8.138.106.244:80/stats



<!-- 视频流 -->

curl localhost:1935

rtmp://47.96.140.250:1935/live/stream_live
# 你推流应该是这样推的吧

rtmp://119.29.135.95:1935/live/stream_live

rtmp://119.29.135.95:1935/live/stream

<!-- 设定所有人都有操作权限 -->

sudo chmod 777 /opt/nginx/vod -R


<!-- 看点播 -->

rtmp://47.96.140.250:1935/vod/1.mp4

<!-- 看记录 -->
http://47.96.140.250:80/rec/01ed440b-6a99-4ad8-a6f6-93d10e00e834_phone-1735363965804-1735363968.flv


# 查看rtmp的状态
http://47.96.140.250:80/stats
















