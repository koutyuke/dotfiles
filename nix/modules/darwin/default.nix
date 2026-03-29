{ ... }:
{
  imports = [
    ./dotfiles

    ./configuration.nix
    ./homebrew.nix
    ./packages.nix
    ./programs.nix
    ./system.nix
  ];
}
