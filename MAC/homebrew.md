## Homebrew常用命令

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 查看 Homebrew 版本
 ```shell
 brew -v
 ```

#### 列出已安装的软件
```shell
 brew list
```

#### 查询是否安装了iterm2
```shell
brew list --cask | grep iterm2
brew list --cask | grep battery-toolkit
```

 
#### 2.3. 安装软件包
```shell
 brew install 包名
 brew install --cask | grep battery-toolkit
 ```

#### 2.4. 卸载软件包
```shell
brew uninstall 包名
brew uninstall --cask battery-toolkit
```
 
#### 2.5. Homebrew自身更新以及更新Homebrew 安装的所有软件包，并将它们升级到最新版本
```shell
brew update && brew upgrade
```

#### 查看哪些包已经过时

```shell
brew outdated
```    

#### 查看iterm2是否过时

```shell
brew outdated --cask iterm2
``` 


#### 更新指定包

```shell
 brew upgrade node
 brew upgrade --cask iterm2
```

#### 锁定或取消锁定
```shell
brew pin $FORMULA      # 锁定某个包
brew unpin $FORMULA    # 取消锁定
```

####  查看哪些包可清理
```shell
 brew cleanup -n
 ```

#### 清理所有
```shell
brew cleanup
```