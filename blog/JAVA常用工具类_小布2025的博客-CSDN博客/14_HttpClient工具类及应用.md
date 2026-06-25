# HttpClient工具类及应用

> 原创 最新推荐文章于 2026-04-29 11:22:05 发布 · 公开 · 1.4k 阅读 · 0 · 6 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/100035796

Content-Type类型：
常见的媒体格式类型如下：

- text/html ： HTML格式

- text/plain ：纯文本格式

- text/xml ： XML格式

- image/gif ：gif图片格式

- image/jpeg ：jpg图片格式

- image/png：png图片格式

以application开头的媒体格式类型：

- application/xhtml+xml ：XHTML格式

- application/xml ： XML数据格式

- application/atom+xml ：Atom XML聚合格式

- application/json ： JSON数据格式

- application/pdf ：pdf格式

- application/msword ： Word文档格式

- application/octet-stream ： 二进制流数据（如常见的文件下载）

- application/x-www-form-urlencoded ： 中默认的encType，form表单数据被编码为key/value格式发送到服务器（表单默认的提交数据的格式）
  另外一种常见的媒体格式是上传文件之时使用的：

- multipart/form-data ： 需要在表单中进行文件上传时，就需要使用该格式

区别:

> application/xml 媒体类型：推荐使用。如果 MIME 用户代理或 Web 用户代理不支持这个媒体类型，会转为 application/octet-stream，当做二进制流来处理。application/xml 实体默认用 UTF-8 字符集。Content-type: application/xml; charset=“utf-8” 或 <?xml version="1.0" encoding="utf-8"?> 都可以生效。

> text/xml 媒体类型：如果 MIME 用户代理或 Web 用户代理不支持这个媒体类型，会将其视为 text/plain，当做纯文本处理。text/xml 媒体类型限制了 XML 实体中可用的编码类型（例如此时支持 UTF-8 但不支持 UTF-16，因为使用 UTF-16 编码的文本在处理 CR，LF 和 NUL 会导致异常转换）。text/xml 实体在 XML 头指定编码格式无效，必须在 HTTP 头部的 Content-Type: 中指定才会生效（例如 <?xml version="1.0" encoding="utf-8"?> 无法设置字符集，Content-Type: text/xml; charset=“utf-8” 则可以）。没有设置字符集时默认使用“us-ascii”字符集。

