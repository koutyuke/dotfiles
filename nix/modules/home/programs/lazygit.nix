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
      llm-agents.codex
    ];
    text = ''
      set -euo pipefail

      repo_root="$(git rev-parse --show-toplevel)"
      cd "$repo_root"

      if git diff --cached --quiet; then
        printf '%s\n' "🔧 chore(repo): update staged changes"
        exit 0
      fi

      tmpdir="$(mktemp -d "''${TMPDIR:-/tmp}/lazygit-ai-commit.XXXXXX")"
      trap 'rm -rf "$tmpdir"' EXIT

      prompt_file="$tmpdir/prompt.txt"
      message_file="$tmpdir/message.txt"
      summary_file="$tmpdir/staged.summary"
      name_status_file="$tmpdir/staged.name-status"
      codex_log_file="$tmpdir/codex.log"
      codex_model="''${CODEX_COMMIT_MODEL:-gpt-5.4-mini}"
      codex_reasoning_effort="''${CODEX_COMMIT_REASONING_EFFORT:-low}"

      git diff --cached --stat --summary > "$summary_file"
      git diff --cached --name-status > "$name_status_file"

      cat > "$prompt_file" <<EOF
      Generate a git commit message.
      $(cat ${aiCommitPromptContextFile})

      Repository: $(basename "$repo_root")

      Staged change summary:
      $(cat "$summary_file")

      Staged file status:
      $(cat "$name_status_file")
      EOF

      if ! codex exec \
        --sandbox read-only \
        --color never \
        --ephemeral \
        -C "$repo_root" \
        --output-last-message "$message_file" \
        -c mcp_servers.notion.enabled=false \
        -c mcp_servers.serena.enabled=false \
        -c "model=\"$codex_model\"" \
        -c "model_reasoning_effort=\"$codex_reasoning_effort\"" \
        - < "$prompt_file" > "$codex_log_file" 2>&1; then
        printf '%s\n' "🔧 chore(repo): update staged changes"
        exit 0
      fi

      grep -v '^```' "$message_file" > "$tmpdir/message.cleaned.txt" || true
      mv "$tmpdir/message.cleaned.txt" "$message_file"

      first_line="$(
        grep -v '^[[:space:]]*$' "$message_file" \
          | head -n 1 \
          | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
      )"

      if [ -z "$first_line" ]; then
        printf '%s\n' "🔧 chore(repo): update staged changes"
        exit 0
      fi

      printf '%s\n' "$first_line"
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
        showIcons = false;
      };

      git = {
        allBranchesLogCmds = [
          "git log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all"
        ];
        branchLogCmds = "git log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate {{branchName}} --";
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
