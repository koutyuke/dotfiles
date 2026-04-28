# 現在のディレクトリまたは指定したpathの絶対pathをclipboardにコピーする。
function copypath() {
  local target="${1:-$PWD}"
  local resolved

  if [[ "$target" == /* ]]; then
    resolved="${target:A}"
  else
    resolved="${PWD}/${target}"
    resolved="${resolved:A}"
  fi

  print -rn -- "$resolved" | pbcopy
  print -r -- "$resolved"
}
