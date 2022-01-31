#!/usr/bin/env sh
# This script has to be sh-compatible, as some environments don't have bash
# preinstalled (e.g. Alpine)

# Pipefail is not available in sh.
set -eu

# Remember we cannot import any scripts here, as this script needs to be
# pipeable.

# You can set these variables before running the script to configure it based
# on your needs. For example: `export BRANCH=dev`
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
GIT_BRANCH="${BRANCH:-main}"

git clone --depth=1 --branch "$GIT_BRANCH" https://github.com/kaykayehnn/dotfiles "$DOTFILES"

# Clear branch so it doesn't interfere with oh-my-zsh's options.
unset BRANCH

cd "$DOTFILES"

# TODO: check if bash is installed
./tools/link.sh
./tools/install.sh

echo "Successfully installed dotfiles."
