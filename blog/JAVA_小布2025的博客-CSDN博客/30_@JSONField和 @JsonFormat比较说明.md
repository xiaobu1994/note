# @JSONField和 @JsonFormat比较说明

> 原创 最新推荐文章于 2025-07-22 15:30:12 发布 · 公开 · 9.6k 阅读 · 4 · 9 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84851363

@JSONField是阿里巴巴下fastjson下的，@JsonFormat是jackson下面的。

一、@JSONField的常用方式：

```html
1.1、name的用法：
```

实体类：

```java
package com.xiaobu.entity;

import com.alibaba.fastjson.annotation.JSONField;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/12/4 19:00
 * @description V1.0
 */
@Data
public class Roles implements Serializable {
    private static final long serialVersionUID = 5775171105018867238L;

    @JSONField(name = "role_id")
    @Column(name = "RoleId")
    private Integer RoleId;

    @JSONField(name = "role_desc")
    @Column(name = "RoleDesc")
    private String RoleDesc;
}
```

测试类：

```java
 /**
     * @author xiaobu
     * @date 2018/12/5 16:53
     * @descprition  表明  json不区分大小写都能转换
     * @version 1.0
     * bean to JSON:{"role_desc":"admin","role_id":8}
     * 需要转换的json:{"ROLE_DESC":"ADMIN","ROLE_ID":8}
     * RoleDesc:ADMIN
     */
    @Test
    public void testJSONField(){
        Roles roles = new Roles();
        roles.setRoleDesc("admin");
        roles.setRoleId(8);
        String jsonStr=JSONObject.toJSONString(roles);
        System.out.println("bean to JSON:"+jsonStr);
        //改变json的key为大写
        jsonStr = jsonStr.toUpperCase();
        System.out.println("需要转换的json:" + jsonStr);
        roles = JSONObject.toJavaObject(JSONObject.parseObject(jsonStr), Roles.class);
        System.out.println("RoleDesc:"+roles.getRoleDesc());

    }
```

1.2  format的用法：

实体类：

```java
 /**
     * 任务接收时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    @JSONField(format = "yyyy-MM-dd")
    @Column(name="TaskAcceptTime")
    private Date TaskAcceptTime;

    /**
     *任务完成时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    @JSONField(format = "yyyy-MM-dd")
    @Column(name="TaskCompleteTime")
    private Date TaskCompleteTime;
```

测试类：

```java
@Test
    public void findByExample() {
        Task task = new Task();
        task.setTaskId("HYR08274-0804");
        Example example = new Example(Task.class);
        Example.Criteria criteria = example.createCriteria();
        if (StringUtils.isNotBlank(task.getTaskId())) {
            criteria.andLike("TaskId", "%" + task.getTaskId() + "%");
        }
        //TaskAcceptTime=Mon Aug 04 00:00:00 CST 2008,TaskCompleteTime=Fri Nov 07 00:00:00 CST 2008
        List<Task> tasks = taskMapper.selectByExample(example);
        System.out.println(tasks);
        //""taskAcceptTime":"2008-08-04","taskCompleteTime":"2008-11-07"
        String fastJsonStr = JSON.toJSONString(tasks);
        System.out.println("fastJsonStr = " + fastJsonStr);
        ObjectMapper MAPPER = new ObjectMapper();
        try {
            //""TaskAcceptTime":"2008-08-04","TaskCompleteTime":"2008-11-07 00:00:00"
            String ujosn = MAPPER.writeValueAsString(tasks);
            System.out.println("ujosn = " + ujosn);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

    }
```

```
@JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8") 必须加上时区。
```

```
@JSONField(format = "yyyy-MM-dd")
```

这两个的作用都是格式化日期时间。且只能作用在日期时间上。

---

补充：  前台传后台
@DateTimeFormat(pattern="yyyy-MM-dd")