# Define scripts here which would run after all other shell setup has been done.

# Autostart tmux on terminal startup
if [[ "$AUTO_TMUX" == "true" && -z "$TMUX" ]] && command -v tmux &> /dev/null ; then
  # Check if tmux server is running
  if tmux list-sessions &> /dev/null ; then
    exec tmux attach-session
  else
    exec tmux
  fi
fi
