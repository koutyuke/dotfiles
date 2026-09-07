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
      enable = [
        "compare-options"
        "docs-that-work"
        "herdr"
      ];
      explicit = {
        grill-me = {
          from = "mattpocock";
          path = "productivity/grill-me";
        };
        grilling = {
          from = "mattpocock";
          path = "productivity/grilling";
        };
        grill-with-docs = {
          from = "mattpocock";
          path = "engineering/grill-with-docs";
        };
        empirical-prompt-tuning = {
          from = "mizchi";
          path = "meta/empirical-prompt-tuning";
        };
        tech-article-reproducibility = {
          from = "mizchi";
          path = "meta/tech-article-reproducibility";
        };
        nix-setup = {
          from = "mizchi";
          path = "tooling/nix-setup";
        };
      };
    };

    targets = {
      agents.enable = true;
      claude.enable = true;
    };
  };
}
