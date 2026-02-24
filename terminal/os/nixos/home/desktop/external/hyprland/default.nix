{ pkgs, lib, ... } :

let
  # 只读配置
  hyprConfig = ./hypr-config;

  # hypr 下的配置文件路径.
  hyprFiles = builtins.readDir hyprConfig;

  # 获取要创建的只读目录.
  hyprReadOnlyConfig = lib.filterAttrs (_: _:
    true ) hyprFiles;

  swayncConfig = ./swaync-config;

  # 配置文件目录
  ml4wConfig = ./ml4w-config;

  # settings 目录可以进行读写.
  ml4wConfigSettings = ./ml4w-config/settings;

  # 获取配置目录下的所有文件.
  ml4wFiles = builtins.readDir ml4wConfig;

  # 排除 settings 目录以便于对其设置读写目录.
  ml4wReadOnlyConfigs = lib.filterAttrs (name: _:
    name != "settings" ) ml4wFiles;
in

{
  wayland.windowManager.hyprland = {
    # 启用 hyprland
    enable = true;

    # 推荐使用 pkgs.hyprland (nixpkgs版本)
    # inputs.hyprland.packages (flake版本)
    package = pkgs.hyprland;

    # 是否启用 XWayland (用于兼容旧版应用)
    xwayland.enable = true;

    # 外部管理,防止警告
    extraConfig = "# Managed by external dotfiles";
  };

  # 以下服务还没有自启动.
  services = {
    # 启用 hypridle 服务,空闲休眠
    hypridle.enable = true;

    # 启用消息通知栏服务
    swaync.enable = true;
  };

  # 启用 hyprland 一些桌面应用
  programs = {
    # 启用 hyprlock
    hyprlock = {
      enable = true;
    };
  };

  # 用户级别软件包
  home.packages = with pkgs; [
    # hyprland 着色器,使得屏幕可以通过着色器渲染.
    hyprshade
  ];

  # 配置服务的目录
  xdg.configFile = {
    # 配置 swaync 消息侧边栏配置
    "swaync".source = swayncConfig;

    # 创建只读目录,以便于复制目录到可读写的目录下.
    "ml4w/settings-readonly".source = ml4wConfigSettings;
  } //
    # hypr 目录下有一些需要读写的目录,因此只设置子目录映射
    # 到只读.
    (
      lib.mapAttrs' (name: _:
        lib.nameValuePair "hypr/${name}" {
          source = "${hyprConfig}/${name}";
        }
      ) hyprReadOnlyConfig
    )
    //
    # 合并 ml4w 目录下的所有只读目录配置.
    (lib.mapAttrs' (name: _:
    lib.nameValuePair "ml4w/${name}" {
      source = "${ml4wConfig}/${name}";
    }
  ) ml4wReadOnlyConfigs);

  # hyprland 后置处理脚本,主要是配置 ml4w 中的可写目录.以便于自定义配置.
  # 因此修改配置文件后需要应用新的 settings,需要手动删除 ~/.config/ml4w 以便于
  # 重新复制文件到可写目录下.
  home.activation.postHyprlandSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # 处理 hypr 目录以及其可写权限.
    mkdir -p "$HOME/.config/hypr"
    chmod u+w $HOME/.config/hypr

    # 复制 settings 目录到一个可正常读写的目录下,以便于切换.
    TEMPLATE_SETTINGS="${ml4wConfigSettings}"
    TARGET_SETTINGS="$HOME/.config/ml4w/settings"

    mkdir -p "$HOME/.config/ml4w"

    # 检查原始目录是否存在,不覆盖已有配置.
    if [ ! -d $TARGET_SETTINGS ];then
      cp -r $TEMPLATE_SETTINGS $TARGET_SETTINGS

      # 设置可写权限.
      chmod -R u+w $TARGET_SETTINGS
    fi
  '';
}

### 配置文件中的一些快捷键.
# Mod + Return => 打开终端.
# Mod + E      => 打开文件浏览器.
# Mod + S      => 打开浏览器.
# Mod + <Num>  => 快速切换到指定的桌面(workspace),Hyprland 是切换到对应
#                 的桌面若不存在则创建.
# Mod + Ctrl + Returrn => 唤出快捷搜索.

