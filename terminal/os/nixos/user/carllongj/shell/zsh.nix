{pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      # 启用 oh-my-zsh
      enable = true;
      theme = "junkfood";
      # 启用插件
      plugins = [
        "git"
        "z"
      ];
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
