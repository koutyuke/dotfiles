{
  config,
  inputs,
  ...
}:
let
  COMMON = {
    path = ../../../../agents/instructions/COMMON.md;
    headingStrategy = "drop";
  };
  CONTEXT7 = {
    path = ../../../../agents/instructions/CONTEXT7.md;
    headingStrategy = "demote";
  };
  CODEX = {
    path = ../../../../agents/instructions/CODEX.md;
    headingStrategy = "drop";
  };
in
{
  imports = [
    inputs.agent-instructions.homeManagerModules.default
  ];

  programs.agent-instructions = {
    enable = true;
    sources = [
      COMMON
      CONTEXT7
    ];
    targets = {
      antigravity.enable = true;
      claude.enable = true;
      codex = {
        enable = true;
        sources = [
          CODEX
        ];
      };
      # opencode はホストごとに有効化する。
      opencode.enable = config.programs.opencode.enable;
    };
    insertH1.enable = true;
  };
}
