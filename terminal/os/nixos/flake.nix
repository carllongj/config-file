{
  description = "NixOS configuration using flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
    in {
      # 主机配置,nixosConfiguration.<hostname> 中的名称
      # 是作为配置锚点.
      nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
        inherit system;

        # 全局模块列表
        modules = [
          ./system/configuration.nix
          # 启用 Home Manager NixOS 模块
          home-manager.nixosModules.home-manager

          # Home Manager 配置
          {
            home-manager.useGlobalPkgs = true;  # 使用系统 pkgs
            home-manager.useUserPackages = true;

            home-manager.users.carl = {
              imports = [
                ./user/carllongj
              ];
            };
          }
        ];
      };
    };
}

