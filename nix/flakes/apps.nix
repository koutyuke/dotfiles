_: {
  perSystem =
    { pkgs, ... }:
    {
      apps.update = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "update-and-gc" ''
            set -euo pipefail

            echo "🔄 Updating flake inputs..."
            nix flake update

            echo ""
            echo "🧹 Running garbage collection..."
            nix-collect-garbage -d

            echo ""
            echo "✅ Flake inputs have been updated. Run 'darwin-rebuild switch --flake .#{hostname}' to apply changes."
          ''
        );
      };
    };
}
