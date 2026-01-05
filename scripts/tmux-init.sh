#!/usr/bin/env bash

set -e

[ -n "$TMUX" ] && exit 0

tmux has-session -t dsa 2>/dev/null || tmux new-session -d -s dsa
tmux has-session -t setting 2>/dev/null || tmux new-session -d -s setting

if ! tmux has-session -t working 2>/dev/null; then
  tmux new-session -d -s working -n main

  tmux send-keys -t working:main.1 'cd ~/go/src/proj' C-m

  tmux split-window -t working:main -h
  tmux send-keys -t working:main.2 'cd ~/go/src/proto' C-m

  tmux select-layout -t working:main even-horizontal

  tmux new-window -t working -n local
  tmux send-keys -t working:local 'cd ~/local' C-m

  tmux select-window -t working:main
fi

tmux attach -t working
