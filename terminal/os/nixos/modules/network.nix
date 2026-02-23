{ config, lib, pkgs, var, ... }:

let
  # 获取配置代理的地址
  globalProxy = var.proxy or null;
  proxyConfig = var.proxyConfig or null;
  exportProxy = var.exportProxy or false;
  hostsConfig = var.hostsConfig or {};
in
{
  # 网络属性相关的配置项.
  networking = {
    # 当前系统的主机名称
    hostName = "nixos";

    # 配置 /etc/hosts 中的域名映射,NixOS 使用合并的
    # 机制来配置域名映射,它会默认配置 127.0.0.0/8 以及 ::1 本
    # 地环回接口配置.
    hosts = hostsConfig ;

    # networkManager 的配置信息
    networkmanager = {
      # 启用 networkmanager 服务.
      enable = true;

      # 禁止接管dns配置.
      # dns = "none";
    };

    # 旁路由地址
    # nameservers = [ "192.168.1.238" ];

    # 配置全局网络代理
    proxy = if (globalProxy != null && exportProxy) then {
      default = globalProxy;
      noProxy = "127.0.0.1,localhost,internal.domain";
    } else {};

  };


  # 配置 OpenSSH 服务.
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

  # 启用 ssh-agent,以便于记住密钥的密码.
  programs.ssh.startAgent = true;

  # 禁用 gnome 的 ssh-agen 服务,防止冲突.
  services.gnome.gcr-ssh-agent.enable = false;

  # 配置 zerotier-one 服务.
  # services.zerotierone = {
  #   # 启用 zerotier-one 服务配置.
  #   enable = true;
  #   # 设置默认加入的网络
  #   joinNetworks = [
  #     # 配置加入的网络
  #   ];
  # };


  environment.systemPackages = with pkgs; [
    # ethtool 命令
    ethtool

    # dns 软件工具包
    dnsutils

    # tcpdump 抓包命令
    tcpdump
  ]
  # 启用代理则安装 proxychains-ng 应用.
  ++ lib.optional (proxyConfig != null) proxychains-ng;

  programs.proxychains = if (proxyConfig != null) then {
    enable = true;
    package = pkgs.proxychains-ng;
    proxies.default = {
      enable = true;
      type = proxyConfig.type;
      host = proxyConfig.host;
      port = proxyConfig.port;
    };
  } else {
    enable = false;
  };
}
