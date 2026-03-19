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
            echo "✅ Done! Run 'darwin-rebuild switch --flake .' to apply changes."
          ''
        );
      };

      apps.update-gui = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "update-gui-apps" ''
            set -euo pipefail

            echo "🔄 Updating flake inputs (includes brew-api for latest cask versions)..."
            nix flake update

            echo ""
            echo "🖥️  Rebuilding darwin configuration (triggers Homebrew cask updates)..."
            darwin-rebuild switch --flake .

            echo ""
            echo "🍎 Updating Mac App Store apps..."
            mas upgrade

            echo ""
            echo "🧹 Running garbage collection..."
            nix-collect-garbage -d

            echo ""
            echo "✅ All GUI apps have been updated!"
          ''
        );
      };
    };
}
