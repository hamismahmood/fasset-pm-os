#!/usr/bin/env bash
# Fires on the Stop hook — sends a macOS notification when Claude finishes a task.
# Only notifies if the session has been running for at least 120 seconds,
# so quick back-and-forth replies don't spam the notification centre.

set -euo pipefail

THRESHOLD=120
START_MARKER="$HOME/.claude/.session-current-start"

# Skip if no start marker or session is under the threshold
if [ ! -f "$START_MARKER" ]; then
  exit 0
fi

START_EPOCH=$(cat "$START_MARKER")
NOW_EPOCH=$(date +%s)
ELAPSED=$((NOW_EPOCH - START_EPOCH))

if [ "$ELAPSED" -lt "$THRESHOLD" ]; then
  exit 0
fi

CWD="$(pwd)"
PROJECT="$(basename "$CWD")"

osascript -e "display notification \"Done in $PROJECT\" with title \"Claude Code\" sound name \"Glass\"" 2>/dev/null || true
