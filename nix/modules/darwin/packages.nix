{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      curl
      git
      gnused
      vim
      wget
    ]
    ++ (with pkgs.brewCasks; [
      alt-tab
      appcleaner
      raycast
      monitorcontrol
      mos
      zoom
    ]);
}
