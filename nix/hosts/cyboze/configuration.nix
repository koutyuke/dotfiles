{ pkgs, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  system = {
    primaryUser = "koutyuke";
    stateVersion = 6;
  };

  users.users = {
    koutyuke.home = "/Users/koutyuke";
  };

  home-manager.users = {
    koutyuke = ./users/koutyuke/home.nix;
  };

  networking = {
    computerName = "koutyuke's MacBook Pro for Cyboze";
    hostName = "cyboze-koutyuke";
    localHostName = "cyboze-koutyuke";
  };

  environment.systemPackages = with pkgs.brewCasks; [
    stats
    pronotes
  ];

  homebrew = {
    casks = [
    ];
    masApps = {
    };
  };
}
