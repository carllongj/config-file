{ inputs, pkgs, lib, ... } :
let
  entryAfter = lib.hm.dag.entryAfter;
  # 配置文件
  waypaperConfig = ./waypaper-config/config.ini;
in 
{
  # 启用 waybar 配置项
  programs.waybar = {
    enable = true;
  };

  # 使用外部配置项以便于在其它发行版通用.
  # waybar 的样例仓库地址。
  # https://github.com/Alexays/Waybar/wiki/Examples

  # home.activation.copyWaypaperConfig = lib.mkAfter ''
  #   TEMPLATE="$HOME/.config/waypaper/config.ini.template"
  #   TARGET="$HOME/.config.waypaper/config.ini"

  #   # 复制模板文件到可写目录.
  #   cp "$TEMPLATE" "$TARGET"
  #   chmod u+w "$TARGET"
  # '';

  # 使得 NixOS 追踪该配置文件.
  xdg.configFile."waypaper/config.ini.template".source = waypaperConfig;

  # 声明后置脚本,以便于创建一个可写的文件供 waypaper 配置使用
  home.activation.initWaypaper = entryAfter ["writeBoundary"] ''
    TEMPLATE="${waypaperConfig}"
    TARGET_DIR="$HOME/.config/waypaper"
    TARGET="$TARGET_DIR/config.ini"
    
    # 优先创建一个目录,防止创建文件失败.
    mkdir -p $TARGET_DIR

    if [ ! -f $TARGET ];then
      # 复制模板文件到可写目录.
      cp "$TEMPLATE" "$TARGET"
      chmod u+w "$TARGET"
    fi
  '';

}
