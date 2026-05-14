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
      awscli2
      databricks-cli
      ssm-session-manager-plugin
    ]
    ++ (with pkgs.brewCasks; [
      coconutbattery
      discord
      typora
    ]);

  programs = {
    git = {
      settings = {
        user = {
          name = "koutyuke";
          email = "75959529+koutyuke@users.noreply.github.com";
          signingKey = "C339D6D586557B3C"; # GPG key ID: gpg --list-secret-keys --keyid-format=long

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
