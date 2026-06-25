# IntelliJ IDEA live Templates

> 原创 于 2023-04-11 21:04:11 发布 · 公开 · 316 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/130093529

### My Log

```xml

<templateSet group="MyLog">
    <template name="psl"
              value="private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger($CLASS_NAME$.class);"
              shortcut="ENTER" description="logback日志对象" toReformat="false" toShortenFQNames="true"
              useStaticImport="true">
        <variable name="CLASS_NAME" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_DECLARATION" value="true"/>
            <option name="JAVA_EXPRESSION" value="true"/>
            <option name="JAVA_STATEMENT" value="true"/>
        </context>
    </template>
    <template name="logp" value="log.$VAR$(&quot;【$METHOD_NAME$】::$PLACE_HOLDERS$&quot;,$ARGUMENTS$);" shortcut="ENTER"
              description="log输出带参日志" toReformat="true" toShortenFQNames="true" useStaticImport="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="PLACE_HOLDERS"
                  expression="groovyScript(&quot;_1.collect { it + ' = [{}]'}.join(', ') &quot;, methodParameters())"
                  defaultValue="" alwaysStopAt="false"/>
        <variable name="METHOD_NAME" expression="methodName()" defaultValue="" alwaysStopAt="false"/>
        <variable name="ARGUMENTS"
                  expression="groovyScript(&quot;_1.collect { it }.join(', ') &quot;, methodParameters())"
                  defaultValue="" alwaysStopAt="false"/>
        <context>
            <option name="JAVA_STATEMENT" value="true"/>
        </context>
    </template>
    <template name="pll"
              value="private static org.apache.logging.log4j.Logger LOG = LogManager.getLogger($CLASS_NAME$.class);"
              shortcut="ENTER" description="log4j日志对象" toReformat="true" toShortenFQNames="true">
        <variable name="CLASS_NAME" expression="className()" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_DECLARATION" value="true"/>
            <option name="JAVA_EXPRESSION" value="true"/>
            <option name="JAVA_STATEMENT" value="true"/>
        </context>
    </template>
    <template name="logs" value="log.$VAR$(&quot;$EXPR_COPY$ ==&gt; 【{}】&quot;,$EXPR$);" shortcut="ENTER"
              description="log输出日志" toReformat="true" toShortenFQNames="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="EXPR" expression="variableOfType(&quot;&quot;)" defaultValue="&quot;expr&quot;"
                  alwaysStopAt="true"/>
        <variable name="EXPR_COPY" expression="escapeString(EXPR)" defaultValue="" alwaysStopAt="false"/>
        <context>
            <option name="JAVA_STATEMENT" value="true"/>
        </context>
    </template>
    <template name="logm" value="log.$VAR$(&quot;【$METHOD_NAME$】::$EXPR_COPY$ ==&gt; 【{}】&quot;,$EXPR$);"
              shortcut="ENTER" description="log输出方法名日志" toReformat="true" toShortenFQNames="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="METHOD_NAME" expression="methodName()" defaultValue="" alwaysStopAt="false"/>
        <variable name="EXPR" expression="variableOfType(&quot;&quot;)" defaultValue="&quot;expr&quot;"
                  alwaysStopAt="true"/>
        <variable name="EXPR_COPY" expression="escapeString(EXPR)" defaultValue="" alwaysStopAt="false"/>
        <context>
            <option name="JAVA_STATEMENT" value="true"/>
        </context>
    </template>
</templateSet>
```

### MybatisCodeHelperPro.xml

```xml

<templateSet group="MybatisCodeHelperPro">
    <template name="cw"
              value="&#9;&#9;&lt;choose&gt;&#10;                &lt;when test=&quot;$var1$&quot;&gt;&#10;                    $var2$&#10;                &lt;/when&gt;&#10;                &lt;otherwise&gt;&#10;                    $var3$&#10;                &lt;/otherwise&gt;&#10;            &lt;/choose&gt;"
              shortcut="ENTER" description="choose when otherwise" toReformat="true" toShortenFQNames="false">
        <variable name="var1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="var2" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="var3" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="MybatisSql" value="true"/>
        </context>
    </template>
    <template name="wa"
              value="&lt;where&gt;&#10;            &lt;if test=&quot;$var1$&quot;&gt;&#10;                $var2$&#10;            &lt;/if&gt;&#10;            &lt;if test=&quot;$var3$&quot;&gt;&#10;                and  $var4$&#10;            &lt;/if&gt;&#10;        &lt;/where&gt;"
              shortcut="ENTER" description="where and" toReformat="true" toShortenFQNames="false">
        <variable name="var1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="var2" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="var3" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="var4" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="MybatisSql" value="true"/>
        </context>
    </template>
    <template name="table" value="&lt;!--@Table $var1$--&gt;$END$" shortcut="ENTER"
              description="set table name for current xml" toReformat="true" toShortenFQNames="false">
        <variable name="var1" expression="tableName" defaultValue="" alwaysStopAt="true"/>
        <context/>
    </template>
    <template name="sup" value=" &lt;!--suppress SqlResolve --&gt;" shortcut="ENTER" description="Ignore sql errors"
              toReformat="true" toShortenFQNames="false">
        <context>
            <option name="XML_TEXT" value="true"/>
        </context>
    </template>
</templateSet>
```

