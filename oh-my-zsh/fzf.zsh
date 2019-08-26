FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"

export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
export FZF_CTRL_T_COMMAND="$FD_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
export FZF_TMUX="1"

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

