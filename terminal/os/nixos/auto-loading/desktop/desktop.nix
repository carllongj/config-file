{ config, pkgs, lib, ... }:

{
  imports = [
    # 引入基础的桌面配置.
    ../../modules/base/desktop.nix
  ];

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

  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    # pipewire 的声音控制可视化组件包.
    pwvucontrol

    # 通用播放器使用的控制命令
    playerctl

    # 截图选区工具
    slurp
    # 对 grim slurp 封装简化截图到剪切板操作.
    grimblast
    # 剪切板历史桌面管理器.
    cliphist

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

  # 启用 XDG Desktop Portal 用以 Wayland 录屏
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];

    # 配置门户
    # config = {
    #  common.default = [ "gtk" ];
    #  hyprland.default = [ "hyprland" "gtk" ];
    # };
  };
}