### MyGroup.xml

```xml

<templateSet group="MyGroup">
    <template name="*"
              value="** &#10; * $methodName$&#10;        * &#10; * @author $author$&#10;        * @date $date$ $time$&#10;        $param$&#10;* @return $return$&#10;        */"
              shortcut="TAB" description="方法注释" toReformat="true" toShortenFQNames="true">
        <variable name="methodName" expression="methodName()" defaultValue="" alwaysStopAt="true"/>
        <variable name="author" expression="user()" defaultValue="" alwaysStopAt="true"/>
        <variable name="time" expression="time()" defaultValue="" alwaysStopAt="true"/>
        <variable name="date" expression="date()" defaultValue="" alwaysStopAt="true"/>
        <variable name="param"
                  expression="groovyScript(&quot;def result=''; def params=\&quot;${_1}\&quot;.replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList(); for(i = 0; i &lt; params.size(); i++) {result+=' * @param ' + params[i] + ' '+params[i]  + ((i &lt; params.size() - 1) ? '\\n' : '')}; return result&quot;, methodParameters()) "
                  defaultValue="" alwaysStopAt="true"/>
        <variable name="return" expression="methodReturnType()" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="td" value="// TODO   $date$   $user$   $end$" shortcut="ENTER" description="TODO  Area"
              toReformat="true" toShortenFQNames="true">
        <variable name="date" expression="date()" defaultValue="" alwaysStopAt="true"/>
        <variable name="user" expression="user()" defaultValue="" alwaysStopAt="true"/>
        <variable name="end" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="fix" value="// FIXME  $date$   $user$   $end$" shortcut="ENTER" description="FIXME  area"
              toReformat="true" toShortenFQNames="true">
        <variable name="date" expression="date()" defaultValue="" alwaysStopAt="true"/>
        <variable name="user" expression="user()" defaultValue="" alwaysStopAt="true"/>
        <variable name="end" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="pll"
              value="private static org.apache.logging.log4j.Logger LOG = LogManager.getLogger($CLASS_NAME$.class);"
              shortcut="ENTER" description="log4j日志对象" toReformat="true" toShortenFQNames="true">
        <variable name="CLASS_NAME" expression="className()" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="/*" value="/**&#10; * $END$&#10; */" shortcut="ENTER" description="javadoc注释" toReformat="true"
              toShortenFQNames="true">
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="pres"
              value="public RestResponse&lt;Map&lt;String, Object&gt;&gt; $VAR1$(){&#10;    Map&lt;String, Object&gt; map = new HashMap&lt;&gt;(4);&#10;    map.put(&quot;code&quot;, 200);&#10;    map.put(&quot;msg&quot;, &quot;success&quot;);&#10;    $END$&#10;    return RestResponse.ok(map);&#10;}&#10; "
              shortcut="ENTER" description="public RespMsg方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="aw" value="@Autowired&#10;private $VAR1$ $VAR2$;&#10;$END$" shortcut="ENTER"
              description="新建Autowired" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR2" expression="decapitalize(VAR1)" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="rs" value="@Resource&#10;private $VAR1$ $VAR2$;&#10;$END$" shortcut="ENTER" description="新建Resource"
              toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR2" expression="decapitalize(VAR1)" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="ppm"
              value="@PostMapping(&quot;$VAR1$&quot;)&#10;public $VAR$ $VAR1$(){&#10;    $END$&#10;    return null;&#10;}"
              shortcut="ENTER" description="post方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="pm" value="public $VAR$ $VAR1$(){&#10;    $END$&#10;}&#10;" shortcut="ENTER"
              description="public  非静态方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="gpm"
              value="@GetMapping(&quot;$VAR1$&quot;)&#10;public $VAR$ $VAR1$(){&#10;    $END$&#10;    return null;&#10;}"
              shortcut="ENTER" description="get方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="prm" value="private $VAR$ $VAR1$(){&#10;    $END$&#10;&#10;}" shortcut="ENTER"
              description="private 非静态方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="psm" value="public static $VAR$ $VAR1$(){&#10;    $END$&#10;&#10;}&#10;" shortcut="ENTER"
              description="public  static 方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="tpvm" value="@Test&#10;public void $VAR1$(){&#10;    $END$&#10;}" shortcut="ENTER"
              description="Junit test方法" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="fixm" value="/**&#10; * FIXME  $date$  $user$  $end$&#10; */" shortcut="ENTER"
              description="FIXME method  area" toReformat="true" toShortenFQNames="true">
        <variable name="date" expression="date()" defaultValue="" alwaysStopAt="true"/>
        <variable name="user" expression="user()" defaultValue="" alwaysStopAt="true"/>
        <variable name="end" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
</templateSet>
```

