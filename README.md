# tmux-agent-pulse

**English** | [한국어](README.ko.md)

AI CLI status notifications for tmux. Supports Claude Code, Codex CLI, and Gemini CLI out of the box.

Shows status icons on tmux window names when AI CLI tools are active:

- **💬** — AI is responding (output detected for 2.5s+)
- **✅** — AI finished responding (output stopped)
- Icons auto-clear when you switch to the window

## How it works

A background daemon polls all tmux panes every 0.5s. It inspects child processes of each pane (`ps -eo pid,ppid,args`) to detect AI CLI tools, then compares output snapshots to track activity changes. No hooks or configuration needed.

## Install

### Requirements

- tmux 3.0+
- [TPM](https://github.com/tmux-plugins/tpm)

> **Note:** The plugin automatically enables the tmux status bar (`set -g status on`) on load, as it's required to display window name icons.

### With TPM

Add to `~/.tmux.conf`:

```bash
set -g @plugin 'devbrother2024/tmux-agent-pulse'
```

Then press `prefix + I` to install.

### Manual

```bash
git clone https://github.com/devbrother2024/tmux-agent-pulse ~/.tmux/plugins/tmux-agent-pulse
```

Add to `~/.tmux.conf`:

```bash
run-shell ~/.tmux/plugins/tmux-agent-pulse/agent-pulse.tmux
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
| `CLAUDE_NOTIFY_CLI_PATTERN` | `claude\|codex\|gemini` | Regex pattern to match CLI tool names in process args |

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
