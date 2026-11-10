{
  description = "Grape's humble computer cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dux-files = {
      url = "github:duxlabs-dev/dux-files";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brave = {
      url = "git+https://codeberg.org/buckley310/brave-browser-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    montrose = {
      url = "github:grapeofwrath/montrose";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    stable,
    home-manager,
    ...
  }: let
    gLib = {
      scanPaths = path:
        map (f: (path + "/${f}"))
        (builtins.attrNames
          (nixpkgs.lib.attrsets.filterAttrs
            (
              path: _type:
                (_type == "directory")
                || (
                  (path != "default.nix") && (nixpkgs.lib.strings.hasSuffix ".nix" path)
                )
            ) (builtins.readDir path)));
      scanFiles = path:
        map (f: (path + "/${f}")) (builtins.attrNames (builtins.readDir path));
    };
    defaultUser = "marcus";
    systems = [
      "grapelab" #homelab
      "grapespire" #laptop
      "grapecontrol" #vps
    ];
  in {
    nixosConfigurations = {
      "grapecontrol" = let hostName = "grapecontrol"; in nixpkgs.lib.nixosSystem {
        specialArgs = let
          system = "x86_64-linux";
        in {
          pkgs-stable = import stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs stable defaultUser hostName gLib;
        };
        modules = [
          ./nixos/${hostName}
        ];
      };
      "grapelab" = let hostName = "grapelab"; in nixpkgs.lib.nixosSystem {
        specialArgs = let
          system = "x86_64-linux";
        in {
          pkgs-stable = import stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs stable defaultUser hostName gLib;
        };
        modules = [
          ./nixos/${hostName}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${defaultUser} = import ./home/${hostName};
            home-manager.extraSpecialArgs = {inherit inputs defaultUser gLib;};
          }
        ];
      };
      "grapespire" = let hostName = "grapespire"; in nixpkgs.lib.nixosSystem {
        specialArgs = let
          system = "x86_64-linux";
        in {
          pkgs-stable = import stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs stable defaultUser hostName gLib;
        };
        modules = [
          ./nixos/${hostName}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${defaultUser} = import ./home/${hostName};
            home-manager.extraSpecialArgs = {inherit inputs defaultUser gLib;};
          }
        ];
      };
    };
  };
}
