{
  imports = [
    # 系统默认配置
    ./configuration.nix

    # 引导配置,在新版本 systemd 对于 NixOS 默认生成的 boot 分区会有过于开放的警告.
    #  fileSystems."/boot" =
    # { device = "/dev/disk/by-uuid/8314-0D17";
    #   fsType = "vfat";
    #   # 此处 options 要将权限设置为 0077 以消除警告.
    #   options = [ "fmask=0022" "dmask=0022" ];
    # };
    ./hardware-configuration.nix

    # 内核参数配置
    ./kernel-configuration.nix
  ];
}
