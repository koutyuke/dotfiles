{
  inputs,
  pkgs,
  system,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${system};
  aicm = pkgs.writeShellApplication {
    name = "aicm";
    runtimeInputs = with pkgs; [
      coreutils
      git
      gnugrep
      gnused
      jq
      llmAgents.codex
      llmAgents.claude-code
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
