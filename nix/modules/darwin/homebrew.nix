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
