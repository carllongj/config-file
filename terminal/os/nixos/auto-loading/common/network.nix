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

    # 配置 DNS 地址
    # nameservers = [
    #  "8.8.8.8"
    #  "1.1.1.1"
    # ];

    # 禁用 resolvconf 服务.
    # resolvconf.enable = false;


    # firewall 默认使用 xtables 实现.
    nftables = {
      # 强制使用 nft 实现.
      enable = true;
    };

    # 配置 NixOS 系统防火墙配置
    firewall = {
      enable = false;

      # 开放端口
      # allowedTCPPorts = [ 22 80 443 ];
      # allowedUDPPorts = [ 53 ];

      # 允许端口范围
      # allowedTcPPortRange = [
      #   { from = 61000 , to = 62000 }
      # ];
    };

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
