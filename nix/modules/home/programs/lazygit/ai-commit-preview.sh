set -euo pipefail

FALLBACK_MESSAGE="🔧 chore(repo): update staged changes"

fallback() {
  printf '%s\n' "$FALLBACK_MESSAGE"
  exit 0
}

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

git diff --cached --quiet && fallback

tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/lazygit-ai-commit.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT

mcp_disabled_args=()
if mcp_names="$(codex mcp list --json 2>/dev/null | jq -r '.[].name' 2>/dev/null)"; then
  while IFS= read -r mcp_name; do
    [ -n "$mcp_name" ] || continue
    mcp_disabled_args+=("-c" "mcp_servers.$mcp_name.enabled=false")
  done <<< "$mcp_names"
fi

prompt_file="$tmpdir/prompt.txt"
cat > "$prompt_file" <<EOF
Generate a git commit message.
$(cat "$AI_COMMIT_PROMPT_CONTEXT_FILE")

Repository: $(basename "$repo_root")

Staged change summary:
$(git diff --cached --stat --summary)

Staged diff:
$(git diff --cached --patch --minimal --no-ext-diff --submodule=diff)
EOF

message_file="$tmpdir/message.txt"
codex exec \
  --sandbox read-only \
  --color never \
  --ephemeral \
  -C "$repo_root" \
  --output-last-message "$message_file" \
  "${mcp_disabled_args[@]}" \
  -c "model=\"${CODEX_COMMIT_MODEL:-gpt-5.4-mini}\"" \
  -c "model_reasoning_effort=\"${CODEX_COMMIT_REASONING_EFFORT:-low}\"" \
  - < "$prompt_file" > "$tmpdir/codex.log" 2>&1 || fallback

first_line="$(
  grep -v -e '^```' -e '^[[:space:]]*$' "$message_file" \
    | head -n 1 \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
)"

[ -n "$first_line" ] || fallback
printf '%s\n' "$first_line"