#### MyGroup2.xml

```xml

<templateSet group="MyGroup2">
    <template name="tolist" value="List&lt;$TYPE$&gt; $VAR$ = new ArrayList&lt;&gt;($ITERABLE_TYPE$);&#10;$END$"
              shortcut="ENTER" description="转list" toReformat="true" toShortenFQNames="true">
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="ITERABLE_TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="map.iter"
              value="for (Map.Entry&lt;$ITERABLE_TYPE$&gt; entry : map.entrySet()) {&#10;    System.out.println(&quot;Key = &quot; + entry.getKey() + &quot;, Value = &quot; + entry.getValue());&#10;    $END$&#10;}&#10;"
              shortcut="ENTER" description="遍历map" toReformat="true" toShortenFQNames="true">
        <variable name="ITERABLE_TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="toSet" value="Set&lt;$TYPE$&gt; $VAR$ = new HashSet&lt;&gt;($ITERABLE_TYPE$);&#10; $END$"
              shortcut="ENTER" description="list转set" toReformat="true" toShortenFQNames="true">
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="ITERABLE_TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="nc" value="$Clazz$ $obj$ = new $Clazz$();&#10;$END$" shortcut="ENTER" description="新建对象"
              toReformat="true" toShortenFQNames="true">
        <variable name="Clazz" expression="classNameComplete()" defaultValue="" alwaysStopAt="true"/>
        <variable name="obj" expression="guessElementType(Container)" defaultValue="camelCase(Clazz)"
                  alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="sb" value="StringBuilder $VAR1$ = new StringBuilder();&#10; $END$" shortcut="ENTER"
              description="新建StringBuilder" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="buff" value="StringBuffer $VAR$ = new StringBuffer();&#10;" shortcut="ENTER"
              description="新建StringBuffer" toReformat="true" toShortenFQNames="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="value" value="@Value(&quot;${$VAR1$}&quot;)&#10;private $TYPE$ $VAR2$;&#10;$END$&#10;"
              shortcut="ENTER" description="新建value" toReformat="true" toShortenFQNames="true">
        <variable name="VAR1" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR2" expression="camelCase(VAR1)" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="st" value="String $VAR$=$END$;" shortcut="ENTER" description="new String" toReformat="true"
              toShortenFQNames="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="nl" value="List&lt;$TYPE$&gt; $VAR$ = new ArrayList&lt;&gt;();&#10;$END$" shortcut="ENTER"
              description="新建list" toReformat="true" toShortenFQNames="true">
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="ns" value="Set&lt;$TYPE$&gt; $VAR$ = new HashSet&lt;&gt;();&#10;$END$" shortcut="ENTER"
              description="新建set" toReformat="true" toShortenFQNames="true">
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="nm" value="Map&lt;$TYPE$&gt; $VAR$ = new HashMap&lt;&gt;(4);&#10;$END$" shortcut="ENTER"
              description="新建map" toReformat="true" toShortenFQNames="true">
        <variable name="TYPE" expression="" defaultValue="" alwaysStopAt="true"/>
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
    <template name="forii" value="for(int i=0,len=$VAR$;i&lt;len;i++){&#10;    $END$&#10;}&#10;" shortcut="ENTER"
              description="Create  new iteration Loop" toReformat="true" toShortenFQNames="true">
        <variable name="VAR" expression="" defaultValue="" alwaysStopAt="true"/>
        <context>
            <option name="JAVA_CODE" value="true"/>
        </context>
    </template>
</templateSet>
```