{ inputs, pkgs, ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];

  programs.zsh.enable = true;

  system = {
    stateVersion = 6;
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  };

  home-manager.users.kousuke = ./home.nix;
}
