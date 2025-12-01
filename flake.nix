{
  description = "NixOS configuration with flake and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    niri.url = "github:YaLTeR/niri";

    limine = {
      url = "github:limine-bootloader/limine";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, niri, ... }@inputs: {
    nixosConfigurations = {
      # 默认主机名，可根据需要修改
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos/configuration.nix

          # 模块化配置
          ./modules/system/boot.nix
          ./modules/system/display-manager.nix
          ./modules/system/desktop.nix
          ./modules/system/gaming.nix
          ./modules/system/locale.nix
          ./modules/system/networking.nix
          ./modules/system/packages.nix
          ./modules/system/security.nix

          # home-manager模块
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.laevatein = import ./home;

            # 传递extraSpecialArgs给home-manager
            home-manager.extraSpecialArgs = { inherit inputs; };
          }

          # catppuccin主题
          catppuccin.nixosModules.catppuccin
        ];
      };
    };
  };
}
