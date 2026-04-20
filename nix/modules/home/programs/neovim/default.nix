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
  nvimStateDir = "${config.xdg.stateHome}/nvim";
  nvimLogDir = "${nvimStateDir}/log";
in
{
  home.sessionVariables = {
    NVIM_LOG_FILE = "${nvimLogDir}/nvim.log";
    NVIM_TSDK = "${pkgs.typescript}/lib/node_modules/typescript/lib";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      astro-language-server
      bash-language-server
      lua-language-server
      nixd
      shellcheck
      shfmt
      stylua
      typescript
      typescript-language-server
    ];
  };

  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e "${nvimConfigDir}" ] && [ ! -L "${nvimConfigDir}" ]; then
      rm -rf "${nvimConfigDir}"
    fi

    mkdir -p "${nvimLogDir}"
    mkdir -p "$(dirname "${nvimConfigDir}")"
    ln -sfn "${nvimSourceDir}" "${nvimConfigDir}"
  '';
}
