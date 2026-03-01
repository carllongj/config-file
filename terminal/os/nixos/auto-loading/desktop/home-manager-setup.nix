{ inputs, nixpkgs, var, ... } :

{
  home-manager = {
    # home-manager 复用已经定义好的 pkgs,防止
    # 重复下载软件包
    useGlobalPkgs = true;
    # 将软件包安装到系统的 HM profile,即路径在
    # /etc/profiles/per-user/${username} 下
    useUserPackages = true;
    # 用户自定义变量进行传递
    extraSpecialArgs = { inherit inputs var; };

    # 默认用户加载指定目录下的配置.
    users."${var.username}" = {
      imports = [
        # 引入配置目录
        ../../home
      ];
    };
  };
}
