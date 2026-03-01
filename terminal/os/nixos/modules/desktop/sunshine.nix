{ config, pkgs, ...} :

{
    # 启用 sunshine
  services.sunshine = {
    enable = true;
    # 是否自启动
    autoStart = false;
    # 允许控制输入
    capSysAdmin = true;
    # 允许自动打开需要的端口
    openFirewall = true;

    # 配置使用 cuda 集成,解决sunshine无法使用nvenc问题.
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  # NixOS 中使用 systemd.user.services 配置的是所有
  # 普通用户都会存在该服务.
  # systemd.services 则是系统级别服务.
  # 配置 sunshine 服务.
  # systemd.user.services.sunshine.serviceConfig = {
  # };
}
