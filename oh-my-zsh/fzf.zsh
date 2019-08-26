FD_COMMAND="fd --hidden --exclude .git --exclude node_modules"

export FZF_DEFAULT_COMMAND="$FD_COMMAND --type f"
export FZF_CTRL_T_COMMAND="$FD_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} 2> /dev/null || tree -I node_modules -C {})'"
export FZF_ALT_C_COMMAND="$FD_COMMAND --type d"
export FZF_ALT_C_OPTS="--preview 'tree -I node_modules -C {}'"
export FZF_TMUX="1"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
