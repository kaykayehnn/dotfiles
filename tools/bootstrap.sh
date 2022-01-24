#!/usr/bin/env sh
# This script has to be sh-compatible, as some environments don't have bash
# preinstalled (e.g. Alpine)

# Pipefail is not available in sh.
set -eu

# Remember we cannot import any scripts here, as this script needs to be
# pipeable.

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

git clone --depth=1 https://github.com/kaykayehnn/dotfiles "$DOTFILES"
cd "$DOTFILES"

# TODO: check if bash is installed
./tools/link.sh
./tools/install.sh

echo "Successfully installed dotfiles."
