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
    nixfmt

    # Application development
    act
    lefthook
    ni
    openssl
    oxfmt
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
    lazydocker

    # System utilities
    fastfetch
    ffmpeg
    mas

    # GUI applications from nixpkgs
    vscode
  ])
  ++ (with pkgs.llm-agents; [
    codex
    claude-code
  ])
  ++ (with pkgs.brewCasks; [
    canva
    chatgpt
    codex-app
    coteditor
    cursor
    dbvisualizer
    devtoys
    figma
    iina
    keyboardcleantool
    nani
    notion
    notunes
    postman
    spotify
    the-unarchiver
    zed
  ]);
}
