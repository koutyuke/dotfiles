{
  pkgs,
  lib,
  config,
  ...
}:
let
  ghosttySettings = {
    theme = "Catppuccin Mocha";
    font-family = "\"JetBrainsMono Nerd Font Mono\"";
    background-opacity = 0.9;
    background-blur = true;
    macos-icon = "xray";
    macos-option-as-alt = true;
    window-padding-x = 8;

    # Quick Terminal
    keybind = [
      "global:cmd+backquote=toggle_quick_terminal"
    ];
    quick-terminal-position = "center";
    quick-terminal-size = "50%,500px";
    quick-terminal-autohide = true;
  };

  renderGhosttyValue =
    value: if builtins.isBool value then if value then "true" else "false" else toString value;

  ghosttyConfigText = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: value:
      if builtins.isList value then
        lib.concatMapStringsSep "\n" (item: "${name} = ${renderGhosttyValue item}") value
      else
        "${name} = ${renderGhosttyValue value}"
    ) ghosttySettings
  );

  ghosttyAppSupportConfig = "${config.home.homeDirectory}/Library/Application Support/com.mitchellh.ghostty/config";
in
{
  home.packages = lib.mkIf pkgs.stdenv.isDarwin [ pkgs.brewCasks.ghostty ];

  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    enableZshIntegration = true;
    settings = ghosttySettings;
  };

  xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ghosttyConfigText;
  };

  home.activation.linkGhosttyConfig = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      mkdir -p "$(dirname "${ghosttyAppSupportConfig}")"
      ln -sfn "${config.xdg.configHome}/ghostty/config" "${ghosttyAppSupportConfig}"
    ''
  );
}
