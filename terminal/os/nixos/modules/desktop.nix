{ config, pkgs, lib, ... }:

{
  services = {
    xserver.enable = false;
    # greetd = {
    #   enable = true;
    #   settings.default_session = {
    #     command = "niri-session";
    #     user = "carl";
    #   };
    # };

    # 使用 gnome 桌面后端环境
    # desktopManager.gnome.enable = true;


    # 使用 plasma6 桌面后端环境.
    desktopManager.plasma6.enable = true;
    # nix 中的 dm 不是具体实现,而是 display-manager.service.
    # 例如在 Arch 中使用 sddm,它重启服务就使用 systemctl restart sddm.
    # NixOS 则统一使用 systemctl restart display-manager.service,而不使用
    # 具体的服务实现.
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      # gdm = {
      #   enable = true;
      #   wayland = true;
      # };
    };
  };

  # 启用系统级别 hyprland 应用
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 引入 niri
  programs.niri = {
    enable = true;
  };

  # 启用锁屏界面应用
  programs.hyprlock.enable = true;
  # 启动自动锁屏服务.
  services.hypridle.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # 启用 steam
  programs.steam = {
    enable = true;
    # 启用本地网络游戏以及流式传输的防火墙端口.
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    gamescopeSession.enable = true;
  };

  # 启用 gamemode 应用,优化游戏性能.
  # 使用方式为通过 gamemoderun 来运行游戏.
  # 通过 gamemoded -s 检查是否加载了gamemode
  programs.gamemode = {

    enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    # pipewire 的声音控制组件安装包.
    pwvucontrol

    # 通用播放器使用的控制命令
    playerctl

    # 截图工具
    grim
    # 截图选区工具
    slurp
    # 对 grim slurp 封装简化截图到剪切板操作.
    grimblast
    # 剪切板历史桌面管理器.
    cliphist
    # wayland 使用的剪切工具.
    wl-clipboard

    # 图片编辑器
    pinta

    # hyprland 取色器工具
    hyprpicker

    # hyprland 使用的壁纸引擎
    waypaper
    swww

    matugen
    imagemagick

    # 消息通知命令
    swaynotificationcenter
    libnotify

    # 任务中心应用
    mission-center
  ];

  # 设置中文输入法.
  # 在 hyprland 下进行切换输入法(没有托盘时),需要通过
  # fictx5-configtool 来进行界面切换输入.
  i18n.inputMethod = {
    # 启用输入法,该选项会自动设置大部分环境变量.
    enable = true;
    # 设置输入法类型.
    type = "fcitx5";
    # 安装输入法软件.
    fcitx5 = {
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons # 包含拼音等基础中文输入.
        fcitx5-gtk # GTK 程序的兼容性支持
        fcitx5-lua # Lua 脚本支持.
      ];

      # 使用wayland前端输入法,禁止设置 GTK_IM_MODULE 变量.
      waylandFrontend = true;
    };
  };

  # 设置输入法的环境变量以兼容 X11 应用
  environment.variables = {
    # GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";

    # 部分 GFLW 的应用需要使用该变量.
    # GLFW_IM_MODULE = "ibus";
  };

  # 启用 XDG Desktop Portal 用以 Wayland 录屏
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # 启用 sunshine
  services.sunshine = {
    enable = true;
    # 允许自启动
    autoStart = true;
    # 允许控制输入
    capSysAdmin = true;
    # 允许自动打开需要的端口
    openFirewall = true;
  };

  # 启用 flatpak 应用
  services.flatpak = {
    enable = true;

    # 默认安装的应用
    packages = [
      # 默认的权限管理工具
      "com.github.tchx84.Flatseal"

      # wechat 应用.
      "com.tencent.WeChat"

      # 任务中心,NixOS 下 flatpak 版本无法获取到,使
      # 用NixOS官方官本.
      # "io.missioncenter.MissionCenter"

      # 远程桌面客户端
      "org.remmina.Remmina"
    ];

    # 重写flatpak 的权限属性
    overrides = {
      "io.missioncenter.MissionCenter" = {
        context = {
          # 允许访问硬件设备
          devices = [ "all" ];

          sockets = [ "wayland" "fallback-x11" "system-bus" "session-bus" ];
        };
      };
    };

    # 设置 flathub 仓库.
    remotes = lib.mkOptionDefault [
      {
        name = "flathub";
        location = "https://mirror.sjtu.edu.cn/flathub/repo/flathub.flatpakrepo";
      }
    ];

    # 应用自动更新
    update.auto.enable = true;

    # 默认情况下该组件只会负责管理声明的软件包和存储库,不会删除
    # 通过命令行安装的应用,开启以下选项将严格按照生命式的管理
    # 应用,通过命令行安装的应用在重建后会被删除.
    # uninstallUnmanaged = false;
  };
}
