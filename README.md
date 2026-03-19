# tmux-claude-notify

**English** | [한국어](README.ko.md)

Claude Code status notifications for tmux. No Claude Code configuration required.

Shows status icons on tmux window names when Claude Code is active in background windows:

- **💬** — Claude is responding (output detected for 2.5s+)
- **✅** — Claude finished responding (output stopped)
- Icons auto-clear when you switch to the window

## How it works

A background daemon polls all tmux panes every 0.5s. It identifies Claude Code panes by their process name (version pattern like `2.1.78`) and compares output snapshots to detect activity changes. No Claude Code hooks or configuration needed.

## Install

### Requirements

- tmux 3.0+
- [TPM](https://github.com/tmux-plugins/tpm)

> **Note:** The plugin automatically enables the tmux status bar (`set -g status on`) on load, as it's required to display window name icons.

### With TPM

Add to `~/.tmux.conf`:

```bash
set -g @plugin 'devbrother2024/tmux-claude-notify'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/devbrother2024/tmux-claude-notify ~/.tmux/plugins/tmux-claude-notify
```

Add to `~/.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/tmux-claude-notify/claude-notify.tmux
```

## Configuration

Optional environment variables (set before the plugin loads):

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_NOTIFY_INTERVAL` | `0.5` | Poll interval in seconds |
| `CLAUDE_NOTIFY_THRESHOLD` | `5` | Consecutive changes needed to detect responding |
| `CLAUDE_NOTIFY_DONE_THRESHOLD` | `3` | Consecutive unchanged polls needed to detect done |
| `CLAUDE_NOTIFY_ICON_RESPONDING` | `💬` | Icon for responding state |
| `CLAUDE_NOTIFY_ICON_DONE` | `✅` | Icon for done state |

Example in `~/.tmux.conf`:

```bash
set-environment -g CLAUDE_NOTIFY_THRESHOLD 3
set-environment -g CLAUDE_NOTIFY_ICON_DONE "⏎"
```

## Uninstall

1. Remove the plugin line from `~/.tmux.conf`
2. Press `prefix + alt + u` (TPM uninstall)
3. Clean up temp files: `rm -rf /tmp/claude-tmux-*`

## License

MIT
