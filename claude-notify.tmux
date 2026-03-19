#!/bin/bash
# tmux-claude-notify: Claude Code status notification for tmux
# https://github.com/devbrother2024/tmux-claude-notify

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SCRIPT="$CURRENT_DIR/scripts/daemon.sh"

# Ensure status bar is enabled (required to see window name icons)
tmux set -g status on

# Kill existing daemon if running
pkill -f "claude-notify.*daemon.sh" 2>/dev/null

# Start daemon in background
tmux run-shell -b "bash $DAEMON_SCRIPT"
