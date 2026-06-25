# SpringBoot | CXF发布WebService服务和客户端调用WebService服务

> 原创 于 2018-11-23 15:00:58 发布 · 公开 · 1.4k 阅读 · 0 · 4 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/84390378

一、引入maven依赖

```java
<!-- cxf支持 -->
        <dependency>
            <groupId>org.apache.cxf</groupId>
            <artifactId>cxf-spring-boot-starter-jaxws</artifactId>
            <version>3.2.7</version>
        </dependency>
```

二、服务端

2.1、service接口类

```java
package com.example.server;
 
import com.example.entity.Book;
 
import javax.jws.WebService;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/23 9:01
 * @description V1.0  如要指定服务名称则接口和实现类的须一致@WebService(name="demo")
 */
@WebService
public interface DemoService {
 
    Book getBookById(int id);
 
    String insert();
}
```

2.2、实现类

```java
package com.example.server;
 
import com.example.entity.Book;
import com.example.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
 
import javax.jws.WebService;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/23 9:03
 * @description V1.0  命名空间 默认为接口类所在包的逆序
 * 如要指定服务名称则接口和实现类的须一致@WebService(name="demo") @WebService(endpointInterface = "com.example.server.DemoService",serviceName = "demo")
 */
@WebService(endpointInterface = "com.example.server.DemoService")
@Component
public class DemoServiceImpl implements DemoService {
    @Autowired
    BookService bookService;
    @Override
    public Book getBookById(int id) {
        Book book = new Book();
        book.setName("webservice测试");
        book.setId(123);
        book.setAuthor("小布");
        return book;
    }
 
    @Override
    public String insert() {
        Book book = new Book();
        book.setAuthor("小布");
        book.setName("CXF webservice调用");
        bookService.save(book);
        return "插入成功";
    }
}
```

2.3、定义拦截器验证用户名和密码

```java
package com.example.server.interceptor;
 
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.saaj.SAAJInInterceptor;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.NodeList;
 
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
/**
 * @author xiaobu
 * @date 2018/11/23 13:57
 * @descprition   CXF定义拦截器用于用户验证
 * @version 1.0
 */
 
public class AuthInterceptor extends AbstractPhaseInterceptor<SoapMessage>{
    private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);
    private SAAJInInterceptor saa = new SAAJInInterceptor();
 
    private static final String USER_NAME = "admin";
    private static final String USER_PASSWORD = "1";
 
    public AuthInterceptor() {
        super(Phase.PRE_PROTOCOL);
        getAfter().add(SAAJInInterceptor.class.getName());
    }
 
    @Override
    public void handleMessage(SoapMessage message) throws Fault {
        SOAPMessage mess = message.getContent(SOAPMessage.class);
        if (mess == null) {
            saa.handleMessage(message);
            mess = message.getContent(SOAPMessage.class);
        }
        SOAPHeader head = null;
        try {
            head = mess.getSOAPHeader();
        } catch (Exception e) {
            logger.error("getSOAPHeader error: {}",e.getMessage(),e);
        }
        if (head == null) {
            throw new Fault(new IllegalArgumentException("找不到Header，无法验证用户信息"));
        }
 
        NodeList users = head.getElementsByTagName("username");
        NodeList passwords = head.getElementsByTagName("password");
        if (users.getLength() < 1) {
            throw new Fault(new IllegalArgumentException("找不到用户信息"));
        }
        if (passwords.getLength() < 1) {
            throw new Fault(new IllegalArgumentException("找不到密码信息"));
        }
 
        String userName = users.item(0).getTextContent().trim();
        String password = passwords.item(0).getTextContent().trim();
        if(USER_NAME.equals(userName) && USER_PASSWORD.equals(password)){
            logger.debug("admin auth success");
        } else {
            SOAPException soapExc = new SOAPException("认证错误");
            logger.debug("admin auth failed");
            throw new Fault(soapExc);
        }
    }
}
```

2.4、CXF服务端配置

