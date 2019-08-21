# Remove git's completions in favour of zsh's.
# https://github.com/agross/dotfiles/commit/4938bc8987a5b4ef0c7411a2c4b988d89a3ade11
if [ -f /usr/local/share/zsh/site-functions/_git ]; then
  rm  -f /usr/local/share/zsh/site-functions/_git
fi

# Wrap git by hub:
eval "$(hub alias -s)"
