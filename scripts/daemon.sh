#!/bin/bash
# Claude Code tmux notification daemon
# Detects Claude Code panes by process name (version pattern N.N.N)
# and shows status icons on inactive windows:
#   💬 = responding (sustained output for 2.5s+)
#   ✅ = done (output stopped after responding)

SNAPSHOT_DIR="/tmp/claude-tmux-snapshots"
STATE_DIR="/tmp/claude-tmux-states"
COUNTER_DIR="/tmp/claude-tmux-counters"
DONE_COUNTER_DIR="/tmp/claude-tmux-done-counters"
mkdir -p "$SNAPSHOT_DIR" "$STATE_DIR" "$COUNTER_DIR" "$DONE_COUNTER_DIR"

POLL_INTERVAL="${CLAUDE_NOTIFY_INTERVAL:-0.5}"
THRESHOLD="${CLAUDE_NOTIFY_THRESHOLD:-5}"
DONE_THRESHOLD="${CLAUDE_NOTIFY_DONE_THRESHOLD:-3}"
ICON_RESPONDING="${CLAUDE_NOTIFY_ICON_RESPONDING:-💬}"
ICON_DONE="${CLAUDE_NOTIFY_ICON_DONE:-✅}"

# md5 command differs between macOS and Linux
if command -v md5 &>/dev/null; then
  MD5_CMD="md5 -q"
elif command -v md5sum &>/dev/null; then
  MD5_CMD="md5sum | cut -d' ' -f1"
fi

while true; do
  VISIBLE=$(tmux list-clients -F '#{session_name}:#{window_index}' 2>/dev/null)

  tmux list-panes -a -F '#{session_name}:#{window_index} #{pane_id} #{pane_current_command}' 2>/dev/null | while read TARGET PANE_ID CMD; do
    # Claude Code pane detection (version pattern: N.N.N)
    echo "$CMD" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$' || continue

    PANE_KEY=$(echo "$PANE_ID" | tr -d '%')
    SNAP_FILE="$SNAPSHOT_DIR/$PANE_KEY"
    STATE_FILE="$STATE_DIR/$PANE_KEY"
    COUNT_FILE="$COUNTER_DIR/$PANE_KEY"
    DONE_COUNT_FILE="$DONE_COUNTER_DIR/$PANE_KEY"
    STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "idle")
    COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo "0")
    DONE_COUNT=$(cat "$DONE_COUNT_FILE" 2>/dev/null || echo "0")

    WINDOW_NAME=$(tmux display-message -t "$TARGET" -p '#{window_name}' 2>/dev/null) || continue
    CLEAN_NAME=$(echo "$WINDOW_NAME" | sed "s/^[$ICON_DONE$ICON_RESPONDING] //")

    # User is viewing this window → clear done icon, but keep responding icon
    if echo "$VISIBLE" | grep -qF "$TARGET"; then
      if [ "$STATE" = "done" ]; then
        [ "$WINDOW_NAME" != "$CLEAN_NAME" ] && tmux rename-window -t "$TARGET" "$CLEAN_NAME" 2>/dev/null
        echo "idle" > "$STATE_FILE"
        echo "0" > "$COUNT_FILE"
        echo "0" > "$DONE_COUNT_FILE"
        rm -f "$SNAP_FILE"
        continue
      fi
    fi

    # Compare pane output snapshot
    CURRENT=$(tmux capture-pane -t "$PANE_ID" -p -S -3 2>/dev/null | eval "$MD5_CMD")
    LAST=$(cat "$SNAP_FILE" 2>/dev/null)
    echo "$CURRENT" > "$SNAP_FILE"

    [ -z "$LAST" ] && continue

    if [ "$CURRENT" != "$LAST" ]; then
      COUNT=$((COUNT + 1))
      echo "$COUNT" > "$COUNT_FILE"
      echo "0" > "$DONE_COUNT_FILE"

      if [ "$COUNT" -ge "$THRESHOLD" ] && [ "$STATE" != "responding" ]; then
        echo "responding" > "$STATE_FILE"
        [ "$WINDOW_NAME" != "$ICON_RESPONDING $CLEAN_NAME" ] && tmux rename-window -t "$TARGET" "$ICON_RESPONDING $CLEAN_NAME" 2>/dev/null
      fi
    else
      if [ "$STATE" = "responding" ]; then
        DONE_COUNT=$((DONE_COUNT + 1))
        echo "$DONE_COUNT" > "$DONE_COUNT_FILE"
        if [ "$DONE_COUNT" -ge "$DONE_THRESHOLD" ]; then
          echo "done" > "$STATE_FILE"
          tmux rename-window -t "$TARGET" "$ICON_DONE $CLEAN_NAME" 2>/dev/null
          echo "0" > "$COUNT_FILE"
        fi
      else
        echo "0" > "$COUNT_FILE"
      fi
    fi
  done

  sleep "$POLL_INTERVAL"
done
