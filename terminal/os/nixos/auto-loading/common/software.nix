{ config, pkgs, ... }:

{
  # 默认安装的工具软件.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    kitty
    fastfetch
    gzip
    file
    unzip
    tree
    jq
    ripgrep
    # lspci 工具
    pciutils
 ];
}
