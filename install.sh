#!/usr/bin/env bash
# This script is idempotent - you can run it at any time to update your
# installation.

# Set dotfiles dir in case we are running this script for the first time.
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

install_shell() {
  # Check if oh-my-zsh is installed
  if ! [ -e "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    # RUNZSH=no skips entering zsh after installation to continue executing the
    # rest of this script.
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi

  : "${ZSH_CUSTOM:="$HOME/.oh-my-zsh/custom"}"
  # Check if powerlevel10k is installed
  if ! [ -e "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
  fi

  ZSH_PLUGINS=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-completions
    MichaelAquilina/zsh-you-should-use
  )

  # Install zsh plugins
  for plugin in "${ZSH_PLUGINS[@]}"; do
    pluginPath="$ZSH_CUSTOM/plugins/$(basename $plugin)"
    if ! [ -e "$pluginPath" ]; then
      git clone --depth=1 "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/$(basename $plugin)"
    fi
  done

  # Install tmux plugin manager
  # https://github.com/tmux-plugins/tpm/blob/master/docs/automatic_tpm_installation.md
  if ! [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing tmux plugins..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  # Install tmux plugins
  ~/.tmux/plugins/tpm/bin/install_plugins
}

install_packages() {
  # Check if brew is installed
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Pull latest tap repositories
  brew update

  # Install deps from Brewfile
  brew bundle --file="$DOTFILES/Brewfile"

  # Install npm packages
  yarn global add create-react-app \
    gatsby-cli \
    jest \
    kaykayehnn/live-server#fix-crash-loading-config \
    netlify-cli \
    nodemon \
    parrotsay \
    prettier \
    serve@^6 \
    source-map-explorer \
    typescript \
    vtop \
    webpack-bundle-analyzer

  # Install vscode extensions
  # Without force vscode does not update already installed extensions
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension CoenraadS.bracket-pair-colorizer --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension dbaeumer.vscode-eslint --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension eamodio.gitlens --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension EditorConfig.EditorConfig --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension esbenp.prettier-vscode --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension Gruntfuggly.todo-tree --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension msjsdiag.debugger-for-chrome --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension PKief.material-icon-theme --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension pnp.polacode --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension sdras.night-owl --force
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension VisualStudioExptTeam.vscodeintellicode --force

  # Check if iTerm2 shell integration is installed
  if ! [ -e "$HOME/.iterm2" ]; then
    curl -fsSL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
  fi

  # Update tldr pages
  tldr --update

  # Install mkcert's Certificate Authority in the system trust store
  mkcert -install
}

install_shell
install_packages
