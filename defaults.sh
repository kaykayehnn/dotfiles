#!/usr/bin/env bash

# Set screenshot format to jpg (default is png)
defaults write com.apple.screencapture type jpg

# EVALUATE: capslock as escape

killall SystemUIServer

# TODO: add hot corners

# TODO: add spaces switching shortcuts
# http://osxdaily.com/2011/09/06/switch-between-desktops-spaces-faster-in-os-x-with-control-keys/
