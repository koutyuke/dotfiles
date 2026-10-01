{
  programs.agent-skills = {
    sources = {
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
      yomiyasu = {
        input = "yomiyasu-skills";
        subdir = "skills";
      };
      orca = {
        input = "orca-skills";
        subdir = "skills";
      };
    };

    skills = {
      enable = [
        "yomiyasu"
        "herdr"
        "orca-cli"
        "orchestration"
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
          path = "empirical-prompt-tuning";
        };
        tech-article-reproducibility = {
          from = "mizchi";
          path = "tech-article-reproducibility";
        };
        nix-setup = {
          from = "mizchi";
          path = "nix-setup";
        };
      };
    };
  };
}
