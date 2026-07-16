# shellcheck shell=bash
set -euo pipefail

DEFAULT_PROVIDER="codex"
DEFAULT_CODEX_MODEL="gpt-5.6-luna"
DEFAULT_CLAUDE_MODEL="haiku"
DEFAULT_OLLAMA_MODEL="gemma4:e2b-it-qat"
DEFAULT_CODEX_EFFORT="none"
DEFAULT_CLAUDE_EFFORT="low"
DEFAULT_OUTPUT="print"
DEFAULT_OLLAMA_HOST="http://127.0.0.1:11434"

default_prompt_context() {
  cat <<'EOF'
Return exactly one English commit message line.
Do not include reasoning, explanations, or alternatives.
Format: `{emoji} {type}({scope}){!}: {description}`
Use `!` only for breaking changes.
Keep `scope` short and based on the main changed area.
Base the message on the staged patch, not only filenames or stats.
Keep `description` imperative and within 64 characters when possible.
Output only the message text.
Allowed pairs: `✨ feat`, `🎈 improve`, `🪦 remove`, `🐛 fix`, `📝 docs`, `💄 style`, `♻️ refactor`, `🏎️ perf`, `🧪 test`, `🦺 ci`, `📦️ build`, `🔧 chore`.
EOF
}

die() {
  printf '❌ %s\n' "$*" >&2
  exit 1
}

die_with_log() {
  local message="$1"
  local log_file="$2"
  local output_file="${3:-}"
  local detail=""

  if [ -s "$log_file" ]; then
    detail="$(
      tail -n 3 "$log_file" \
        | sed '/^[[:space:]]*$/d' \
        | tr '\n' ' ' \
        | sed 's/[[:space:]]*$//'
    )"
  fi

  if [ -z "$detail" ] && [ -n "$output_file" ] && [ -s "$output_file" ]; then
    detail="$(
      tail -n 3 "$output_file" \
        | sed '/^[[:space:]]*$/d' \
        | tr '\n' ' ' \
        | sed 's/[[:space:]]*$//'
    )"
  fi

  if [ -n "$detail" ]; then
    die "$message: $detail"
  fi

  die "$message"
}

usage() {
  cat <<'EOF'
Usage: aicm [-p provider] [-m model] [-e effort] [-o output] [-c config]

Options:
  -p, --provider     codex | claude | ollama
  -m, --model        model name
  -e, --effort       reasoning effort
  -o, --output       print | copy | cmd
  -c, --config       JSON config path
      --prompt       prompt text
      --prompt-file  prompt file path
  -h, --help         show help
EOF
}

json_get() {
  local file="$1"
  local key="$2"
  jq -er --arg key "$key" '.[$key] // empty' "$file" 2>/dev/null || true
}

