# Shell prompt — sourced by ~/.bashrc and ~/.zshrc

if [ -n "$ZSH_VERSION" ]; then
  # ── Zsh prompt ──────────────────────────────────────────────────────────────
  autoload -Uz colors && colors
  setopt PROMPT_SUBST

  case "$TERM" in
    xterm-color|*-256color)
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
      ;;
    *)
      PROMPT='%n@%m:%~%# '
      ;;
  esac

  # Set xterm title to user@host:dir
  case "$TERM" in
    xterm*|rxvt*)
      precmd() { print -Pn "\e]0;%n@%m: %~\a"; }
      ;;
  esac

else
  # ── Bash prompt ─────────────────────────────────────────────────────────────
  if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
  fi

  case "$TERM" in
    xterm-color|*-256color) _color_prompt=yes ;;
  esac

  if [ "$_color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
  unset _color_prompt

  case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
  esac
fi
