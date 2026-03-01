{ lib, ...} :

{
  # 配置 zerotier-one 服务.
  services.zerotierone = {
    # 启用 zerotier-one 服务配置,NixOS 配置会默认将服务
    # 设置为开机自启,它默认启用 systemd 服务.
    enable = true;
    # 建议手动执行 sudo zerotier-cli join <id>,执行一次即可.
    # 设置默认加入的网络
    #  joinNetworks = [
    #    # 配置加入的网络
    #  ];
  };

  # 强制覆盖 systemd 单元配置,移除自启依赖,防止自启
  systemd.services.zerotierone.wantedBy = lib.mkForce [ ];
}
