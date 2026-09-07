{ inputs, ... }:
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;

    sources = {
      koutyuke = {
        input = "koutyuke-skills";
        subdir = "skills";
      };
      herdr = {
        input = "herdr-skills";
        subdir = "skills";
      };
      mattpocock = {
        input = "mattpocock-skills";
        subdir = "skills";
      };
      mizchi = {
        input = "mizchi-skills";
      };
    };

    skills = {
      enableAll = [ "koutyuke" ];
      enable = [
        "herdr"
        "productivity/grill-me"
        "productivity/grilling"
        "engineering/grill-with-docs"
        "meta/empirical-prompt-tuning"
        "meta/tech-article-reproducibility"
        "tooling/nix-setup"
      ];
    };

    targets = {
      agents.enable = true;
      claude.enable = true;
    };
  };
}
