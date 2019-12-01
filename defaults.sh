#!/usr/bin/env bash

# Set screenshot format to jpg (default is png)
defaults write com.apple.screencapture type jpg

# EVALUATE: capslock as escape

killall SystemUIServer

# TODO: maybe this should be in iterm2 branch?
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# TODO: add hot corners

# TODO: add spaces switching shortcuts
# http://osxdaily.com/2011/09/06/switch-between-desktops-spaces-faster-in-os-x-with-control-keys/
