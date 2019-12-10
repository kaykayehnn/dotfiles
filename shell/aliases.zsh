# Put shell aliases and custom functions here.

# Pings Cloudflare's DNS server
alias ping1="ping 1.1.1.1"
alias batpkg="bat package.json"
alias dot="cd ~/.dotfiles"
alias weather="curl v2.wttr.in"
# Easier pasting of commands
alias "$"="eval"
# Brew aliases
alias b="brew"
alias bi="brew install"
alias bci="brew cask install"
alias bs="brew search"
alias bup="brew upgrade && brew upgrade"

# By default man shows the `builtin` page when looking for any shell builtin
# such as cd or alias, which is not very useful by itself. This function
# augments man to open the bash manual and scroll to the relevant section when
# searching for builtins.
# It also makes man prettier.
man() {
  # This subshell is used to keep the LESS variables scoped to the function.
  (
    export LESS_TERMCAP_mb=$'\E[1;31m'
    export LESS_TERMCAP_md=$'\E[1;36m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[1;32m'
    export LESS_TERMCAP_ue=$'\E[0m'

    # If there are no arguments or any option arguments forward them to man and
    # exit early.
    if [[ $# = 0 ]]; then
      command man
      return
    fi
    for argument; do
      if [[ $argument =~ "^-" ]]; then
        command man "$@"
        return
      fi
    done

    # The exit code represent whether the last argument exited successfully.
    local exit_code
    for argument; do
      local man_path="$(command man --path -- "$argument")"
      # Skip argument if man could not find it's page.
      if [[ "$man_path" = "" ]]; then
        exit_code=1
        continue
      fi

      # If argument's man page resolves to the same path as builtins, except if
      # argument is "builtin" or "builtins", open bash man page and scroll to the
      # relevant section.
      if [[ ! ($argument =~ "^builtins?$") && $man_path = "/usr/share/man/man1/builtin.1" ]]; then
        command man bash | less -p "^       $argument "
      else
        command man -- "$argument"
      fi
      exit_code=$?
    done
    return $exit_code
  )
}
