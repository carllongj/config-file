{ config, lib, ... }:

{
  # 启用图形驱动
  hardware.graphics = {
    enable = true;

    # 启用32位库支持.
    enable32Bit = lib.mkDefault true;
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

  # 设置 nvidia 使用的引导参数.
  boot.initrd = {
      # 该选项设置必须要强制加载到镜像中的内核模块.
      # 提前加载 nvidia 驱动
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}
