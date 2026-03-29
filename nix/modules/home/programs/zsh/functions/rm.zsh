# Replace rm with macOS trash while tolerating common rm flags.
function rm() {
  local arg
  local -a targets=()

  while (( $# > 0 )); do
    arg="$1"
    case "$arg" in
      --)
        shift
        targets+=("$@")
        break
        ;;
      -f|--force|-i|-I|-P|-d|-r|-R|-v)
        ;;
      -rf|-fr|-rR|-Rr|-Rv|-vR|-rfv|-rvf|-frv|-fvr|-vrf|-vfr)
        ;;
      --dir|--recursive|--verbose|--preserve-root|--no-preserve-root|--one-file-system)
        ;;
      -*)
        echo "rm: unsupported option for trash wrapper: $arg" >&2
        return 1
        ;;
      *)
        targets+=("$arg")
        ;;
    esac
    shift
  done

  if (( ${#targets[@]} == 0 )); then
    echo "rm: missing operand" >&2
    return 1
  fi

  command trash "${targets[@]}"
}
