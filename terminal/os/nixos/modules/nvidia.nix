{ config, pkgs, ... }:

{
  # 启用图形驱动
  hardware.graphics = {
    enable = true;

    # 启用32位库支持.
    enable32Bit = true;

    # 不需要再额外安装驱动便可支持
    extraPackages = with pkgs; [
      # 安装 intel 核显视频编解码驱动
      intel-media-driver
    ];
  };

  # 允许应用查找驱动支持
  environment.variables = {
    # 设置为 nvidia,使得所有应用都使用nvidia
    # LIBVA_DRIVER_NAME = "nvidia";
  };

  # 加载 Nvidia 驱动模块
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # 启用模式设置(必选,Wayland 是必需的).
    modesetting.enable = true;

    # NVIDIA 电源管理.改善休眠唤醒稳定性
    powerManagement.enable = true;

    # 在新系列 16X/RTX 之后的显卡才建议开启该项.
    powerManagement.finegrained = false;

    # 是否使用开源的内核驱动模块(即 nvidia-open),不是Nouveau.
    open = false;

    # 启用 NVIDIA 设置菜单.
    nvidiaSettings = true;

    # 选择的驱动包.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
    # nvidia 显卡监控应用
    # nvtopPackages.full
  ];
}
