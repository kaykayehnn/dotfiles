# support Compose v2 as docker CLI plugin
# DOCKER_CONTEXT=default command docker compose &>/dev/null \
#   && dccmd='docker compose' \
#   || dccmd='docker-compose'

# Skip checking for docker-CLI plugin to improve performance.
# TODO: Maybe send a PR to add an option for this?
dccmd="docker-compose"

# Add docker-compose completions. OMZ does this automatically but for this
# workaround, we need to do it manually.
fpath+=($ZSH/plugins/docker-compose)

alias dco="$dccmd"
alias dcb="$dccmd build"
alias dce="$dccmd exec"
alias dcps="$dccmd ps"
alias dcrestart="$dccmd restart"
alias dcrm="$dccmd rm"
alias dcr="$dccmd run"
alias dcstop="$dccmd stop"
alias dcup="$dccmd up"
alias dcupb="$dccmd up --build"
alias dcupd="$dccmd up -d"
alias dcdn="$dccmd down"
alias dcl="$dccmd logs"
alias dclf="$dccmd logs -f"
alias dcpull="$dccmd pull"
alias dcstart="$dccmd start"
alias dck="$dccmd kill"

unset dccmd
