{ config, lib, var, ... } :

let
  config = var.user.ssh.config or null;
in
{

  # home-manager 对 ssh 的相关配置
  programs.ssh = {
    # 启用 ssh 配置,必须要启用才生效.
    enable = true;

    # 禁用 home-manager 的一些默认配置
    enableDefaultConfig = false;

    # 引入外部的配置.
    matchBlocks = config // {
      # 所有主机通用配置.
      "*" = {
        extraOptions = {
          # 不需要手动执行ssh-add,正常使用密钥后会
          # 自动将密钥加入到agent中.
          "AddKeysToAgent" = "yes";
        };
      };
    };
  };
}