```java
package com.example.server.interceptor;
 
import com.example.server.DemoService;
import org.apache.cxf.Bus;
import org.apache.cxf.jaxws.EndpointImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
 
import javax.xml.ws.Endpoint;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/23 9:16
 * @description V1.0 CXF配置
 */
@Configuration
public class CxfConfig {
    @Autowired
    private Bus bus;
 
    @Autowired
    DemoService demoService;
 
    /**
     * @author xiaobu
     * @date 2018/11/23 14:38
     * @return javax.xml.ws.Endpoint
     * @descprition  EndpointImpl 引入的包为  org.apache.cxf.jaxws.EndpointImpl; 
     * @version 1.0
     */
    @Bean
    public Endpoint endpoint() {
        EndpointImpl endpoint = new EndpointImpl(bus, demoService);
        endpoint.publish("/demoService");
        endpoint.getInInterceptors().add(new AuthInterceptor());
        return endpoint;
    }
 
}
```

2.5、访问 [http://localhost:8080/services/demoService?wsdl](http://localhost:8080/services/demoService?wsdl) 效果如下（默认的路径http://主机地址:端口/services）：

```cobol
<wsdl:definitions xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:tns="http://server.example.com/" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:ns1="http://schemas.xmlsoap.org/soap/http" name="DemoServiceImplService" targetNamespace="http://server.example.com/">
<wsdl:types>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tns="http://server.example.com/" elementFormDefault="unqualified" targetNamespace="http://server.example.com/" version="1.0">
<xs:element name="getBookById" type="tns:getBookById"/>
<xs:element name="getBookByIdResponse" type="tns:getBookByIdResponse"/>
<xs:element name="insert" type="tns:insert"/>
<xs:element name="insertResponse" type="tns:insertResponse"/>
<xs:complexType name="insert">
<xs:sequence/>
</xs:complexType>
<xs:complexType name="insertResponse">
<xs:sequence>
<xs:element minOccurs="0" name="return" type="xs:string"/>
</xs:sequence>
</xs:complexType>
<xs:complexType name="getBookById">
<xs:sequence>
<xs:element name="arg0" type="xs:int"/>
</xs:sequence>
</xs:complexType>
<xs:complexType name="getBookByIdResponse">
<xs:sequence>
<xs:element minOccurs="0" name="return" type="tns:book"/>
</xs:sequence>
</xs:complexType>
<xs:complexType name="book">
<xs:sequence>
<xs:element minOccurs="0" name="author" type="xs:string"/>
<xs:element name="id" type="xs:int"/>
<xs:element minOccurs="0" name="name" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:schema>
</wsdl:types>
<wsdl:message name="getBookByIdResponse">
<wsdl:part element="tns:getBookByIdResponse" name="parameters"> </wsdl:part>
</wsdl:message>
<wsdl:message name="insert">
<wsdl:part element="tns:insert" name="parameters"> </wsdl:part>
</wsdl:message>
<wsdl:message name="insertResponse">
<wsdl:part element="tns:insertResponse" name="parameters"> </wsdl:part>
</wsdl:message>
<wsdl:message name="getBookById">
<wsdl:part element="tns:getBookById" name="parameters"> </wsdl:part>
</wsdl:message>
<wsdl:portType name="DemoService">
<wsdl:operation name="insert">
<wsdl:input message="tns:insert" name="insert"> </wsdl:input>
<wsdl:output message="tns:insertResponse" name="insertResponse"> </wsdl:output>
</wsdl:operation>
<wsdl:operation name="getBookById">
<wsdl:input message="tns:getBookById" name="getBookById"> </wsdl:input>
<wsdl:output message="tns:getBookByIdResponse" name="getBookByIdResponse"> </wsdl:output>
</wsdl:operation>
</wsdl:portType>
<wsdl:binding name="DemoServiceImplServiceSoapBinding" type="tns:DemoService">
<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
<wsdl:operation name="insert">
<soap:operation soapAction="" style="document"/>
<wsdl:input name="insert">
<soap:body use="literal"/>
</wsdl:input>
<wsdl:output name="insertResponse">
<soap:body use="literal"/>
</wsdl:output>
</wsdl:operation>
<wsdl:operation name="getBookById">
<soap:operation soapAction="" style="document"/>
<wsdl:input name="getBookById">
<soap:body use="literal"/>
</wsdl:input>
<wsdl:output name="getBookByIdResponse">
<soap:body use="literal"/>
</wsdl:output>
</wsdl:operation>
</wsdl:binding>
<wsdl:service name="DemoServiceImplService">
<wsdl:port binding="tns:DemoServiceImplServiceSoapBinding" name="DemoServiceImplPort">
<soap:address location="http://localhost:8080/services/demoService"/>
</wsdl:port>
</wsdl:service>
</wsdl:definitions>
```

三、客户端配置

3.1、在头部设置账户、密码

```java
package com.example.server.interceptor;
 
 
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.headers.Header;
import org.apache.cxf.helpers.DOMUtils;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
 
import javax.xml.namespace.QName;
import java.util.List;
 
/**
 * @author xiaobu
 * @date 2018/11/23 14:11
 * @return
 * @descprition  客户端在头部设置账户、密码
 * @version 1.0
 */
public class ClientLoginInterceptor  extends AbstractPhaseInterceptor<SoapMessage> {
 
    private String username;
    private String password;
 
    public ClientLoginInterceptor(String username, String password) {
        super(Phase.PREPARE_SEND);
        this.username = username;
        this.password = password;
    }
 
    @Override
    public void handleMessage(SoapMessage soap) throws Fault {
        List<Header> headers = soap.getHeaders();
        Document doc = DOMUtils.createDocument();
        Element auth = doc.createElement("authority");
        Element username = doc.createElement("username");
        Element password = doc.createElement("password");
        username.setTextContent(this.username);
        password.setTextContent(this.password);
        auth.appendChild(username);
        auth.appendChild(password);
        headers.add(0, new Header(new QName("tiamaes"),auth));
    }
}
```

3.2、动态调用

```java
package com.example.cxfClient;
 
import com.example.entity.Book;
import com.example.server.interceptor.ClientLoginInterceptor;
import com.example.util.EntityUtils;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;
 
import java.util.Arrays;
import java.util.List;
import java.util.Map;
 
/**
 * @author xiaobu
 * @version JDK1.8.0_171
 * @date on  2018/11/23 10:45
 * @description V1.0 webservice客户端调用
 */
public class TestDemo {
    private static final String WSDL_URL = "http://localhost:8080/services/demoService?wsdl";
    private static final String USER_NAME = "admin";
    private static final String PASS_WORD = "1";
    private static JaxWsDynamicClientFactory dcf = JaxWsDynamicClientFactory.newInstance();
    private static Client client = dcf.createClient(WSDL_URL);
 
    public static void main(String[] args) {
        method1();
    }
 
    /**
     * @author xiaobu
     * @date 2018/11/23 14:29
     * @param
     * @return void
     * @descprition  //动态调用
     * @version 1.0
     */
    @SuppressWarnings("all")
    private static void method1() {
        // 需要密码的情况需要加上用户名和密码
         client.getOutInterceptors().add(new ClientLoginInterceptor(USER_NAME,PASS_WORD));
        Object[] objects = new Object[0];
        try {
            // invoke("方法名",参数1,参数2,参数3....);
            objects = client.invoke("getBookById", 1);
            List list = Arrays.asList(objects);
            //这里的Book对象
            List<Book> books = EntityUtils.copyList(list,Book.class,new String[]{});
            System.out.println("books=======>>"+books);
            Book book = EntityUtils.convertBean(objects[0], Book.class);
            System.out.println("book======>>"+book);
            Book book2 = EntityUtils.copy(objects[0], Book.class, new String[]{});
            System.out.println("book2======>>"+book2);
            Map map = EntityUtils.objectToMap(book);
            System.out.println("Map:" + map);
            Book book1 = EntityUtils.mapToObject(map,Book.class);
            System.out.println("book1======>>"+book1);
        } catch (java.lang.Exception e) {
            e.printStackTrace();
        }
    }
 
}
```

客户端生成代理调用的省略。。。。



---

项目用到shiro的话，需要设置匿名可以访问



```java
 //设置webservice访问无需登录  否则会出现Caused by: com.ctc.wstx.exc.WstxEOFException: Unexpected EOF in prolog
        filterChainDefinitionMap.put("/services/**", "anon");
```