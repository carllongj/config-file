{
  description = "NixOS configuration with auto-module loading";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 引入 home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 引入 agenix 用以隐私文件加解密
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 引入 walker 搜索框设置
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix flatpak 应用启用,因它不需要依赖
    # 任何 nixpkgs 版本,因此不需要设置 follows
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak?ref=latest";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, nix-flatpak, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # 引入定义的配置变量.
    var = import ./config { inherit lib; };

    loadIfExists = path:
      if builtins.pathExists path
        then lib.filesystem.listFilesRecursive path
        |> builtins.filter (p: lib.hasSuffix ".nix" (builtins.baseNameOf p))
      else [];

    # 自动加载模块
    autoload = (name :
      let
        # 通用模块
        autoLoadCommon = ./auto-loading/common;
        # 系统单独配置
        autoLoadModule = (./auto-loading + "/${name}");

        # 递归加载该模块下的所有 .nix 文件模块.
        commonModules = loadIfExists autoLoadCommon;
        machineModules = loadIfExists autoLoadModule;
      in
       commonModules ++ machineModules
    );

    # 构建操作系统函数.
    mkSystem = name: nixpkgs.lib.nixosSystem {
      inherit system;
      # 将变量收集一并传递给模块.
      specialArgs = { inherit inputs nixpkgs var; };
      # 设置加载的模块
      modules = [
        ./system

        # 引入 home-manager 的模块
        home-manager.nixosModules.home-manager

        # 引入 agenix 模块
        agenix.nixosModules.default

        # 引用 nix-flatpak 模块
        nix-flatpak.nixosModules.nix-flatpak

        # 密钥文件引入
        (./secrets + "/${name}")

      ] ++ (autoload "${name}");
    };
  in
  {
    nixosConfigurations = {
      # 桌面环境主机配置
      desktop = mkSystem "desktop";

      # 虚拟机配置环境
      vm = mkSystem "vm";
    };
  };
}
