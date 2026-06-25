# 记录fastjson的使用

> 原创 最新推荐文章于 2024-08-17 17:17:51 发布 · 公开 · 380 阅读 · 1 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84863126

一、toJSONString()的应用

源码解析：

```java

	   public static String toJSONString(Object object) {
        return toJSONString(object, emptyFilters);
    }
```

实例应用：

```java

	   //将list转成json字符串
    @Override
    public String findTaskVosByTaskId(String taskId) {
        List<TaskVo> list = taskMapper.findTaskVosByTaskId(taskId);
        return JSON.toJSONString(list);
    }





    //将对象转成json字符串
    @Override
    public String findById(String taskId) {
        TaskVo taskVo = taskMapper.findById(taskId);
        return JSON.toJSONString(taskVo);
    }
```

---

二、parseObject(String text, Class<T> clazz)的应用 也可以把json字符串转为jsonobject

源码解析：

```java
   //T 需要实现 Serializable接口（不实现好像也可以） 
        public static <T > T parseObject(String text, Class < T > clazz) {
            return parseObject(text, clazz);
        }
```

实例应用：

```java
//转换为对应的实体类。 
public static TaskVo findById(String taskId){
        try {
            objects = client.invoke("findById", taskId);
            String json = (String) objects[0];
            return JSON.parseObject(json,TaskVo.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
```

---

三、parseArray(String text, Class<T> clazz)的应用

源码分析：

```java
    //需要实现 Serializable接口（不实现好像也可以）
	public static <T> List<T> parseArray(String text, Class<T> clazz) {
        if (text == null) {
            return null;
        } else {
            DefaultJSONParser parser = new DefaultJSONParser(text, ParserConfig.getGlobalInstance());
            JSONLexer lexer = parser.lexer;
            int token = lexer.token();
            ArrayList list;
            if (token == 8) {
                lexer.nextToken();
                list = null;
            } else if (token == 20 && lexer.isBlankInput()) {
                list = null;
            } else {
                list = new ArrayList();
                parser.parseArray(clazz, list);
                parser.handleResovleTask(list);
            }

            parser.close();
            return list;
        }
    }
	
```

实例应用：

```java
public static List<TaskVo> findTaskVosByTaskName(String taskName){
        try {
            objects = client.invoke("findTaskVosByTaskName", taskName);
            String json = (String) objects[0];
            return JSON.parseArray(json,TaskVo.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
```

---

四、parseArray(String text)与JSONArray(List<Object> list)的应用

源码分析：

```java
//把字符串变成  JSONArray 
public static JSONArray parseArray(String text) {
        if (text == null) {
            return null;
        } else {
            DefaultJSONParser parser = new DefaultJSONParser(text, ParserConfig.getGlobalInstance());
            JSONLexer lexer = parser.lexer;
            JSONArray array;
            if (lexer.token() == 8) {
                lexer.nextToken();
                array = null;
            } else if (lexer.token() == 20) {
                array = null;
            } else {
                array = new JSONArray();
                parser.parseArray(array);
                parser.handleResovleTask(array);
            }

            parser.close();
            return array;
        }
    }

    
    //把list集合变成JSONArray
    public JSONArray(List<Object> list) {
        this.list = list;
    }
```

实例应用：

```java
 public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("1");
        list.add("2");
        list.add("3");
        String json = JSON.toJSONString(list);
        System.out.println("json = " + json);
        JSONArray jsonArray = new JSONArray(new ArrayList<>(list));
        System.out.println("jsonArray = " + jsonArray);
        JSONArray array= JSONArray.parseArray(JSON.toJSONString(list));
        System.out.println("array = " + array);
    }
```

结果显示：

```java
json = ["1","2","3"]
jsonArray = ["1","2","3"]
array = ["1","2","3"]
```

---

五、toString()和toJSONString()的应用

源码分析：

```java
 public String toString() {
        return this.toJSONString();
    }




  public String toJSONString() {
        SerializeWriter out = new SerializeWriter();

        String var2;
        try {
            (new JSONSerializer(out)).write(this);
            var2 = out.toString();
        } finally {
            out.close();
        }

        return var2;
    }
```

实例应用：

```java
  public static void main(String[] args) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("rowCount", "rowCount");
        jsonObject.put("taskVos", "taskVos");
        jsonObject.put("resultCount", "resultCount");
        System.out.println("jsonObject.toString() = " + jsonObject.toString());
        System.out.println("jsonObject.toJSONString() = " + jsonObject.toJSONString());
    }
```

结果显示：

```java
jsonObject.toString() = {"resultCount":"resultCount","taskVos":"taskVos","rowCount":"rowCount"}
jsonObject.toJSONString() = {"resultCount":"resultCount","taskVos":"taskVos","rowCount":"rowCount"}
```

可以看出toString()最终还要调用toJSONString()，建议直接使用toJSONString()。



FastJSON 转换保存null值

```java
JSON.toJSONString(jsonObject, SerializerFeature.WriteMapNullValue);
```