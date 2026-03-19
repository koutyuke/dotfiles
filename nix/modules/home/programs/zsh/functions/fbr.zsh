# fzf: local branch switcher
function fbr() {
  local b
  b=$(git branch --all --color=never 2>/dev/null \
    | sed 's/^[*[:space:]]*//' \
    | sed 's#^remotes/##' \
    | sort -u \
    | fzf --prompt='branch> ') || return
  git checkout "${b#origin/}"
}
