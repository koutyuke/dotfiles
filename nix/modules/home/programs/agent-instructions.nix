{
  config,
  inputs,
  ...
}:
let
  BASE = {
    path = ../../../../agents/instructions/BASE.md;
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
  YOUR_CODE_IS_SO_FAT = {
    path = ../../../../agents/instructions/YOUR_CODE_IS_SO_FAT.md;
    headingStrategy = "demote";
  };
  ORCA = {
    path = ../../../../agents/instructions/ORCA.md;
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
      BASE
      YOUR_CODE_IS_SO_FAT
      CONTEXT7
    ];
    targets = {
      antigravity.enable = true;
      claude = {
        enable = true;
        sources = [
          ORCA
        ];
      };
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
