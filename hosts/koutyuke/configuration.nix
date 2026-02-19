{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  system = {
    primaryUser = "kousuke";
    stateVersion = 6;
  };

  users.users = {
    kousuke.home = "/Users/kousuke";
    
  };

  home-manager.users = {
    kousuke = ./users/kousuke/home.nix;
  };

  networking = {
    computerName = "koutyuke's MacBook Pro";
    hostName = "koutyuke";
    localHostName = "koutyuke";
  };
}
