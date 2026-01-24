{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # 软链接 nvim 配置到用户目录下
  home.file.".config/nvim".source = ./nvim;
}
