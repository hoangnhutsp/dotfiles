#!/usr/bin/env bash

set -e

[ -n "$TMUX" ] && exit 0

tmux has-session -t dsa 2>/dev/null || tmux new-session -d -s dsa
tmux has-session -t setting 2>/dev/null || tmux new-session -d -s setting
tmux has-session -t working 2>/dev/null || tmux new-session -d -s working

tmux attach -t working
