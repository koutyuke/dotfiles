{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../modules/home
    ./programs
  ];

  home.username = "koutyuke";
  home.homeDirectory = "/Users/koutyuke";

  home.stateVersion = "25.11";
  home.sessionVariables.OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = "true";

  me = {
    dotfiles = {
      projectsRoot = "${config.home.homeDirectory}/Developer";
      root = "${config.me.dotfiles.projectsRoot}/github.com/koutyuke/dotfiles";
    };
    project.personalDirectoryName = ".koutyuke";
  };

  home.packages = with pkgs; [
    awscli2
    databricks-cli
    google-cloud-sdk
    ssm-session-manager-plugin
  ];

  programs.home-manager.enable = true;
}
