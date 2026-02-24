{ pkgs, ... }:

{
  # 优化 steam 游戏环境
  home.packages = with pkgs; [
    # 图形化proton管理工具
    protonup-qt
  ];

  # 在 Steam 中运行游戏可能会遇到 MangoHud 配置的时区不正确,这是
  # Steam 容器在复制NixOS 系统中的时区断链导致MangoHud不知道系统时区
  # 就显示为 UTC 时区,因此在添加 MANGOHUD=1 来启动游戏时必须要添加
  # 指定时区的配置,例如以下启动项.

  # 强行使用TZ 指定为东八区的时间.
  # MAONGOHUD=1 TZ="GMT-8" %command%
}
