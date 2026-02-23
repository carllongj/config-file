{ config, lib, pkgs, ... }:

{
  # 内核配置
  boot.kernel = {
    # 配置内核默认参数
    sysctl = {
      # 启用 ipv4 转发
      "net.ipv4.ip_forward" = 1;

      # 关闭反向路径过滤
      # "net.ipv4.conf.all.rp_filter" = 0;
      # "net.ipv4.conf.default.rp_filter" = 0;

      # 启用ipv6 转发
      # "net.ipv6.conf.all.forwarding" = 1;
    };
  };
}
