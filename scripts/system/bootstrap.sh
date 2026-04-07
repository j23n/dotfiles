#!/usr/bin/env bash
# Bootstrap: symlink scripts/bin/ into ~/.local/bin
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
source "$DOTFILES/scripts/lib/log.sh"

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

log "Linking scripts from $DOTFILES/scripts/bin/ → $BIN_DIR"

shopt -s nullglob
scripts=("$DOTFILES/scripts/bin"/*)
shopt -u nullglob

if [[ ${#scripts[@]} -eq 0 ]]; then
  info "No scripts in scripts/bin/ yet"
  exit 0
fi

for script in "${scripts[@]}"; do
  [[ -f "$script" ]] || continue
  name="$(basename "$script")"
  chmod +x "$script"
  ln -sf "$script" "$BIN_DIR/$name"
  info "  linked: $name"
done

log "Done. Ensure $BIN_DIR is on your PATH."
