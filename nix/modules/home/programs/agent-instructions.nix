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
    fragments = [
      COMMON
      CONTEXT7
    ];
    targets = {
      claude.enable = true;
      codex = {
        enable = true;
        fragments = [
          CODEX
        ];
      };
      # opencode はホストごとに有効化する。
      opencode.enable = config.programs.opencode.enable;
    };
    insertH1.enable = true;
  };
}
