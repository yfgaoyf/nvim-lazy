# nvim-lazy

​	懒人福音，开箱即用阅读代码工具包，neovim使用官网版本`NVIM v0.11.0`，配合lazyvim插件集合完成代码阅读工具的集成。

## 系统要求

1. ubuntu 20+（主要依赖GLIBC v28+）
2. x86-64系统

## 目录结构介绍

- dot-config-nvim，nvim的config目录，在本机上的形式`~/.config/nvim`
- dot-local-share-nvim，nvim插件目录，在本机上的形式`~/.local/share/nvim`
- bin-nvim-linux64，64位nvim的可执行程序，需要配置到本机的PATH环境变量中
- tools，辅助工具目录，包含bear工具用于生成compile_commands.json

## 使用介绍

- 克隆本仓库到本地
- 执行`./nvim_install.sh`进行本地化安装
- `cd`到目标项目代码的根目录，执行`nvim .`即可打开项目代码进行阅读与修改

## 快捷键介绍

## 参考

[neovim](https://neovim.io/)

[lazyvim](https://www.lazyvim.org/)
