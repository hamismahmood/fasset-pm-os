#!/usr/bin/env bash
# Universal session-start hook — fires at every Claude Code session start.
# 1. Writes a start-time marker for duration tracking.
# 2. Appends an open entry to the session timing log.
# 3. Instructs Claude to query Graphiti at the right scope.

set -euo pipefail

CWD="$(pwd)"
SESSION_LOG="$HOME/.claude/session-timing.log"
START_MARKER="$HOME/.claude/.session-current-start"

# ── Time tracking ──────────────────────────────────────────────────────────────
date +%s > "$START_MARKER"

# Detect OS and project from cwd (dynamic — no hardcoded names)
ACTIVE_OS_GROUP=""
if [[ "$CWD" == */Documents/* ]]; then
  # Extract the folder immediately under Documents/
  OS_FOLDER="$(echo "$CWD" | sed -n 's|.*/Documents/\([^/]*\).*|\1|p')"
  ACTIVE_OS_GROUP="$(echo "$OS_FOLDER" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"
fi

ACTIVE_PROJECT=""
if [[ "$CWD" == *"/projects/"* ]]; then
  ACTIVE_PROJECT="$(echo "$CWD" | sed -n 's|.*/projects/\([^/]*\).*|\1|p')"
fi

# Append open entry to timing log (end hook will fill in duration)
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)	START	${ACTIVE_OS_GROUP:-global}	${ACTIVE_PROJECT:-}	$CWD" >> "$SESSION_LOG"

# ── Graphiti context instruction ───────────────────────────────────────────────
SCOPE_LINE="Working scope: global"
[ -n "$ACTIVE_OS_GROUP" ]  && SCOPE_LINE="$SCOPE_LINE + ${ACTIVE_OS_GROUP}"
[ -n "$ACTIVE_PROJECT" ]   && SCOPE_LINE="$SCOPE_LINE + ${ACTIVE_PROJECT}"

GROUPS_JSON='["global"]'
[ -n "$ACTIVE_OS_GROUP" ]  && GROUPS_JSON="[\"global\", \"${ACTIVE_OS_GROUP}\"]"
[ -n "$ACTIVE_PROJECT" ]   && GROUPS_JSON="[\"global\", \"${ACTIVE_OS_GROUP}\", \"${ACTIVE_PROJECT}\"]"

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Universal Claude session starting. ${SCOPE_LINE}.\n\nBefore your first response, do the following in order:\n1. Call mcp__graphiti__search_memory_facts with group_ids: ${GROUPS_JSON} and a query relevant to the active scope.\n2. Call mcp__graphiti__search_nodes with the same group_ids for entity context.\n3. If inside an OS folder, read the last 3 entries of <OS>/session_log.md for continuity.\n4. Greet the user and reference recent work if relevant.\n\nIf Graphiti is unreachable, fall back to MEMORY.md and session_log.md.\n\nUniversal agents available: agent-architect, system-analyst, devils-advocate, discovery-agent, trend-analyst. OS agents available when inside an OS folder."
  }
}
EOF
