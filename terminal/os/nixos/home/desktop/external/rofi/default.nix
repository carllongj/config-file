{ pkgs, ... } :

{
  # 启用 rofi 
  programs.rofi = {
    enable = true;
  };

  # 设置配置文件目录
  xdg.configFile."rofi".source = ./rofi-config;
}
