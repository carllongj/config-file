{ pkgs, ... } :

{
  # 配置 zsh
  programs.kitty = {
    enable = true;

    # 字体配置
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    # 其它配置(kitty.conf 文件中的配置项)
    settings = {
      # 背景透明度,设置为不透明
      background_opacity = "1";
      dynamic_background_opacity = "no";

      # 窗口布局
      window_margin_width = 10;
      remember_window_size = "no";
      initial_window_width = "120c";
      initial_window_height = "35c";

      # 字体进阶设置
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";

      # 光标设置 (Kitty 0.35+ 支持 cursor_trail)
      cursor_shape = "beam";
      cursor_trail = 1;
      cursor_trail_decay = "0.3 0.6";

      # 交互与反馈
      confirm_os_window_close = 0;
      enable_audio_bell = "yes";
      copy_on_select = "yes";
    };
    # 额外配置项,用以配置主题颜色,更换主题替换以下配置项即可.
    extraConfig = ''
      background            #202020
      foreground            #adadad
      cursor                #ffffff
      selection_background  #1a3272
      color0                #000000
      color8                #545454
      color1                #fa5355
      color9                #fb7172
      color2                #126e00
      color10               #67ff4f
      color3                #c2c300
      color11               #ffff00
      color4                #4581eb
      color12               #6d9df1
      color5                #fa54ff
      color13               #fb82ff
      color6                #33c2c1
      color14               #60d3d1
      color7                #adadad
      color15               #eeeeee
      selection_foreground #202020
    '';
  };
}
