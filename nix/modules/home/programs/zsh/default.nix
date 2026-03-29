{ ... }:
let
  readDir =
    dir:
    let
      entries = builtins.readDir dir;
    in
    map (name: builtins.readFile (dir + "/${name}")) (
      builtins.filter (name: entries.${name} == "regular") (builtins.attrNames entries)
    );
in
{
  imports = [
    ./alias.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
      [
        (builtins.readFile ./config.zsh)
      ]
      ++ (readDir ./functions)
    );
  };
}
