{ pkgs, ... }:
{
  programs = {
    _1password = {
      enable = true;
    };
    _1password-gui = {
      enable = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    casks = [
    ];
  };
}
