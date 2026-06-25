# Nginx搭建视频流媒体服务(Win)

> 原创 于 2023-09-07 17:18:46 发布 · 2.6k 阅读 · 0 · 4 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/132742433

#### 下载Nginx，nginx 1.7.11.3 Gryphon版本

[地址](http://nginx-win.ecsds.eu/download/) 

#### 2、配置nginx

```text
#user  nobody;
worker_processes  1;
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#pid        logs/nginx.pid;
events {
    worker_connections  1024;
}
rtmp_auto_push on;
 
#RTMP服务
rtmp{
	server{
		listen 1935;        #服务端口
		chunk_size 4096;    #数据传输块的大小
		#rtmp点播配置，访问方式：rtmp://127.0.0.1:1935/vod/xxx.mp4
		application vod {
			play ./vod;    #点播视频存放目录，里面放一个xxx.mp4可以直接播放
		}
		#rtmp协议直播推流
		application live {
			live on;
			record all;
			record_path ./rec; # 保存路径
			#record_max_size 1K;
			#append current timestamp to each flv
			record_unique on;
			#publish only from localhost
			#allow publish 127.0.0.1;
			#deny publish all; 
		}
		 # HLS协议直播推流
		application hls {
			live on;                    #开启rtmp直播
			hls on;                     #开启hls支持
			wait_video on;              #第一个视频帧发送前禁用音频
			hls_path ./m3u8File;     #文件保存路径，需要先创建，不然执行推流会报错
			hls_fragment 5s;            #用来设置每一个块的大小。默认是5秒。只能为整数
			hls_playlist_length 30s;    #设置播放列表的长度，单位是秒，听说设置成3秒延迟低点
			hls_nested off;              #默认是off。打开后的作用是每条流自己有一个文件夹
			hls_cleanup off;            #不清理ts	, on｜off 默认是开着的，是否删除列表中已经没有的媒体块
			#hls_continuous:            #on|off 设置连续模式，是从停止播放的点开始还是直接跳过
	   }
	}
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';
    #access_log  logs/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    #keepalive_timeout  0;
    keepalive_timeout  65;
    #gzip  on;
    server {
        listen       9090;
        server_name  localhost;
        #charset koi8-r;
        #access_log  logs/host.access.log  main;
		#hls点播地址
		location /hls {
			types {
				application/vnd.apple.mpegurl m3u8; 
				#或 application/x-mpegURL
				video/mp2t ts;
			}
			alias ./m3u8File; #点播视频文件(.ts;.m3u8)存放位置
			expires -1;
			add_header Cache-Control no-cache; #跨域支持，不然网页播放不了
			add_header Access-Control-Allow-Origin *;
			add_header Access-Control-Allow-Headers "Origin, X-Requested-With, Content-Type, Accept";
			add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
		}
    # 直播状态监听
    location /stat{
		    rtmp_stat all;
			rtmp_stat_stylesheet stat.xsl;
		}
		location /stat.xsl{
		    root ./nginx-rtmp-module-master;
		}    
		error_page   500 502 503 504  /50x.html;
		location = /50x.html {
			root   html;
		}
 
	}	
	autoindex on;# 显示目录
	autoindex_exact_size on;# 显示文件大小
	autoindex_localtime on;# 显示文件时间
}
```

#### 3、在nginx目录下面创建三个文件夹m3u8File、 vod、rec

#### javacv的依赖

```xml
 <!-- mac 平台报错 https://gitee.com/52jian/EasyMedia/issues/I5ZMMR-->
        <!-- 媒体只用到以下两个，javacv、ffmpeg
        <dependency>
            <groupId>org.bytedeco</groupId>
            <artifactId>javacv</artifactId>
            <version>1.5.7</version>
        </dependency>
        <!--全平台的ffmpeg-->
        <dependency>
            <groupId>org.bytedeco</groupId>
            <artifactId>ffmpeg-platform</artifactId>
            <version>5.0-1.5.7</version>
        </dependency>
```

#### 推流命令

```java
package com.zj.ffmpeg;

import org.bytedeco.javacpp.Loader;

import java.io.IOException;

/**
 * @see <a href="https://blog.csdn.net/xuw_xy/article/details/118582071#:~:text=%E5%8F%AF%E4%BB%A5%E4%BD%BF%E7%94%A8%E4%BB%A5%E4%B8%8B%E5%91%BD%E4%BB%A4%E5%B0%86%20MP4%20%E6%96%87%E4%BB%B6%E6%8E%A8%E6%B5%81%20%E5%88%B0%20RTSP%20%E6%9C%8D%E5%8A%A1%E5%99%A8%20%EF%BC%9A%20%60%60%60,%E5%90%8D%EF%BC%8C%60-c%20copy%60%20%E8%A1%A8%E7%A4%BA%E7%9B%B4%E6%8E%A5%E6%8B%B7%E8%B4%9D%E5%8E%9F%E5%A7%8B%20%E6%B5%81%20%EF%BC%8C%60-f%20%3A%2F%2F%20%E7%9A%84%E5%9C%B0%E5%9D%80%E5%92%8C%20%E5%90%8D%E3%80%82">ffmpeg 常用命令汇总</a>
 * @see <a href="https://blog.csdn.net/davidullua/article/details/120562737">ffmpeg 常用命令汇总</a>
 *
 * @author 小布
 * @version 1.0.0
 * @className PushStream.java
 * @createTime 2023年08月19日 15:25:00
 */
public class PushStream {
    public static void main(String[] args) {
        String ffmpeg = Loader.load(org.bytedeco.ffmpeg.ffmpeg.class);
        // ffmpeg -re -i video3.mp4 -vcodec h264 -acodec copy -f flv rtmp://127.0.0.1/live/test
        // ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-re", "-stream_loop", "-1", "-i", "D:\\1.mp4", "-c", "copy", "-f", "flv", "rtmp://127.0.0.1:1935/live/test");
        // 直播
        ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-re",  "-i", "D:\\1.mp4", "-c", "copy", "-f", "flv", "rtmp://127.0.0.1:1935/live/test");
        //切片
        // ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-re",  "-i", "D:\\1.mp4", "-vcodec", "copy", "-acodec", "copy","-f", "flv", "rtmp://127.0.0.1:1935/hls/test");
        try {
            pb.inheritIO().start().waitFor();
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
        }

    }

}

```

#### 用VLC软件进行播放

> 点播地址

```text
rtmp://127.0.0.1:1935/vod/1.flv
```

> 切片地址

```text
rtmp://127.0.0.1:1935/hls/test
```

> 直播地址

```text
rtmp://127.0.0.1:1935/hls/test
```

#### 文件点播不支持mp4 文件

> 检测配置是否正确

```text
nginx.exe -t
```

> 启动

```text
start nginx
```

> 关闭

```text
nginx -s stop
```

> 重新加载配置

```text
nginx.exe -s reload
```

> 关闭所有nginx进程

```text
taskkill /IM nginx.exe /F
```

> windows任务管理器下Nginx的进程命令

```text
tasklist /fi "imagename eq nginx.exe"
```

[Nginx搭建视频流媒体服务（直播&点播）](https://blog.csdn.net/JohnGene/article/details/125284580) 
[在windows下搭建、配置nginx流媒体服务器，并进行rtmp流的推流、拉流测试](https://blog.csdn.net/u014552102/article/details/100906058) 