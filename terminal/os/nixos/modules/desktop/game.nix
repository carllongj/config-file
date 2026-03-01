{ config, pkgs, lib, ... }:

{
  # 启用 steam
  programs.steam = {
    enable = true;
    # 启用本地网络游戏以及流式传输的防火墙端口.
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    gamescopeSession.enable = true;
  };

  # 启用 gamemode 应用,优化游戏性能.
  # 使用方式为通过 gamemoderun 来运行游戏.
  # 通过 gamemoded -s 检查是否加载了gamemode
  programs.gamemode = {
    enable = true;
  };

}