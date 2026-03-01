{ pkgs, var, ... } :

{
  users.users."${var.username}" = {
    extraGroups = [
      "video"
      "input"
      # sytemd 日志查看
      "systemd-journal"

      # 渲染硬件加速,render 设备默认权限是 666.
      # 因此不需要添加组别,默认可用.
      # "render"

      # 启用gamemode 时设置.
      "gamemode"
    ];
  };
}
