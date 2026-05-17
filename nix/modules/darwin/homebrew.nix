{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };

    casks = [
      # Managed by Homebrew via nix-darwin because Arc browser works best when installed in /Applications via Homebrew, ensuring proper app integration and updates.
      "arc"

      # Managed by Homebrew via nix-darwin because some applications must be placed in /Applications directory to work properly, and installing via nix-darwin's programs sometimes does not provide the latest version.
      "1password"

      # Managed by Homebrew via nix-darwin because it is not recognized in settings unless placed in /Applications.
      "azookey"

      "google-chrome"

      # Managed by Homebrew via nix-darwin because the app needs kernel extension/system integration for keyboard remapping.
      "karabiner-elements"

      # Managed by Homebrew via nix-darwin because the app becomes broken when trying to install via brew-nix.
      # "orbstack"
    ];

    masApps = {

    };
  };
}
