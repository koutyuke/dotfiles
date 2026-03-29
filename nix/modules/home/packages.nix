{ pkgs, ... }:
{
  home.packages = [
    pkgs.brewCasks."jordanbaird-ice@beta"
  ]
  ++ (with pkgs; [
    # CLI tools
    act
    bun
    eza
    fastfetch
    fd
    ffmpeg
    ghq
    httpie
    jq
    lefthook
    mas
    ni
    nodejs_24
    openssl
    postgresql
    ripgrep
    tree
    watchman
    yq-go

    # Development tools
    cocoapods
    mise
    uv

    # GUI Applications
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
