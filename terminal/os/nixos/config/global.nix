{ lib, ...} :

# 定义变量的属性集合.
{
  # 全局配置用户名(系统用户以及git中配置的用户名).
  username = "carllongj";

  # 用以设置是否导入代理地址到环境变量中,不指定默认为false.
  # 是否设置 http_proxy 等环境变量.
  # exportProxy = false;

  # 设置全局代理的地址.
  proxy = "http://192.168.1.238:7890";

  # 启用 nix 下模拟 HFS 动态链接库.
  enableNixLd = true;

  # 用以配置 /etc/hosts 的映射.
  hostsConfig = {
    # 格式为 "<ip> = [<domain>]"
    # <domain>可以是字符串或者列表
    "192.168.1.238" = [ "n2" ];
  };
}
