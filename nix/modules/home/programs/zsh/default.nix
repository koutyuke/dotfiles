{
  lib,
  ...
}:
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
    completionInit = ":";

    antidote = {
      enable = true;
      plugins = [
        "mattmc3/ez-compinit"
      ];
    };

    sessionVariables = {
      LANG = "ja_JP.UTF-8";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 540 ''
        zstyle ':plugin:ez-compinit' 'compstyle' 'zshzoo'
        zstyle ':plugin:ez-compinit' 'use-cache' 'yes'
      '')
      (lib.mkOrder 1000 (
        builtins.concatStringsSep "\n" (
          [
            (builtins.readFile ./config.zsh)
          ]
          ++ (readDir ./functions)
        )
      ))
    ];
  };
}
