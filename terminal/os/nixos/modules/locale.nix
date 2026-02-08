{ pkgs, ... } :

{
  # 设置当前系统时区
  time.timeZone = "Asia/Shanghai";

  # 国际化语言相关配置
  i18n = {
    # 设置全局默认的语言为英文
    defaultLocale = "en_US.UTF-8";
    # 其它本地化则语言则为中文.
    extraLocaleSettings = {
      LC_TIME = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPAER = "zh_CN.UTF-8";
      LC_CTYPE = "zh_CN.UTF-8";
    };
    # 用以设置系统中支持的语言列表.
    # 类似于 localegen 命令来生成支持的 locale.
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  # 设置中文输入法.
  i18n.inputMethod = {
    # 启用输入法,该选项会自动设置大部分环境变量.
    enable = true;
    # 设置输入法类型.
    type = "fcitx5";
    # 安装输入法软件.
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons # 包含拼音等基础中文输入.
      fcitx5-gtk # GTK 程序的兼容性支持
      fcitx5-lua # Lua 脚本支持.
    ];
  };

  # 设置默认下载的字体软件包.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];


  # 设置字体属性.
  fonts = {
    enableDefaultPackages = true;
    # 配置字体的渲染.
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Sans" "Noto Sans CJK SC"];
        sansSerif = ["Noto Serif" "Noto Serif CJK SC"];
        monospace = ["JetBrainsMono Nerd Font"];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
