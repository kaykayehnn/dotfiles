#!/usr/bin/env bash

# Assign default values in case .zshrc has not been sourced (such as during first install).
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

VSCODE_ROOT=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  VSCODE_ROOT="$HOME/.config/Code"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  VSCODE_ROOT="$HOME/Library/Application Support/Code"
else
  echo "Unknown OS $OSTYPE, aborting"
  exit 1
        # Unknown.
fi


# This array holds source:target pairs which need to be symlinked.
SYMLINK_MAP=(
  # RC files
  "$DOTFILES/.zshrc" "$HOME/.zshrc"
  "$DOTFILES/.myclirc" "$HOME/.myclirc"
  "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  "$DOTFILES/.gitignore_global" "$HOME/.config/git/ignore"
  "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
  "$DOTFILES/httpie.json" "$HOME/.httpie/config.json"
  "$DOTFILES/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  "$DOTFILES/.xbindkeysrc" "$HOME/.xbindkeysrc"
  "$DOTFILES/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
  "$DOTFILES/libinput-gestures.conf" "$HOME/.config/libinput-gestures.conf"
  # VSCode files
  "$DOTFILES/vscode/settings.json" "$VSCODE_ROOT/User/settings.json"
  "$DOTFILES/vscode/keybindings.json" "$VSCODE_ROOT/User/keybindings.json"
  "$DOTFILES/vscode/snippets/" "$VSCODE_ROOT/User/snippets"
)

# Exit with 0 if all files linked successfully, with 1 if any of them failed.
exit_code=0

# Start the for loop at 1 because seq uses <= instead of <. That way we iterate
# all pairs like so: (0, 1) (2, 3) on an array of length 4.
for i in $(seq 1 2 ${#SYMLINK_MAP[@]}); do
  source="${SYMLINK_MAP[$i - 1]}"
  target="${SYMLINK_MAP[$i]}"

  # If target exists
  if [ -e "$target" ]; then
    # and it is a symlink
    if [ -L "$target" ]; then
      targetSource=$(readlink "$target")
      if [ "$source" = "$targetSource" ]; then
        : # It is already linked, do nothing
      else
        exit_code=1
        echo "$source could not be linked because a symbolic link already exists at $target\nThe symbolic link points to $targetSource"
      fi

      continue
    else
      echo "$source could not be linked because $target exists."
    fi

    exit_code=1
    continue
  fi

  # Ensure directory exists
  mkdir -p "$(dirname "$target")"

  ln -s "$source" "$target"
  echo "Linked $source..."
done

exit $exit_code
