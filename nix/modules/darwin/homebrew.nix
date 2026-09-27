{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      extraFlags = [ "--force-cleanup" ];
    };

    casks = [
      "1password"
      "alt-tab"
      "appcleaner"
      "arc"
      "azookey"
      "canva"
      "chatgpt"
      "claude"
      "coteditor"
      "dbvisualizer"
      "devtoys"
      "figma"
      "ghostty"
      "google-chrome"
      "iina"
      "jordanbaird-ice@beta"
      "karabiner-elements"
      "keyboardcleantool"
      "monitorcontrol"
      "mos"
      "nani"
      "notion"
      "notunes"
      "stablyai/orca/orca"
      "postman"
      "raycast"
      "spotify"
      "the-unarchiver"
      "zed"
      "zoom"
    ];

    masApps = {

    };
  };
}
