{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lg";
    settings = {
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
    };
  };
}
