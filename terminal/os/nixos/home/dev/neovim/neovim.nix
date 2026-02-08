{ pkgs, var, ... } :

{
  # 配置 neovim 相关配置信息
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # 定义 neovim 配置插件需要的软件包.
    extraPackages = with pkgs; [
      fzf
    ];
  };


  # 指向本地配置的 lua 脚本
  xdg.configFile."nvim" = {
    # 指向本地的配置文件路径
    source = ./neovim-config;

    # 递归映射整个目录
    recursive = true;
  };
}
