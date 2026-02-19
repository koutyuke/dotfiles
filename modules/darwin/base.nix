{ inputs, pkgs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Using DetermineSystems/nix-installer to install Nix
  nix = {
    enable = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    wget
  ];

  programs = {
    zsh = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  time.timeZone = "Asia/Tokyo";
}
