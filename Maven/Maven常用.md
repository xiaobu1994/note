```text
1. 检查当前Maven环境启用的文件

mvn help:effective-settings

2. 查看当前项目的pom配置，包括所有依赖

mvn help:effective-pom

3. 查看当前处于激活状态的profile

mvn help:active-profiles

4. 打包跳过test

mvn clean package -Dmaven.test.skip=true

5. 本地打jar

mvn install:install-file -Dfile=E:/ojdbc6.jar -DgroupId=com.oracle -DartifactId=ojdbc6 -Dversion=11.2.0.4.0 -Dpackaging=jar -DgeneratePom=true

6. 清空本地仓库
mvn dependency:purge-local-repository

```