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
            echo "✅ Flake inputs have been updated. Run 'nix run .#upgrade' to apply changes."
          ''
        );
      };

      apps.upgrade = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "upgrade-system-and-apps" ''
            set -euo pipefail

            echo ""
            echo "🖥️  Rebuilding darwin configuration (updates nix packages and Homebrew-managed apps)..."
            darwin-rebuild switch --flake .

            echo ""
            echo "🍎 Updating Mac App Store apps..."
            mas upgrade

            echo ""
            echo "🧹 Running garbage collection..."
            nix-collect-garbage -d

            echo ""
            echo "✅ System packages and GUI apps have been applied."
          ''
        );
      };

    };
}
