{ inputs, system, ... }:
{
  programs.opencode = {
    enable = true;
    package = inputs.llm-agents.packages.${system}.opencode2;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      plugins = [ "oh-my-opencode-slim@2.2.25" ];
      mcp.servers = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
        serena = {
          type = "local";
          command = [
            "serena"
            "start-mcp-server"
            "--context=ide"
            "--project-from-cwd"
          ];
        };
        playwright = {
          type = "local";
          command = [
            "bunx"
            "@playwright/mcp@latest"
          ];
        };
        chrome-devtools = {
          type = "local";
          command = [
            "bunx"
            "chrome-devtools-mcp@latest"
          ];
        };
        openaiDeveloperDocs = {
          type = "remote";
          url = "https://developers.openai.com/mcp";
        };
      };
    };
  };

  xdg.configFile."opencode/cli.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/v2/cli.json";
    tabs.mode = "off";
    theme.name = "catppuccin-mocha-blue";
    session = {
      thinking = "hide";
    };
    diffs = {
      wrap = "word";
    };
    animations = true;
  };
}
