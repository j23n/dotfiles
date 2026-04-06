# dotfiles

Managed with [chezmoi](https://chezmoi.io). Works on macOS (Apple Silicon + Intel) and Linux (Ubuntu/Debian, Fedora).

## New machine setup

```bash
# 1. Clone
git clone git@github.com:YOU/dotfiles.git ~/dotfiles

# 2. Init chezmoi pointing at this repo as source
chezmoi init --source ~/dotfiles --apply

# 3. Reload shell
exec bash

# 4. Link scripts/bin/ to PATH
bash ~/dotfiles/scripts/system/bootstrap.sh
```

## Structure

| Path | Purpose |
|---|---|
| `shell/` | Modular shell config sourced by `.bashrc` |
| `scripts/bin/` | Executables on `$PATH` (symlinked via bootstrap.sh) |
| `scripts/lib/` | Shared bash library (source, don't run) |
| `scripts/git-helpers/` | Git workflow shortcuts |
| `scripts/system/` | Bootstrap and maintenance scripts |
| `config/` | Brewfile, mise.toml, other tooling config |
| `docs/` | This file and the script catalogue |

## Shell modules

`.bashrc` is a thin loader that sources these in order:

| Module | Purpose |
|---|---|
| `shell/env.sh` | `$PATH`, exports, tool initialisation (GPG, fzf, px, …) |
| `shell/aliases.sh` | All aliases |
| `shell/functions.sh` | Interactive functions |
| `shell/prompt.sh` | Starship or fallback PS1 |

Machine-local overrides go in `~/.bashrc.local` (not committed).

## Adding a script

1. Drop it in `scripts/bin/`
2. `chmod +x` it — `bootstrap.sh` will symlink it to `~/.local/bin`
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
