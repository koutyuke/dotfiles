{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command_timeout = 1000;
      format = builtins.concatStringsSep "" [
        "[](#012A4A)"
        "[  ](bg:#012A4A)"
        "$os"
        "$username"
        "[](fg:#012A4A bg:#043c64)"
        "$directory"
        "[](fg:#043c64 bg:#064f84)"
        "$git_branch"
        "$git_status"
        "[](fg:#064f84 bg:#2A6F97)"
        "$c"
        "$elixir"
        "$elm"
        "$golang"
        "$gradle"
        "$haskell"
        "$java"
        "$julia"
        "$nodejs"
        "$bun"
        "$nim"
        "$rust"
        "$scala"
        "[](fg:#2A6F97 bg:#468FAF)"
        "$docker_context"
        "[](fg:#468FAF bg:#61A5C2)"
        "$time"
        "[ ](fg:#61A5C2)\n"
        "$character\n"
      ];

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[<<](bold green)";
        vimcmd_replace_one_symbol = "[<<](bold purple)";
        vimcmd_replace_symbol = "[<<](bold purple)";
        vimcmd_visual_symbol = "[<<](bold yellow)";
      };

      username = {
        show_always = true;
        style_user = "bg:#012A4A";
        style_root = "bg:#012A4A";
        format = "[$user ]($style)";
        disabled = false;
      };

      os = {
        style = "bg:#012A4A";
        disabled = true;
      };

      directory = {
        style = "bg:#043c64";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Developer" = "󰲳 ";
        };
      };

      bun = {
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#468FAF";
        format = "[ $symbol $context ]($style)$path";
      };

      elixir = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      elm = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      git_branch = {
        symbol = "";
        style = "bg:#064f84";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#064f84";
        format = "[$all_status$ahead_behind ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      gradle = {
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      julia = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
        detect_files = [
          "package.json"
          ".node-version"
          "!bunfig.toml"
          "!bun.lockb"
        ];
      };

      nim = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      scala = {
        symbol = " ";
        style = "bg:#2A6F97";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#61A5C2";
        format = "[  $time ]($style)";
      };
    };
  };
}
