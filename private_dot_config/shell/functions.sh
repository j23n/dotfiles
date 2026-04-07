#!/usr/bin/env bash
# Interactive shell functions — sourced by ~/.bashrc

# cd and list
cdl() { cd "$1" && ll; }

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1" || return 1; }

# Fuzzy branch switcher (requires fzf + git)
gco() {
  local branch
  branch=$(git branch --all 2>/dev/null \
    | grep -v HEAD \
    | fzf --preview 'git log --oneline --color=always {}' \
    | sed 's/remotes\/origin\///' \
    | tr -d ' *') || return 1
  git checkout "$branch"
}

# Quick find by name
f() { find . -name "*$1*" 2>/dev/null; }

# Extract any archive
extract() {
  case "$1" in
    *.tar.gz|*.tgz)   tar xzf "$1"  ;;
    *.tar.bz2|*.tbz)  tar xjf "$1"  ;;
    *.tar.xz)         tar xJf "$1"  ;;
    *.zip)            unzip "$1"     ;;
    *.gz)             gunzip "$1"    ;;
    *.rar)            unrar x "$1"   ;;
    *)                echo "Cannot extract '$1'" ;;
  esac
}
