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
            echo "🛠️ Applying system updates managed by nix-darwin/home-manager..."
            darwin-rebuild switch --flake .#koutyuke

            echo ""
            echo "🧹 Running garbage collection..."
            nix-collect-garbage -d

            echo ""
            echo "✅ Flake inputs have been updated and system updates have been applied."
          ''
        );
      };

      apps.update-gui = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "update-gui" ''
            set -euo pipefail

            echo "🔄 Updating brew-api input for brewCasks..."
            nix flake update brew-api

            echo ""
            echo "🍺 Updating Homebrew metadata..."
            brew update

            echo ""
            echo "🖥️ Upgrading Homebrew casks..."
            brew upgrade --cask

            echo ""
            echo "🏪 Upgrading Mac App Store apps..."
            mas upgrade

            echo ""
            echo "🛠️ Applying GUI updates managed by nix-darwin/home-manager..."
            darwin-rebuild switch --flake .#koutyuke

            echo ""
            echo "🧹 Running garbage collection..."
            nix-collect-garbage -d

            echo ""
            echo "✅ GUI application updates have been applied."
          ''
        );
      };
    };
}
