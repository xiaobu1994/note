# JAVACV对视频流和视频文件的操作

> 原创 已于 2023-08-30 10:47:18 修改 · 2.5k 阅读 · 0 · 7 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/132413078

### MAVEN依赖

```xml
  <!-- mac 平台报错 https://gitee.com/52jian/EasyMedia/issues/I5ZMMR-->
        <!-- 媒体只用到以下两个，javacv、ffmpeg -->
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
        <!-- hutool工具包 -->
		<dependency>
			<groupId>cn.hutool</groupId>
			<artifactId>hutool-all</artifactId>
			<version>5.3.3</version>
		</dependency>
```

### JavaCvUtil

```java
package com.xiaobu.util;

import cn.hutool.core.util.StrUtil;
import lombok.extern.slf4j.Slf4j;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacpp.Loader;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.springframework.util.StopWatch;

import java.io.IOException;

/**
 * @author 小布
 * @version 1.0.0
 * @className JavaCvUtil.java
 * @createTime 2023年08月19日 11:10:00
 */
@Slf4j
public class JavaCvUtil {
    /**
     * convertFileByApi
     *借助JavaCV和ffmpeg的api
     * @param sourcePath       sourcePath 可以是流地址或者文件地址
     * @param fileFullPathName fileFullPathName
     * @param duration         duration 录制时长 只针对视频流录制
     * @return java.lang.String
     * @author xiaobu
     * @date 2023/8/21 9:40
     */
    public static String convertStream2FileByApi(String sourcePath, String fileFullPathName, int duration) {
        long beginTime = System.currentTimeMillis();
        FFmpegFrameGrabber frameGrabber = new FFmpegFrameGrabber(sourcePath);
        Frame capturedFrame = null;
        FFmpegFrameRecorder recorder = null;
        try {
            frameGrabber.start();
            frameGrabber.getLengthInTime();
            //获取video得类型 如MP4等
            String videoType = fileFullPathName.substring(fileFullPathName.lastIndexOf(".") + 1);
            recorder = new FFmpegFrameRecorder(fileFullPathName, frameGrabber.getImageWidth(), frameGrabber.getImageHeight(), frameGrabber.getAudioChannels());
            recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            recorder.setFormat(videoType);
            recorder.setFrameRate(frameGrabber.getFrameRate());
            recorder.setVideoBitrate(frameGrabber.getVideoBitrate());
            recorder.setAudioBitrate(192000);
            recorder.setAudioOptions(frameGrabber.getAudioOptions());
            recorder.setAudioQuality(0);
            recorder.setSampleRate(44100);
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            recorder.start();
            while (true) {
                try {
                    capturedFrame = frameGrabber.grabFrame();
                    if (capturedFrame == null) {
                        System.out.println("!!! Failed cvQueryFrame");
                        break;
                    }
                    recorder.record(capturedFrame);
                    long nowTime = System.currentTimeMillis();
                    long costTime = nowTime - beginTime;
                    //duration S自动断开
                    if (costTime >= duration * 1000L) {
                        log.info("【convertFileByApi】::costTime ==> 【{}】", costTime);
                        break;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            recorder.stop();
            recorder.release();
            frameGrabber.stop();
            frameGrabber.release();
            recorder.close();
            frameGrabber.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        //返回转码后视频文件名称
        return fileFullPathName;
        //返回转码后视频全路径
        //return fileFullPathName;
    }


    /**
     * convertFile2FileByApi
     *
     * @author 小布
     * @date 2023/8/21 13:33
     * @param sourcePath sourcePath
     * @param fileFullPathName fileFullPathName
     * @param duration duration 录制时长（z）
     * @return java.lang.String
     */
    public static String convertFile2FileByApi(String sourcePath, String fileFullPathName, int duration) {
        long beginTime = System.currentTimeMillis();
        FFmpegFrameGrabber frameGrabber = new FFmpegFrameGrabber(sourcePath);
        Frame capturedFrame = null;
        FFmpegFrameRecorder recorder = null;
        try {
            frameGrabber.start();
            frameGrabber.setTimestamp(20 * 1000000);
            // 视频的时长 微秒
            long lengthInTime = frameGrabber.getLengthInTime();
            String format = String.format("视频长度:%s(S)",  lengthInTime / 1000 / 1000);
            System.out.println(format);
            //获取video得类型 如MP4等
            String videoType = fileFullPathName.substring(fileFullPathName.lastIndexOf(".") + 1);
            recorder = new FFmpegFrameRecorder(fileFullPathName, frameGrabber.getImageWidth(), frameGrabber.getImageHeight(), frameGrabber.getAudioChannels());
            recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            recorder.setFormat(videoType);
            recorder.setFrameRate(frameGrabber.getFrameRate());
            recorder.setVideoBitrate(frameGrabber.getVideoBitrate());
            recorder.setAudioBitrate(192000);
            recorder.setAudioOptions(frameGrabber.getAudioOptions());
            // Highest quality
            recorder.setAudioQuality(0);
            recorder.setSampleRate(44100);
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            recorder.start();
            int count = 0;
            while (true) {
                try {
                    capturedFrame = frameGrabber.grabFrame();
                    if (capturedFrame == null) {
                        log.error("【convertFile2FileByApi】::【!!! Failed cvQueryFrame】");
                        break;
                    }
                    count++;
                    if (count > 1000) {
                        break;
                    }
                    recorder.record(capturedFrame);
                    long nowTime = System.currentTimeMillis();
                    long costTime = nowTime - beginTime;
                    //duration S自动断开
                    if (costTime >= duration * 1000L) {
                        log.info("【convertFileByApi】::costTime ==> 【{}】", costTime);
                        break;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            recorder.stop();
            recorder.release();
            frameGrabber.stop();
            frameGrabber.release();
            recorder.close();
            frameGrabber.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        //返回转码后视频文件名称
        return fileFullPathName;
        //返回转码后视频全路径
        //return fileFullPathName;
    }

    /**
     * 基于JavaCV跨平台调用ffmpeg命令
     * duration 录制时长为多少秒的视频
     */
    public static String convertByCommand(String sourcePath, String destPath, String duration) {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start("开始执行基于JavaCV跨平台调用ffmpeg命令录制视频");
        try {
            String ffmpeg = Loader.load(org.bytedeco.ffmpeg.ffmpeg.class);
            ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-i", sourcePath, "-vcodec", "h264", destPath);
            if (StrUtil.isNotBlank(duration)) {
                pb = new ProcessBuilder(ffmpeg, "-i", sourcePath, "-vcodec", "h264", "-t", duration, destPath);
            }
            pb.inheritIO().start().waitFor();
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
        }
        stopWatch.stop();
        log.info("【convertByFfmpegCommand】::stopWatch.getTotalTimeSeconds() ==> 【{}】", stopWatch.getTotalTimeSeconds());
        return destPath;

    }

}
```

