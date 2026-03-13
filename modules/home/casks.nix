{ pkgs, ... }:
{
  home.packages = [
    pkgs.brewCasks."1password"
  ]
  ++ (with pkgs.brewCasks; [
    appcleaner
    arc
    azookey
    canva
    chatgpt
    clipy
    cursor
    dbvisualizer
    devtoys
    figma
    ghostty
    jordanbaird-ice
    karabiner-elements
    keyboardcleantool
    monitorcontrol
    mos
    notion
    notunes
    orbstack
    postman
    raycast
    spotify
    the-unarchiver
    visual-studio-code
    zoom
  ]);
}
