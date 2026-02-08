{
  config,
  pkgs,
  lib,
  ...
}: {
  # 引入用户配置目录.
  imports = [
    ./shell
    ./terminal
    ./dev
  ];

  # 统一配置指针光标
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;

    # 自动在 GTK 以及 X11 中应用光标.
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
  };

  # 添加用户级别PATH路径
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # 该选项用以针对版本不匹配时也继续构建.
  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";
}