### 测试类

```java
package com.xiaobu.ffmpeg;

import org.bytedeco.javacpp.Loader;

import java.io.IOException;

/**
 * @author 小布
 * @version 1.0.0
 * @className Test1.java
 * @createTime 2023年08月21日 10:28:00
 */
public class Test1 {
    public static void main(String[] args) {
        String fileFullPathName = "D:\\1.mp4";
        String videoType = fileFullPathName.substring(fileFullPathName.lastIndexOf(".") + 1);
        System.out.println("videoType = " + videoType);
        String format = String.format("视频类型:%s,视频长度:%s(S)", videoType, "10");
        System.out.println("format = " + format);
        extracted();
    }

    private static void extracted() {
        String ffmpeg = Loader.load(org.bytedeco.ffmpeg.ffmpeg.class);
        // "-vcodec", "h264" 音频转码的意思
        // ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-y", "-i", "D:\\1.mp4", "-vcodec", "h264", "-t", "30", "D:\\3.mp4");
        // -c copy：直接复制，不经过重新编码（这样比较快）
        // ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-y", "-i", "D:\\1.mp4", "-c", "copy", "-t", "30", "D:\\3.mp4");
        // ffmpeg -i input.mp4 -acodec copy -vn out.aac
        // ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-y", "-i", "D:\\1.mp4", "-acodec", "copy", "-vn", "D:\\out.aac");
        // ffmpeg -iout.mp4 -vcodeccopy D:\3.mp4 只copy视频
        ProcessBuilder pb = new ProcessBuilder(ffmpeg, "-y", "-i", "D:\\1.mp4", "-vcodec", "copy", "D:\\3.mp4");
        try {
            pb.inheritIO().start().waitFor();
        } catch (InterruptedException | IOException e) {
            e.printStackTrace();
        }
    }

}

```

