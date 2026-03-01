{ pkgs, ...} :

{
  # vscode 配置项
  programs.vscode = {
    enable = true;

    profiles.default = {
      # 指定需要安装的插件
      extensions = with pkgs.vscode-extensions; [
        # nix 语法插件
        bbenoist.nix

        # vscode 的 remote-ssh 插件
        ms-vscode-remote.remote-ssh

        shardulm94.trailing-spaces

        # 图标主题
        pkief.material-icon-theme
      ];

      userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "material-icon-theme";
      };
    };
  };
}
