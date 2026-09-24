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
      root = "${config.me.dotfiles.projectsRoot}/github.com/koutyuke/dotfiles";
    };
    project.personalDirectoryName = ".koutyuke";
  };

  home.packages = with pkgs; [
    awscli2
    databricks-cli
    google-cloud-sdk
    ssm-session-manager-plugin
  ];

  programs = {
    agent-skills = {
      sources = {
        herdr = {
          input = "herdr-skills";
          subdir = "skills";
        };
        mattpocock = {
          input = "mattpocock-skills";
          subdir = "skills";
        };
        mizchi = {
          input = "mizchi-skills";
        };
      };

      skills = {
        enable = [
          "herdr"
        ];
        explicit = {
          grill-me = {
            from = "mattpocock";
            path = "productivity/grill-me";
          };
          grilling = {
            from = "mattpocock";
            path = "productivity/grilling";
          };
          grill-with-docs = {
            from = "mattpocock";
            path = "engineering/grill-with-docs";
          };
          empirical-prompt-tuning = {
            from = "mizchi";
            path = "meta/empirical-prompt-tuning";
          };
          tech-article-reproducibility = {
            from = "mizchi";
            path = "meta/tech-article-reproducibility";
          };
          nix-setup = {
            from = "mizchi";
            path = "tooling/nix-setup";
          };
        };
      };
    };
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
