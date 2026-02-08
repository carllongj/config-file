{ config, pkgs, var, ... }:
let
  # 获取配置代理的地址
  globalProxy = var.proxy or null;
in
{
  # 网络属性相关的配置项.
  networking = {
    # 当前系统的主机名称
    hostName = "nixos";

    # networkManager 的配置信息
    networkmanager.enable = true;

    # 配置全局网络代理
    proxy = if (globalProxy != null) then {
      default = globalProxy;
      noProxy = "127.0.0.1,localhost,internal.domain";
    } else {};
  };


  # 配置 OpenSSH 服务
  services.openssh = {
    # 启用 OpenSSH Server 服务.
    enable = true;
    settings = {
      # 是否允许使用密码登录.
      PasswordAuthentication = true;
      # 是否允许 root 用户登录,默认为 no
      # PermitRootLogin = "yes";
    };
  };

  # 配置 zerotier-one 服务.
  # services.zerotierone = {
  #   # 启用 zerotier-one 服务配置.
  #   enable = true;
  #   # 设置默认加入的网络
  #   joinNetworks = [
  #     # 配置加入的网络
  #   ];
  # };
}
