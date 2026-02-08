{ pkgs, var, lib, ... } :

let
  # 获取配置的代理地址.
  proxy = var.git.proxy or var.proxy;
in
{
  # 配置 git 相关配置信息
  programs.git = {
    enable = true;

    # git 相关的配置项
    settings = {
      user = {
        name = var.username;
        email = var.git.email;
      };

      init.defaultBranch = "main";
      pull.rebase = true;

      # 设置 git 代理
      http = lib.optionalAttrs (proxy != null) {
        # 设置指定域名的代理.
        "https://github.com/".proxy = proxy;
      };
    };

    # 全局忽略文件,以下目录或者文件自
    # 动忽略加入到版本管理中.
    ignores = [
      ".DS_Store"
      "*.swp"
      ".idea/"
      ".vscode/"
      "result"
      "target/"
    ];
  };
}
