final: prev: {
  brewCasks = prev.brewCasks // {
    # 7zz extracts the DMG into DbVisualizer/DbVisualizer.app/ instead of DbVisualizer.app/
    dbvisualizer = prev.brewCasks.dbvisualizer.overrideAttrs (_: {
      sourceRoot = "DbVisualizer/DbVisualizer.app";
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
        hash = "sha256-uB1860OHQpOeGLNbQqmvEfttTMuU5AdHThEwAA4NEkE=";
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
