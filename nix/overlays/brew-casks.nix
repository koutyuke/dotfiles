final: prev: {
  brewCasks = prev.brewCasks // {
    # undmg fails on DbVisualizer's DMG; 7zz extracts it into DbVisualizer/DbVisualizer.app/.
    dbvisualizer = prev.brewCasks.dbvisualizer.overrideAttrs (_: {
      sourceRoot = "DbVisualizer.app";
      unpackPhase = ''
        set -euo pipefail
        7zz x -snld "$src"
        mv DbVisualizer/DbVisualizer.app .
        find . -maxdepth 1 -type l -delete
      '';
    });

    # Raycast's DMG currently extracts into Raycast/Raycast.app/ instead of Raycast.app/.
    raycast = prev.brewCasks.raycast.overrideAttrs (_: {
      sourceRoot = "Raycast.app";
      unpackPhase = ''
        set -euo pipefail
        7zz x -snld "$src"
        mv Raycast/Raycast.app .
        find . -maxdepth 1 -type l -delete
      '';
    });

    # Postman's download URL omits the .zip suffix, so brew-nix falls back to 7zz and breaks symlinks.
    postman = prev.brewCasks.postman.overrideAttrs (_: {
      unpackPhase = ''
        set -euo pipefail
        unzip "$src"
      '';
    });

    coteditor = prev.brewCasks.coteditor.overrideAttrs (oldAttrs: {
      installPhase = (oldAttrs.installPhase or "") + ''
        cot="$out/Applications/CotEditor.app/Contents/SharedSupport/bin/cot"

        if [ ! -x "$cot" ]; then
          echo "CotEditor cot command not found at $cot" >&2
          exit 1
        fi

        mkdir -p "$out/bin"
        echo "#!${prev.runtimeShell}" > "$out/bin/cot"
        echo "exec \"$cot\" \"\$@\"" >> "$out/bin/cot"
        chmod +x "$out/bin/cot"
      '';
    });

    # Keep the upstream URL and only update the fixed-output hash.
    istat-menus = prev.brewCasks.istat-menus.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-yD9gfObD2z2krFKflq/nalAwY8wh0CtCwx+2f2oRRaY=";
      };
    });

    # Keep the upstream URL and only update the fixed-output hash.
    keyboardcleantool = prev.brewCasks.keyboardcleantool.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-nujha0SzBWI0KaODB91muIdL+nTtuFiwQ3rWKs3bdLY=";
      };
    });

    # Keep the upstream URL and only update the fixed-output hash.
    spotify = prev.brewCasks.spotify.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-NHEoNIFFGMMEYDeHTmIp6dKwvs/JYocmdVEYbJsUj8c=";
      };
    });

    # brew-nix's default unpackPhase uses zcat (gzip), but Teams' .pkg Payload is pbzx-compressed.
    microsoft-teams = prev.brewCasks.microsoft-teams.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ prev.pbzx ];
      unpackPhase = ''
        set -euo pipefail
        xar -xf "$src" MicrosoftTeams_app.pkg/Payload
        pbzx -n MicrosoftTeams_app.pkg/Payload | cpio -idm
      '';
    });
  };
}
