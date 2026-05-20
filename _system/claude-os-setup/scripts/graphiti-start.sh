#!/usr/bin/env bash
# graphiti-start.sh — start the Graphiti MCP server for Claude Code.
#
# SETUP: Set MCP_DIR to the absolute path of your graphiti mcp_server folder.
# Then register this script as an MCP server in ~/.claude/settings.json:
#
#   "mcpServers": {
#     "graphiti": {
#       "command": "/bin/bash",
#       "args": ["~/.claude/scripts/graphiti-start.sh"],
#       "type": "stdio"
#     }
#   }
#
# Graphiti repo: https://github.com/getzep/graphiti

set -euo pipefail

# ─── CONFIGURE THIS ────────────────────────────────────────────────────────────
MCP_DIR="${GRAPHITI_MCP_DIR:-$HOME/path/to/graphiti/mcp_server}"
CONFIG_FILE="${GRAPHITI_CONFIG:-$MCP_DIR/config/config.yaml}"
# ───────────────────────────────────────────────────────────────────────────────

if [ ! -d "$MCP_DIR" ]; then
  echo "Graphiti MCP server directory not found: $MCP_DIR" >&2
  echo "Set GRAPHITI_MCP_DIR env var or edit MCP_DIR in this script." >&2
  exit 1
fi

# Load credentials
if [ -f "$MCP_DIR/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$MCP_DIR/.env"
  set +a
fi

exec uv run --project "$MCP_DIR" "$MCP_DIR/main.py" \
  --transport stdio \
  --config "$CONFIG_FILE"
