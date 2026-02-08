{ config, pkgs, ... }:

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
    displayManager = {
      sddm = {
        enable = true;
      };
      # gdm = {
      #   enable = true;
      #   wayland = true;
      # };
    };
  };

  environment.systemPackages = with pkgs; [
    # mesa 相关的测试库,如 glxinfo,glxgears 命令
    mesa-demos

    # vulkan 相关的测试库,如 vulkaninfo,vkcube 命令.
    vulkan-tools

    # 安装 google-chrome 浏览器.
    google-chrome
    # 安装 chromium 浏览器.
    chromium

    # 安装 vscode 编辑器.
    vscode-with-extensions
  ];
}
