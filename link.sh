#!/usr/bin/env zsh
# The default bash shipped with macOS (3.2) does not support associative
# arrays. In order to run this this script you need zsh.

# Assign default values in case they are not set.
: "${DOTFILES_DIR:="$HOME/.dotfiles"}"
: "${ZSH_CUSTOM:="$HOME/.oh-my-zsh/custom"}"

# This associative array holds source:target pairs which need to be symlinked.
typeset -A SYMLINK_MAP=(
  # RC files
  "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  "$DOTFILES_DIR/.myclirc" "$HOME/.myclirc"
  "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
  "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
  "$DOTFILES_DIR/glances.conf" "/usr/local/etc/glances/glances.conf"
  "$DOTFILES_DIR/micro.json" "$HOME/.config/micro/settings.json"
  "$DOTFILES_DIR/httpie.json" "$HOME/.httpie/config.json"
  # VSCode files
  "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
  "$DOTFILES_DIR/vscode/snippets/" "$HOME/Library/Application Support/Code/User/snippets"
  # Since vscode's configuration does not support using ~ or providing a
  # variable like $HOME, this is the most appropriate path to put such an
  # executable.
  "$DOTFILES_DIR/vscode/vscode-shell.sh" "/usr/local/bin/vscode-shell"
)

# Add zsh custom files
for filename in $DOTFILES_DIR/shell/*.zsh; do
    SYMLINK_MAP[$filename]="$ZSH_CUSTOM/$(basename $filename)"
done

# Exit with 0 if all files linked successfully, with 1 if any of them failed.
exit_code=0

for source target in ${(kv)SYMLINK_MAP}; do
  # Target is already linked
  if [ -L "$target" ]; then
    targetSource=$(readlink "$target")
    if [ "$source" = $targetSource ]; then
      echo "$source is already linked"
    else
      exit_code=1
      echo "$source could not be linked as a symbolic link already exists at $target\nThe symbolic link points to $targetSource"
    fi

    continue
  fi

  # Target exists
  if [ -e "$target" ]; then
    exit_code=1
    echo $source could not be linked because $target exists.
    continue
  fi

  # Ensure directory exists
  mkdir -p $(dirname $target)

  echo "Linking $source..."
  ln -s "$source" "$target"
done

exit $exit_code
