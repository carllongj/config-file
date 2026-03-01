{ pkgs, ...} :

{
  # 配置 mangohud 配置
  xdg.configFile."MangoHud".source = ./mangohud-config;

    # 用户级别使用软件安装
  home.packages = with pkgs; [
    # 游戏内帧率,温度,占用显示.
    mangohud
  ];
}
