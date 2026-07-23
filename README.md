# linear-open 🧑‍💻

Type `linear open` to open the [Linear](https://linear.app/) issue associated with your current Git branch in your browser. Inspired by [`git-open`](https://github.com/paulirish/git-open).

## How it works

A lot of Linear users have GitHub integration enabled and use the _Copy git branch name_ action (`Cmd/Ctrl+Shift+.` or `Ctrl+Shift+.`) to copy the git branch name when starting to work on an issue. If you are following the intended convention   of prefixing the branch name with the issue key, this plugin allows you to open the issue directly in your browser by typing `linear open`. The plugin also supports customized base URL's for opening the issue.

## Usage

```sh
linear open
Opening REM-471 → https://linear.app/issue/REM-471
```

The current branch name is scanned for a Linear issue key (e.g. `PRO-125`, `ENG-42`). All of the formats from Linear's "Copy branch name" work:

- `username/proj-123-feature-description`
- `PROJ-123-feature-description`
- `proj-123`
- `feature/HOW-42`

## Installation

The following sections describe how to install the plugin for different plugin managers.

### Oh My Zsh (recommended)

```sh
git clone https://github.com/arienshibani/linear-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/linear-open
```

Then add `linear-open` to `plugins=(...)` in `~/.zshrc` and restart your shell.

### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle arienshibani/linear-open` to your `.zshrc` with your other bundle commands.

Antigen will handle cloning the plugin for you automatically the next time you start zsh. You can also add the plugin to a running zsh with `antigen bundle arienshibani/linear-open` for testing before adding it to your `.zshrc`.

### [zplug](https://github.com/zplug/zplug)

```zsh
zplug "arienshibani/linear-open"
```

Then `zplug install` and `zplug load`.

### [zgenom](https://github.com/jandamm/zgenom)

Add `zgenom load arienshibani/linear-open` to your `.zshrc` where your other `zgenom load` calls are. Run `zgenom reset` (or regenerate) and restart the shell so the plugin is picked up.

## Requirements

- [Zsh](https://www.zsh.org/) (tested on v5.0+)
- [Git](https://git-scm.com/)
- A browser opener (`open`, `xdg-open`, or `powershell.exe` / `cmd.exe`)

## Configuration

Optional environment variable (set in `~/.zshrc`):

```zsh
# Default: https://linear.app/issue
# Linear's /issue/KEY URL redirects into your workspace.
# Use a workspace-scoped base if you prefer a direct URL:
export LINEAR_OPEN_BASE_URL="https://linear.app/your-workspace/issue"
```

## Inspired by

— Type `git open` to open the repo website (GitHub, GitLab, Bitbucket)

## License

Copyright linear-open contributors. Licensed under MIT.
<http://opensource.org/licenses/MIT>
