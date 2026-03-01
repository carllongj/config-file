{ pkgs, ... }:

# 对于 vmware 相关的虚拟机不需要安装其它驱动.
{
  # 自动安装并配置 open-vm-tools
  virtualisation.vmware.guest.enable = true;

  # 如果你使用的是桌面环境（如 GNOME/KDE），
  # 建议确保 X11 相关驱动也启用，以获得更好的缩放体验
  services.xserver.videoDrivers = [ "vmware" ];

  # 允许 vmware 在宿主机与虚拟机内进行粘贴板共享.
  # 在 wayland 下因为不允许应用随意读取剪切板,可能存在宿主机复制,虚拟机内
  # 能粘贴,但是虚拟机内复制,宿主机无法粘贴.
  environment.systemPackages = with pkgs; [
    open-vm-tools
  ];

  # 自启 open-vm-tools 服务
  # systemd.services.open-vm-tools.wantedBy = [ "multi-user.target" ];
}
