#!/bin/bash
# tmux-agent-pulse: AI CLI status notifications for tmux
# https://github.com/devbrother2024/tmux-agent-pulse

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SCRIPT="$CURRENT_DIR/scripts/daemon.sh"

# Ensure status bar is enabled (required to see window name icons)
tmux set -g status on

# Kill existing daemon if running
pkill -f "agent-pulse.*daemon.sh" 2>/dev/null

# Start daemon in background
tmux run-shell -b "bash $DAEMON_SCRIPT"
