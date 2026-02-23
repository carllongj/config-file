
{
  # 引入用户配置目录.
  imports = [
    ./shell
    ./terminal
    ./dev
    ./desktop
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPAER = "zh_CN.UTF-8";
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    # LC_MESSAGES 决定程序界面语言,配置该选项使得
    # 应用显示特定的语言.
    LC_MESSAGES = "zh_CN.UTF-8";
  };

  # 添加用户级别PATH路径
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # 该选项用以针对版本不匹配时也继续构建.
  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "25.11";
}
