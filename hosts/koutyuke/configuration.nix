{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/darwin
  ];
  nixpkgs.config.allowUnfree = true;

  # Using DetermineSystems/nix-installer to install Nix
  nix.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];

  programs = {
    bash = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };

  system = {
    primaryUser = "kousuke";
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users = {
    kousuke = {
      name = "kousuke";
      home = "/Users/kousuke";
    };
  };

  home-manager.users = {
    kousuke = ./users/kousuke/home.nix;
  };

  networking = {
    computerName = "koutyuke's MacBook Pro";
    hostName = "koutyuke";
    localHostName = "koutyuke";
  };

  time.timeZone = "Asia/Tokyo";
}
