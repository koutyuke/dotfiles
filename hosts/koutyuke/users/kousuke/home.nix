{ pkgs, ... }:
{
  imports = [
    ../../../../modules/home
  ];

  home.username = "kousuke";
  home.homeDirectory = "/Users/kousuke";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    awscli2
    databricks-cli
  ];

  programs.home-manager.enable = true;
}
