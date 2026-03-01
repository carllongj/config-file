{ pkgs, var, inputs, ... }:

# 配置解密文件,在此配置NixOS需要解密哪些文件到系统中
let
  username = var.username;
  agenix = inputs.agenix;
in
{
  # NixOS 在重新构建时就会解密每一个条目的加密内容将其写入到
  # /run/agenix.d/ 目录下并且建立软链接到指定的目录.

  # /run/agenix.d/ 是一个内存文件系统,agenix.d 会保证解密后的
  # 数据也不会写入到磁盘,而是开机或者重新构建时写入到内存使用.

  # 配置项指向了加密的文件,并且将其解密到指定的目录下.
  age.secrets."private-key" = {
    file = ./private-key.age;
    # 私钥通常需要 0600 权限且属于特定用户
    owner = "${username}";
    # 设置权限.
    mode = "0600";
    # 创建软链接的路径,并且指向解密后的文件路径
    path = "/home/${username}/.ssh/id_ed25519";
  };

  # 配置公钥(公钥不需要加密),为了对比如何配置.
  age.secrets."public-key" = {
    file = ./public-key.age;
    # 私钥通常需要 0600 权限且属于特定用户
    owner = "${username}";
    # 设置权限.
    mode = "0600";
    # 创建软链接的路径,并且指向解密后的文件路径
    path = "/home/${username}/.ssh/id_ed25519.pub";
  };

  # 本地 smbd 服务对应的密钥文件
  age.secrets."smbd.cred" = {
    file = ./smbd.age ;
    owner = "${username}";
    mode = "0600";
    path = "/home/${username}/.sec/smbd.cred";
  };

  # 记录 ubuntu 使用的远程密码
  age.secrets."ubuntu.remote-pass" = {
    file = ./ubuntu-remote-pass.age;
    owner = "${username}";
    mode = "0600";
    path = "/home/${username}/.sec/ubuntu-remote-pass";
  };

  # frpc 文件不需要映射到文件系统中.
  age.secrets."frpc-secret-config" = {
    file = ./frpc-screct-config.age;
    owner = "services";
    mode = "0400";
  };

  # 安装解析相关的工具.
  environment.systemPackages = with pkgs; [
    # 安装 agenix 软件包.
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
