# fzf: insert history
function fhistory() {
  local selected
  selected=$(fc -rl 1 | fzf --tac --no-sort --height 40% --prompt='history> ' \
    | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//') || return
  LBUFFER+="$selected"
  zle redisplay
}

zle -N fzf-history-insert
bindkey '^R' fzf-history-insert
