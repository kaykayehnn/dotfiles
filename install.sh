#!/usr/bin/env bash
# This script is idempotent - you can run it at any time to update your
# installation.

# Check if brew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install deps from Brewfile
brew bundle

NPM_GLOBAL_PACKAGES=(
  create-react-app
  fx
  gatsby-cli
  jest
  netlify-cli
  nodemon
  prettier
  serve@^6
  source-map-explorer
  typescript
  webpack-bundle-analyzer
)

# Install npm packages
yarn global add ${NPM_GLOBAL_PACKAGES[@]}

RUBY_GEMS=(
  colorls
)

gem install "${RUBY_GEMS[@]}"

# Check if oh-my-zsh is installed
if ! [ -e "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

: "${ZSH_CUSTOM:="$HOME/.oh-my-zsh/custom"}"
# Check if powerlevel10k is installed
if ! [ -e "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

ZSH_PLUGINS=(
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-completions
)

# Install zsh plugins
for plugin in "${ZSH_PLUGINS[@]}"; do
  pluginPath="$ZSH_CUSTOM/plugins/$(basename $plugin)"
  if ! [ -e "$pluginPath" ]; then
    git clone "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/$(basename $plugin)"
  fi
done

# Install tmux plugin manager
# https://github.com/tmux-plugins/tpm/blob/master/docs/automatic_tpm_installation.md
if ! [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing tmux plugins..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

CODE_EXTENSIONS=(
  CoenraadS.bracket-pair-colorizer
  dbaeumer.vscode-eslint
  eamodio.gitlens
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  Gruntfuggly.todo-tree
  jasonnutter.search-node-modules
  johnpapa.vscode-peacock
  msjsdiag.debugger-for-chrome
  PKief.material-icon-theme
  pnp.polacode
  sdras.night-owl
  VisualStudioExptTeam.vscodeintellicode
)

for extension in "${CODE_EXTENSIONS[@]}"; do
  /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension "$extension" --force
done

# Update tldr pages
tldr --update
