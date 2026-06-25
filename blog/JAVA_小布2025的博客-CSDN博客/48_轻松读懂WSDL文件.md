# 轻松读懂WSDL文件

> 原创 最新推荐文章于 2026-05-22 14:15:21 发布 · 公开 · 2.9k 阅读 · 0 · 10 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/104676880

| 元素 | 定义 |
|:---:|:---:|
| portType | web service 执行的操作 |
| message | web service 使用的消息 |
| types | web service 使用的数据类型 |
| binding | web service 使用的通信协议 |

### portType 是最重要的 WSDL 元素。

portType 元素

它可描述一个 web service、可被执行的操作，以及相关的消息。

可以把 portType 元素比作传统编程语言中的一个函数库（或一个模块、或一个类）。

| 类型 | 定义 |
|:---:|:---:|
| One-way | 此操作可接受消息，但不会返回响应。 |
| Request-response | 此操作可接受一个请求并会返回一个响应 |
| Solicit-response | 此操作可发送一个请求，并会等待一个响应。 |
| Notification | 此操作可发送一条消息，但不会等待响应。 |

Request-response

```xml
<wsdl:portType name="DemoService">
<wsdl:operation name="demo2">
<wsdl:input message="tns:demo2" name="demo2"> </wsdl:input>
<wsdl:output message="tns:demo2Response" name="demo2Response"> </wsdl:output>
</wsdl:operation>
<wsdl:operation name="demo">
<wsdl:input message="tns:demo" name="demo"> </wsdl:input>
<wsdl:output message="tns:demoResponse" name="demoResponse"> </wsdl:output>
</wsdl:operation>
</wsdl:portType>

```

端口DemoService定义了一个名为demo2的Request-response操作

### message 元素定义一个操作的数据元素。

每个消息均由一个或多个部件组成。可以把这些部件比作传统编程语言中一个函数调用的参数。

### types  元素定义 web service 使用的数据类型。

为了最大程度的平台中立性，WSDL 使用 XML Schema 语法来定义数据类型。

### Binding

binding 元素为每个端口定义消息格式和协议细节。

binding 元素有两个属性 - name 属性和 type 属性。

name 属性定义 binding 的名称，而 type 属性指向用于 binding 的端口，在这个例子中是 “glossaryTerms” 端口。

soap:binding 元素有两个属性 - style 属性和 transport 属性。

style 属性可取值 “rpc” 或 “document”。在这个例子中我们使用 document。transport 属性定义了要使用的 SOAP 协议。在这个例子中我们使用 HTTP。

operation 元素定义了每个端口提供的操作符。

对于每个操作，相应的 SOAP 行为都需要被定义。同时您必须如何对输入和输出进行编码。在这个例子中我们使用了 “literal”。

> Literal采用XML Schema编码

### service

```
service:相同于webservice容器，也可理解为一个工厂  
name:用于指定客户端的容器类/工厂类,客户端代码从此类开始  
port:用来指定服务器端的一个入口(对应SEI的实现类)  
port binding:引用上面定义的  
port name:容器通过这个方法获得实现类  
address:客户端真正用于请求的地址  
```

```xml
<wsdl:service name="DemoServiceImplService">
<wsdl:port binding="tns:DemoServiceImplServiceSoapBinding" name="DemoServiceImplPort">
<soap:address location="http://localhost:8899/services/demoService"/>
</wsdl:port>
</wsdl:service>
```

2、input:表示调用这个方法需要传入的参数。

2、output:表示调用这个方法返回的结果。

3、types:使用XML模式语言声明在WSDL文档中的其他位置使用的复杂数据类型与元素

4、import:类似于XML模式文档中的import元素，用于从其他WSDL文档中导入WSDL定义

5、portType:和operation元素描述了Web服务的接口并定义了他的方法。portType元素和operation元素类似于java接口和接口中定义的方法声明。operation元素使用一个或者多个message类型来定义他的输入和输出的有效负载；

6、Binding:特定端口类型的具体协议和数据格式规范的绑定。
7、Service:相关服务访问点的集合。
8、Port:定义为协议/数据格式绑定与具体Web访问地址组合的单个服务访问点。

service元素包含一个或者多个port元素，其中每个port元素表示一个不同的Web服务。port元素将URL赋给一个特定的binding，甚至可以使两个或者多个port元素将不同的URL赋值给相同的binding