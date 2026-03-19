{ pkgs, ... }:
let
  functionsDir = ./functions;
  functionFiles =
    let
      entries = builtins.readDir functionsDir;
    in
    builtins.map (name: builtins.readFile (functionsDir + "/${name}"))
      (builtins.filter (name: entries.${name} == "regular") (builtins.attrNames entries));
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      proot = "cd $(git rev-parse --show-toplevel)";
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

    initContent = builtins.concatStringsSep "\n" (
      [ (builtins.readFile ./config.zsh) ] ++ functionFiles
    );
  };
}
