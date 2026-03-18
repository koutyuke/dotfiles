{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "uninstall";
    };

    casks = [
      "1password"
    ];
  };
}
