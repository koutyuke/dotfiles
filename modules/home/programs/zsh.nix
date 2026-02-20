{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      proot = "cd $(git rev-parse --show-toplevel)";
      sed = "gsed";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "copypath"
        "sudo"
        "extract"
      ];
    };

    sessionVariables = {
      LANG = "ja_JP.UTF-8";
    };

    initContent = ''
      # ghq + fzf: project switcher
      function prj() {
        local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
        if [ -n "$src" ]; then
          cd $(ghq root)/$src
        fi
      }

      # fzf: local branch switcher
      function fbr() {
        local branches branch
        branches=$(git --no-pager branch -vv) &&
          branch=$(echo "$branches" | fzf +m) &&
          git switch $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
      }

      # fzf: remote branch switcher
      function fbrr() {
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
          branch=$(echo "$branches" |
            fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) &&
          git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
      }
    '';
  };
}
