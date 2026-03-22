# Open dotfiles project directory
function dotfiles() {
  local dotfiles_dir="${DOTFILES_DIR:-$HOME/Desktop/projects/@me/dotfiles}"

  if [[ ! -d "$dotfiles_dir" ]]; then
    echo "dotfiles directory not found: $dotfiles_dir" >&2
    echo "Set DOTFILES_DIR to override the default path." >&2
    return 1
  fi

  case "${1:-}" in
    -c|--cursor)
      cursor "$dotfiles_dir"
      ;;
    -v|--vscode)
      code "$dotfiles_dir"
      ;;
    -h|--help)
      echo "Usage: dotfiles [option]"
      echo ""
      echo "Options:"
      echo "  -c, --cursor   Open in Cursor"
      echo "  -v, --vscode   Open in VS Code"
      echo "  -h, --help     Show this help"
      echo "  (no option)    cd into dotfiles directory"
      ;;
    "")
      cd "$dotfiles_dir"
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Run 'dotfiles --help' for usage." >&2
      return 1
      ;;
  esac
}