### javacv 实现对文件进行切片

```java
package com.xiaobu.FFmpegFrame;

/**
 * @author 小布
 * @version 1.0.0 实现流切片
 * @className StreamSliceTest.java
 * @createTime 2023年08月18日 10:53:00
 */

import org.bytedeco.ffmpeg.avcodec.AVPacket;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;

public class StreamSliceTest {

    public static void main(String[] args) throws Exception {
        FFmpegFrameGrabber grabber = new FFmpegFrameGrabber("D:\\1.mp4");
        grabber.start();

        FFmpegFrameRecorder recorder = new FFmpegFrameRecorder("D:\\hls\\1.m3u8", grabber.getImageWidth(), grabber.getImageHeight(), grabber.getAudioChannels());
        recorder.setFormat("hls");
        recorder.setOption("hls_time", "60");
        recorder.setOption("hls_playlist_type", "vod");
        recorder.setOption("hls_list_size", "0");
        recorder.setOption("hls_segment_filename", "D:\\hls\\video_%04d.ts");
        recorder.start(grabber.getFormatContext());

        AVPacket packet = null;
        while ((packet = grabber.grabPacket()) != null) {
            recorder.recordPacket(packet);
            avcodec.av_packet_unref(packet);
        }

        recorder.close();
        grabber.close();
    }
}

```

