#!/bin/bash

input=$(cat)

RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[96m'
GREEN='\033[92m'
MAGENTA='\033[95m'
YELLOW='\033[93m'
RED='\033[91m'
GRAY='\033[90m'

SEP="${GRAY} · ${RESET}"

usage_color() {
    local percentage=$1

    if [ "$percentage" = "-" ]; then
        printf '%s' "$GRAY"
    elif [ "$percentage" -ge 80 ]; then
        printf '%s' "$RED"
    elif [ "$percentage" -ge 50 ]; then
        printf '%s' "$YELLOW"
    else
        printf '%s' "$GREEN"
    fi
}

format_percentage() {
    local value=$1

    if [ -z "$value" ] || [ "$value" = "null" ]; then
        printf '%s' "-"
    else
        printf '%.0f' "$value"
    fi
}

percentage_text() {
    if [ "$1" = "-" ]; then
        printf '%s' "-"
    else
        printf '%s%%' "$1"
    fi
}

# model.display_name は現在の形式、文字列の model は旧形式との互換用。
MODEL=$(jq -r '
    if (.model | type) == "object" then
        .model.display_name // .model.id // "Claude"
    else
        .model // "Claude"
    end
' <<<"$input")
EFFORT=$(jq -r '.effort.level // empty' <<<"$input")

# workspace.project_dir は worktree 利用時も元プロジェクト名を安定して表示できる。
CWD=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
PROJECT_DIR=$(jq -r '.workspace.project_dir // .cwd // empty' <<<"$input")
[ -z "$CWD" ] && CWD=$PWD
[ -z "$PROJECT_DIR" ] && PROJECT_DIR=$CWD

PROJECT=$(basename "$PROJECT_DIR")
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)

CONTEXT=$(format_percentage "$(jq -r '.context_window.used_percentage // empty' <<<"$input")")
SESSION=$(format_percentage "$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")")
WEEKLY=$(format_percentage "$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")")

CONTEXT_COLOR=$(usage_color "$CONTEXT")
SESSION_COLOR=$(usage_color "$SESSION")
WEEKLY_COLOR=$(usage_color "$WEEKLY")
CONTEXT_TEXT=$(percentage_text "$CONTEXT")
SESSION_TEXT=$(percentage_text "$SESSION")
WEEKLY_TEXT=$(percentage_text "$WEEKLY")

OUT="${CYAN}${BOLD}${MODEL}${RESET}"
[ -n "$EFFORT" ] && OUT="${OUT} ${CYAN}${EFFORT}${RESET}"
[ -n "$PROJECT" ] && OUT="${OUT}${SEP}${GREEN}${PROJECT}${RESET}"
[ -n "$BRANCH" ] && OUT="${OUT}${SEP}${MAGENTA}${BRANCH}${RESET}"
OUT="${OUT}${SEP}${DIM}ctx${RESET} ${CONTEXT_COLOR}${CONTEXT_TEXT}${RESET}"
[ "$CONTEXT" != "-" ] && OUT="${OUT} ${DIM}used${RESET}"
OUT="${OUT}${SEP}${DIM}5h${RESET} ${SESSION_COLOR}${SESSION_TEXT}${RESET}"
OUT="${OUT}${SEP}${DIM}weekly${RESET} ${WEEKLY_COLOR}${WEEKLY_TEXT}${RESET}"

printf '%b\n' "$OUT"
