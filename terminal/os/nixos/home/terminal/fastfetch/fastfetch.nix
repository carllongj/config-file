{ nixpkgs, lib, ...} :

{
  # 启用 fastfetch 配置项
  programs.fastfetch = {
    enable = true;
  };

  # 指向自定义配置文件.
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
}
