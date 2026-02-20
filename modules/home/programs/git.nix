{ config, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "koutyuke";
        email = "75959529+koutyuke@users.noreply.github.com";
        signingKey = "9FDB1C649817A245"; # GPG key ID: gpg --list-secret-keys --keyid-format=long
      };
      commit = {
        gpgSign = true;
      };
      tag = {
        gpgSign = true;
      };
      gpg = {
        program = "${config.programs.gpg.package}/bin/gpg2";
      };
      init = {
        defaultBranch = "main";
      };
      github = {
        user = "koutyuke";
      };
    };

    ignores = [
      ".DS_Store"
      "todo.me.md"
    ];
  };
}
