# This file is used for setting up shell commands.
# Environment variables and setup scripts should be placed here.

export GPG_TTY="$(tty)"
export BAT_CONFIG_PATH="$HOME/.dotfiles/.batrc"
export RIPGREP_CONFIG_PATH="$HOME/.dotfiles/.ripgreprc"
export GEM_HOME="$HOME/.gem"

eval "$(hub alias -s)"

# Remove git's completions in favour of zsh's.
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
  rm -f /usr/local/share/zsh/site-functions/_git
fi

# Source z
source /usr/local/etc/profile.d/z.sh

setup_fuck() {
  alias fuck='unalias fuck && eval $(thefuck --alias) && fuck'

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

setup_fuck

setup_fzf() {
  local FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"

  export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
  export FZF_CTRL_T_COMMAND="$FD_COMMAND"
  export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
  export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
  export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
  export FZF_DEFAULT_OPTS='--height 40%'

  # Setup fzf
  # ---------
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2>/dev/null

  # Key bindings
  # ------------
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
}

setup_fzf

unset -f setup_fuck setup_fzf
