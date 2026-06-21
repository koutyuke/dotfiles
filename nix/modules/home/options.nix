{
  config,
  lib,
  ...
}:
{
  options.me.dotfiles = {
    projectsRoot = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Developer";
      description = "The root directory where projects are stored.";
    };

    root = lib.mkOption {
      type = lib.types.str;
      default = "${config.me.dotfiles.projectsRoot}/github.com/koutyuke/dotfiles";
      description = "The path where this dotfiles repository is located.";
    };
  };

  options.me.project = {
    personalDirectoryName = lib.mkOption {
      type = lib.types.str;
      default = ".koutyuke";
      description = "The name of the Git-ignored directory for personal files in each project.";
    };
  };

  config.home.sessionVariables = {
    DOTFILES_DIR = config.me.dotfiles.root;
  };
}
