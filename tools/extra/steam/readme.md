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
### 存档文件
* `Linux` 下借助 `Proton` 运行的 `Windows` 游戏会有一个 `compat`目录,这个本质上是提供
  模拟 `Windows` 的目录,首先需要找到 `gameId`,这个 `Id`会作为参数在`steam`启动的命令行
  参数中,通过以下命令查看.
  ```bash
    # 查找关键字的第一个进程通常是启动的根进程.
    # 它的参数会带有 AppId 作为参数,<key> 是游戏进程关键字
    pgrep -fa <key> |grep AppId
  ```
* 通过 `AppId` 来找到对应的 `compat` 目录,它内部就包含了 `Windows` 的 `C盘`驱动器.对于
  一般的游戏存档都是默认存储到`C盘`的用户目录下.
  ```bash
    # 这个是游戏的专属目录,它是 proton对于游戏运行的 compat目录
    cd ~/.local/share/Steam/steamapps/compatdata/<AppId>

    # 以下目录通常是存档目录,它一定是在上面的 compat 目录中.
    # 以下路径是相较于 `compatdata` 目录.
    # proton中,模拟的windows 用户固定为 `steamuser`
    cd pfx/drive_c/users/steamusers/
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
    # 可以通过 pgrep -fa <keyword> 来检索进程的信息.
    $XDG_CONFIG_DIR/MangoHud/${app}.conf

    # 个人全局配置
    $XDG_CONFIG_DIR/MangoHud/MangoHud.conf
  ```

##### 原理说明
* `MangoHud` 是基于 `Vulkan` 的用以监控`FPS`,温度,`CPU/GPU负载`等信息的覆盖层.
* 它的可执行文件是一个脚本,用以设置环境变量并且加载应用程序.它本身并不是一个
  可执行文件,而是一个脚本(`/usr/bin/mangohud`).通过`Vulkan`提供的调用链插入覆盖层的逻辑.
  ```bash
    # 核心逻辑,设置环境变量,并且执行传入的参数
    exec env MANGOHUD=1 "$@"

    # 启用 preload 的执行命令,通常是加载OpenGL库的.
    exec env MANGOHUD=1 LD_PRELOAD="${LD_PRELOAD}" "$@"
  ```
* `mangohud` 的处理逻辑如下,是否禁用由`/usr/bin/mangohud`中的`DISABLE_LD_PRELOAD`来
  指定.
  1. 对于没有禁用 `LD_PRELOAD`的程序(通常只有`反作弊`的程序会检测该环境
  变量),优先通过`LD_PRELOAD`来加载.这样可以兼容`OpenGL`的程序.
  2. 对于有`反作弊`监控的游戏,即环境变量中设置了该游戏禁用`LD_PRELOAD`,那么就使用
  `Vulkan`自带的机制来实现覆盖层.此时`OpenGL`的库将不会有覆盖层.

* 使用建议
  1. 如果应用具有反作弊系统,最好不要使用`LD_PRELOAD`的方式,可能导致检测到作弊.
    ```bash
      # 通过此种方式来运行游戏
      # 前提是游戏使用的是 vulkan
      MANGOHUD=1 %command%
    ```
  2. 如果应用使用`Vulkan`,就最好使用非`LD_PRELOAD`模式,参看上面启动
  3. 如果确定应用使用的 `OpenGL`,那么就必须要使用 `LD_PRELOAD`的加载方式来`hook`调用,否则无法显示`hud`.
    ```bash
      # 通过命令启动,通常情况下会使用LD_PRELOAD的方式
      mangohud %command%
    ```

#### lsfg-vk
* `lsfg-vk` 是用以通过`Windows`原生的`无损帧生成`软件来实现`Linux`环境下
  的补帧工具,在 `github`选择对应的二进制包安装即可.
  ```bash
   # 链接地址: https://github.com/PancakeTAS/lsfg-vk

   # ArchLinux 下安装使用,并且会带有 lsfg-vk-ui 的图形
   # 配置,这个图形本质上还是操作的 配置文件.
   paru -S lsfg-vk

   # 配置文件路径地址,该目录下的所有*.toml文件
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

#### OBS
* `Linux` 下使用 `obs` 的视频编解码器默认行为会使用桌面显示的GPU进行编解码.通过以下设置来
  使用其它显卡(`核显`)来进行编解码.
  * 切换到高级模式进行选择编解码器
    ```bash
      设置 -> 输出 -> 输出模式 -> 选择高级
    ```
  * 选择 `FFmpeg VAAPI` 开头的编解码器.
    ```bash
      FFmpeg VAAPI H.264
    ```
  * 选择 `VAAPI` 设备,选择对应要使用的显卡即可.
  * 在使用之前,要确保`vaapi`等库的驱动安装完成.

#### 壁纸引擎

* `Wallpaper Engine` 不支持 `Linux`,`Linux` 可以使用如下方案来使用`wallpaper engine`的动态
   壁纸.仅在 `KDE Plasma` 环境下.
  1. 安装 `壁纸插件`,通过 `AUR` 安装.
  ```bash
    paru -S plasma6-wallpapers-wallpaper-engine-git
  ```
  2. 按照如下操作,设置桌面壁纸插件.
  ```bash
    # 操作
    桌面点击鼠标右键 -> 桌面与壁纸 -> 壁纸类型

    # 选择以下的插件.
    Wallpaper Engine for KDE
  ```
    * 若没有该插件,则执行以下命令重启`KDE plasma`
    ```bash
      systemctl --user restart plasma-plasmashell
    ```
  * 可能出现找不到壁纸,`Library` 则需要选择以下的壁纸路径,才能正确获取到订阅的壁纸.
    ```bash
      ~/.local/share/Steam
    ```
