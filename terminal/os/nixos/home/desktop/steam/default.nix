{ pkgs, ... }:

{
  # 优化 steam 游戏环境
  home.packages = with pkgs; [
    # 图形化proton管理工具
    protonup-qt
  ];
}
