final: prev: {
  direnv = prev.direnv.overrideAttrs (old: {
    env = (old.env or { }) // {
      CGO_ENABLED = "1";
    };
  });

  edencommon = prev.edencommon.overrideAttrs (old: {
    doCheck = false;
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DBUILD_TESTING=OFF" ];
  });

  watchman = prev.watchman.overrideAttrs (old: {
    doCheck = false;
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DBUILD_TESTING=OFF" ];
    buildInputs = (old.buildInputs or [ ]) ++ [ prev.gtest ];
  });
}
