{
  description = "NixOS configuration with auto-module loading";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 引入 home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    # 设置模块对应的目录.
    modulesDirectory = ./modules;

    # 递归加载该模块下的所有 .nix 文件模块.
    moduleConfigurations = lib.filesystem.listFilesRecursive modulesDirectory|>
      builtins.filter (path: lib.hasSuffix ".nix" (builtins.baseNameOf path));

    # 定义变量的属性集合.
    var = {
      # 全局配置用户名(系统用户以及git中配置的用户名).
      username = "carllongj";

      # 设置全局代理的地址.
      # proxy = "<http_proxy_addr>";

      # git 环境变量配置.
      git = {
        # 设置git 使用的用户名,若未设置则使用 var.username.
        # username = "<set git username>";

        # 设置 git 使用的邮箱地址.
        # email = "<set git email>"

        # 设置 git 配置的代理服务器(github).
        # proxy = "<git_proxy_addr>";
      };
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      # 将变量收集一并传递给模块.
      specialArgs = { inherit inputs var; };
      # 设置加载的模块
      modules = [
        ./system

        # 引入 home-manager 的模块
        home-manager.nixosModules.home-manager
      ] ++ moduleConfigurations;
    };
  };
}
