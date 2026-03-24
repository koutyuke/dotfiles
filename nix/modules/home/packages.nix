{ pkgs, ... }:
{
  home.packages = [
    pkgs.brewCasks."jordanbaird-ice@beta"
  ]
  ++ (with pkgs; [
    # CLI tools
    act
    bun
    ffmpeg
    fd
    ghq
    httpie
    jq
    lefthook
    mas
    fastfetch
    ni
    nodejs_24
    openssl
    ripgrep
    tree
    watchman
    yq-go
    postgresql

    # Development tools
    cocoapods
    mise
    uv
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
