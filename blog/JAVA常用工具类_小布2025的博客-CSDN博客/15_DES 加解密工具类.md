# DES 加解密工具类

> 原创 最新推荐文章于 2024-05-10 20:34:24 发布 · 公开 · 366 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/83543939

一、DES加解密工具类

```java
package com.hans.common.util;

import java.io.*;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Objects;

import javax.crypto.*;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.IvParameterSpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;


public class DES {

    public static final String KEY = "ydiqfkea";

    /**
     * 加密函数
     *
     * @param data
     * 加密数据
     * @param key
     * 密钥
     * @return 返回加密后的数据
     */
    public static byte[] encrypt(byte[] data, byte[] key) {
        try {
            // DES算法要求有一个可信任的随机数源
            SecureRandom sr = new SecureRandom();
            // 从原始密钥数据创建DESKeySpec对象
            DESKeySpec dks = new DESKeySpec(key);
            // 创建一个密匙工厂，然后用它把DESKeySpec转换成
            // 一个SecretKey对象
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey secretKey = keyFactory.generateSecret(dks);
            // using DES in ECB mode
            Cipher cipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
            // 用密匙初始化Cipher对象
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, sr);
            // 执行加密操作
            return cipher.doFinal(data);
        } catch (Exception e) {
            System.err.println("DES算法，加密数据出错!");
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 解密函数
     *
     * @param data
     * 解密数据
     * @param key
     * 密钥
     * @return 返回解密后的数据
     */
    public static byte[] decrypt(byte[] data, byte[] key) {
        try {
// DES算法要求有一个可信任的随机数源
            SecureRandom sr = new SecureRandom();
// byte rawKeyData[] = /* 用某种方法获取原始密匙数据 */;
// 从原始密匙数据创建一个DESKeySpec对象
            DESKeySpec dks = new DESKeySpec(key);
// 创建一个密匙工厂，然后用它把DESKeySpec对象转换成
// 一个SecretKey对象
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey secretKey = keyFactory.generateSecret(dks);
// using DES in ECB mode
            Cipher cipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
// 用密匙初始化Cipher对象
            cipher.init(Cipher.DECRYPT_MODE, secretKey, sr);
// 正式执行解密操作
            return cipher.doFinal(data);
        } catch (Exception e) {
            System.err.println("DES算法，解密出错。");
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 加密函数
     *
     * @param data
     * 加密数据
     * @param key
     * 密钥
     * @return 返回加密后的数据
     */
    public static byte[] CBCEncrypt(byte[] data, byte[] key, byte[] iv) {
        try {
// 从原始密钥数据创建DESKeySpec对象
            DESKeySpec dks = new DESKeySpec(key);
// 创建一个密匙工厂，然后用它把DESKeySpec转换成
// 一个SecretKey对象
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey secretKey = keyFactory.generateSecret(dks);
// Cipher对象实际完成加密操作
            Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
// 若采用NoPadding模式，data长度必须是8的倍数
// Cipher cipher = Cipher.getInstance("DES/CBC/NoPadding");
// 用密匙初始化Cipher对象
            IvParameterSpec param = new IvParameterSpec(iv);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, param);
// 执行加密操作
            return cipher.doFinal(data);
        } catch (Exception e) {
            System.err.println("DES算法，加密数据出错!");
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 解密函数
     *
     * @param data
     * 解密数据
     * @param key
     * 密钥
     * @return 返回解密后的数据
     */
    public static byte[] CBCDecrypt(byte[] data, byte[] key, byte[] iv) {
        try {
// 从原始密匙数据创建一个DESKeySpec对象
            DESKeySpec dks = new DESKeySpec(key);
// 创建一个密匙工厂，然后用它把DESKeySpec对象转换成
// 一个SecretKey对象
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
            SecretKey secretKey = keyFactory.generateSecret(dks);
// using DES in CBC mode
            Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
// 若采用NoPadding模式，data长度必须是8的倍数
// Cipher cipher = Cipher.getInstance("DES/CBC/NoPadding");
// 用密匙初始化Cipher对象
            IvParameterSpec param = new IvParameterSpec(iv);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, param);
// 正式执行解密操作
            return cipher.doFinal(data);
        } catch (Exception e) {
            System.err.println("DES算法，解密出错。");
            e.printStackTrace();
        }
        return null;
    }
    /**
     * sn 解密
     * @return
     */
    public static String decrypt(String sn,String key){
        String result = "";
        try {
            BASE64Decoder base64De = new BASE64Decoder();
            byte[] b = null;
            sn=sn.replaceAll("-", "/").replaceAll("_", "+");
            if("..".equals(sn.substring(sn.length() - 2, sn.length()))){
                sn = sn.substring(0, sn.length()-2) +"==";
            }else if(".".equals(sn.substring(sn.length() - 1, sn.length()))){
                sn = sn.substring(0, sn.length()-1) +"=";
            }
            b = base64De.decodeBuffer(sn);
            result = new String(Objects.requireNonNull(DES.decrypt(b, key.getBytes())));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }



	// 根据密码解密文件。
	public static void decryptFile(String file, String newFile, String key) {
		// DES算法要求有一个可信任的随机数源
		SecureRandom sr = new SecureRandom();
		// byte rawKeyData[] = /* 用某种方法获取原始密匙数据 */;
		// 从原始密匙数据创建一个DESKeySpec对象
		DESKeySpec dks = null;
		InputStream in = null;
		CipherOutputStream cout = null;
		OutputStream out = null;
		try {
			dks = new DESKeySpec(key.getBytes("utf8"));
			// 创建一个密匙工厂，然后用它把DESKeySpec对象转换成
			// 一个SecretKey对象
			SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
			SecretKey secretKey = keyFactory.generateSecret(dks);
			// using DES in ECB mode
			Cipher cipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
			// 用密匙初始化Cipher对象
			cipher.init(Cipher.DECRYPT_MODE, secretKey, sr);

			in = new FileInputStream(file);
			out = new FileOutputStream(newFile);
			cout = new CipherOutputStream(out, cipher);
			byte[] buffer = new byte[1024];
			int count = 0;
			while ((count = in.read(buffer)) > 0) {
				cout.write(buffer, 0, count);
			}
		} catch (InvalidKeyException | NoSuchAlgorithmException | InvalidKeySpecException | NoSuchPaddingException | IOException e) {
			e.printStackTrace();
		} finally {
			try {
				cout.close();
				out.close();
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}


    /**
     *
     * @param bytes byte数组
     * @return 字符串
     */
	public static String getEncryptStr(byte[] bytes){
        BASE64Encoder base64Encoder = new BASE64Encoder();
        String encoderStr = base64Encoder.encode(Objects.requireNonNull(bytes));
        return encoderStr.replaceAll("/", "-").replaceAll("\\+", "_");
    }
}

```