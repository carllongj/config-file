{ config, pkgs, lib, ... }:

{
  services = {
    # 是否使用X11的桌面,若只使用wayland则可以不启用.
    xserver.enable = lib.mkDefault false;
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
    desktopManager.plasma6.enable = lib.mkDefault true;
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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    # 截图工具
    grim
    # wayland 使用的剪切工具.
    wl-clipboard
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
  };

  # 启用 XDG Desktop Portal 用以 Wayland 录屏
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
