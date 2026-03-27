{ config, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      commit = {
        gpgSign = true;
      };
      tag = {
        gpgSign = true;
      };
      init = {
        defaultBranch = "main";
      };

      ghq = {
        root = "~/Desktop/projects";
      };
    };

    ignores = [
      ".DS_Store"
      ".direnv"
      ".serena"
      "todo.me.md"
    ];
  };
}
