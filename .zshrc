# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Variables
export DOTFILES="$HOME/.dotfiles"
export LANG="en_US.UTF-8"
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  vscode
  zsh-syntax-highlighting
  yarn
  extract
  docker
  docker-compose
  fzf
  z
  # TODO: colored-man-pages does not handle some edge cases correctly.
  # Submit a PR to improve it
  # See the following commit for reference
  # https://github.com/kaykayehnn/dotfiles/commit/a2ee11528b079f0d1b324fe224ae90e79f04e582
  colored-man-pages
  command-not-found
  magic-enter
  thefuck
  tmux
  transfer
  urltools
)

if [[ "$OSTYPE" == "darwin"* ]]; then # macOS
  plugins+=osx
fi

# This is the zsh-completions plugin inlined for better performance. The only
# thing it does is add its src folder to fpath, however since oh-my-zsh
# executes compinit before plugins, the plugin's readme suggests running
# compinit again after sourcing oh-my-zsh. This is redundant and can be avoided
# by inlining the plugin before sourcing oh-my-zsh.
fpath+="$ZSH/custom/plugins/zsh-completions/src"

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6A6A6A'

# Source custom shell files before zsh to be able to make overrides.
source $DOTFILES/shell/aliases.zsh
source $DOTFILES/shell/setup.zsh
source $DOTFILES/shell/theme.zsh

source $ZSH/oh-my-zsh.sh

# This plugin doesn't follow the naming conventions so zsh cannot load it
# automatically.
source $ZSH_CUSTOM/plugins/zsh-you-should-use/you-should-use.plugin.zsh

# In case extra.zsh does not exist the initial prompt renders an error exit
# code as this is the last command executed before it. We OR it with true to
# work around this issue.
[ -e "$DOTFILES/shell/extra.zsh" ] && source "$DOTFILES/shell/extra.zsh" || true

# Run shell post-hooks
source $DOTFILES/shell/post_hook.zsh
