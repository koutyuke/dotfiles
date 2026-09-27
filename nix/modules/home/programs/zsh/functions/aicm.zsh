function aicm() {
  local output='' command_text
  local -a original_args=("$@")

  while (( $# > 0 )); do
    case "$1" in
      -o | --output)
        (( $# >= 2 )) || break
        output="$2"
        shift 2
        ;;
      *) shift ;;
    esac
  done

  if [[ "$output" != cmd ]]; then
    command aicm "${original_args[@]}"
    return $?
  fi

  command_text=$(command aicm "${original_args[@]}") || return $?
  print -rz -- "$command_text"
}
