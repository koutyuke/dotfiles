{
  config,
  pkgs,
  ...
}:
let
  home = config.home.homeDirectory;
in
{
  programs.bun = {
    enable = true;
    settings = {
      install = {
        minimumReleaseAge = 259200;
      };
      telemetry = false;
    };
  };

  home.packages = with pkgs; [
    nodejs_24
    pnpm
  ];

  home.sessionVariables = {
    BUN_INSTALL = "${home}/.bun";
    NPM_CONFIG_PREFIX = "${home}/.local/share/npm";
    PNPM_HOME = "${home}/.local/share/pnpm";
  };

  home.sessionPath = [
    "${home}/.bun/bin"
    "${home}/.local/share/npm/bin"
    "${home}/.local/share/pnpm"
  ];

  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: 4320
  '';
}
