{
  description = "koutyuke's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    hostname = "koutyuke";
    username = "kousuke";
    system = "aarch64-darwin";
    hostConfigPath = ./configuration.nix;

    mkDarwinSystem = {
      system,
      username,
      hostname,
      hostConfigPath
    }: nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        hostConfigPath
        home-manager.darwinModules.home-manager
        {
          users.users.${username}.home = "/Users/${username}";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
        }
      ];
      specialArgs = {
        inherit inputs self system;
      };
    };

  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#koutyuke
    darwinConfigurations."${hostname}" = mkDarwinSystem {
      inherit hostname username system hostConfigPath;
    };
  };
}
