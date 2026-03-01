{ lib, ...} :

{
  # 启用 flatpak 应用
  services.flatpak = {
    enable = true;

    # 默认安装的应用
    packages = [
      # 默认的权限管理工具
      "com.github.tchx84.Flatseal"

      # wechat 应用.
      "com.tencent.WeChat"

      # 任务中心,NixOS 下 flatpak 版本无法获取到,使
      # 用NixOS官方官本.
      # "io.missioncenter.MissionCenter"

      # 远程桌面客户端
      "org.remmina.Remmina"
    ];

    # 重写flatpak 的权限属性
    # overrides = {
    #   "io.missioncenter.MissionCenter" = {
    #     context = {
    #       # 允许访问硬件设备
    #       devices = [ "all" ];

    #       sockets = [ "wayland" "fallback-x11" "system-bus" "session-bus" ];
    #     };
    #   };
    # };

    # 设置 flathub 仓库.
    remotes = lib.mkOptionDefault [
      {
        name = "flathub";
        location = "https://mirror.sjtu.edu.cn/flathub/repo/flathub.flatpakrepo";
      }
    ];

    # 应用自动更新
    update.auto.enable = true;

    # 默认情况下该组件只会负责管理声明的软件包和存储库,不会删除
    # 通过命令行安装的应用,开启以下选项将严格按照生命式的管理
    # 应用,通过命令行安装的应用在重建后会被删除.
    # uninstallUnmanaged = false;
  };

}
