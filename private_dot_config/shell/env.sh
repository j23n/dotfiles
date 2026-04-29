# Environment variables, PATH, and tool initialisation
# Sourced by ~/.bashrc and ~/.zshrc — do not execute directly

# ── Core ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.radicle/bin:$PATH"
export EDITOR=hx
export VISUAL="$EDITOR"
export PAGER="less -R"
export TERM=xterm-256color
export COLORTERM=truecolor

# ── History ───────────────────────────────────────────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
  export HISTSIZE=1000000
  export SAVEHIST=1000000
  export HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
  setopt HIST_IGNORE_DUPS HIST_EXPIRE_DUPS_FIRST SHARE_HISTORY
  setopt APPEND_HISTORY INC_APPEND_HISTORY
elif [ -n "$BASH_VERSION" ]; then
  export HISTSIZE=-1
  export HISTFILESIZE=-1
  export HISTCONTROL="ignoredups:erasedups"
  shopt -s histappend
  shopt -s checkwinsize
  PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

# ── Debian lesspipe ───────────────────────────────────────────────────────────
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ── Completion ────────────────────────────────────────────────────────────────
if [ -n "$BASH_VERSION" ] && ! shopt -oq posix; then
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
if [ "$(uname)" = Darwin ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ── mise (runtime version manager) ───────────────────────────────────────────
if command -v mise >/dev/null 2>&1; then
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(mise activate zsh)"
  else
    eval "$(mise activate bash)"
  fi
fi

# ── fzf key bindings & completion ─────────────────────────────────────────────
if command -v fzf >/dev/null 2>&1; then
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(fzf --zsh)"
  else
    eval "$(fzf --bash)"
  fi
fi

# ── px ────────────────────────────────────────────────────────────────────────
[ -f "$HOME/.local/share/px/px.sh" ] && . "$HOME/.local/share/px/px.sh"
if [ -n "$ZSH_VERSION" ]; then
  [ -f "$HOME/.local/share/px/completions/_px" ] && fpath+=("$HOME/.local/share/px/completions")
elif [ -n "$BASH_VERSION" ]; then
  [ -f "$HOME/.local/share/px/completions/px.bash" ] && . "$HOME/.local/share/px/completions/px.bash"
fi
