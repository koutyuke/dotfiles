{
  programs.agent-skills = {
    sources = {
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
      i-have-adhd = {
        input = "i-have-adhd-skills";
        subdir = "skills";
      };
    };

    skills = {
      enable = [
        "i-have-adhd"
        "yomiyasu"
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
    targets = {
      antigravity = {
        enable = true;
        dest = "$HOME/.gemini/config/skills";
      };
    };
  };
}
