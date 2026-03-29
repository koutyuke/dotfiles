{ pkgs, ... }:
{
  home.packages = [
    pkgs.brewCasks."jordanbaird-ice@beta"
  ]
  ++ (with pkgs; [
    # Shell and search
    eza
    fd
    ripgrep
    tree

    # Nix and environment management
    mise
    nixfmt

    # JavaScript and application development
    act
    bun
    lefthook
    ni
    nodejs_24
    openssl
    postgresql
    watchman

    cocoapods
    uv

    # API and data tools
    httpie
    jnv
    jq
    yq-go

    # Git and repository tools
    delta
    ghq

    # System utilities
    fastfetch
    ffmpeg
    mas

    # GUI applications from nixpkgs
    vscode
  ])
  ++ (with pkgs.llm-agents; [
    codex
  ])
  ++ (with pkgs.brewCasks; [
    canva
    chatgpt
    clipy
    cursor
    dbvisualizer
    devtoys
    figma
    keyboardcleantool
    notion
    notunes
    postman
    spotify
    the-unarchiver
  ]);
}
