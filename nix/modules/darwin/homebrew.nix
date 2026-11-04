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
      "postman"
      "raycast"
      "spotify"
      "t3-code"
      "the-unarchiver"
      "zed"
      "zoom"
    ];

    masApps = {

    };
  };
}
