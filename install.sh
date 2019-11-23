#!/usr/bin/env bash
# This script is idempotent - you can run it at any time to update your
# installation.

# Check if brew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Pull latest tap repositories
brew update

# Install deps from Brewfile
brew bundle --file="$DOTFILES/Brewfile"

NPM_GLOBAL_PACKAGES=(
  create-react-app
  gatsby-cli
  jest
  live-server
  netlify-cli
  nodemon
  parrotsay
  prettier
  serve@^6
  source-map-explorer
  typescript
  vtop
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
)

# Install zsh plugins
for plugin in "${ZSH_PLUGINS[@]}"; do
  pluginPath="$ZSH_CUSTOM/plugins/$(basename $plugin)"
  if ! [ -e "$pluginPath" ]; then
    git clone --depth=1 "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/$(basename $plugin)"
  fi
done


# Install tmux plugin manager and plugins declared in .tmux.conf.
# tmux plugin declarations are declared like "set -g @plugin 'plugin-author/plugin-repo'"
# so the plugin path is the fourth field in the output.
for plugin in tmux-plugins/tpm $(awk '/@plugin/ { print $4 }' ~/.dotfiles/.tmux.conf | tr -d "'"); do
  plugin_name="$(basename $plugin)"
  plugin_directory="$HOME/.tmux/plugins/$plugin_name"
  if ! [ -d "$plugin_directory" ]; then
    # Print a loading statement, then overwrite it when cloning has completed.
    echo "Installing $plugin_name..."
    git clone --recursive --depth=1 --quiet "https://github.com/$plugin" "$plugin_directory" \
      && echo -e "\r\e[1KInstalled $plugin_name" \
      || echo -e "\r\e[1KInstalling $plugin_name failed"
  fi
done

CODE_EXTENSIONS=(
  CoenraadS.bracket-pair-colorizer
  dbaeumer.vscode-eslint
  eamodio.gitlens
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  Gruntfuggly.todo-tree
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
