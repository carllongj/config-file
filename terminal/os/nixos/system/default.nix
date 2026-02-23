{
  imports = [
    # 系统默认配置
    ./configuration.nix
    # 引导配置
    ./hardware-configuration.nix
    # 内核参数配置
    ./kernel-configuration.nix
  ];
}