```java
package com.xiaobu.base.utils;

import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Content-type 常用的几种类型
 * application/x-www-form-urlencoded :form表单键值对<K,V>类型 默认类型
 *
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/12/10 10:40
 * @description V1.0 HttpClient工具类
 */
public class HttpClientUtils {

    /**
     * 获取httppost对象 设置连接超时属性
     * setConnectTimeout：设置连接超时时间，单位毫秒。
     * setConnectionRequestTimeout：设置从connect Manager获取Connection 超时时间，单位毫秒。这个属性是新加的属性，因为目前版本是可以共享连接池的。
     * setSocketTimeout：请求获取数据的超时时间，单位毫秒。 如果访问一个接口，多少时间内无法返回数据，就直接放弃此次调用。
     */
    public static HttpPost getHttpPost(String url) {
        // 创建post方式请求对象
        HttpPost httpPost = new HttpPost(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(5000).setConnectionRequestTimeout(1000)
                .setSocketTimeout(5000).build();
        httpPost.setConfig(requestConfig);
        return httpPost;
    }

    /**
     * @param url 请求地址, map 数据类型, encoding 编码]
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/12/10 10:46
     * @descprition pots请求传输 形式数据形式访问
     * @version 1.0
     */
    public static String sendPostDataByMap(String url, Map<String, String> map, String encoding) {
        // 创建httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        // 创建post方式请求对象
        HttpPost httpPost = getHttpPost(url);
        // 装填参数
        List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
        if (map != null) {
            for (Map.Entry<String, String> entry : map.entrySet()) {
                nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
        }
        // 设置参数到请求对象中
        try {
            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs, encoding));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        // 设置header信息
        // 指定报文头【Content-type】、【User-Agent】
        httpPost.setHeader("Content-type", "application/x-www-form-urlencoded");
        httpPost.setHeader("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
        CloseableHttpResponse response = getPostResponse(httpClient, httpPost);
        return getResult(response, encoding);
    }

    /**
     * @param url 请求笛子, json 请求数据类型, encoding编码
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/12/10 10:45
     * @descprition post请求传输json
     * @version 1.0
     * JSON.toJSONString(map) 将map对象转化为json字符串
     */
    public static String sendPostDataByJson(String url, String json, String encoding) {
        // 创建httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        // 创建post方式请求对象
        HttpPost httpPost = getHttpPost(url);
        // 设置参数到请求对象中
        StringEntity stringEntity = new StringEntity(json, ContentType.APPLICATION_JSON);
        stringEntity.setContentEncoding(encoding);
        httpPost.setEntity(stringEntity);
        CloseableHttpResponse response = getPostResponse(httpClient, httpPost);
        return getResult(response, encoding);
    }


    public static String sendPostDataByXml(String url, String xml, String encoding) {
        // 创建httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        // 创建post方式请求对象
        HttpPost httpPost = getHttpPost(url);
        httpPost.addHeader("Content-Type", "text/xml;charset=UTF-8");
        // 设置参数到请求对象中  text/xml和application/xml的区别
        StringEntity stringEntity = new StringEntity(xml, encoding);
        stringEntity.setContentEncoding(encoding);
        httpPost.setEntity(stringEntity);
        CloseableHttpResponse response = getPostResponse(httpClient, httpPost);
        return getResult(response, encoding);
    }

    /**
     * @param url 访问地址, encoding 编码]
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/12/10 11:17
     * @descprition get方式请求
     * setConnectTimeout：设置连接超时时间，单位毫秒。
     * setConnectionRequestTimeout：设置从connect Manager获取Connection 超时时间，单位毫秒。这个属性是新加的属性，因为目前版本是可以共享连接池的。
     * setSocketTimeout：请求获取数据的超时时间，单位毫秒。 如果访问一个接口，多少时间内无法返回数据，就直接放弃此次调用。
     * @version 1.0
     */
    public static String sendGetData(String url, String encoding) {
        // 创建httpclient对象
        CloseableHttpClient httpClient = HttpClients.createDefault();
        // 创建get方式请求对象
        HttpGet httpGet = new HttpGet(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(5000).setConnectionRequestTimeout(1000)
                .setSocketTimeout(5000).build();
        httpGet.setConfig(requestConfig);
        // Content-type设置为application/x-www-form-urlencoded 或者不设置也是可以的(默认为application/x-www-form-urlencoded)
        httpGet.addHeader("Content-type", "application/json");
        // 通过请求对象获取响应对象
        CloseableHttpResponse response = getGetResponse(httpClient, httpGet);
        return getResult(response, encoding);
    }

    /**
     * @param httpClient , httpPost
     * @return org.apache.http.client.methods.CloseableHttpResponse
     * @author xiaobu
     * @date 2018/12/10 11:18
     * @descprition 获取response对象
     * @version 1.0
     */
    public static CloseableHttpResponse getPostResponse(CloseableHttpClient httpClient, HttpPost httpPost) {
        CloseableHttpResponse response = null;
        try {
            response = httpClient.execute(httpPost);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }


    /**
     * @param httpClient , httpGET
     * @return org.apache.http.client.methods.CloseableHttpResponse
     * @author xiaobu
     * @date 2018/12/10 11:18
     * @descprition 获取response对象
     * @version 1.0
     */
    public static CloseableHttpResponse getGetResponse(CloseableHttpClient httpClient, HttpGet httpGet) {
        CloseableHttpResponse response = null;
        try {
            response = httpClient.execute(httpGet);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }

    /**
     * @param response, encoding]
     * @return java.lang.String
     * @author xiaobu
     * @date 2018/12/10 11:18
     * @descprition 获取结果
     * @version 1.0
     */
    public static String getResult(CloseableHttpResponse response, String encoding) {
        String result = "";
        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            try {
                result = EntityUtils.toString(response.getEntity(), encoding);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        // 释放链接
        try {
            response.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }


}


```

