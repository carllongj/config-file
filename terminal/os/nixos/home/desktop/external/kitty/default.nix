{ pkgs, ... } :

{
  # 配置 zsh
  programs.kitty = {
    enable = true;
  };

  # 配置桌面下的kitty配置.
  xdg.configFile."kitty".source = ./kitty-config;
}