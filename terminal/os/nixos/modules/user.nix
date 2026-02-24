{ pkgs, var, ... } :

{
  users.users."${var.username}" = {
    isNormalUser = true;
    # 设置当前用户的默认 Shell,zsh 则必须要安装.
    shell = pkgs.zsh;
    description = "User Account ${var.username}";
    # 设置主用户组
    group = "${var.username}";

    # 设置额外的用户组
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      
      # 渲染硬件加速,render 设备默认权限是 666.
      # 因此不需要添加组别,默认可用.
      # "render"

      # 启用gamemode 时设置.
      "gamemode"
    ];

    # 设置用户家目录.
    home = "/home/${var.username}";
    # packages = with pkgs; [
      # 设置用户目录下要安装的软件包
      # tree
    # ];
  };

  # 创建一个新的用户组.
  users.groups."${var.username}" = {};

  # 用户设置了使用 zsh,则必须要安装zsh.
  programs.zsh.enable = true;

}
