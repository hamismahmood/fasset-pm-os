#!/usr/bin/env bash
# Universal SubagentStart audit. Writes to <OS>/.claude/agent-audit.log.
set -euo pipefail

PROJ_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG="${PROJ_DIR}/.claude/agent-audit.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

PAYLOAD="$(cat)"
AGENT="$(printf '%s' "$PAYLOAD" | /usr/bin/python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
    print(d.get("subagent_type") or d.get("agent_type") or d.get("matcher") or "unknown")
except Exception:
    print("unknown")' 2>/dev/null || echo unknown)"

mkdir -p "$(dirname "$LOG")"
printf '%s\tSubagentStart\t%s\n' "$TS" "$AGENT" >> "$LOG"
exit 0
