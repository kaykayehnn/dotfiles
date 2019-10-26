#!/usr/bin/env bash

# Use directory name as session identifier and remove invalid characters.
session_name="$(basename "$(pwd)" | sed 's/[^a-zA-Z0-9_-]//')"

# -t name searches for sessions starting with name, whereas -t=name looks for
# an exact match.
if ! tmux has-session -t="$session_name" 2> /dev/null
then
  # Create new session
  exec tmux new-session -s "$session_name"
else
  # Create new session attached to current session group.
  new_session_name=$(tmux new-session -t="$session_name" -d -P)
  tmux new-window -t="$new_session_name"
  exec tmux attach-session -t="${new_session_name}"
fi
