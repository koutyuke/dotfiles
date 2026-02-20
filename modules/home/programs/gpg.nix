{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
  };

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      default-cache-ttl 600
      max-cache-ttl 7200
    '';
  };
}
