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

    unfocused-split-opacity = 0.72;
    unfocused-split-fill = "#000000";
    split-divider-color = "#7a7a7a";

    # Quick Terminal
    quick-terminal-position = "center";
    quick-terminal-size = "50%,500px";
    quick-terminal-autohide = true;

    keybind = [
      # Quick Terminal
      "global:cmd+backquote=toggle_quick_terminal"

      # Move Pane
      "ctrl+option+h=goto_split:left"
      "ctrl+option+l=goto_split:right"
      "ctrl+option+j=goto_split:down"
      "ctrl+option+k=goto_split:up"

      # Resize Pane (40px unit)
      "cmd+ctrl+h=resize_split:left,40"
      "cmd+ctrl+l=resize_split:right,40"
      "cmd+ctrl+k=resize_split:up,40"
      "cmd+ctrl+j=resize_split:down,40"

      # tmux: Cmd+hjkl → C-b + ←↓↑→ (pane move)
      # "cmd+h=text:\\x02\\x1b[D"
      # "cmd+j=text:\\x02\\x1b[B"
      # "cmd+k=text:\\x02\\x1b[A"
      # "cmd+l=text:\\x02\\x1b[C"

      # tmux: Cmd+d → C-b | (split horizontal), Cmd+Shift+d → C-b - (split vertical)
      # "cmd+d=text:\\x02%"
      # "cmd+shift+d=text:\\x02\""

      # tmux: Cmd+Shift+w → C-b w (kill pane without confirmation)
      # "cmd+shift+w=text:\\x02X"
    ];
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
