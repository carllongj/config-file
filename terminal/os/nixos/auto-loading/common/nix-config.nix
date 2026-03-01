{ pkgs, lib, var, ... } :

let
  enableNixLd = var.enableNixLd or false;
in
{
  # nixos 默认只允许安装开源软件,开启该选项
  # 才允许安装闭源软件,允许所有闭源软件.
  nixpkgs.config.allowUnfree = true;

  # 以下选项用以只允许安装指定的闭源软件.
  # nixpkgs.config.allowUnfreePredicates =
  # pkg: builtins.ele (nixpkgs.lib.getName pkg) [
  #   "vscode"
  #   "steam"
  # ]

  # Nix 相关的配置.
  nix = {
    # 构建垃圾回收相关配置信息
    gc = {
      # 是否启用自动垃圾回收机制.
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      # 仅保留最近7天的构建信息.
      options = lib.mkDefault "--delete-older-than 7d";
    };

    settings = {
      # 将缓冲区设置为 512MB (单位为 bytes)
      download-buffer-size = 536870912;

      # 配置 nix 的实验特性,就可以在执行 nix 相关命令时不再使用
      # --option extra-experimental-features 来指定实验特性.
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators" # 启用管道符支持
      ];

      # 1. 指定二进制缓存服务器地址
      # substituters = [
      #   "https://mirrors.ustc.edu.cn/nix-channels/store"
      #   # 官方源
      #   "https://cache.nixos.org/"
      # ];
    };
  };

  # 解决应用程序使用FHS的标准链接库路径(/lib64/ld-linux-x86-64.so)
  # (NixOS 不使用FHS)导致无法正常运行应用.
  programs.nix-ld = if ( enableNixLd ) then {
    enable = true;
    # libraries = with pkgs; [
    #   zlib
    #   curl
    #   openssl
    # ];
  }
  else { enable = false; };
}
