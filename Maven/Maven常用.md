# Maven 常用命令

## 1. 检查当前 Maven 环境启用的文件

```shell
mvn help:effective-settings
```

## 2. 查看当前项目的 POM 配置（包括所有依赖）

```shell
mvn help:effective-pom
```

## 3. 查看当前处于激活状态的 Profile

```shell
mvn help:active-profiles
```

## 4. 打包并跳过测试

```shell
mvn clean package -Dmaven.test.skip=true
```

## 5. 将 JAR 包安装到本地仓库

```shell
mvn install:install-file -Dfile=E:/ojdbc6.jar -DgroupId=com.oracle -DartifactId=ojdbc6 -Dversion=11.2.0.4.0 -Dpackaging=jar -DgeneratePom=true
```

## 6. 清空本地仓库

```shell
mvn dependency:purge-local-repository
```
