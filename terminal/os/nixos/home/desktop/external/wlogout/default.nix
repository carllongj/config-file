{ inputs, pkgs, ... } :

{
  # 启用 wlogout 配置
  programs.wlogout = {
    enable = true;
  };

  # wlogout 配置
  xdg.configFile."wlogout".source = ./wlogout-config;
}
