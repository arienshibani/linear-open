# linear-open — Oh My Zsh plugin
# Open the Linear issue linked to the current Git branch in your browser.
#
# Usage:
#   linear open
#   linear          # same as `linear open` (default subcommand)
#
# Install (Oh My Zsh):
#   git clone https://github.com/arienshibani/linear-open.git \
#     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/linear-open
#   # then add `linear-open` to plugins=(...) in ~/.zshrc

# Linear issue URL base. Override in ~/.zshrc if needed, e.g.:
#   export LINEAR_OPEN_BASE_URL="https://linear.app/my-workspace/issue"
: "${LINEAR_OPEN_BASE_URL:=https://linear.app/issue}"

# ---------------------------------------------------------------------------
# Internals
# ---------------------------------------------------------------------------

# Print to stderr and return non-zero.
_linear_open_error() {
  print -u2 -- "linear-open: $*"
  return 1
}

# Open a URL in the default browser (macOS, Linux, WSL/Windows).
_linear_open_browser() {
  local url="$1"

  if [[ -z "$url" ]]; then
    _linear_open_error "no URL provided"
    return 1
  fi

  if (( $+commands[open] )); then
    # macOS (and some BSD systems)
    open "$url"
  elif (( $+commands[xdg-open] )); then
    # Linux desktop environments
    xdg-open "$url" >/dev/null 2>&1 &
  elif (( $+commands[powershell.exe] )); then
    # WSL / Windows
    powershell.exe -NoProfile -Command "Start-Process '${url}'"
  elif (( $+commands[cmd.exe] )); then
    # Fallback for some WSL setups without powershell.exe in PATH
    cmd.exe /c start "" "$url"
  else
    _linear_open_error "could not find a command to open URLs (tried: open, xdg-open, powershell.exe)"
    print -u2 -- "linear-open: open this URL manually: $url"
    return 1
  fi
}

# Extract a Linear issue key (e.g. HOW-125) from a branch name.
# Handles common Linear "Copy branch name" formats:
#   username/proj-123-feature-description
#   PROJ-123-feature-description
#   proj-123
#   feature/HOW-42
#
# Returns the key in UPPERCASE via stdout, or empty string if none found.
_linear_open_extract_issue() {
  local branch="$1"
  local key=""

  # Match TEAMKEY-NUMBER anywhere in the branch name.
  # Team keys are letters optionally followed by letters/digits (Linear team identifiers).
  # Prefer the leftmost match so prefixes like "username/" don't confuse us.
  if [[ "$branch" =~ (^|[^A-Za-z0-9])([A-Za-z][A-Za-z0-9]*)-([0-9]+)([^A-Za-z0-9]|$) ]]; then
    key="${match[2]}-${match[3]}"
  elif [[ "$branch" =~ ^([A-Za-z][A-Za-z0-9]*)-([0-9]+) ]]; then
    key="${match[1]}-${match[2]}"
  fi

  if [[ -n "$key" ]]; then
    # Uppercase for Linear's canonical issue URL form
    print -r -- "${(U)key}"
  fi
}

# Resolve the current Git branch name, or fail with a friendly message.
_linear_open_current_branch() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    _linear_open_error "not a Git repository"
    return 1
  fi

  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || true

  if [[ -z "$branch" || "$branch" == "HEAD" ]]; then
    _linear_open_error "could not determine the current branch (detached HEAD?)"
    return 1
  fi

  print -r -- "$branch"
}

# ---------------------------------------------------------------------------
# Public command
# ---------------------------------------------------------------------------

# linear open — open the Linear issue for the current branch
linear() {
  local subcommand="${1:-open}"

  case "$subcommand" in
    open|-o)
      # Consume the subcommand only when the user typed it explicitly.
      [[ $# -gt 0 ]] && shift
      ;;
    help|-h|--help)
      cat <<'EOF'
Usage: linear [open]

Open the Linear issue associated with the current Git branch.

The branch name is parsed for a Linear issue key (e.g. HOW-125, ENG-42)
in common formats produced by Linear's "Copy branch name" feature.

Environment:
  LINEAR_OPEN_BASE_URL   Base URL for issues (default: https://linear.app/issue)

Examples:
  linear
  linear open
EOF
      return 0
      ;;
    *)
      _linear_open_error "unknown subcommand '$subcommand' (try: linear open)"
      return 1
      ;;
  esac

  local branch issue url
  branch="$(_linear_open_current_branch)" || return $?
  issue="$(_linear_open_extract_issue "$branch")"

  if [[ -z "$issue" ]]; then
    _linear_open_error "no Linear issue key found in branch '$branch'"
    print -u2 -- "linear-open: expected something like PROJ-123 in the branch name"
    return 1
  fi

  url="${LINEAR_OPEN_BASE_URL%/}/${issue}"

  print -- "Opening ${issue} → ${url}"
  _linear_open_browser "$url"
}

# Optional convenience: `linopen` as a short alias for `linear open`
alias linopen='linear open'
