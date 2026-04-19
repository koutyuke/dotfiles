{
  config,
  lib,
  pkgs,
  ...
}:
let
  repoRoot = "${config.home.homeDirectory}/Desktop/projects/koutyuke/dotfiles";
  nvimSourceDir = "${repoRoot}/nvim";
  nvimConfigDir = "${config.xdg.configHome}/nvim";
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      bash-language-server
      lua-language-server
      nixd
      shellcheck
      shfmt
      stylua
    ];
  };

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e "${nvimConfigDir}" ] && [ ! -L "${nvimConfigDir}" ]; then
      rm -rf "${nvimConfigDir}"
    fi

    mkdir -p "$(dirname "${nvimConfigDir}")"
    ln -sfn "${nvimSourceDir}" "${nvimConfigDir}"
  '';
}
