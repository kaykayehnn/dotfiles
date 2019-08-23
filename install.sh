#!/usr/bin/env bash

# Run without downloading:
# curl https://raw.githubusercontent.com/kaykayehnn/dotfiles/master/.macos | bash

# Check if brew is installed
if ! command -v brew > /dev/null 2>&1; then
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

# Check if oh-my-zsh is installed
if ! [ -e "$HOME/.oh-my-zsh" ]; then
	echo "Installing oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

OMZ_PLUGINS=(
# Fish-like fast/unobtrusive autosuggestions for zsh.
  zsh-users/zsh-autosuggestions
# Fish shell-like syntax highlighting for Zsh.
  zsh-users/zsh-syntax-highlighting
# Additional completion definitions for Zsh.
  zsh-users/zsh-completions
)

# Install OMZ plugins
: "${ZSH_CUSTOM:="$HOME/.oh-my-zsh/custom"}"
for plugin in "${OMZ_PLUGINS[@]}"; do
	pluginPath="$ZSH_CUSTOM/plugins/$(basename $plugin)"
	if ! [ -e "$pluginPath" ]; then
  	echo git clone "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/$(basename $plugin)"
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
	jasonnutter.search-node-modules
	johnpapa.vscode-peacock
	msjsdiag.debugger-for-chrome
	PKief.material-icon-theme
	pnp.polacode
	sdras.night-owl
	VisualStudioExptTeam.vscodeintellicode
	wayou.vscode-todo-highlight
)

for extension in "${CODE_EXTENSIONS[@]}"; do
	/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension "$extension"
done
