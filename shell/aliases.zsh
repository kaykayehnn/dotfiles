# Put shell aliases and custom functions here.

# Pings Cloudflare's DNS server
alias ping1="ping 1.1.1.1"
alias batpkg="bat package.json"
alias dot="cd ~/.dotfiles"
alias weather="curl v2.wttr.in"

# Augments man by adding colors and handling shell builtins.
man() {
  local COLORS="LESS_TERMCAP_mb=$'\E[1;31m' \
    LESS_TERMCAP_md=$'\E[1;36m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[01;44;33m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[1;32m' \
    LESS_TERMCAP_ue=$'\E[0m'"

  for argument in "$@"; do
    # If argument's man page resolves to the location for builtins,
    if [ "$(command man --path -- "$1")" "==" "$(command man --path "builtin")" ]; then
      # opens the builtins man page and searches for the first occurrence of
      # the command with paragraph-like indentation.
      eval "command man zshbuiltins | $COLORS less -p '^       $1 '"
    else
      eval "$COLORS command man -- '$argument'"
    fi
  done
}
