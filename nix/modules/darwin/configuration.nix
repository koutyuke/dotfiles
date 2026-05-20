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

  determinateNix = {
    enable = true;
    customSettings = {
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };

  brew-nix = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
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
