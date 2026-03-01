{ config, pkgs, lib, ... }:

{
  imports = [
    # 虚拟机引入基础的桌面配置.
    ../../modules/base/desktop.nix
  ];
}
