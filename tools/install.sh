#!/usr/bin/env bash
# This script is idempotent - you can run it at any time to update your
# installation.

set -euo pipefail

# Set dotfiles dir in case we are running this script for the first time.
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

main() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # First install packages common for all Linux distros
    pip3 install spotify-cli-linux

    # shellcheck source=/dev/null
    . /etc/os-release
    # Distro-specific installers
    if [[ "$NAME" == "Manjaro Linux" ]]; then
      # Regenerate mirrorlist
      # Optional: Move Bulgarian mirrors to the top
      sudo pacman-mirrors -c Bulgaria && sudo pacman -Syyu

      # Install yay
      sudo pacman -S --needed git base-devel
      mkdir ~/clone
      if ! [ -d ~/clone/yay ]; then
        git clone https://aur.archlinux.org/yay.git ~/clone/yay
        cd ~/clone/yay
        makepkg -si
      fi

      # TODO: make this a dictionary, where each package has multiple values
      # Support:
      # - package groups (a package depending on another package)
      # - entries for arch, ubuntu, darwin, etc.
      # - should we install package on any(or all) of the above platforms
      # - tags (like optional, fun etc.)

      # Add to pacman.conf
      # UseSyslog
      # Color
      # CheckSpace
      # VerbosePkgLists
      # ILoveCandy
      yay -Y --devel --combinedupgrade --batchinstall --save

      # Install other packages
      yay -S --needed neofetch tmux tealdeer ntfs-3g xclip vscodium-bin \
        vscodium-bin-marketplace kitty fzf exa hub nerd-fonts-fira-code \
        firefox-developer-edition thefuck pv gnu-netcat yarn nmap bat \
        libreoffice-still autossh gparted postman-bin plymouth notepadqq \
        plymouth-theme-manjaro ripgrep wakeonlan ncdu glances bashtop \
        discord sublime-text2 networkmanager-openvpn trash-cli tigervnc \
        dotnet-runtime dotnet-sdk visual-studio-code-bin rider docker spotify \
        signal-desktop nvme-cli obs-studio pinta kmag orca fd unrar httpie \
        copyq nnn youtube-dl git-delta chromium dog doge marktext lazygit \
        krusader dust bottom duf docker-compose cpufetch-git nmon awesome \
        autokey-qt nextcloud-client gimp mongodb-bin mongodb-tools-bin \
        mongodb-compass caprine xbindkeys xautomation xorg-xev joplin-desktop \
        tokei jq rpiplay-git torbrowser-launcher mpv kdenlive kvantum-qt5 \
        plasma5-applets-active-window-control latte-dock freetube-bin \
        # Install browser extension as well https://community.kde.org/Plasma/Browser_Integration
        plasma-browser-integration \
        kalendar slack-desktop aws-cli-v2-bin sysbench alacritty \
        libinput-gestures autofs cmatrix xorg-xinput img2pdf ocrmypdf glow \
        shellcheck
      # Install WhiteSur window decoration theme from KDE
      
      # DBeaver depends on jre11
      yay -S --needed dbeaver jre11-jdk

      # TODO: maybe add a variable for kernel version?
      yay -S --needed virtualbox linux510-virtualbox-host-modules

      # Uninstall stuff
      sudo pacman -R thunderbird snapd pamac-snap-plugin
    elif [[ "$NAME" == "Ubuntu" ]]; then
      sudo apt update
      sudo apt install -y zsh neofetch tmux htop tldr fzf
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Check if brew is installed
    if ! command -v brew >/dev/null 2>&1; then
      echo "Installing homebrew..."
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Pull latest tap repositories
    brew update

    # Install deps from Brewfile
    brew bundle --file="$DOTFILES/Brewfile"
  else
    echo "Unknown OS $OSTYPE, aborting"
    exit 1
    # Unknown.
  fi

  # Install npm packages if yarn exists
  if command -v yarn &> /dev/null; then
    yarn global add kaykayehnn/live-server#fix-crash-loading-config \
      nodemon \
      parrotsay \
      serve@^6
  fi

  # Check if oh-my-zsh is installed
  if ! [ -e "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    # RUNZSH=no skips entering zsh after installation to continue executing the
    # rest of this script.
    # KEEP_ZSHRC=yes tells OMZ not to overwrite our .zshrc.
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
    pluginPath="$ZSH_CUSTOM/plugins/$(basename "$plugin")"
    if ! [ -e "$pluginPath" ]; then
      git clone --depth=1 "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/$(basename "$plugin")"
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

  code_fallback() {
    if command -v code &> /dev/null; then
      code "$@"
    fi
    if command -v codium &> /dev/null; then
      codium "$@"
    fi
    # macOS before being linked to PATH
    if /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code &> /dev/null; then
      /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code "$@"
    fi
  }
  
  # Install vscode extensions
  # Without force vscode does not update already installed extensions
  code_fallback --install-extension dbaeumer.vscode-eslint --force
  code_fallback --install-extension eamodio.gitlens --force
  code_fallback --install-extension EditorConfig.EditorConfig --force
  code_fallback --install-extension esbenp.prettier-vscode --force
  code_fallback --install-extension Gruntfuggly.todo-tree --force
  code_fallback --install-extension styled-components.vscode-styled-components --force
  code_fallback --install-extension ms-dotnettools.csharp --force
  code_fallback --install-extension ms-python.python --force
  code_fallback --install-extension ms-python.vscode-pylance --force
  code_fallback --install-extension ms-vscode-remote.remote-ssh --force
  code_fallback --install-extension ms-vscode-remote.remote-ssh-edit --force
  code_fallback --install-extension PKief.material-icon-theme --force
  code_fallback --install-extension pnp.polacode --force
  code_fallback --install-extension sdras.night-owl --force
  code_fallback --install-extension VisualStudioExptTeam.vscodeintellicode --force
  code_fallback --install-extension ms-azuretools.vscode-docker --force
  code_fallback --install-extension redhat.vscode-xml --force

  # Update tldr pages if tldr is installed
  if command -v tldr &> /dev/null; then
    tldr --update
  fi

  # TODO: setup libinput-gestures
}

main
