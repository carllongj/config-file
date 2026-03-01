{ pkgs, var, inputs, ... }:

# 配置解密文件,在此配置NixOS需要解密哪些文件到系统中
let
  username = var.username;
  agenix = inputs.agenix;
in
{
  # age.secrets."private-key" = {
  #   file = ./private-key.age;
  #   # 私钥通常需要 0600 权限且属于特定用户
  #   owner = "${username}";
  #   # 设置权限.
  #   mode = "0600";
  #   # 创建软链接的路径,并且指向解密后的文件路径
  #   path = "/home/${username}/.ssh/id_ed25519";
  # };


  # 安装解析相关的工具.
  environment.systemPackages = with pkgs; [
    # 安装 agenix 软件包.
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
