{ config, pkgs, ... }:

{
  # 默认安装的工具软件.
  environment.systemPackages = with pkgs; [
    btop
    yazi

    # make 命令
    gnumake
    # gcc 命令
    gcc

    ffmpeg-full

    # 引入 mount.cifs 挂载命令
    cifs-utils

    killall
 ];
}
