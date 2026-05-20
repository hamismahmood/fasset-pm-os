#!/usr/bin/env bash
# install.sh — one-command setup for the Claude OS on a new machine
#
# Usage: bash install.sh
#
# What it does:
#   1. Creates ~/.claude/scripts/, hooks/, skills/, agents/ if needed
#   2. Copies scripts, hooks, skills, and template agents into place
#   3. Makes scripts executable
#   4. Writes ~/.claude/CLAUDE.md from template (if not already present)
#   5. Writes a baseline ~/.claude/settings.json (if not already present)
#   6. Prints next steps

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "================================================"
echo "  Claude OS — install"
echo "================================================"
echo ""

# ── 1. Create dirs ──────────────────────────────────

echo "[1/5] Creating ~/.claude/ structure..."
mkdir -p "$CLAUDE_DIR/scripts"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/agents"
echo "  Done."

# ── 2. Copy scripts ─────────────────────────────────

echo ""
echo "[2/5] Installing scripts..."
cp "$REPO_DIR/scripts/"*.sh "$CLAUDE_DIR/scripts/"
[ -f "$REPO_DIR/scripts/save-session.py" ] && cp "$REPO_DIR/scripts/save-session.py" "$CLAUDE_DIR/scripts/"
chmod +x "$CLAUDE_DIR/scripts/"*.sh
echo "  Installed: $(ls "$CLAUDE_DIR/scripts/" | tr '\n' ' ')"

# ── 3. Copy hooks ───────────────────────────────────

echo ""
echo "[3/5] Installing hooks..."
cp "$REPO_DIR/hooks/"*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/"*.sh
echo "  Installed: $(ls "$CLAUDE_DIR/hooks/" | tr '\n' ' ')"

# ── 4. Copy skills ──────────────────────────────────

echo ""
echo "[4/5] Installing skills..."
for skill_dir in "$REPO_DIR/skills/"/*/; do
  skill_name="$(basename "$skill_dir")"
  mkdir -p "$CLAUDE_DIR/skills/$skill_name"
  cp -r "$skill_dir"* "$CLAUDE_DIR/skills/$skill_name/" 2>/dev/null || true
done
echo "  Installed: $(ls "$CLAUDE_DIR/skills/" | tr '\n' ' ')"

# ── 5. Copy template agents ─────────────────────────

echo ""
echo "[5/5] Installing template agents..."
cp "$REPO_DIR/template-agents/"*.md "$CLAUDE_DIR/agents/"
echo "  Installed: $(ls "$CLAUDE_DIR/agents/" | tr '\n' ' ')"

# ── CLAUDE.md ────────────────────────────────────────

if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$REPO_DIR/CLAUDE.md.template" "$CLAUDE_DIR/CLAUDE.md"
  echo ""
  echo "  Wrote ~/.claude/CLAUDE.md from template."
  echo "  → Open it and replace <YOUR_NAME> with your name."
else
  echo ""
  echo "  ~/.claude/CLAUDE.md already exists — not overwritten."
fi

# ── settings.json ────────────────────────────────────

if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  cat > "$CLAUDE_DIR/settings.json" <<'EOF'
{
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "model": "sonnet",
  "effortLevel": "high",
  "skipDangerousModePermissionPrompt": true,
  "theme": "light",
  "agentPushNotifEnabled": true,
  "skipAutoPermissionPrompt": true,
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/session-start.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/session-end.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/stop-notify.sh",
            "timeout": 5,
            "async": true
          }
        ]
      }
    ]
  },
  "mcpServers": {}
}
EOF
  echo "  Wrote ~/.claude/settings.json (baseline — add MCPs manually)."
else
  echo "  ~/.claude/settings.json already exists — not overwritten."
fi

# ── Done ─────────────────────────────────────────────

echo ""
echo "================================================"
echo "  Install complete!"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Edit ~/.claude/CLAUDE.md"
echo "     Replace <YOUR_NAME> and update the OS list"
echo "     to match the domains you want to work in."
echo ""
echo "  2. Install Claude Code (if not already):"
echo "     npm install -g @anthropic-ai/claude-code"
echo ""
echo "  3. (Optional) Set up Graphiti for persistent memory."
echo "     Edit ~/.claude/scripts/graphiti-start.sh to point"
echo "     at your Graphiti MCP server, then add it to"
echo "     ~/.claude/settings.json under mcpServers."
echo ""
echo "  4. Open Claude Code in any directory and run:"
echo "     /bootstrap-os <YourOS_Name>"
echo "     e.g. /bootstrap-os Consulting_OS"
echo ""
echo "  That's it. Claude will scaffold the folder and"
echo "  walk you through setting up agents."
echo ""
