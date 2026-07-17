{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    git
    gnused
    vim
    wget
  ];
}
