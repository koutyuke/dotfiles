{ config, pkgs, ... }:
{
  imports = [
    ../../../../modules/home
  ];

  home.username = "koutyuke";
  home.homeDirectory = "/Users/koutyuke";

  home.stateVersion = "25.11";

  me = {
    dotfiles = {
      projectsRoot = "${config.home.homeDirectory}/Developer";
      root = "${config.me.dotfiles.projectsRoot}/github/koutyuke/dotfiles";
    };
    project.personalDirectoryName = ".koutyuke";
  };

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
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBk2xkj3CF9EUtfkrLUiicfi3ozSgGEEmT/KECKfvqEy";
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
  };
}
