{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../modules/home
  ];

  home.username = "koutyuke";
  home.homeDirectory = "/Users/koutyuke";

  home.stateVersion = "25.11";

  home.packages =
    with pkgs;
    [
      bash
    ]
    ++ (with pkgs.brewCasks; [
      iina
      intellij-idea
      jetbrains-toolbox
      zed
    ]);

  programs = {
    git = {
      settings = {
        user = {
          name = "koutyuke";
          email = "75959529+koutyuke@users.noreply.github.com";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyByIDlc1RwBvu9dOKY0UKldrUrdT7pl5bxGCnO42E6";
        };
        gpg = {
          format = "ssh";
          ssh = {
            program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };
        github = {
          user = "koutyuke";
        };
      };
    };
    home-manager = {
      enable = true;
    };
    zsh = {
      initContent = lib.mkAfter ''
        if [ -r /Users/koutyuke/.config/op/plugins.sh ]; then
          source /Users/koutyuke/.config/op/plugins.sh
        fi
      '';
    };
  };
}
