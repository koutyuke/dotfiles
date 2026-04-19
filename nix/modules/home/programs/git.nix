{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      core = {
        editor = "nvim";
        pager = "delta";
      };

      commit = {
        gpgSign = true;
      };

      delta = {
        dark = true;
        syntax-theme = "Catppuccin Mocha";
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        keep-plus-minus-markers = true;
        hunk-header-style = "file line-number syntax";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      diff = {
        colorMoved = "default";
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
      ".koutyuke"
    ];
  };
}
