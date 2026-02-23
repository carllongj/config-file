{ lib, ...} :

let
  # 定义全局变量的文件.
  global = import ./global.nix { inherit lib; };

  # 定义用户级别变量的文件,使用 home-manager 写入.
  user = import ./user.nix { inherit lib global; };

  # 对变量进行处理的逻辑
  processed = import ./post-variable.nix { inherit lib global; };
in
  # 合并结果集合
  global // user // processed
