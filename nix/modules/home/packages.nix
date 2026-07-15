{ pkgs, ... }:
{
  home.packages = [
    pkgs.brewCasks."jordanbaird-ice@beta"
  ]
  ++ (with pkgs; [
    # Development tools
    act
    cocoapods
    delta
    eza
    fastfetch
    fd
    ffmpeg
    ghq
    httpie
    jnv
    jq
    lazydocker
    lefthook
    mas
    ni
    openssl
    postgresql
    ripgrep
    tree
    uv
    watchman
    yq-go

    # Linting and formatting
    nixfmt
    oxfmt
    ruff
    shellcheck

    # LSP
    basedpyright
    nixd

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
