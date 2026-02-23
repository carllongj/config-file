{lib, global, ...} :

# 对定义变量的后置处理
let
  proxy = global.proxy or null;
  matched =  builtins.match "([^:]+)://([^:/]+):([0-9]+)" proxy;
in
{
  # 组装成便于使用的代理对象.
  proxyConfig = if proxy == null then null
  else if matched == null then throw "Invalid proxy URL: ${proxy}"
  else {
    type = builtins.elemAt matched 0;
    host = builtins.elemAt matched 1;
    port = lib.toInt (builtins.elemAt matched 2);
  };
}
