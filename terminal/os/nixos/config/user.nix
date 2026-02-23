{ lib, ...} :

{
  # user 将被嵌套一个层级
  user = {
    # git 环境变量配置.
    git = {
      # 设置git 使用的用户名,若未设置则使用 var.username.
      # username = "carllongj";

      # 设置 git 使用的邮箱地址.
      email = "carllongj@gmail.com";

      # 设置 git 配置的代理服务器(github).
      # proxy = "<git_proxy_addr>";
    };

    # 用以配置 ssh_config 中的选项配置.
    ssh = {
      config = {
       "jump" = {
          hostname = "192.168.1.238";
          port = 47022;
          user = "jump";
        };
        "n2" = {
          hostname = "127.0.0.1";
          port = 47022;
          user = "carllongj";
          identityFile = "~/.ssh/id_ed25519";
          proxyJump = "jump";
          controlMaster = "auto";
          controlPath = "~/.ssh/control-%r@%h:%p";
          controlPersist = "10m";
        };
      };
    };
  };
}
