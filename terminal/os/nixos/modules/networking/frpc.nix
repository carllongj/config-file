{ config, pkgs, var, ... }:

let
  username = var.services.username;
  group = var.services.group;
in
{
  # 定义 frpc 对应的 systemd 服务
  systemd.services.frpc = {
    description = "Frp Client Services";

    after = [ "networking.target" "agenix.service" ];
    # NixOS 中若指定了该选项,则表示它会在该阶段被自动启动.
    # 因此不需要开机自启动就不需要添加该项.
    # wantedBy = [ "multi-user.target" ];

    # systemd 配置项
    serviceConfig = {
      # 选项要为正确的小写格式.若为默认的 simple,
      # NixOS 会省略该选项.
      Type = "simple";

      ExecStart = "${pkgs.frp}/bin/frpc -c ${config.age.secrets.frpc-secret-config.path}";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "${username}";
      Group = "${group}";
    };
  };

  # 引入服务软件包
  environment.systemPackages = with pkgs; [
    frp
  ];
}
