# dotfiles

Managed with [chezmoi](https://chezmoi.io). Works on macOS (Apple Silicon + Intel) and Linux (Ubuntu/Debian, Fedora).

## New machine setup

```bash
# 1. Init chezmoi pointing at this repo as source
chezmoi init --source ~/dev/dotfiles --apply

# 2. Reload shell
exec bash
```

## Structure

| Path | Deploys to | Purpose |
|---|---|---|
| `private_dot_config/shell/` | `~/.config/shell/` | Modular shell config sourced by `.bashrc` |
| `dot_local/bin/` | `~/.local/bin/` | Executables on `$PATH` |
| `dot_local/share/shell/` | `~/.local/share/shell/` | Shared bash libraries (source, don't run) |
| `docs/` | *(repo only)* | This file and the script catalogue |

## Shell modules

`.bashrc` is a thin loader that sources these in order:

| Module | Purpose |
|---|---|
| `~/.config/shell/env.sh` | `$PATH`, exports, tool initialisation (GPG, fzf, px, …) |
| `~/.config/shell/aliases.sh` | All aliases |
| `~/.config/shell/functions.sh` | Interactive functions |
| `~/.config/shell/prompt.sh` | Fallback PS1 |

Machine-local overrides go in `~/.bashrc.local` (not committed).

## Adding a script

1. Drop it in `dot_local/bin/` and `chmod +x` it
2. `chezmoi apply` — it deploys directly to `~/.local/bin/`
3. Add a row to `docs/SCRIPTS.md`

## Adding a personal project repo

For projects not on any package manager, add an entry to `.chezmoiexternal.toml`:

```toml
[".local/share/my-project"]
    type = "git-repo"
    url = "git@github.com:you/my-project.git"
    refreshPeriod = "168h"
```

`chezmoi update` will keep it current.
