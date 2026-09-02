{
  config,
  inputs,
  pkgs,
  system,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${system};
  # 生成した .aicm.json から参照させる安定パス。Nix store のパスは世代ごとに変わり、
  # GC で消えるため、既に生成済みの JSON が壊れないよう ~/.config 側を指す。
  schemaPath = "${config.xdg.configHome}/aicm/aicm.schema.json";
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
      AICM_SCHEMA_PATH=${pkgs.lib.escapeShellArg schemaPath}
      ${builtins.readFile ./aicm.sh}
    '';
  };
in
{
  home.packages = [ aicm ];

  xdg.configFile."aicm/aicm.schema.json".source = ./aicm.schema.json;
}
