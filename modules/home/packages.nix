{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLI tools
    act
    bun
    ffmpeg
    fd
    ghq
    httpie
    jq
    lefthook
    neofetch
    ni
    nodejs_24
    openssl
    ripgrep
    tree
    watchman
    yq-go

    # Development tools
    cocoapods
    mise
    uv
  ];
}
