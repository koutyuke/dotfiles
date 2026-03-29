{
  pkgs,
  lib,
  ...
}:
let
  aiCommitPromptContext = ''
    Project-specific commit guidance:
    - Output exactly one line.
    - Use English only. Never use Japanese.
    - Use this format exactly: {emoji} {type}({scope}){breaking_change_exclamation}: {description}
    - Omit ! unless the change is breaking.
    - Keep {scope} within roughly 3 path levels and derive it from the changed area when possible.
    - Keep {description} concise, imperative, and within 64 characters when possible.
    - Output only the commit message text.
    - Allowed types and emoji:
      - ✨ feat
      - 🎈 improve
      - 🪦 remove
      - 🐛 fix
      - 📝 docs
      - 💄 style
      - ♻️ refactor
      - 🏎️ perf
      - 🧪 test
      - 🦺 ci
      - 📦️ build
      - 🔧 chore
  '';

  aiCommitPromptContextFile = pkgs.writeText "lazygit-ai-commit-context.txt" aiCommitPromptContext;

  aiCommitCommand = pkgs.writeShellApplication {
    name = "lazygit-ai-commit";
    runtimeInputs = with pkgs; [
      git
      gnused
      llm-agents.codex
    ];
    text = ''
      set -euo pipefail

      repo_root="$(git rev-parse --show-toplevel)"
      cd "$repo_root"

      if git diff --cached --quiet; then
        echo "No staged changes found. Stage changes first."
        exit 1
      fi

      tmpdir="$(mktemp -d "''${TMPDIR:-/tmp}/lazygit-ai-commit.XXXXXX")"
      trap 'rm -rf "$tmpdir"' EXIT

      prompt_file="$tmpdir/prompt.txt"
      message_file="$tmpdir/message.txt"
      diff_file="$tmpdir/staged.diff"
      summary_file="$tmpdir/staged.summary"
      codex_log_file="$tmpdir/codex.log"
      codex_model="''${CODEX_COMMIT_MODEL:-gpt-5.4-mini}"
      codex_reasoning_effort="''${CODEX_COMMIT_REASONING_EFFORT:-low}"

      git diff --cached --stat --summary > "$summary_file"
      git diff --cached --patch --minimal --no-ext-diff --submodule=diff > "$diff_file"

      cat > "$prompt_file" <<EOF
      You generate Git commit messages for the current repository.

      Follow this guidance exactly:
      $(cat ${aiCommitPromptContextFile})

      Additional rules:
      - Base the message only on the staged changes.
      - Do not mention tools, AI, or that the message was generated.
      - Do not wrap the answer in Markdown fences.
      - Return exactly one commit message line.
      - Do not add a body, bullets, explanation, or quotes.

      Repository: $(basename "$repo_root")

      Staged change summary:
      $(cat "$summary_file")

      Staged diff:
      $(cat "$diff_file")
      EOF

      echo "Generating commit message with Codex..."

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
        echo "Codex failed to generate a commit message."
        echo
        echo "Last Codex log lines:"
        tail -n 80 "$codex_log_file"
        exit 1
      fi

      grep -v '^```' "$message_file" > "$tmpdir/message.cleaned.txt" || true
      mv "$tmpdir/message.cleaned.txt" "$message_file"
      first_line="$(grep -v '^[[:space:]]*$' "$message_file" | head -n 1)"
      printf '%s\n' "$first_line" > "$message_file"
      if [ ! -s "$message_file" ]; then
        echo "Codex returned an empty commit message."
        exit 1
      fi

      echo
      echo "Generated commit message:"
      echo "----------------------------------------"
      echo
      cat "$message_file"
      echo
      echo "----------------------------------------"
      echo

      while true; do
        printf "[a]ccept  [e]dit  [c]ancel: "
        read -r choice
        case "$choice" in
          a|A)
            git commit --edit -F "$message_file"
            break
            ;;
          e|E)
            "''${VISUAL:-''${EDITOR:-vi}}" "$message_file"
            if [ ! -s "$message_file" ]; then
              echo "Commit message is empty. Cancelling."
              exit 1
            fi
            git commit --edit -F "$message_file"
            break
            ;;
          c|C)
            echo "Cancelled."
            exit 0
            ;;
          *)
            echo "Enter a, e, or c."
            ;;
        esac
      done
    '';
  };
in
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lzg";
    settings = {
      git = {
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
          description = "Generate commit message with Codex and review it";
          command = lib.getExe aiCommitCommand;
          output = "terminal";
        }
      ];
    };
  };
}
