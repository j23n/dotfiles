#!/usr/bin/env bash
# Environment variables, PATH, and tool initialisation
# Sourced by ~/.bashrc — do not execute directly

# ── Core ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.radicle/bin:$PATH"
export EDITOR=hx
export VISUAL="$EDITOR"
export PAGER="less -R"
export TERM=xterm-256color
export COLORTERM=truecolor

# ── History ───────────────────────────────────────────────────────────────────
export HISTSIZE=-1            # unlimited in-memory history
export HISTFILESIZE=-1        # unlimited on-disk history
export HISTCONTROL="ignoredups:erasedups"
shopt -s histappend
shopt -s checkwinsize
# Write every command to disk immediately; pull in commands from other terminals
PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# ── Debian lesspipe ───────────────────────────────────────────────────────────
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ── Bash completion ───────────────────────────────────────────────────────────
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ── GPG / SSH agent ───────────────────────────────────────────────────────────
export GPG_TTY=$(tty)
if command -v gpgconf >/dev/null 2>&1 && [ -x /usr/bin/gpg-connect-agent ]; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent 2>/dev/null
fi

# ── hledger ───────────────────────────────────────────────────────────────────
export LEDGER_FILE="$HOME/documents/finance/ledger/2025.journal"

# ── Cargo (Rust) ──────────────────────────────────────────────────────────────
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ── Homebrew (macOS) ──────────────────────────────────────────────────────────
if [[ $(uname) == Darwin ]]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ── mise (runtime version manager) ───────────────────────────────────────────
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
fi

# ── fzf key bindings & completion ─────────────────────────────────────────────
command -v fzf &>/dev/null && eval "$(fzf --bash)"

# ── px ────────────────────────────────────────────────────────────────────────
[[ -f "$HOME/.local/share/px/px.sh" ]]                  && source "$HOME/.local/share/px/px.sh"
[[ -f "$HOME/.local/share/px/completions/px.bash" ]]    && source "$HOME/.local/share/px/completions/px.bash"
