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
  "$DOTFILES_DIR/.yarnrc" "$HOME/.yarnrc"
  "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
  "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
	# Micro editor config
  "$DOTFILES_DIR/micro.json" "$HOME/.config/micro/settings.json"
	# VSCode files
  "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
  "$DOTFILES_DIR/vscode/snippets/" "$HOME/Library/Application Support/Code/User/snippets"
)

# Add zsh custom files
for filename in $DOTFILES_DIR/oh-my-zsh/*.zsh; do
    SYMLINK_MAP[$filename]="$ZSH_CUSTOM/$(basename $filename)"
done

# Link files
for source target in ${(kv)SYMLINK_MAP}; do
	# Target is already linked
	if [ -L "$target" ]; then
		targetSource=$(readlink "$target")
    if [ "$source" = $targetSource ]; then
			echo "$source is already linked"
    else
      echo "$source could not be linked as a symbolic link already exists at $target\nThe symbolic link points to $targetSource"
    fi

		continue
	fi

  # Target exists
  if [ -e "$target" ]; then
    echo $source could not be linked because $target exists.
		continue
  fi

	echo "Linking $source..."
  ln -s "$source" "$target"
done