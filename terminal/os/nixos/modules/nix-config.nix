{ nixpkgs, lib, ... } :

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
    # 配置 nix 的实验特性,就可以不在命令选项中声明.
    # settings = {
    #   experimental-features = [
    #     "nix-command"
    #     "flakes"
    #     "pipe-operators" # 启用管道符支持
    #     ];
    # };
  };
}
