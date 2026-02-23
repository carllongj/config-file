{ pkgs, var, ... } :
let
  chrome-proxy = if var.proxy == null then
    "" else "--proxy-server=${var.proxy}";
in
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

    # 定义shell的别名
    shellAliases = {
      # agenix 使用指定路径配置文件.仍然可以通过 age 命令
      # 来进行加解密操作,不一定需要使用该命令.
      ax = "RULES=/etc/nixos/secrets/secrets.nix agenix";
      # 后台运行启用代理的chrome浏览器
      pg = "google-chrome ${chrome-proxy}> /dev/null 2>&1 &!";
    };
  };
}
