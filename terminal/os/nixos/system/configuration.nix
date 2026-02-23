{ config, lib, pkgs, ... }:

{
  # 引导项相关的设置
  boot = {
    loader = {
      # 设置 systemd-boot 作为 EFI boot loader
      systemd-boot.enable = true;

      # 是否允许引导程序修改 EFI 变量(主板会根据变量来读取对应的加载项).
      # 通常单独安装需要设置为true,以便于系统能正确的找到系统的引导.
      efi.canTouchEfiVariables = true;

      # 设置 efi 的目录挂载点,默认就是 /boot,因此可以不用设置.
      # efi.efiSysMountPoint = "/boot";
    };

    # 设置 initrd 相关的模块设置.
    initrd = {
      # 设置引导时额外加载的模块项到镜像中.
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
      # 该选项设置必须要强制加载到镜像中的内核模块.
      # 提前加载 nvidia 驱动
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

      # 隐藏 从 initrd 到真正 root 目录系统的日志.
      verbose = false;
    };
    # 设置引导时加载的文件系统支持,以便于允许启动后挂载
    # ntfs 用以支持windows系统下的文件系统.
    # supportedFilesystems = [ "ntfs" ];

    # 指定使用的内核版本,若不指定则使用 LTS 版本的内核.
    # kernelPackages = pkgs.linuxPackages_latest;

    # 设置内核加载的模块.
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # 减少内核日志输出
    consoleLogLevel = 0;

    # 启用开机动画.
    # plymouth = {
    #   enable = true;
    #   # 默认主题
    #   # theme = "bgrt";

    #   themePackages = [ pkgs.adi1090x-plymouth-themes ];

    #   # 常用推荐: "loader", "glitch", "seal", "circuit", "target", "crosshair"
    #   theme = "circuit";
    # };

    # 指定内核参数,以下选项通常搭配开机动画时使用.
    # kernelParams = [
    #  "quite" "splash" "loglevel=3"
       # 不显示 systemd 日志
    #  "rd.systemd.show_status=false"
    #  关闭 udev 日志信息以及 rd 中的 udev.
    #  “udev.log_level=3”
    #  "rd.udev.log_level=3"
    # ];
  };

  # 启用 zRAM 交换分区.
  zramSwap = {
    enable = true;

    # 设置最大内存空间的比例,占用最大内存的50%
    memoryPercent = 50;

    # 设置交换分区的优先级
    priority = 100;

    # 指定压缩算法.
    algorithm = "zstd";
  };

  system.stateVersion = "25.11";
}
