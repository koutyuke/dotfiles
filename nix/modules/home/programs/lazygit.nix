{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lzg";

    settings = {
      gui = {
        fileTreeSortOrder = "foldersFirst";
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
          description = "Generate commit message";
          prompts = [
            {
              type = "input";
              title = "Commit message";
              key = "CommitMessage";
              initialValue = ''{{ runCommand "aicm -o print" }}'';
            }
            {
              type = "menu";
              title = "Co-authored by";
              key = "CoauthoredBy";
              options = [
                {
                  name = "none";
                  value = "none";
                }
                {
                  name = "codex";
                  description = "Codex <noreply@openai.com>";
                  value = "codex";
                }
                {
                  name = "claude";
                  description = "Claude <noreply@anthropic.com>";
                  value = "claude";
                }
              ];
            }
          ];
          command = ''git commit -m {{ .Form.CommitMessage | quote }}{{ if eq .Form.CoauthoredBy "codex" }} --trailer "Co-authored-by: Codex <noreply@openai.com>"{{ else if eq .Form.CoauthoredBy "claude" }} --trailer "Co-authored-by: Claude <noreply@anthropic.com>"{{ end }}'';
        }
      ];
    };
  };
}
