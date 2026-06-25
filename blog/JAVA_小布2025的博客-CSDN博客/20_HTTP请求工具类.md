# HTTP请求工具类

> 原创 最新推荐文章于 2025-01-20 14:26:48 发布 · 公开 · 232 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/82260097

public class MyX509TrustManager {
private static class TrustAnyHostnameVerifier implements HostnameVerifier {
@Override
public boolean verify(String hostname, SSLSession session) {
return true;
}
}

```
/**
 * post方式请求服务器(https协议)
 *
 * @param url
 *            请求地址
 *            编码
 * @return
 * @throws java.security.NoSuchAlgorithmException
 * @throws java.security.KeyManagementException
 * @throws java.io.IOException
 */
public static String getResult1(String url) throws NoSuchAlgorithmException,
		KeyManagementException, IOException {


	URL console = new URL(url);
	HttpURLConnection conn = (HttpURLConnection) console.openConnection();
	conn.connect();
	InputStream is = conn.getInputStream();
	if (is != null) {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = is.read(buffer)) != -1) {
			outStream.write(buffer, 0, len);
		}
		is.close();

		return new String(outStream.toByteArray(),"utf-8");
	}
	return null;
}


/**
 * post方式请求服务器(https协议)
 * 
 * @param url
 *            请求地址
 *            编码
 * @return
 * @throws java.security.NoSuchAlgorithmException
 * @throws java.security.KeyManagementException
 * @throws java.io.IOException
 */
public static String getResult(String url) throws NoSuchAlgorithmException,
		KeyManagementException, IOException {
	

	URL console = new URL(url);
	HttpsURLConnection conn = (HttpsURLConnection) console.openConnection();
	conn.setHostnameVerifier(new TrustAnyHostnameVerifier());
	conn.connect();
	InputStream is = conn.getInputStream();
	if (is != null) {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = is.read(buffer)) != -1) {
			outStream.write(buffer, 0, len);
		}
		is.close();
		
		return new String(outStream.toByteArray(),"utf-8");
	}
	return null;
}

/**
 * 向post发送post请求
 * @param context 发送的内容 url：地址
 * @return
 * @throws NoSuchAlgorithmException
 * @throws KeyManagementException
 * @throws IOException
 */
public static String postHttps(byte[] context,String url) throws NoSuchAlgorithmException,
		KeyManagementException, IOException {


	URL console = new URL(url);
	HttpsURLConnection conn = (HttpsURLConnection) console.openConnection();
	conn.setHostnameVerifier(new TrustAnyHostnameVerifier());
	conn.setRequestMethod("POST");
	conn.setRequestProperty("Content-Length",
			String.valueOf(context.length));
	conn.setUseCaches(false);
	conn.setDoOutput(true);

	conn.getOutputStream().write(context);
	conn.getOutputStream().flush();
	conn.getOutputStream().close();
	conn.connect();
	InputStream is = conn.getInputStream();
	if (is != null) {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = is.read(buffer)) != -1) {
			outStream.write(buffer, 0, len);
		}
		is.close();

		return new String(outStream.toByteArray(), "utf-8");
	}
	return null;
}
```

}