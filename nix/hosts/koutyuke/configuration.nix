{ pkgs, ... }:
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
    cleanmymac
    istat-menus
    microsoft-teams
    pronotes
  ];

  homebrew = {
    casks = [
      "aws-vpn-client"
    ];
    masApps = {
      "Goodnotes" = 1444383602;
      "Prime Video" = 545519333;
    };
  };
}
