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
  TOOLS = {
    path = ../../../../agents/instructions/TOOLS.md;
    headingStrategy = "drop";
  };
  YOUR_CODE_IS_SO_FAT = {
    path = ../../../../agents/instructions/YOUR_CODE_IS_SO_FAT.md;
    headingStrategy = "demote";
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
      TOOLS
    ];
    targets = {
      antigravity.enable = true;
      claude.enable = true;
      codex.enable = true;

      # opencode はホストごとに有効化する。
      opencode.enable = config.programs.opencode.enable;
    };
    insertH1.enable = true;
  };
}
