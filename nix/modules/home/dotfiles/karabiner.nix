{
  config,
  lib,
  ...
}:
let
  sourceDirectory = "${config.me.dotfiles.root}/karabiner";
  targetDirectory = "${config.xdg.configHome}/karabiner";
in
{
  home.activation.linkKarabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e "${targetDirectory}" ] && [ ! -L "${targetDirectory}" ]; then
      echo "Refusing to replace non-symlink Karabiner config: ${targetDirectory}" >&2
      echo "Move it away manually, then run home-manager activation again." >&2
      exit 1
    fi

    mkdir -p "$(dirname "${targetDirectory}")"
    ln -sfn "${sourceDirectory}" "${targetDirectory}"
  '';
}
