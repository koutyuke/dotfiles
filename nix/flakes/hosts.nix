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
          inputs.brew-nix.overlays.default
          inputs.llm-agents.overlays.default
          (import ../overlays/brew-casks.nix)
          (import ../overlays/packages.nix)
        ];
      };
    };
  };
}
