# Java实体映射工具 MapStruct的简单应用

> 原创 最新推荐文章于 2026-05-12 10:40:29 发布 · 公开 · 448 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/108864531

> MapStruct（https://mapstruct.org/ ）是一种代码生成器，它极大地简化了基于”约定优于配置”方法的Java bean类型之间映射的实现。生成的映射代码使用纯方法调用，因此快速、类型安全且易于理解。

一、pom.xml的maven 依赖

```xml
    <properties>
             <org.mapstruct.version>1.3.1.Final</org.mapstruct.version>
    </properties>


<dependency>
            <groupId>org.mapstruct</groupId>
            <artifactId>mapstruct</artifactId>
            <version>${org.mapstruct.version}</version>
</dependency>



 <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>1.8</source> <!-- depending on your project -->
                    <target>1.8</target> <!-- depending on your project -->
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.mapstruct</groupId>
                            <artifactId>mapstruct-processor</artifactId>
                            <version>${org.mapstruct.version}</version>
                        </path>
                        <!-- 添加lombok依赖 否则会报找不到属性-->
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>1.16.10</version>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>

```

二、业务代码

2.1 实体类

```java
package com.demo;

import lombok.Data;

import java.util.Date;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/9/29 9:40
 * @description
 */
@Data
public class PersonDO {
    private Integer id;
    private String name;
    private int age;
    private Date birthday;
    private String gender;
}

```

```java
package com.demo;

import lombok.Data;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/9/29 9:43
 * @description
 */
@Data
public class PersonDTO {
    private String userName;
    private Integer age;
    private String birthday;
    private String gender;
}

```

2.2 定义映射接口

```java
package com.demo;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/9/29 9:30
 * @description
 */
@Mapper
interface PersonConvert {
    PersonConvert INSTANCE = Mappers.getMapper(PersonConvert.class);

    @Mapping(source = "name", target = "userName")
    @Mapping(target = "birthday", source = "birthday",dateFormat = "yyyy-MM-dd HH:mm:ss")
    PersonDTO do2dto(PersonDO person);

}

```

2.3 测试类

```java
package com.demo;

import java.util.Date;

/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2020/9/29 9:21
 * @description
 */
public class MapStructDemo {

    public static void main(String[] args) {
        PersonDO personDO = new PersonDO();
        personDO.setName("xiaobu");
        personDO.setAge(26);
        personDO.setBirthday(new Date());
        personDO.setId(1);
        personDO.setGender("男");
        PersonDTO personDTO = PersonConvert.INSTANCE.do2dto(personDO);
        System.out.println(personDTO);
    }
}

```

 ![错误信息.jpg](./assets/62_1.png)

解决方案: 在pom.xml里面添加lombok依赖

参考:

[MapStruct and Lombok not working together](https://stackoverflow.com/questions/47676369/mapstruct-and-lombok-not-working-together) 