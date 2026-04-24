final: prev:
let
  isDarwin = prev.stdenv.hostPlatform.isDarwin;
in
{
  # Work around current upstream direnv test regressions on Darwin.
  # Reported upstream: https://github.com/NixOS/nixpkgs/issues/507531
  # TODO: Remove this once the upstream issue is fixed.
  direnv =
    if isDarwin then
      prev.direnv.overrideAttrs (_: {
        doCheck = false;
      })
    else
      prev.direnv;
}
