# This file is used for setting up shell commands.
# Environment variables and setup scripts should be placed here.

CDPATH=".:$HOME:$HOME/projects"
export GPG_TTY="$(tty)"
export BAT_THEME="GitHub"
export RIPGREP_CONFIG_PATH="$DOTFILES/.ripgreprc"
export DDGR_COLORS="oFdgxy"

# fzf options
FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
export FZF_CTRL_T_COMMAND="$FD_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
export FZF_DEFAULT_OPTS='--height 40%'
unset FD_COMMAND

# Wrap git by github's hub wrapper
alias git=hub
# Override ls with exa
alias l="exa -laah"
alias ls="exa"

# Remove git's completions in favour of zsh's.
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
  rm -f /usr/local/share/zsh/site-functions/_git
fi

# Bind Ctrl-Space to execute current suggestion
bindkey '^ ' autosuggest-execute

# Setup iterm2 shell integration if it is installed.
[ -e "$HOME/.iterm2_shell_integration.zsh" ] && source "$HOME/.iterm2_shell_integration.zsh"

setup_fuck() {
  # Inline `thefuck --alias` to improve performance.
  fuck () {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING;
    export TF_SHELL=zsh;
    export TF_ALIAS=fuck;
    TF_SHELL_ALIASES=$(alias);
    export TF_SHELL_ALIASES;
    TF_HISTORY="$(fc -ln -10)";
    export TF_HISTORY;
    export PYTHONIOENCODING=utf-8;
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD;
    unset TF_HISTORY;
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
    test -n "$TF_CMD" && print -s $TF_CMD
  }

  fuck-command-line() {
      local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
      [[ -z $FUCK ]] && echo -n -e "\a" && return
      BUFFER=$FUCK
      zle end-of-line
  }

  # Bind Esc-Esc to fuck.
  zle -N fuck-command-line
  bindkey -M emacs '\e\e' fuck-command-line
  bindkey -M vicmd '\e\e' fuck-command-line
  bindkey -M viins '\e\e' fuck-command-line
}

setup_z() {
  source /usr/local/etc/profile.d/z.sh

  unalias z
  # Overrides z to make it interactive when called with no arguments.
  z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --nth 2.. --no-sort --tac | sed 's/^[0-9,.]* *//')"
  }
}

# This function optimizes `eval "$(brew command-not-found-init)"` by sourcing
# the handler directly. This can improve shell startup performance by multiple
# seconds as brew itself incurs a huge slowdown to any subcommand.
setup_command_not_found() {
  # Get brew's prefix manually instead of executing $(brew --prefix) to improve
  # performance.
  local prefix
  if [[ "$OSTYPE" == "linux-gnu" ]]; then # Linux
    prefix="/usr/linuxbrew/.linuxbrew"
  elif [[ "$OSTYPE" == "darwin"* ]]; then # macOS
    prefix="/usr/local"
  else
    return # Unknown OS
  fi

  BREW_COMMAND_NOT_FOUND_HANDLER="$prefix/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
  if [ -f "$BREW_COMMAND_NOT_FOUND_HANDLER" ]; then
    source "$BREW_COMMAND_NOT_FOUND_HANDLER"
  fi
}

setup_fuck
setup_z
setup_command_not_found

unset -f setup_fuck setup_z setup_command_not_found