```java
package com.xiaobu.FFmpegFrame;

import org.bytedeco.ffmpeg.avcodec.AVPacket;
import org.bytedeco.ffmpeg.avformat.AVFormatContext;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.ffmpeg.global.avutil;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.FFmpegLogCallback;

/**
 * @author 小布
 * @version 1.0.0
 * @className StreamSliceTest2.java
 * @createTime 2023年08月21日 15:12:00
 */
public class StreamSliceTest2 {

    /**
     * @Title: push
     * @Description: hls切片
     * @param input  可以是一个InputStream的流、动态图片(apng,gif等等)，视频文件（mp4,flv,avi等等）,流媒体地址（http-flv,rtmp，rtsp等等）
     * @param output hls切片存放地址
     * @return: void
     **/
    public void push(String input, String output)
            throws org.bytedeco.javacv.FrameGrabber.Exception, org.bytedeco.javacv.FrameRecorder.Exception {
        FFmpegFrameGrabber grabber = null;// 采集器
        FFmpegFrameRecorder recorder = null;// 解码器
        int bitrate = 2500000;// 比特率
        double framerate;// 帧率
        try {
            // 开启ffmpeg日志级别；QUIET是屏蔽所有，可选INFO、DEBUG、ERROR等
            avutil.av_log_set_level(avutil.AV_LOG_INFO);
            FFmpegLogCallback.set();
            grabber = new FFmpegFrameGrabber(input);
            grabber.start();
            // 异常的framerate，强制使用25帧
            if (grabber.getFrameRate() > 0 && grabber.getFrameRate() < 100) {
                framerate = grabber.getFrameRate();
            } else {
                framerate = 25.0;
            }
            bitrate = grabber.getVideoBitrate();// 获取到的比特率 0
            recorder = new FFmpegFrameRecorder(output, grabber.getImageWidth(), grabber.getImageHeight(), 0);
            // 设置比特率
            recorder.setVideoBitrate(bitrate);
            // h264编/解码器
            recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            // 设置音频编码
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            // 视频帧率(保证视频质量的情况下最低25，低于25会出现闪屏)
            recorder.setFrameRate(framerate);
            // 关键帧间隔，一般与帧率相同或者是视频帧率的两倍
            recorder.setGopSize((int) framerate);
            // 解码器格式
            recorder.setFormat("hls");
            // 单个切片时长,单位是s，默认为2s
            recorder.setOption("hls_time", "60");
            // recorder.setOption("hls_playlist_type", "vod");
            // HLS播放的列表长度，0标识不做限制
            recorder.setOption("hls_list_size", "0");
            // 设置切片的ts文件序号起始值，默认从0开始，可以通过此项更改
            recorder.setOption("start_number", "120");
            recorder.setOption("hls_segment_filename", "D:\\hls\\video_%04d.ts");
//			recorder.setOption("hls_segment_type","mpegts");
            // 自动删除切片，如果切片数量大于hls_list_size的数量，则会开始自动删除之前的ts切片，只保 留hls_list_size个数量的切片
            // recorder.setOption("hls_flags","delete_segments");
            // ts切片自动删除阈值，默认值为1，表示早于hls_list_size+1的切片将被删除
            // recorder.setOption("hls_delete_threshold","1");
            /*
             * hls的切片类型： 'mpegts'：以MPEG-2传输流格式输出ts切片文件，可以与所有HLS版本兼容。 'fmp4':以Fragmented
             * MP4(简称：fmp4)格式输出切片文件，类似于MPEG-DASH，fmp4文件可用于HLS version 7和更高版本。
             */
//			recorder.setOption("hls_segment_type","mpegts");

            AVFormatContext fc = null;
            fc = grabber.getFormatContext();
            recorder.start(fc);
            AVPacket packet = null;
            while ((packet = grabber.grabPacket()) != null) {
                recorder.recordPacket(packet);
                avcodec.av_packet_unref(packet);
            }

        } catch (Exception e) {
            assert grabber != null;
            grabber.stop();
            grabber.close();
            if (recorder != null) {
                recorder.stop();
                recorder.release();
            }
        } finally {
            assert grabber != null;
            grabber.stop();
            grabber.close();
            if (recorder != null) {
                recorder.stop();
                recorder.release();
            }
        }
    }

    public static void main(String[] args)
            throws org.bytedeco.javacv.FrameGrabber.Exception, org.bytedeco.javacv.FrameRecorder.Exception {
        StreamSliceTest2 test = new StreamSliceTest2();
        test.push("D:\\1.mp4",
                "D:\\hls\\hls.m3u8");
    }

}
```

[JAVACV 版本说明](https://blog.csdn.net/eguid_1/article/details/112574330?ops_request_misc=&request_id=5d1ccd9ce6aa4a57b9546597f6aff170&biz_id=&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~koosearch~default-3-112574330-null-null.268) 
[JAVACV 基于JavaCV跨平台执行ffmpeg命令](https://blog.csdn.net/eguid_1/article/details/121670408) 
[JavaCV入门](http://zhangxuetu.cn/archives/2013) 
[ffmpeg入门教程](https://blog.csdn.net/Javachichi/article/details/131660999) 
[ffmpeg命令大全](https://blog.csdn.net/walkeryudev/article/details/94623129) 
[ffmpeg命令大全](https://blog.csdn.net/walkeryudev/article/details/94623129) 
[ffmpeg文档](https://ffmpeg.org/documentation.html) 