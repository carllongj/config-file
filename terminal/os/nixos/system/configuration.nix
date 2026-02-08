{ config, lib, pkgs, ... }:

{
  # 引导项相关的设置
  boot = {
    loader = {
      # 设置 systemd-boot 作为 EFI boot loader
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # 设置 initrd 相关的模块设置.
    initrd = {
      # 设置引导时额外加载的模块项到镜像中.
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
      # 该选项设置必须要强制加载到镜像中的内核模块.
      kernelModules = [ ];
    };
    # 设置引导时加载的文件系统支持,以便于允许启动后挂载
    # ntfs 用以支持windows系统下的文件系统.
    # supportedFilesystems = [ "ntfs" ];

    # 指定使用的内核版本,若不指定则使用 LTS 版本的内核.
    # kernelPackages = pkgs.linuxPackages_latest;

    # 设置内核加载的模块.
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  system.stateVersion = "25.11";
}
