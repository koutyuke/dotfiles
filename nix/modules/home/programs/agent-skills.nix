{ inputs, ... }:
{
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  # 業務環境では個人 Skill 以外を入れられないため、共通には koutyuke-skills だけを置く。
  # 外部 Skill はホストごとの home.nix で追加する。
  programs.agent-skills = {
    enable = true;

    sources = {
      koutyuke = {
        input = "koutyuke-skills";
        subdir = "skills";
      };
    };

    skills.enable = [
      "docs-that-work"
      "drill-me"
      "teacher-prompt"
      "twintail"
      "weigh-in"
    ];

    targets = {
      agents.enable = true;
      claude.enable = true;
    };
  };
}
