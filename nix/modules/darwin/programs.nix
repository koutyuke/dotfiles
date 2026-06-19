{ ... }:
{
  programs = {
    _1password = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableBashCompletion = false;
      enableGlobalCompInit = false;
      promptInit = "";
    };
  };
}
