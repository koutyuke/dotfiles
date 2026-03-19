{ inputs, ... }:
{
  system,
  hostConfiguration,
  modules ? [ ],
  specialArgs ? { },
  overlays ? [ ],
}:
assert builtins.pathExists hostConfiguration;
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [
    hostConfiguration
    inputs.home-manager.darwinModules.home-manager
    inputs.brew-nix.darwinModules.default
    (
      { ... }:
      {
        nixpkgs.overlays = overlays;
      }
    )
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
    }
  ]
  ++ modules;

  specialArgs = specialArgs // {
    inherit inputs system;
  };
}
