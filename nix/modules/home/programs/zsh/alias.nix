{ ... }:
{
  programs.zsh = {
    shellAliases = {
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        cdr = "cd $(git rev-parse --show-toplevel)";
        l = "eza --icons=auto --group-directories-first";
        la = "eza --icons=auto --group-directories-first -a";
        ll = "eza --icons=auto --group-directories-first -hla";
        lt = "eza --icons=auto --group-directories-first -aTL1";
        o = "open";

        # docker compose
        dc = "docker compose";
        dcu = "docker compose up";
        dcd = "docker compose down";

        # nix aliases
        ns = "nix-shell";
        ngc = "nix-collect-garbage";
      };
    };

    initContent = ''
      unalias l la ll lt 2>/dev/null
    '';
  };
}
