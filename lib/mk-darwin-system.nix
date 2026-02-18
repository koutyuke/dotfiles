{ inputs, ... }:
{
  system,
  hostConfiguration,
  modules ? [ ],
  specialArgs ? { },
}:
assert builtins.pathExists hostConfiguration;
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [
    hostConfiguration
    inputs.home-manager.darwinModules.home-manager
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
