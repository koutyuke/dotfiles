{ inputs, ... }:
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;

    sources.dotfiles.path = ../../../../agents/skills;
    skills.enable = [
      "compare-options"
      "docs-that-work"
    ];

    targets = {
      agents.enable = true;
      claude.enable = true;
    };
  };
}
