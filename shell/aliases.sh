# shellcheck shell=bash
# Put shell aliases and custom functions here.

# Pings Cloudflare's DNS server
alias ping1="ping 1.1.1.1"
alias dot='cd $DOTFILES'
alias weather="curl v2.wttr.in"
alias ddg="ddgr"
# Ignore dollar sign (useful when executing copied commands)
alias $=""
# Common typo
alias c="cd"
# Brew aliases
alias b="brew"
alias bi="brew install"
alias bu="brew uninstall"
alias bca="brew --cask"
alias bci="brew install --cask"
alias bcu="brew uninstall --cask"
alias bs="brew search"
alias bss="brew services"
alias bssl="brew services list"
alias bssr="brew services restart"
alias bssta="brew services start"
alias bssto="brew services stop"
alias bup="brew update && brew upgrade"

alias xclip="xclip -selection clipboard"
alias open="open-cli"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Mirror macOS copy/paste commands
  alias pbcopy="xclip"
  alias pbpaste="xclip -o"
fi
