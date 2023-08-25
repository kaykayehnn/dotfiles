# shellcheck shell=bash
# This file is used for setting up shell commands.
# Environment variables and setup scripts should be placed here.

# Make glob patterns case-insensitive
setopt extendedglob
unsetopt CASE_GLOB

CDPATH=".:$HOME:$HOME/projects"
# shellcheck disable=SC2155 # This only applies to non-interactive shells
export GPG_TTY="$(tty)"
export BAT_THEME="OneHalfDark"
export RIPGREP_CONFIG_PATH="$DOTFILES/.ripgreprc"
export DDGR_COLORS="oFdgxy"

# ZSH you-should-use plugin
export YSU_MESSAGE_POSITION="after"
export YSU_IGNORED_ALIASES=("g" "c")

# Use trash-cli with nnn. For gio trash, set to 2
export NNN_TRASH=1

# Tmux plugin options
# shellcheck disable=SC2034 # The variable is used in a zsh plugin
ZSH_TMUX_AUTOSTART=true
# shellcheck disable=SC2034 # The variable is used in a zsh plugin
ZSH_TMUX_AUTOQUIT=false

# Wrap git by github's hub wrapper if it is installed
if command -v hub $> /dev/null; then
  alias git=hub
fi

# Override ls with exa if it is installed
if command -v exa > /dev/null; then
  alias l="exa -laah"
  alias ls="exa"
  # We already take care of ls colors, so this prevents oh-my-zsh from
  # overriding the ls aliases.
  # shellcheck disable=SC2034 # The variable is used internally in oh-my-zsh
  DISABLE_LS_COLORS=true
fi

# Remove git's completions in favour of zsh's.
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
  rm -f /usr/local/share/zsh/site-functions/_git
fi

# Set editor to vscode if installed, otherwise fallback to nano.
if command -v code > /dev/null; then
  export EDITOR="code --wait"
else
  export EDITOR="nano"
fi

# Bind Ctrl-Space to execute current suggestion
bindkey '^ ' autosuggest-execute

setup_zoxide() {
  eval "$(zoxide init zsh --no-cmd)"

  # Run zi when run with 0 arguments and z when there are any arguments.
  z() {
    if [ $# -gt 0 ]; then
      __zoxide_z "$*"
      return
    fi
    
    __zoxide_zi
  }
}

setup_brew() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    
    # Add completions path
    fpath+="/opt/homebrew/share/zsh/site-functions"
  fi
}

setup_fzf() {
  # To install useful keybindings and fuzzy completion:
  # /opt/homebrew/opt/fzf/install

  FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"
  export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
  export FZF_CTRL_T_COMMAND="$FD_COMMAND"
  export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
  export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
  export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
  export FZF_DEFAULT_OPTS='--height 40%'
  unset FD_COMMAND

  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# Brew needs to be setup first so that it's binaries are available!
setup_brew
setup_zoxide
setup_fzf

unset -f setup_zoxide setup_brew setup_fzf
