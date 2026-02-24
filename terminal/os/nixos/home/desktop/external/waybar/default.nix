{ inputs, pkgs, ... } :

{
  # 在其它桌面环境下的统一执行
  # bash ~/.config/waybar/toggle.sh 来启动,参数会通过
  # ~/.config/ml4w/settings/waybar-theme.sh 配置文件中设置
  # 的主题


  # 启用 waybar 配置项
  programs.waybar = {
    enable = true;
  };

  # 使用外部配置项以便于在其它发行版通用.
  # waybar 的样例仓库地址。
  # https://github.com/Alexays/Waybar/wiki/Examples

  # 引入配置文件
  xdg.configFile."waybar".source = ./waybar-config;

  # ml4w 的 waybar 配置跟随主题,因此在配置布局时要修改
  # 主题对应的 config 文件,添加条目定义时则在 modules.json
  # 配置,在配置中添加显示.


}
