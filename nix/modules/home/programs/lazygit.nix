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
          ];
          command = "git commit -m {{ .Form.CommitMessage | quote }}";
        }
      ];
    };
  };
}
