{ inputs, ... }:
{
  flake = {
    darwinConfigurations = {
      koutyuke =
        let
          system = "aarch64-darwin";
        in
        inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ../configuration.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-bak";
            }
          ];
          specialArgs = {
            inherit inputs system;
          };
        };
    };
  };
}
