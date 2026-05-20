#!/usr/bin/env bash
# install-os-claude.sh — install or refresh the .claude/ layer in an OS folder.
# Idempotent: safe to run multiple times. Symlinks 00_agents/*.md into
# .claude/agents/, packaged 00_skills/<name>/SKILL.md folders into
# .claude/skills/, and writes shared settings.json + hooks.
#
# Usage: install-os-claude.sh <os-folder-absolute-path>

set -euo pipefail

OS_DIR="${1:-}"
if [ -z "$OS_DIR" ] || [ ! -d "$OS_DIR" ]; then
  echo "Usage: $0 <os-folder-absolute-path>" >&2
  echo "Example: $0 /Users/yourname/Documents/Marketing_OS" >&2
  exit 1
fi

OS_NAME="$(basename "$OS_DIR")"
echo "Installing .claude/ layer into: $OS_NAME"

# 1. Required canonical structure
mkdir -p "$OS_DIR/00_agents" "$OS_DIR/00_skills" "$OS_DIR/00_tools" "$OS_DIR/projects"
[ -f "$OS_DIR/CLAUDE.md" ]      || echo "# $OS_NAME" > "$OS_DIR/CLAUDE.md"
[ -f "$OS_DIR/MEMORY.md" ]      || echo "# Memory — $OS_NAME" > "$OS_DIR/MEMORY.md"
[ -f "$OS_DIR/session_log.md" ] || echo "# Session log — $OS_NAME" > "$OS_DIR/session_log.md"

# 2. .claude/ subdirs
mkdir -p "$OS_DIR/.claude/agents" "$OS_DIR/.claude/skills" "$OS_DIR/.claude/hooks" "$OS_DIR/.claude/commands"

# 3. Symlink 00_agents/*.md into .claude/agents/
cd "$OS_DIR/.claude/agents"
# Clear stale symlinks that no longer have a target
for link in *.md; do
  [ -L "$link" ] || continue
  [ -e "$link" ] || rm -f "$link"
done
# Add fresh symlinks for every agent in 00_agents/
shopt -s nullglob
for f in "$OS_DIR/00_agents/"*.md; do
  ln -sf "../../00_agents/$(basename "$f")" "$(basename "$f")"
done
shopt -u nullglob

# 4. Symlink any folder-packaged skills (containing SKILL.md) into .claude/skills/
cd "$OS_DIR/.claude/skills"
for link in */; do
  [ -L "${link%/}" ] || continue
  [ -e "${link%/}" ] || rm -f "${link%/}"
done
while IFS= read -r skill_path; do
  skill_name="$(basename "$skill_path")"
  rel_path="$(python3 -c "import os.path,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$skill_path" "$OS_DIR/.claude/skills")"
  ln -sfn "$rel_path" "$skill_name"
done < <(find "$OS_DIR/00_skills" -name SKILL.md -exec dirname {} \;)

# 5. Hooks — symlink to user-level hooks dir so updates propagate everywhere
mkdir -p "$OS_DIR/.claude/hooks"
for hook in session-start.sh session-end.sh log-subagent.sh; do
  src="$HOME/.claude/hooks/$hook"
  [ -f "$src" ] && ln -sfn "$src" "$OS_DIR/.claude/hooks/$hook" || true
done

# 6. Settings — write OS-level hooks config
cat > "$OS_DIR/.claude/settings.json" <<EOF
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear",
        "hooks": [
          {
            "type": "command",
            "command": "\\"\$CLAUDE_PROJECT_DIR\\"/.claude/hooks/session-start.sh",
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
            "command": "\\"\$CLAUDE_PROJECT_DIR\\"/.claude/hooks/session-end.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "SubagentStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\\"\$CLAUDE_PROJECT_DIR\\"/.claude/hooks/log-subagent.sh",
            "async": true,
            "timeout": 5
          }
        ]
      }
    ]
  }
}
EOF

# 7. Apply to projects/<*>/ — symlink each project's 00_agents/ into its own .claude/agents/
shopt -s nullglob
for proj_dir in "$OS_DIR/projects/"*/; do
  proj_dir="${proj_dir%/}"
  [ -d "$proj_dir/00_agents" ] || continue
  mkdir -p "$proj_dir/.claude/agents"
  cd "$proj_dir/.claude/agents"
  for link in *.md; do
    [ -L "$link" ] || continue
    [ -e "$link" ] || rm -f "$link"
  done
  for f in "$proj_dir/00_agents/"*.md; do
    [ -f "$f" ] || continue
    ln -sf "../../00_agents/$(basename "$f")" "$(basename "$f")"
  done
done
shopt -u nullglob

# Summary
cd "$OS_DIR/.claude"
AGENT_COUNT=$(find agents -maxdepth 1 -mindepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
SKILL_COUNT=$(find skills -maxdepth 1 -mindepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')
PROJ_COUNT=$(find "$OS_DIR/projects" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
echo "  Agents registered: $AGENT_COUNT"
echo "  Skills registered: $SKILL_COUNT"
echo "  Projects with .claude/agents/: $PROJ_COUNT"
echo "Done."
