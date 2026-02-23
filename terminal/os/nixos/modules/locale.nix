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
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      # 注意：LC_MESSAGES 决定程序界面语言。
      # 如果你想让应用界面是中文，必须加上这一行：
      LC_MESSAGES = "zh_CN.UTF-8";
    };
    # 用以设置系统中支持的语言列表.
    # 类似于 localegen 命令来生成支持的 locale.
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  # 设置默认下载的字体软件包.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-lgc-plus

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only

    # inter
    fira-sans
    roboto

    # 图标字体库
    font-awesome
    # 谷歌图标字体库
    material-icons
  ];


  # 设置字体属性.
  fonts = {
    enableDefaultPackages = true;
    # 配置字体的渲染,它主要的作用是查找字体以及处理字体回退.
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Sans" "Noto Sans CJK SC"];
        sansSerif = ["Noto Serif" "Noto Serif CJK SC"];
        # 等宽字体设置回退
        monospace = [
          "JetBrainsMono Nerd Font"
          "Material Icons"
          "Noto Sans Old Persian"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
