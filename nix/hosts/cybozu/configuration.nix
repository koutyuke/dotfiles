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
    computerName = "koutyuke's MacBook Pro for Cybozu";
    hostName = "cybozu-koutyuke";
    localHostName = "cybozu-koutyuke";
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
