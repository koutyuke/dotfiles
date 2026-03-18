{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
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
    ]
    ++ (with pkgs.brewCasks; [
      # appcleaner
      # arc
      # azookey
      # canva
      # chatgpt
      clipy
      # cursor
      # dbvisualizer
      # devtoys
      # figma
      # ghostty
      # jordanbaird-ice
      # karabiner-elements
      # keyboardcleantool
      # monitorcontrol
      # mos
      # notion
      # notunes
      # orbstack
      # postman
      # raycast
      # spotify
      # the-unarchiver
      # visual-studio-code
      # zoom
    ]);
}
