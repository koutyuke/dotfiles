_: {
  perSystem =
    { pkgs, ... }:
    {
      apps.update = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "update-and-gc" ''
            set -euo pipefail

            host="''${1:-koutyuke}"

            echo "🔐 Caching sudo credentials..."
            sudo -v

            echo ""
            echo "🔄 Updating flake inputs..."
            nix flake update

            echo ""
            echo "🛠️ Applying system updates managed by nix-darwin/home-manager for host '$host'..."
            sudo darwin-rebuild switch --flake ".#$host"

            echo ""
            echo "🧹 Running garbage collection..."
            sudo nix-collect-garbage -d

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

            host="''${1:-koutyuke}"

            echo "🔐 Caching sudo credentials..."
            sudo -v

            echo ""
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
            echo "🛠️ Applying GUI updates managed by nix-darwin/home-manager for host '$host'..."
            sudo darwin-rebuild switch --flake ".#$host"

            echo ""
            echo "🧹 Running garbage collection..."
            sudo nix-collect-garbage -d

            echo ""
            echo "✅ GUI application updates have been applied."
          ''
        );
      };
    };
}
