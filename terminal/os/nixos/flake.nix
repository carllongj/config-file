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

    # 设置模块对应的目录.
    modulesDirectory = ./modules;

    # 递归加载该模块下的所有 .nix 文件模块.
    moduleConfigurations = lib.filesystem.listFilesRecursive modulesDirectory|>
      builtins.filter (path: lib.hasSuffix ".nix" (builtins.baseNameOf path));

    # 引入定义的配置变量.
    var = import ./config { inherit lib; };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
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
        ./secrets

      ] ++ moduleConfigurations;
    };
  };
}
