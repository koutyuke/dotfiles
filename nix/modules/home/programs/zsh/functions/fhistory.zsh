# fzf: insert history into command line
function fhistory() {
  local selected
  selected=$(fc -rl 1 | fzf --no-sort --height 40% --prompt='history> ' \
    | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//') || return

  if [[ -n "$WIDGET" ]]; then
    LBUFFER="$selected"
    zle reset-prompt
  else
    print -z "$selected"
  fi
}

zle -N fhistory
bindkey '^R' fhistory
