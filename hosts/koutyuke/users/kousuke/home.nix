{ pkgs, ... }:
{
  imports = [
    ../../../../modules/home
  ];

  home.username = "kousuke";
  home.homeDirectory = "/Users/kousuke";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    awscli2
    databricks-cli
  ];

  programs = {
    git = {
      settings = {
        user = {
          name = "koutyuke";
          email = "75959529+koutyuke@users.noreply.github.com";
          signingKey = "9FDB1C649817A245"; # GPG key ID: gpg --list-secret-keys --keyid-format=long

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
