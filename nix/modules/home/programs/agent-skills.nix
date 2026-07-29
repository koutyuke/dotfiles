{ inputs, ... }:
let
  skillsRoot = ../../../../agents/skills;
  excludedSkills = [
    "en-to-ja-paper-translator"
  ];
  enabledSkills = builtins.filter (
    name: !builtins.elem name excludedSkills && builtins.pathExists (skillsRoot + "/${name}/SKILL.md")
  ) (builtins.attrNames (builtins.readDir skillsRoot));
in
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;

    sources.dotfiles.path = skillsRoot;
    skills.enable = enabledSkills;

    targets = {
      agents.enable = true;
      claude.enable = true;
    };
  };
}
