#!/usr/bin/env zsh
# The default bash shipped with macOS (3.2) does not support associative
# arrays. In order to run this this script you need zsh or a newer version of
# bash.

# Assign default values in case .zshrc has not been sourced (such as during first install).
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# This associative array holds source:target pairs which need to be symlinked.
typeset -A SYMLINK_MAP=(
  # RC files
  "$DOTFILES/.zshrc" "$HOME/.zshrc"
  "$DOTFILES/.myclirc" "$HOME/.myclirc"
  "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  "$DOTFILES/.gitignore_global" "$HOME/.config/git/ignore"
  "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
  "$DOTFILES/glances.conf" "/usr/local/etc/glances/glances.conf"
  "$DOTFILES/micro.json" "$HOME/.config/micro/settings.json"
  "$DOTFILES/httpie.json" "$HOME/.httpie/config.json"
  # VSCode files
  "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  "$DOTFILES/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
  "$DOTFILES/vscode/snippets/" "$HOME/Library/Application Support/Code/User/snippets"
)

# Exit with 0 if all files linked successfully, with 1 if any of them failed.
exit_code=0

for source in "${(@k)SYMLINK_MAP}"; do
  target="${SYMLINK_MAP[$source]}"

  # If target exists
  if [ -e "$target" ]; then
    # and it is a symlink
    if [ -L "$target" ]; then
      targetSource=$(readlink "$target")
      if [ "$source" = "$targetSource" ]; then
        # It is already linked, do nothing
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
