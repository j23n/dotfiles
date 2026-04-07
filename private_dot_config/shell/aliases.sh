#!/usr/bin/env bash
# Aliases — sourced by ~/.bashrc

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ── ls ────────────────────────────────────────────────────────────────────────
alias ll="ls -lAhF --color=auto"
alias la="ls -A --color=auto"
alias l="ls -CF --color=auto"

# ── Safety nets ───────────────────────────────────────────────────────────────
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# ── fd (Debian installs fdfind) ───────────────────────────────────────────────
command -v fdfind &>/dev/null && alias fd="fdfind"

# ── Utilities ─────────────────────────────────────────────────────────────────
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -sh"
alias ports="ss -tulpn 2>/dev/null || netstat -tulpn"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ── Git ───────────────────────────────────────────────────────────────────────
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias glog="git log --oneline --graph --decorate -20"

# ── Dotfiles ──────────────────────────────────────────────────────────────────
alias dot="chezmoi cd"
alias dots="chezmoi status"
alias dotup="chezmoi apply"
