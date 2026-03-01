{ pkgs, ... }:

{
  # 使用 nvidia 配置文件.
  imports = [
    ../../modules/hardware/nvidia.nix
  ];
  # 启用图形驱动
  hardware.graphics = {
    # 不需要再额外安装驱动便可支持
    extraPackages = with pkgs; [
      # 安装 intel 核显视频编解码驱动
      intel-media-driver
    ];
  };

  # 在遇到 nvidia 相关的文件下载失败时,可以将DNS强制
  # 设置为 8.8.8.8以及1.1.1.1 可以正常下载.
  environment.systemPackages = with pkgs; [
    # nvidia 显卡监控应用
    nvtopPackages.full
  ];
}
