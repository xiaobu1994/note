# Windows下Zookeeper安装

> 原创 于 2019-05-08 16:19:42 发布 · 公开 · 1.7k 阅读 · 0 · 0 · 本内容遵循CC 4.0 BY-SA版权协议 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。 · 编辑
> 文章链接：https://blog.csdn.net/tanhongwei1994/article/details/89959218

进入 [官网](http://zookeeper.apache.org/) ，我下载的是zookeeper-3.4.14版本的
解压到D盘，进入D:\zookeeper-3.4.14\conf,将zoo_sample.cfg改成zoo.cfg。zoo.cfg相关参数说明:

```
# zk里使用的基本时间单位
#tickTime=2000
# leader和follower之间最长的心跳时间，心跳时间为initLimit*tickTime,
#如果为10，则这里的心跳时间为10 * 2000=20000ms=20s
#initLimit=10
# leader和follower之间发送消息，请求和应答的最大时间长度，时间长度为syncLimit*tickTime,
#如果为5,则这里的时间长度为5*2000=10000ms=10s
#syncLimit=5
# zk数据目录
#dataDir=/zookeeper_data
#　端口
#clientPort=2181
# 客户端连接上限，可增加
#maxClientCnxns=60
```

进入D:\zookeeper-3.4.14\bin，双击zkServer.cmd

```
D:\zookeeper-3.4.14\bin>call "C:\Program Files\Java\jdk1.8.0_171"\bin\java "-Dzo
okeeper.log.dir=D:\zookeeper-3.4.14\bin\.." "-Dzookeeper.root.logger=INFO,CONSOL
E" -cp "D:\zookeeper-3.4.14\bin\..\build\classes;D:\zookeeper-3.4.14\bin\..\buil
d\lib\*;D:\zookeeper-3.4.14\bin\..\*;D:\zookeeper-3.4.14\bin\..\lib\*;D:\zookeep
er-3.4.14\bin\..\conf" org.apache.zookeeper.server.quorum.QuorumPeerMain "D:\zoo
keeper-3.4.14\bin\..\conf\zoo.cfg"
2019-05-08 16:03:20,855 [myid:] - INFO  [main:QuorumPeerConfig@136] - Reading co
nfiguration from: D:\zookeeper-3.4.14\bin\..\conf\zoo.cfg
2019-05-08 16:03:20,878 [myid:] - INFO  [main:DatadirCleanupManager@78] - autopu
rge.snapRetainCount set to 3
2019-05-08 16:03:20,878 [myid:] - INFO  [main:DatadirCleanupManager@79] - autopu
rge.purgeInterval set to 0
2019-05-08 16:03:20,879 [myid:] - INFO  [main:DatadirCleanupManager@101] - Purge
 task is not scheduled.
2019-05-08 16:03:20,881 [myid:] - WARN  [main:QuorumPeerMain@116] - Either no co
nfig or no quorum defined in config, running  in standalone mode
2019-05-08 16:03:20,944 [myid:] - INFO  [main:QuorumPeerConfig@136] - Reading co
nfiguration from: D:\zookeeper-3.4.14\bin\..\conf\zoo.cfg
2019-05-08 16:03:20,945 [myid:] - INFO  [main:ZooKeeperServerMain@98] - Starting
 server
2019-05-08 16:03:21,019 [myid:] - INFO  [main:Environment@100] - Server environm
ent:zookeeper.version=3.4.14-4c25d480e66aadd371de8bd2fd8da255ac140bcf, built on
03/06/2019 16:18 GMT
2019-05-08 16:03:21,019 [myid:] - INFO  [main:Environment@100] - Server environm
ent:host.name=A-A01-7387.hanslaser.com
2019-05-08 16:03:21,020 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.version=1.8.0_171
2019-05-08 16:03:21,021 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.vendor=Oracle Corporation
2019-05-08 16:03:21,022 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.home=C:\Program Files\Java\jdk1.8.0_171\jre
2019-05-08 16:03:21,022 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.class.path=D:\zookeeper-3.4.14\bin\..\build\classes;D:\zookeeper-3.4.14
\bin\..\build\lib\*;D:\zookeeper-3.4.14\bin\..\zookeeper-3.4.14.jar;D:\zookeeper
-3.4.14\bin\..\lib\audience-annotations-0.5.0.jar;D:\zookeeper-3.4.14\bin\..\lib
\jline-0.9.94.jar;D:\zookeeper-3.4.14\bin\..\lib\log4j-1.2.17.jar;D:\zookeeper-3
.4.14\bin\..\lib\netty-3.10.6.Final.jar;D:\zookeeper-3.4.14\bin\..\lib\slf4j-api
-1.7.25.jar;D:\zookeeper-3.4.14\bin\..\lib\slf4j-log4j12-1.7.25.jar;D:\zookeeper
-3.4.14\bin\..\conf
2019-05-08 16:03:21,024 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.library.path=C:\Program Files\Java\jdk1.8.0_171\bin;C:\Windows\Sun\Java
\bin;C:\Windows\system32;C:\Windows;C:\ProgramData\Boxstarter;C:\Program Files (
x86)\Common Files\Oracle\Java\javapath;D:\app\tanhw119214\product\11.2.0\dbhome_
1\bin;C:\Program Files (x86)\Common Files\NetSarang;C:\Windows\system32;C:\Windo
ws;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Progr
am Files\Java\jdk1.8.0_171\bin;D:\apache-tomcat-8.5.30\bin;D:\JetBrains\apache-c
xf-3.0.2/bin;D:\apache-maven-3.3.3\bin;D:\mysql-5.6.26-winx64\bin;C:\Program Fil
es\Microsoft SQL Server\120\DTS\Binn\;C:\Program Files\Microsoft SQL Server\Clie
nt SDK\ODBC\110\Tools\Binn\;C:\Program Files (x86)\Microsoft SQL Server\120\Tool
s\Binn\;C:\Program Files\Microsoft SQL Server\120\Tools\Binn\;C:\Program Files (
x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\;C:\Program Files (x86
)\Microsoft SQL Server\120\DTS\Binn\;D:\phpWeb\Apache24\bin;D:\phpWeb\php5.6;D:\
Tool\Git\cmd;C:\ProgramData\chocolatey\bin;D:\software\erl10.1\bin;C:\Go\bin;C:\
Users\tanhw119214\AppData\Local\Programs\Python\Python37\Scripts\;C:\Users\tanhw
119214\AppData\Local\Programs\Python\Python37\;D:\工具\Fiddler;C:\Users\tanhw119
214\go\bin;.
2019-05-08 16:03:21,032 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.io.tmpdir=C:\Users\TANHW1~1\AppData\Local\Temp\
2019-05-08 16:03:21,033 [myid:] - INFO  [main:Environment@100] - Server environm
ent:java.compiler=<NA>
2019-05-08 16:03:21,034 [myid:] - INFO  [main:Environment@100] - Server environm
ent:os.name=Windows 7
2019-05-08 16:03:21,066 [myid:] - INFO  [main:Environment@100] - Server environm
ent:os.arch=amd64
2019-05-08 16:03:21,066 [myid:] - INFO  [main:Environment@100] - Server environm
ent:os.version=6.1
2019-05-08 16:03:21,067 [myid:] - INFO  [main:Environment@100] - Server environm
ent:user.name=tanhw119214
2019-05-08 16:03:21,074 [myid:] - INFO  [main:Environment@100] - Server environm
ent:user.home=C:\Users\tanhw119214
2019-05-08 16:03:21,074 [myid:] - INFO  [main:Environment@100] - Server environm
ent:user.dir=D:\zookeeper-3.4.14\bin
2019-05-08 16:03:21,101 [myid:] - INFO  [main:ZooKeeperServer@836] - tickTime se
t to 2000
2019-05-08 16:03:21,101 [myid:] - INFO  [main:ZooKeeperServer@845] - minSessionT
imeout set to -1
2019-05-08 16:03:21,102 [myid:] - INFO  [main:ZooKeeperServer@854] - maxSessionT
imeout set to -1
2019-05-08 16:03:21,237 [myid:] - INFO  [main:ServerCnxnFactory@117] - Using org
.apache.zookeeper.server.NIOServerCnxnFactory as server connection factory
2019-05-08 16:03:21,239 [myid:] - INFO  [main:NIOServerCnxnFactory@89] - binding
 to port 0.0.0.0/0.0.0.0:2181
```

开一个command,进入zookeeper-3.4.14的bin目录，然后执行以下命令

```cmd
zkCli.cmd -server localhost:2181
```

```
Connecting to localhost:2181
2019-05-08 16:06:25,139 [myid:] - INFO  [main:Environment@100] - Client environm
ent:zookeeper.version=3.4.14-4c25d480e66aadd371de8bd2fd8da255ac140bcf, built on
03/06/2019 16:18 GMT
2019-05-08 16:06:25,142 [myid:] - INFO  [main:Environment@100] - Client environm
ent:host.name=A-A01-7387.hanslaser.com
2019-05-08 16:06:25,142 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.version=1.8.0_171
2019-05-08 16:06:25,144 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.vendor=Oracle Corporation
2019-05-08 16:06:25,144 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.home=C:\Program Files\Java\jdk1.8.0_171\jre
2019-05-08 16:06:25,144 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.class.path=D:\zookeeper-3.4.14\bin\..\build\classes;D:\zookeeper-3.4.14
\bin\..\build\lib\*;D:\zookeeper-3.4.14\bin\..\zookeeper-3.4.14.jar;D:\zookeeper
-3.4.14\bin\..\lib\audience-annotations-0.5.0.jar;D:\zookeeper-3.4.14\bin\..\lib
\jline-0.9.94.jar;D:\zookeeper-3.4.14\bin\..\lib\log4j-1.2.17.jar;D:\zookeeper-3
.4.14\bin\..\lib\netty-3.10.6.Final.jar;D:\zookeeper-3.4.14\bin\..\lib\slf4j-api
-1.7.25.jar;D:\zookeeper-3.4.14\bin\..\lib\slf4j-log4j12-1.7.25.jar;D:\zookeeper
-3.4.14\bin\..\conf
2019-05-08 16:06:25,145 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.library.path=C:\Program Files\Java\jdk1.8.0_171\bin;C:\Windows\Sun\Java
\bin;C:\Windows\system32;C:\Windows;C:\ProgramData\Boxstarter;C:\Program Files (
x86)\Common Files\Oracle\Java\javapath;D:\app\tanhw119214\product\11.2.0\dbhome_
1\bin;C:\Program Files (x86)\Common Files\NetSarang;C:\Windows\system32;C:\Windo
ws;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Progr
am Files\Java\jdk1.8.0_171\bin;D:\apache-tomcat-8.5.30\bin;D:\JetBrains\apache-c
xf-3.0.2/bin;D:\apache-maven-3.3.3\bin;D:\mysql-5.6.26-winx64\bin;C:\Program Fil
es\Microsoft SQL Server\120\DTS\Binn\;C:\Program Files\Microsoft SQL Server\Clie
nt SDK\ODBC\110\Tools\Binn\;C:\Program Files (x86)\Microsoft SQL Server\120\Tool
s\Binn\;C:\Program Files\Microsoft SQL Server\120\Tools\Binn\;C:\Program Files (
x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\;C:\Program Files (x86
)\Microsoft SQL Server\120\DTS\Binn\;D:\phpWeb\Apache24\bin;D:\phpWeb\php5.6;D:\
Tool\Git\cmd;C:\ProgramData\chocolatey\bin;D:\software\erl10.1\bin;C:\Go\bin;C:\
Users\tanhw119214\AppData\Local\Programs\Python\Python37\Scripts\;C:\Users\tanhw
119214\AppData\Local\Programs\Python\Python37\;D:\工具\Fiddler;C:\Users\tanhw119
214\go\bin;.
2019-05-08 16:06:25,146 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.io.tmpdir=C:\Users\TANHW1~1\AppData\Local\Temp\
2019-05-08 16:06:25,147 [myid:] - INFO  [main:Environment@100] - Client environm
ent:java.compiler=<NA>
2019-05-08 16:06:25,152 [myid:] - INFO  [main:Environment@100] - Client environm
ent:os.name=Windows 7
2019-05-08 16:06:25,153 [myid:] - INFO  [main:Environment@100] - Client environm
ent:os.arch=amd64
2019-05-08 16:06:25,153 [myid:] - INFO  [main:Environment@100] - Client environm
ent:os.version=6.1
2019-05-08 16:06:25,181 [myid:] - INFO  [main:Environment@100] - Client environm
ent:user.name=tanhw119214
2019-05-08 16:06:25,181 [myid:] - INFO  [main:Environment@100] - Client environm
ent:user.home=C:\Users\tanhw119214
2019-05-08 16:06:25,181 [myid:] - INFO  [main:Environment@100] - Client environm
ent:user.dir=D:\zookeeper-3.4.14\bin
2019-05-08 16:06:25,192 [myid:] - INFO  [main:ZooKeeper@442] - Initiating client
 connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apach
e.zookeeper.ZooKeeperMain$MyWatcher@531d72ca
Welcome to ZooKeeper!
2019-05-08 16:06:25,386 [myid:] - INFO  [main-SendThread(localhost:2181):ClientC
nxn$SendThread@1025] - Opening socket connection to server localhost/127.0.0.1:2
181. Will not attempt to authenticate using SASL (unknown error)
2019-05-08 16:06:25,389 [myid:] - INFO  [main-SendThread(localhost:2181):ClientC
nxn$SendThread@879] - Socket connection established to localhost/127.0.0.1:2181,
 initiating session
JLine support is enabled
2019-05-08 16:06:25,415 [myid:] - INFO  [main-SendThread(localhost:2181):ClientC
nxn$SendThread@1299] - Session establishment complete on server localhost/127.0.
0.1:2181, sessionid = 0x100019848b80000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
```

客户端已成功连接server！