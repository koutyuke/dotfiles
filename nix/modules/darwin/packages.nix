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
      appcleaner
      arc
      raycast
      monitorcontrol
      mos
      zoom
    ]);
}
