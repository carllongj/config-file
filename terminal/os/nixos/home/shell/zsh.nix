{ pkgs, ... } :

{
  # 配置 zsh
  programs.zsh = {
    enable = true;
    # 自动补全以及语法高亮
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 启用 oh-my-zsh 配置
    oh-my-zsh = {
      enable = true;

      # 设置 oh-my-zsh 的主题
      theme = "junkfood";

      plugins = [
        "git"
        "z"
      ];
    };
  };
}
