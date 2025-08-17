## Linux 下使用 steam

### Linux 越过steam使用proton

* 在 Linux 中使用 `Proton` 直接运行 `Windows` 应用时,可以直接通过命令进行运行.
  但是需要设置一些环境变量,然后才能运行 `Proton`.
  ```bash
    # 设置前缀目录,这个目录是设置 compatdata 的目录,可以是任意的目录
    export STEAM_COMPAT_DATA_PATH="<compatdata>"

    # 设置windows前缀目录,该目录通常在 compatdata目录下
    export WINEPREFIX="$STEAM_COMPAT_DATA_PATH/pfx"

    # 设置 steam 的客户端安装路径,若要越过steam则不需要配置该选项.
    export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"

    # 设置 proton 的工具链的路径.
    export STEAM_COMPAT_TOOL_PATHS="$HOME/.steam/steam/steamapps/common/Proton 9.0"

    # 运行 Proton (替换为需要使用的 Proton 版本路径)
    ~/.steam/steam/steamapps/common/Proton\ 9.0/proton run <exe>
  ```

### Linux 命令行参数
* 指定启动的客户端语言
  ```
      steam -language schinese
  ```
* `steam` 搭配 `mangohud` 显示游玩游戏
  ```
    mangohud steam -language schinese
  ```

### 性能监控

#### MangoHud
* `MangoHud` 是一个用以 `OpenGL`, `Vulkan` 的覆盖层,安装与使用如下.
  ```bash
    # Ubuntu 下安装
    sudo apt install mangohud

    # Arch 下安装,使用 AUR,mangojuice 是用以图形化
    # 配置mangohud 显示的程序
    paru -S mangohud mangojuice

    # 使用时使用mangohud 来启动即可
    mangohud glxgears
  ```
* `steam` 搭配 `MangoHud` 进行启用游戏,针对单个游戏设置可以通过 `steam` 启动选项来设置.
  ```
    mangohud %command%
  ```
  * `%command%` 是 `steam` 传递给该选项用以启动的命令,该选项还可以实现其它功能如加载`Mod`.
* 配置文件加载,`MangoHud` 按照以下配置加载顺序.
  ```bash
    # 应用程序下带有的一个配置文件.
    /path/app/MangoHud.conf

    # 用户配置目录下存在的一个匹配进程文件名称的配置文件
    # 这个程序不一定是可执行文件名称,而是进程的名称.
    # 所以配置文件必须要匹配正确的进程名.
    $XDG_CONFIG_DIR/MangoHud/${app}.conf

    # 个人全局配置
    $XDG_CONFIG_DIR/MangoHud/MangoHud.conf
  ```
#### lsfg-vk
* `lsfg-vk` 是用以通过`Windows`原生的`无损帧生成`软件来实现`Linux`环境下
  的补帧工具,在 `github`选择对应的二进制包安装即可.
  ```bash
   # 链接地址: https://github.com/PancakeTAS/lsfg-vk

   # ArchLinux 下安装使用,并且会带有 lsfg-vk-ui 的图形
   # 配置,这个图形本质上还是操作的 配置文件.
   paru -S lsfg-vk

   # 配置文件路径地址.
   # ~/.config/lsfg-vk/config.toml
  ```
* `lsfg` 依赖 `windows` 原版的`无损帧生成`的文件,即 `Lossless.dll`,需要复制
  该文件到 `Linux`系统中,通过环境变量或者`lsfg-vk-ui`来设置 `dll` 文件路径.

* 启动帧生成,`lsfg-vk` 本质上是通过配置文件来创建 `profile`,然后在应用中
  使用对应的配置来启动帧生成.
  ```bash
    # 通过设置使用某一个预定义的 profile 来运行程序.
    LSFG_PROCESS="<profile>" cmd
  ```
