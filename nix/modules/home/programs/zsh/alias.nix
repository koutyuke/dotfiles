{ ... }:
{
  programs.zsh = {
    shellAliases = {
      cd = "z";
      ls = "eza --icons=auto --group-directories-first";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
        cdi = "zi";
        cdr = "cd $(git rev-parse --show-toplevel)";
        la = "ls -a";
        ll = "ls -alh";
        lt = "ls -aTL1";
        o = "open";
        cwd = "copypath";
        gwd = "open -a ghostty $PWD";
        tm = "tmux";

        # git
        g = "git";
        lzg = "lazygit";

        # docker
        lzd = "lazydocker";
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
