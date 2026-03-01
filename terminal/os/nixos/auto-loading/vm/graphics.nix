{ pkgs, ... }:

{
  # 引入 vmware 虚拟机配置
  imports = [
    ../../modules/hardware/vmware.nix
  ];
}
