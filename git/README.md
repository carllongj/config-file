### delta
* `delta` 是用于提供直接的对比命令,它本身可以单独使用用以对比文件,也可以集成到 `git diff` 中用以比较.
* `发行版安装`
  ```bash
  # ubuntu 安装
  sudo apt install git-delta

  # Arch 安装
  sudo pacman -S git-delta
  ```
* 普通使用,需要先配置 delta,将其配置文件拷贝到配置目录
 ```
   delta a.json b.json

   delta src/ dest/
 ```

#### 配置 delta
* 将 `delta` 目录拷贝到 `~/.config/`目录下,`delta` 默认从 `XDG_CONFIG_DIR` 环境变量读取配置文件,这些配置
  用于 `delta` 命令.
* 集成到 `git` 命令中,需要配置 `~/.gitconfig` 文件,将以下配置添加到该配置文件中.
  ```ini
    [core]
      autocrlf = input
      editor = nvim
      pager = delta

    [interactive]
      diffFilter = delta --color-only --features=interactive

    [include]
      path = /home/carl/.config/delta/themes.gitconfig

    [delta]
      features = gruvbox-dark
      line-numbers = true
      side-by-side = true

    [delta "interactive"]
      keep-plus-minus-markers = false
  ```