服务端代码:

```java
    /**
      * 功能描述: Post方式获取数据
      * @author xiaobu
      * @date 2019/8/23 12:36
      * @param data 用于获取application/x-www-form-urlencoded 下的参数名称data的数据 , request 通过流来获取body的数据
      * @return java.lang.String
      * @version 1.0
      */
     @PostMapping("revQrCodeRelationData")
     public String revQrCodeRelationData(String data, HttpServletRequest request) {
         try {
             InputStream inputStream = request.getInputStream();
             BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
             String line = null;
             StringBuilder stringBuilder = new StringBuilder();
             while ((line = bufferedReader.readLine()) != null) {
                 //读取并换行
                 stringBuilder.append(line + "\n");
             }
             System.out.println("stringBuilder = " + stringBuilder);
         } catch (IOException e) {
             e.printStackTrace();
         }
         return null;
     }
 
 
 
 
     /**
      * 功能描述:Get方式
      * @author xiaobu
      * @date 2019/8/23 12:41
      * @param Sign, timeStamp, device, quntity
      * @return java.lang.String
      * @version 1.0
      */
     @GetMapping("sendQRCodeData")
     public String sendQrCodeData(String Sign,long timeStamp,String device,int  quntity){
         Map<String, String> data = new HashMap<>();
         data.put("QRCode1", "http://xxxxxxx1");
         data.put("QRCode2", "http://xxxxxxx2");
         data.put("QRCode3", "http://xxxxxxx3");
         data.put("IndexCode1", "001");
         data.put("IndexCode2", "002");
         data.put("IndexCode3", "003");
         data.put("Quantity", quntity+"");
         return "success";
     }
```

测试代码:

```java
package com.xiaobu;

import com.xiaobu.base.utils.HttpClientUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/12/27 15:55
 * @description V1.0
 */
public class HttpClientDemo {
    public static void main(String[] args) {
        String postUrl = "http://localhost:8899/api/revQrCodeRelationData";
        //通过K-V来获取 SpringMVC实现了封装
        Map<String, String> map = new HashMap<>();
        map.put("data", "我是你大爷");
        String result = HttpClientUtils.sendPostDataByMap(postUrl, map, "UTF-8");
        System.out.println("result = " + result);

        //通过request.getInputStream()来获取
        String json = "我是你二大爷";
        String jsonResult=HttpClientUtils.sendPostDataByJson(postUrl, json, "UTF-8");
        System.out.println("jsonResult = " + jsonResult);
        //通过request.getInputStream()来获取
        String xml = "<!--?xml version=\"1.0\"?-->\n" +
                "<methodcall>\n" +
                "    <methodname>examples.getStateName</methodname>\n" +
                "    <params>\n" +
                "        <param>\n" +
                "            <value><i4>中国人</i4></value>\n" +
                "\n" +
                "    </params>\n" +
                "</methodcall>";
        String xmlResult=HttpClientUtils.sendPostDataByXml(postUrl, xml, "UTF-8");
        System.out.println("xmlResult = " + xmlResult);

        //get方式
        String getUrl = "http://localhost:8899/api/sendQRCodeData?Sign=1&timeStamp=1234567890123&device=1&quntity=1";
        String getResult = HttpClientUtils.sendGetData(getUrl, "UTF-8");
        System.out.println("getResult = " + getResult);
    }
}

```

参考:

[Http中Content-Type的详解](https://blog.csdn.net/danielzhou888/article/details/72861097) 