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

  environment.systemPackages = with pkgs.brewCasks; [
    aldente
    aws-vpn-client
    cleanmymac
    istat-menus
    microsoft-teams
  ];

  homebrew = {
    masApps = {
      "Goodnotes" = 1444383602;
      "Kindle" = 302584613;
      "Prime Video" = 545519333;
      "Windows App" = 1295203466;
    };
  };
}
