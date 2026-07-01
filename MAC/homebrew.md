# Homebrew 常用命令

## 目录

- [安装 Homebrew](#安装-homebrew)
- [查看 Homebrew 版本](#查看-homebrew-版本)
- [列出已安装的软件](#列出已安装的软件)
- [查询是否安装指定软件](#查询是否安装指定软件)
- [安装软件包](#安装软件包)
- [卸载软件包](#卸载软件包)
- [更新 Homebrew 及所有软件](#更新-homebrew-及所有软件)
- [查看哪些包已经过时](#查看哪些包已经过时)
- [更新指定包](#更新指定包)
- [锁定包](#锁定包)
- [取消锁定](#取消锁定)
- [查看哪些包可清理](#查看哪些包可清理)
- [清理所有缓存](#清理所有缓存)

---

## 安装 Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 查看 Homebrew 版本

```shell
brew -v
```

## 列出已安装的软件

```shell
brew list
```

## 查询是否安装指定软件

查询是否安装 iTerm2：

```shell
brew list --cask | grep iterm2
```

查询是否安装 Battery Toolkit：

```shell
brew list --cask | grep battery-toolkit
```

## 安装软件包

安装命令行软件：

```shell
brew install 包名
```

安装 GUI 软件：

```shell
brew install --cask battery-toolkit
```

## 卸载软件包

卸载命令行软件：

```shell
brew uninstall node
```

卸载 GUI 软件：

```shell
brew uninstall --cask battery-toolkit
```

## 更新 Homebrew 及所有软件

更新 Homebrew，并升级所有已安装的软件：

```shell
brew update && brew upgrade
```

## 查看哪些包已经过时

查看所有过时的命令行软件：

```shell
brew outdated
```

查看所有过时的 GUI 软件：

```shell
brew outdated --cask
```

查看 iTerm2 是否需要更新：

```shell
brew outdated --cask iterm2
```

## 更新指定包

更新命令行软件：

```shell
brew upgrade node
```

更新 GUI 软件：

```shell
brew upgrade --cask iterm2
```

## 锁定包

锁定软件，防止升级：

```shell
brew pin node
```

## 取消锁定

```shell
brew unpin node
```

## 查看哪些包可清理

预览可以清理的缓存：

```shell
brew cleanup -n
```

## 清理所有缓存

```shell
brew cleanup
```