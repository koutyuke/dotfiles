final: prev: {
  brewCasks = prev.brewCasks // {
    spotify = prev.brewCasks.spotify.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        # Keep the upstream URL and only update the fixed-output hash.
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-uB1860OHQpOeGLNbQqmvEfttTMuU5AdHThEwAA4NEkE=";
      };
    });
    keyboardcleantool = prev.brewCasks.keyboardcleantool.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        # Keep the upstream URL and only update the fixed-output hash.
        url = builtins.head oldAttrs.src.urls;
        hash = "sha256-nujha0SzBWI0KaODB91muIdL+nTtuFiwQ3rWKs3bdLY=";
      };
    });
  };
}
