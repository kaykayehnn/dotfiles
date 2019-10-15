# This file is used for setting up shell commands.
# Environment variables and setup scripts should be placed here.

export GPG_TTY="$(tty)"
export BAT_CONFIG_PATH="$HOME/.dotfiles/.batrc"
export RIPGREP_CONFIG_PATH="$HOME/.dotfiles/.ripgreprc"

eval "$(hub alias -s)"
eval $(thefuck --alias)

# Remove git's completions in favour of zsh's.
# https://github.com/agross/dotfiles/commit/4938bc8987a5b4ef0c7411a2c4b988d89a3ade11
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
  rm  -f /usr/local/share/zsh/site-functions/_git
fi

setup_fzf() {
  local FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"

  export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
  export FZF_CTRL_T_COMMAND="$FD_COMMAND"
  export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
  export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
  export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"

  # Setup fzf
  # ---------
  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

  # Key bindings
  # ------------
  source "/usr/local/opt/fzf/shell/key-bindings.zsh"
}

setup_fzf

unset -f setup_fzf
