#!/usr/bin/env bash
# Universal session-end hook — fires when a Claude Code session closes.
# 1. Calculates and logs session duration.
# 2. Instructs Claude to save a memory summary to Graphiti + session_log.md.

set -euo pipefail

CWD="$(pwd)"
SESSION_LOG="$HOME/.claude/session-timing.log"
START_MARKER="$HOME/.claude/.session-current-start"

# ── Time tracking ──────────────────────────────────────────────────────────────
DURATION_SECS=""
if [ -f "$START_MARKER" ]; then
  START_EPOCH=$(cat "$START_MARKER")
  END_EPOCH=$(date +%s)
  DURATION_SECS=$((END_EPOCH - START_EPOCH))

  ACTIVE_OS_GROUP=""
  if [[ "$CWD" == */Documents/* ]]; then
    OS_FOLDER="$(echo "$CWD" | sed -n 's|.*/Documents/\([^/]*\).*|\1|p')"
    ACTIVE_OS_GROUP="$(echo "$OS_FOLDER" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"
  fi

  ACTIVE_PROJECT=""
  if [[ "$CWD" == *"/projects/"* ]]; then
    ACTIVE_PROJECT="$(echo "$CWD" | sed -n 's|.*/projects/\([^/]*\).*|\1|p')"
  fi

  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)	END	${ACTIVE_OS_GROUP:-global}	${ACTIVE_PROJECT:-}	${DURATION_SECS}s	$CWD" >> "$SESSION_LOG"
  rm -f "$START_MARKER"
fi

DURATION_NOTE=""
[ -n "$DURATION_SECS" ] && DURATION_NOTE=" Session duration: ${DURATION_SECS}s."

# ── Auto-memory instruction ────────────────────────────────────────────────────
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionEnd",
    "additionalContext": "Session ending.${DURATION_NOTE}\n\nBefore signing off:\n1. Call mcp__graphiti__add_memory with a session-summary episode at the narrowest relevant scope (project > os > global). Include: decisions made, files changed, what to pick up next time.\n2. If inside an OS folder, append an entry to <OS>/session_log.md using the standard template.\n3. If any corrections from this session apply broadly across domains, save them with group_id 'global'.\n4. Default to the narrowest scope — promote to wider scope only when a pattern repeats."
  }
}
EOF
