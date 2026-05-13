{ pkgs, ... }:
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
    ]
    ++ (with pkgs.brewCasks; [
    ]);

  programs = {
    git = {
      settings = {
        user = {
          name = "koutyuke";
          email = "75959529+koutyuke@users.noreply.github.com";
          signingKey = ""; # GPG key ID: gpg --list-secret-keys --keyid-format=long
        };
        github = {
          user = "koutyuke";
        };
      };
    };
    home-manager = {
      enable = true;
    };
  };

}
