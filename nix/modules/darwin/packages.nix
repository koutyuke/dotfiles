{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      vim
      curl
      git
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