clean_message() {
  grep -v -e '^```' -e '^[[:space:]]*$' "$1" \
    | head -n 1 \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

double_quote() {
  printf "%s" "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/^/"/; s/$/"/'
}

resolve_path() {
  case "$1" in
    /*) printf '%s\n' "$1" ;;
    *) printf '%s\n' "$repo_root/$1" ;;
  esac
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || die "not in a git repository"
cd "$repo_root"

config_file="$repo_root/.koutyuke/.aicm.json"
cli_provider=""
cli_model=""
cli_effort=""
cli_output=""
cli_config=""
cli_prompt=""
cli_prompt_file=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    -p | --provider)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_provider="$2"
      shift 2
      ;;
    -m | --model)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_model="$2"
      shift 2
      ;;
    -e | --effort)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_effort="$2"
      shift 2
      ;;
    -o | --output)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_output="$2"
      shift 2
      ;;
    -c | --config)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_config="$2"
      shift 2
      ;;
    --prompt)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_prompt="$2"
      shift 2
      ;;
    --prompt-file)
      [ "$#" -ge 2 ] || die "$1 requires a value"
      cli_prompt_file="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

[ -n "$cli_config" ] && config_file="$cli_config"

provider="$DEFAULT_PROVIDER"
model=""
effort=""
output="$DEFAULT_OUTPUT"
ollama_host="$DEFAULT_OLLAMA_HOST"
prompt_context=""
prompt_context_file="${AICM_PROMPT_CONTEXT_FILE:-}"

if [ -f "$config_file" ]; then
  jq -e type "$config_file" >/dev/null 2>&1 || die "invalid config JSON: $config_file"
  provider="$(json_get "$config_file" provider || true)"
  model="$(json_get "$config_file" model || true)"
  effort="$(json_get "$config_file" effort || true)"
  output="$(json_get "$config_file" output || true)"
  ollama_host="$(json_get "$config_file" ollamaHost || true)"
  prompt_context="$(json_get "$config_file" prompt || true)"
  prompt_context_file="$(json_get "$config_file" promptFile || true)"
  provider="${provider:-$DEFAULT_PROVIDER}"
  output="${output:-$DEFAULT_OUTPUT}"
  ollama_host="${ollama_host:-$DEFAULT_OLLAMA_HOST}"
fi

provider="${cli_provider:-$provider}"
model="${cli_model:-$model}"
effort="${cli_effort:-$effort}"
output="${cli_output:-$output}"
prompt_context="${cli_prompt:-$prompt_context}"
prompt_context_file="${cli_prompt_file:-$prompt_context_file}"

case "$provider" in
  codex)
    model="${model:-$DEFAULT_CODEX_MODEL}"
    effort="${effort:-$DEFAULT_CODEX_EFFORT}"
    ;;
  claude)
    model="${model:-$DEFAULT_CLAUDE_MODEL}"
    effort="${effort:-$DEFAULT_CLAUDE_EFFORT}"
    ;;
  ollama) model="${model:-$DEFAULT_OLLAMA_MODEL}" ;;
  *) die "unsupported provider: $provider" ;;
esac

case "$provider:$effort" in
  codex:none | codex:low | codex:medium | codex:high | codex:xhigh) ;;
  claude:low | claude:medium | claude:high | claude:xhigh | claude:max) ;;
  ollama:) ;;
  ollama:*) die "effort is unsupported for ollama provider" ;;
  *) die "unsupported effort for $provider: $effort" ;;
esac

case "$output" in
  print | copy | cmd) ;;
  *) die "unsupported output: $output" ;;
esac

git diff --cached --quiet && die "staged changes are empty"

tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/aicm.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT

prompt_file="$tmpdir/prompt.txt"
if [ -z "$prompt_context" ] && [ -n "$prompt_context_file" ]; then
  prompt_context_file="$(resolve_path "$prompt_context_file")"
  [ -r "$prompt_context_file" ] || die "prompt file is not readable: $prompt_context_file"
  prompt_context="$(cat "$prompt_context_file")"
fi

if [ -z "$prompt_context" ]; then
  prompt_context="$(default_prompt_context)"
fi

current_branch="$(git branch --show-current)"
if [ -z "$current_branch" ]; then
  current_branch="detached HEAD $(git rev-parse --short HEAD)"
fi

cat >"$prompt_file" <<EOF
Generate a git commit message.
$prompt_context

Repository: $(basename "$repo_root")
Branch: $current_branch

Staged change summary:
$(git diff --cached --stat --summary)

Staged diff:
$(git diff --cached --patch --minimal --no-ext-diff --submodule=diff)
EOF

message_file="$tmpdir/message.txt"
log_file="$tmpdir/$provider.log"

case "$provider" in
  codex)
    codex_home="$tmpdir/codex-home"
    mkdir -p "$codex_home"
    real_codex_home="${CODEX_HOME:-$HOME/.codex}"
    [ -r "$real_codex_home/auth.json" ] && ln -s "$real_codex_home/auth.json" "$codex_home/auth.json"
    codex_args=(
      --ignore-user-config
      --ignore-rules
      --disable apps
      --disable plugins
      --disable tool_suggest
      --sandbox read-only
      --color never
      --ephemeral
      -C "$repo_root"
      -m "$model"
      --output-last-message "$message_file"
    )
    codex_args+=(-c "model_reasoning_effort=\"$effort\"")
    CODEX_HOME="$codex_home" codex exec "${codex_args[@]}" \
      - <"$prompt_file" >"$log_file" 2>&1 || die_with_log "codex failed" "$log_file"
    ;;
  claude)
    claude -p \
      --safe-mode \
      --no-session-persistence \
      --disable-slash-commands \
      --strict-mcp-config \
      --mcp-config '{"mcpServers":{}}' \
      --tools '' \
      --permission-mode dontAsk \
      --model "$model" \
      --effort "$effort" \
      --output-format text \
      "$(cat "$prompt_file")" >"$message_file" 2>"$log_file" || die_with_log "claude failed" "$log_file" "$message_file"
    ;;
  ollama)
    OLLAMA_HOST="$ollama_host" ollama run "$model" \
      --think false \
      --hidethinking <"$prompt_file" >"$message_file" 2>"$log_file" || die_with_log "ollama failed" "$log_file"
    ;;
esac

message="$(clean_message "$message_file")"
[ -n "$message" ] || die "$provider returned an empty message"

case "$output" in
  print)
    printf '%s\n' "$message"
    ;;
  copy)
    printf '%s' "$message" | pbcopy || die "failed to copy message"
    printf '%s\n' "$message"
    ;;
  cmd)
    command_text="git commit -m $(double_quote "$message")"
    printf '%s' "$command_text" | pbcopy || die "failed to copy command"
    printf '%s\n' "$command_text"
    ;;
esac
