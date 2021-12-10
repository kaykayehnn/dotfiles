#!/usr/bin/env sh
set -e

# Remember we cannot import any scripts here, as this script needs to be
# pipeable.

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

git clone --depth=1 https://github.com/kaykayehnn/dotfiles "$DOTFILES"
cd "$DOTFILES"

./tools/link.sh
./tools/install.sh

echo "Successfully installed dotfiles."