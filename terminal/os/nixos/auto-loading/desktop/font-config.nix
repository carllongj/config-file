{ pkgs, ... } :

{
  # 设置桌面环境默认下载的字体软件包.
  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    noto-fonts-lgc-plus

    nerd-fonts.fira-code
    nerd-fonts.symbols-only

    # inter
    fira-sans
    roboto

    # 图标字体库
    font-awesome
    # 谷歌图标字体库
    material-icons
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "Material Icons"
      "Noto Sans Old Persian"
    ];
  };
}