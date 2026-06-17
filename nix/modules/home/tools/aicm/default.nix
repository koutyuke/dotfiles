{ pkgs, ... }:
let
  aicm = pkgs.writeShellApplication {
    name = "aicm";
    runtimeInputs = with pkgs; [
      coreutils
      git
      gnugrep
      gnused
      jq
      llm-agents.codex
      llm-agents.claude-code
      ollama
    ];
    text = ''
      ${builtins.readFile ./aicm.sh}
    '';
  };
in
{
  home.packages = [ aicm ];
}
