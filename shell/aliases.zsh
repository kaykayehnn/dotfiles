# Put shell aliases and custom functions here.

# Pings Cloudflare's DNS server
alias ping1="ping 1.1.1.1"
alias batpkg="bat package.json"
alias dot="cd ~/.dotfiles"
# Add colors to man pages
alias man="LESS_TERMCAP_mb=$'\E[1;31m' \
  LESS_TERMCAP_md=$'\E[1;36m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[01;44;33m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[1;32m' \
  LESS_TERMCAP_ue=$'\E[0m' man"

alias weather="curl v2.wttr.in"
