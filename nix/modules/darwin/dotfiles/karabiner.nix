{ config, ... }:
let
  primaryUser = config.system.primaryUser;
  homeDirectory = config.users.users.${primaryUser}.home;
  repoRoot = "${homeDirectory}/Desktop/projects/koutyuke/dotfiles";
  sourceDirectory = "${repoRoot}/karabiner";
  targetDirectory = "${homeDirectory}/.config/karabiner";
in
{
  system.activationScripts.postActivation.text = ''
    mkdir -p "${homeDirectory}/.config"

    if [ -e "${targetDirectory}" ] && [ ! -L "${targetDirectory}" ]; then
      rm -rf "${targetDirectory}"
    fi

    ln -sfn "${sourceDirectory}" "${targetDirectory}"
    chown -h ${primaryUser}:staff "${targetDirectory}"
  '';
}
