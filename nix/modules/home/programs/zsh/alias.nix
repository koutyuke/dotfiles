{ ... }:
{
  programs.zsh = {
    shellAliases = {
      proot = "cd $(git rev-parse --show-toplevel)";

      # ls = "eza --icons=auto";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        l = "eza --icons=auto --group-directories-first -h";
        la = "l -a";
        ll = "l -l -a";
        lt = "l --tree";
      };
    };
  };
}
