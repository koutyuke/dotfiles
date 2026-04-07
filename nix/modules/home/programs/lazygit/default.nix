{
  pkgs,
  lib,
  ...
}:
let
  aiCommitPromptContext = ''
    Return exactly one English commit message line.
    Think briefly and return the result immediately.
    Format: {emoji} {type}({scope}){!}: {description}
    Use ! only for breaking changes.
    Keep scope short and based on the main changed area.
    Base the message on the staged patch, not only filenames or stats.
    Keep description imperative and within 64 characters when possible.
    Output only the message text.
    Allowed pairs: ✨ feat, 🎈 improve, 🪦 remove, 🐛 fix, 📝 docs, 💄 style, ♻️ refactor, 🏎️ perf, 🧪 test, 🦺 ci, 📦️ build, 🔧 chore.
  '';

  aiCommitPromptContextFile = pkgs.writeText "lazygit-ai-commit-context.txt" aiCommitPromptContext;

  aiCommitPreviewCommand = pkgs.writeShellApplication {
    name = "lazygit-ai-commit-preview";
    runtimeInputs = with pkgs; [
      git
      gnused
      coreutils
      gnugrep
      jq
      llm-agents.codex
    ];
    text = ''
      export AI_COMMIT_PROMPT_CONTEXT_FILE=${aiCommitPromptContextFile}
      ${builtins.readFile ./ai-commit-preview.sh}
    '';
  };
in
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lzg";

    settings = {
      gui = {
        nerdFontsVersion = "3";
      };

      git = {
        allBranchesLogCmds = [
          "git log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all"
        ];
        branchLogCmd = "git log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate {{branchName}} --";
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };

      customCommands = [
        {
          key = "C";
          context = "files";
          description = "Generate commit message with Codex";
          prompts = [
            {
              type = "input";
              title = "Commit message";
              key = "CommitMessage";
              initialValue = ''{{ runCommand "${lib.getExe aiCommitPreviewCommand}" }}'';
            }
          ];
          command = "git commit -m {{ .Form.CommitMessage | quote }}";
        }
      ];
    };
  };
}
