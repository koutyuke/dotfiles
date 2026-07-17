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
    computerName = "koutyuke's MacBook Pro for Cybozu";
    hostName = "cybozu-koutyuke";
    localHostName = "cybozu-koutyuke";
  };

  homebrew = {
    brews = [
      {
        name = "ollama";
        restart_service = "changed";
      }
    ];
    casks = [
      "docker-desktop"
      "intellij-idea"
      "jetbrains-toolbox"
      "pronotes"
      "stats"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Dropover" = 1355679052;
      # "iMovie" = 408981434;
      # "Keynote" = 409183694;
      "Magnet" = 441258766;
      # "Numbers" = 409203825;
      # "Pages" = 409201541;
    };
  };
}
