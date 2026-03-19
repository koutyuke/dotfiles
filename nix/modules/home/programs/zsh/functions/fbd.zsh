# fzf: delete local branch
# default: show only merged branches (safe)
# -a: include all branches
# -D: force delete
function fbd() {
  local include_all=0
  local force_delete=0
  local opt
  local current
  local delete_flag='-d'
  local -a branches
  local -a selected

  while getopts "aD" opt; do
    case "$opt" in
      a) include_all=1 ;;
      D) force_delete=1 ;;
      *) return 1 ;;
    esac
  done

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not a git repository"
    return 1
  fi

  current=$(git branch --show-current 2>/dev/null)

  if (( include_all )); then
    branches=("${(@f)$(git for-each-ref --format='%(refname:short)' refs/heads | grep -vx "$current")}")
  else
    branches=("${(@f)$(git branch --merged --format='%(refname:short)' | grep -vx "$current")}")
  fi

  if (( ${#branches[@]} == 0 )); then
    echo "No deletable branches found"
    return 0
  fi

  selected=("${(@f)$(printf '%s\n' "${branches[@]}" | fzf --multi --prompt='delete branch> ')}") || return
  (( ${#selected[@]} == 0 )) && return

  if (( force_delete )); then
    delete_flag='-D'
  fi

  git branch "$delete_flag" "${selected[@]}"
}
