{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      proot = "cd $(git rev-parse --show-toplevel)";
      # sed = "gsed";
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

    initContent = builtins.concatStringsSep "\n" [
      # other configs
      (builtins.readFile ./config.zsh)
      # useful functions
      (builtins.readFile ./scripts.zsh)
    ];
  };
}
