{ inputs, ... }:
let
  mkDarwinSystem = import ../lib/mk-darwin-system.nix { inherit inputs; };
in
{
  flake = {
    darwinConfigurations = {
      koutyuke = mkDarwinSystem {
        system = "aarch64-darwin";
        hostConfiguration = ../hosts/koutyuke/configuration.nix;
        overlays = [
          (import ../overlays/packages.nix)
        ];
      };
      cybozu = mkDarwinSystem {
        system = "aarch64-darwin";
        hostConfiguration = ../hosts/cybozu/configuration.nix;
        overlays = [
          (import ../overlays/packages.nix)
        ];
      };
    };
  };
}
