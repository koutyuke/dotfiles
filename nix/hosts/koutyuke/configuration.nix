{ ... }:
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
    computerName = "koutyuke's MacBook Pro";
    hostName = "koutyuke";
    localHostName = "koutyuke";
  };

  homebrew = {
    brews = [
      {
        name = "ollama";
        restart_service = "changed";
      }
    ];
    casks = [
      "aldente"
      "aws-vpn-client"
      "cleanmymac"
      "coconutbattery"
      "discord"
      "istat-menus"
      "microsoft-teams"
      "orbstack"
      "pronotes"
      "typora"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Dropover" = 1355679052;
      "Goodnotes" = 1444383602;
      # "iMovie" = 408981434;
      # "Keynote" = 409183694;
      "Magnet" = 441258766;
      "Microsoft Word" = 462054704;
      # "Numbers" = 409203825;
      # "Pages" = 409201541;
      "Prime Video" = 545519333;
      "Xcode" = 497799835;
    };
  };
}
