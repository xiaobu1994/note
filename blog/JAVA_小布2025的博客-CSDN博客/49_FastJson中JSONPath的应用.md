# FastJson中JSONPath的应用

> 原创 最新推荐文章于 2026-03-20 09:25:16 发布 · 公开 · 949 阅读 · 1 · 2 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/104835013

## JSONPath是FastJson的一个类 先解析JSON数据为JSONObject，然后就能直接使用JSONPath了。  (fastjson在1.2.0之后就支持jsonpath了)

```java
package com.xiaobu.note.json.fastjson;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONPath;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/3/13 8:23
 * @description
 */
public class FastJsonDemo1 {

    public static void main(String[] args) {
        String jsonStr = "{ \"store\": {\"book\": [{ \"category\": \"reference\"," +
                "\"author\": \"Nigel Rees\",\"title\": \"Sayings of the Century\"," +
                "\"price\": 8.95},{ \"category\": \"fiction\",\"author\": \"Evelyn Waugh\"," +
                "\"title\": \"Sword of Honour\",\"price\": 12.99,\"isbn\": \"0-553-21311-3\"" +
                "}],\"bicycle\": {\"color\": \"red\",\"price\": 19.95}}}";
        // 先解析JSON数据为JSONObject，然后就能直接使用JSONPath了。
        JSONObject jsonObject = JSON.parseObject(jsonStr);
        System.out.println("book数目:"+ JSONPath.eval(jsonObject, "$.store.book.size()") );
        System.out.println("第一本书的title:"+JSONPath.eval(jsonObject,"$.store.book[0].title"));
        System.out.println("第一本书的category和author:"+JSONPath.eval(jsonObject,"$.store.book[0]['category','author']"));
        System.out.println("price>10的书:"+JSONPath.eval(jsonObject,"$.store.book[price>10]"));
        System.out.println("price>8的书的标题:"+JSONPath.eval(jsonObject,"$.store.book[price>8]"));
        System.out.println("price>7的书:"+JSONPath.eval(jsonObject,"$.store.book[price>7]"));
        System.out.println("price>7的书的标题:"+JSONPath.eval(jsonObject,"$.store.book[price>7].title"));
       //不带单引号会出现Exception in thread "main" java.lang.UnsupportedOperationException 异常
        System.out.println("书的标题为Sayings of the Century:"+JSONPath.eval(jsonObject,"$.store.book[title='Sayings of the Century']"));
        System.out.println("bicycle的所有属性:"+JSONPath.eval(jsonObject,"$.store.bicycle.*"));
        System.out.println("bicycle:"+JSONPath.eval(jsonObject,"$.store.bicycle"));

    }
}
```

结果:

```properties
book数目:2
第一本书的title:Sayings of the Century
第一本书的category和author:[reference, Nigel Rees]
price>10的书:[{"author":"Evelyn Waugh","price":12.99,"isbn":"0-553-21311-3","category":"fiction","title":"Sword of Honour"}]
price>8的书的标题:[{"author":"Evelyn Waugh","price":12.99,"isbn":"0-553-21311-3","category":"fiction","title":"Sword of Honour"}]
price>7的书:[{"author":"Nigel Rees","price":8.95,"category":"reference","title":"Sayings of the Century"}, {"author":"Evelyn Waugh","price":12.99,"isbn":"0-553-21311-3","category":"fiction","title":"Sword of Honour"}]
price>7的书的标题:[Sayings of the Century, Sword of Honour]
书的标题为Sayings of the Century:[{"author":"Nigel Rees","price":8.95,"category":"reference","title":"Sayings of the Century"}]
bicycle的所有属性:[red, 19.95]
bicycle:{"color":"red","price":19.95}
```

个人理解:不适用于需要很多的json属性的业务场景。