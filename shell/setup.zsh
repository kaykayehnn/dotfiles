# This file is used for setting up shell commands.
# Environment variables and setup scripts should be placed here.

CDPATH=".:$HOME:$HOME/projects"
export GPG_TTY="$(tty)"
export BAT_THEME="OneHalfDark"
export RIPGREP_CONFIG_PATH="$DOTFILES/.ripgreprc"
export DDGR_COLORS="oFdgxy"

# ZSH you-should-use plugin
export YSU_MESSAGE_POSITION="after"
export YSU_IGNORED_ALIASES=("g" "c")

# fzf options
FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"
export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
export FZF_CTRL_T_COMMAND="$FD_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
export FZF_DEFAULT_OPTS='--height 40%'
unset FD_COMMAND

# Wrap git by github's hub wrapper if it is installed
if command -v hub $> /dev/null; then
  alias git=hub
else
  echo "Hub not installed"
fi

# Override ls with exa if it is installed
if command -v exa > /dev/null; then
  alias l="exa -laah"
  alias ls="exa"
  # We already take care of ls colors, so this prevents oh-my-zsh from
  # overriding the ls aliases. 
  DISABLE_LS_COLORS=true
else
  echo "Exa not installed"
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
  # Change z command to something else so it does not conflict with enhancement.
  _Z_CMD="zzz"

  # Overrides z to make it interactive when called with no arguments.
  z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  }
}

setup_fuck
setup_z

unset -f setup_fuck setup_z
