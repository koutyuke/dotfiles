{
  inputs,
  pkgs,
  system,
  ...
}:
let
  llmAgents = inputs.llm-agents.packages.${system};
in
{
  home.packages =
    (with pkgs; [
      # Development tools
      act
      cocoapods
      delta
      eza
      fastfetch
      fd
      ffmpeg
      ghq
      httpie
      jnv
      jq
      lazydocker
      lefthook
      mas
      ni
      openssl
      postgresql
      ripgrep
      tree
      uv
      watchman
      yq-go

      # Linting and formatting
      nixfmt
      oxfmt
      ruff
      shellcheck

      # LSP
      basedpyright
      nixd
    ])
    ++ (with llmAgents; [
      codex
      claude-code
    ]);
}
