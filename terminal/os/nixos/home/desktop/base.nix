{
  config,
  pkgs,
  lib,
  ...
}:

{
   # 统一配置界面指针光标
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    # 自动在 GTK 以及 X11 中应用光标,
    gtk.enable = true;
    x11.enable = true;
  };

  # 用户级别使用软件安装
  home.packages = with pkgs; [
    # 音乐播放器.
    amberol

    # mesa 相关的测试库,如 glxinfo,glxgears 命令
    mesa-demos

    # 视频播放
    mpv

    # vulkan 相关的测试库,如 vulkaninfo,vkcube 命令.
    vulkan-tools

    # 安装 google-chrome 浏览器.
    google-chrome

    # 安装 chromium 浏览器.
    chromium

    # 代码对比软件
    meld

    # 游戏内帧率,温度,占用显示.
    mangohud

    # 目录管理器
    nautilus
  ];
}
