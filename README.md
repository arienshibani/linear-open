# zsh-linear-open

This plugin for Zsh adds a `linear` command that when executed, will check the current branch name you are on for a **Linear issue key**. If found, it will open your browser to the corresponding Linear issue, directly in your browser. Similar to the `git open` command.

## Requirements

- [Zsh](https://www.zsh.org/) (Tested to work on v5.0 or higher)
- [Git](https://git-scm.com/)
- A browser opener available on your OS (`open`, `xdg-open`, or `powershell.exe`)

---

## Installation

### Oh My Zsh (recommended)

Clone into your Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/arienshibani/linear-open.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/linear-open
```

Enable the plugin in `~/.zshrc`:

```zsh
plugins=(... linear-open)
```

Reload your shell:

```bash
source ~/.zshrc
```

### Zplug

```zsh
zplug "arienshibani/linear-open"
```

Then:

```bash
zplug install
zplug load
```

### zgenom

```zsh
zgenom load arienshibani/linear-open
```

Run `zgenom reset` (or regenerate) and restart the shell so the plugin is picked up.

### Antigen

```zsh
antigen bundle arienshibani/linear-open
antigen apply
```

### Manual (no plugin manager)

```bash
git clone https://github.com/arienshibani/linear-open.git ~/src/linear-open
```

Add to `~/.zshrc`:

```zsh
source ~/src/linear-open/linear-open.plugin.zsh
```

---

## Usage

From any Git repository whose current branch contains a Linear issue key:

```bash
linear          # default: open
linear open     # explicit
linopen         # short alias for `linear open`
linear help     # usage text
```

Example:

```text
$ git branch --show-current
ari/how-125-add-oauth

$ linear open
Opening HOW-125 → https://linear.app/issue/HOW-125
```

### Configuration

Optional environment variable (set in `~/.zshrc`):

```zsh
# Default: https://linear.app/issue
# Linear's /issue/KEY URL redirects into your workspace.
# Use a workspace-scoped base if you prefer a direct URL:
export LINEAR_OPEN_BASE_URL="https://linear.app/your-workspace/issue"
```

---

## Git alias alternative (`git linear`)

If you prefer not to use Oh My Zsh, you can install a Git alias that shells out to the same logic.

### Option A - alias pointing at this plugin

After cloning the repo somewhere permanent (e.g. `~/src/linear-open`):

```bash
git config --global alias.linear '!zsh -c '\''
  source ~/src/linear-open/linear-open.plugin.zsh
  linear open
'\'''
```

Then:

```bash
git linear
```

### Option B - self-contained one-liner alias

No plugin install required:

```bash
git config --global alias.linear '!f() {
  branch=$(git rev-parse --abbrev-ref HEAD) || exit 1
  if [ "$branch" = "HEAD" ]; then echo "git linear: detached HEAD"; exit 1; fi
  key=$(printf "%s" "$branch" | grep -oE "[A-Za-z][A-Za-z0-9]*-[0-9]+" | head -1 | tr "[:lower:]" "[:upper:]")
  if [ -z "$key" ]; then echo "git linear: no Linear issue key in branch '\''$branch'\''"; exit 1; fi
  url="https://linear.app/issue/$key"
  echo "Opening $key → $url"
  if command -v open >/dev/null 2>&1; then open "$url"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$url"
  elif command -v powershell.exe >/dev/null 2>&1; then powershell.exe -NoProfile -Command "Start-Process '\''$url'\''"
  else echo "git linear: open manually: $url"; exit 1; fi
}; f'
```

---

## How it works

1. Confirm the cwd is inside a Git work tree (`git rev-parse --is-inside-work-tree`)
2. Read the current branch (`git rev-parse --abbrev-ref HEAD`)
3. Match a Linear-style key with Zsh regex: letters + `-` + digits (e.g. `HOW-125`)
4. Uppercase the key and open `${LINEAR_OPEN_BASE_URL}/${KEY}` in the default browser

---

## License

[MIT](./LICENSE)
