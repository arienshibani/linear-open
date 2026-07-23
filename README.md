# zsh-linear-open 🧑‍💻

Type `linear open` to open the [Linear](https://linear.app/) issue associated with your current Git branch in your browser. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/82124eb9-afc5-4249-bd12-05dd95d71f37" width="480" alt="Demo of linear open in action">
</p>

## Rationale

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

#### 1. Install the plugin

```sh
git clone https://github.com/arienshibani/linear-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/linear-open
```

#### 2. Add `linear-open` to `plugins=(...)` in `~/.zshrc`.

```zsh
plugins=(
  git
  linear-open
)
```

#### 3. Restart your shell to load the plugin.

```sh
source ~/.zshrc
```

---

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

— Inspired by [`git-open`](https://github.com/paulirish/git-open).

## License

Copyright linear-open contributors. Licensed under MIT.
<http://opensource.org/licenses/MIT>
