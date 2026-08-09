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

BAR_WIDTH=10
BAR_FILLED='▰'
BAR_EMPTY='▱'

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

# 使用率をブロック数へ四捨五入する。データ欠損時は空バーを描く。
render_bar() {
    local percentage=$1
    local filled=0
    local i
    local bar=''

    if [ "$percentage" != "-" ]; then
        filled=$(((percentage * BAR_WIDTH + 50) / 100))
        [ "$filled" -gt "$BAR_WIDTH" ] && filled=$BAR_WIDTH
    fi

    for ((i = 0; i < BAR_WIDTH; i++)); do
        if [ "$i" -lt "$filled" ]; then
            bar="${bar}${BAR_FILLED}"
        else
            bar="${bar}${BAR_EMPTY}"
        fi
    done

    printf '%s' "$bar"
}

# macOS(BSD date) は -r、GNU date は -d @ で epoch 秒を解釈する。
format_epoch() {
    local epoch=${1%%.*}
    local fmt=$2

    if [ -z "$epoch" ] || [ "$epoch" = "null" ]; then
        return
    fi

    date -r "$epoch" "+$fmt" 2>/dev/null || date -d "@$epoch" "+$fmt" 2>/dev/null
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

PR_NUMBER=$(jq -r '.pr.number // empty' <<<"$input")
PR_STATE=$(jq -r '.pr.review_state // empty' <<<"$input")

CONTEXT=$(format_percentage "$(jq -r '.context_window.used_percentage // empty' <<<"$input")")
SESSION=$(format_percentage "$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")")
WEEKLY=$(format_percentage "$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")")

# 5h 枠は当日中に切り替わるので時刻のみ、7d 枠は日をまたぐので曜日を添える。
SESSION_RESET=$(format_epoch "$(jq -r '.rate_limits.five_hour.resets_at // empty' <<<"$input")" '%H:%M')
WEEKLY_RESET=$(format_epoch "$(jq -r '.rate_limits.seven_day.resets_at // empty' <<<"$input")" '%a %H:%M')

CONTEXT_COLOR=$(usage_color "$CONTEXT")
SESSION_COLOR=$(usage_color "$SESSION")
WEEKLY_COLOR=$(usage_color "$WEEKLY")
CONTEXT_TEXT=$(percentage_text "$CONTEXT")
SESSION_TEXT=$(percentage_text "$SESSION")
WEEKLY_TEXT=$(percentage_text "$WEEKLY")

LINE1="${CYAN}${BOLD}${MODEL}${RESET}"
[ -n "$EFFORT" ] && LINE1="${LINE1} ${CYAN}${EFFORT}${RESET}"
[ -n "$PROJECT" ] && LINE1="${LINE1}${SEP}${GREEN}${PROJECT}${RESET}"
[ -n "$BRANCH" ] && LINE1="${LINE1}${SEP}${MAGENTA}${BRANCH}${RESET}"

if [ -n "$PR_NUMBER" ]; then
    LINE1="${LINE1}${SEP}${DIM}PR${RESET}${CYAN}#${PR_NUMBER}${RESET}"
    case $PR_STATE in
        approved) LINE1="${LINE1} ${GREEN}✓${RESET}" ;;
        changes_requested) LINE1="${LINE1} ${RED}✗${RESET}" ;;
        pending) LINE1="${LINE1} ${YELLOW}⋯${RESET}" ;;
        draft) LINE1="${LINE1} ${GRAY}◦${RESET}" ;;
    esac
fi

LINE2="${DIM}ctx${RESET} ${CONTEXT_COLOR}$(render_bar "$CONTEXT")${RESET} ${CONTEXT_COLOR}${CONTEXT_TEXT}${RESET}"
LINE2="${LINE2}${SEP}${DIM}5h${RESET} ${SESSION_COLOR}${SESSION_TEXT}${RESET}"
[ -n "$SESSION_RESET" ] && LINE2="${LINE2} ${GRAY}↻${SESSION_RESET}${RESET}"
LINE2="${LINE2}${SEP}${DIM}7d${RESET} ${WEEKLY_COLOR}${WEEKLY_TEXT}${RESET}"
[ -n "$WEEKLY_RESET" ] && LINE2="${LINE2} ${GRAY}↻${WEEKLY_RESET}${RESET}"

printf '%b\n%b\n' "$LINE1" "$LINE2"
