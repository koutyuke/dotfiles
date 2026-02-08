{ pkgs, ... }:
{
  home.username = "kousuke";
  home.homeDirectory = "/Users/kousuke";

  home.stateVersion = "25.11";
  home.packages = [ ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "koutyuke";
        email = "gunji.kousuke08@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      github = {
        user = "koutyuke";
      };
    };
    ignores = [ ".DS_Store" ];
  };

  programs.home-manager.enable = true;
}
