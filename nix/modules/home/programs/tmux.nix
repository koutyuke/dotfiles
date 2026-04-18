{ ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    extraConfig = ''
      # kill pane without confirmation
      bind X kill-pane
    '';
  };
}
