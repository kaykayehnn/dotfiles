# shellcheck shell=bash
# Define scripts here which would run after all other shell setup has been done.

# Customize colors for colored-man-pages plugin.
# TODO: It would be nice if this were in setup.zsh but it has to be executed
# after the plugin to override its default colors.
# shellcheck disable=SC2034,SC2154
less_termcap[mb]=$'\E[1;31m'
less_termcap[md]=$'\E[1;36m'
less_termcap[me]=$'\E[0m'
less_termcap[so]=$'\E[01;44;33m'
less_termcap[se]=$'\E[0m'
less_termcap[us]=$'\E[1;32m'
less_termcap[ue]=$'\E[0m'
