_: {
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";

        programs = {
          # nix
          nixpkgs-fmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
        };
      };
    };
}
