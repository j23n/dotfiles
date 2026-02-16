#!/bin/bash
set -eu

mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/lib/helix/hx" "$HOME/.local/bin/hx"
