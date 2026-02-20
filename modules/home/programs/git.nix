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
    };

    ignores = [
      ".DS_Store"
      "todo.me.md"
    ];
  };
}
