{ config, pkgs, ... }:

{
  # 默认安装的工具软件.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    kitty
    fastfetch
    btop
    yazi
    # lspci 工具
    pciutils
    # make 命令
    gnumake
    # gcc 命令
    gcc
 ];
}
