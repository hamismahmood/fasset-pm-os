#!/usr/bin/env bash
# bootstrap-project.sh — create a new project inside the active OS.
# Must be run with cwd inside an OS folder. Scaffolds projects/<slug>/
# with the canonical structure and .claude/agents/ wired.
#
# Usage: bootstrap-project.sh <project-slug>

set -euo pipefail

SLUG="${1:-}"
if [ -z "$SLUG" ]; then
  echo "Usage: $0 <project-slug>" >&2
  echo "Run this from inside an OS folder (or pass --os-dir)" >&2
  exit 1
fi

# Detect active OS by walking up from cwd until we find 00_agents/ + projects/
CWD="$(pwd)"
OS_DIR=""
DIR="$CWD"
while [ "$DIR" != "/" ] && [ -z "$OS_DIR" ]; do
  if [ -d "$DIR/00_agents" ] && [ -d "$DIR/projects" ]; then
    OS_DIR="$DIR"
    break
  fi
  DIR="$(dirname "$DIR")"
done

if [ -z "$OS_DIR" ]; then
  echo "Could not detect an OS folder above cwd. Run this from inside an OS folder." >&2
  exit 1
fi

OS_NAME="$(basename "$OS_DIR")"
PROJ_DIR="$OS_DIR/projects/$SLUG"

if [ -e "$PROJ_DIR" ]; then
  echo "Project already exists: $PROJ_DIR" >&2
  exit 1
fi

PROJ_SLUG="$(echo "$SLUG" | tr '-' '_' | tr '[:upper:]' '[:lower:]')"

echo "Bootstrapping project: $SLUG (in $OS_NAME)"
mkdir -p "$PROJ_DIR/00_agents" "$PROJ_DIR/00_skills" "$PROJ_DIR/00_tools" \
         "$PROJ_DIR/spec" "$PROJ_DIR/code" "$PROJ_DIR/.claude/agents"

cat > "$PROJ_DIR/CLAUDE.md" <<EOF
# $SLUG

Project-specific instructions. Inherits from \`$OS_NAME/CLAUDE.md\`
and \`~/.claude/CLAUDE.md\`.

## Project context

[Fill in: what this project is, who it's for, what success looks like.]

## Active agents

This project's agents live in \`00_agents/\` (symlinked into
\`.claude/agents/\`). Specialise them as needed — keep changes
documented in \`AGENT_LEARNINGS.md\`.

## Graphiti
- group_id: \`$PROJ_SLUG\`
EOF

cat > "$PROJ_DIR/MEMORY.md" <<EOF
# Memory — $SLUG

Project-level memory. References to feedback/project/reference notes.
EOF

cat > "$PROJ_DIR/AGENT_LEARNINGS.md" <<EOF
# Agent learnings — $SLUG

Document any project-specific specialisations made to copied agents.
EOF

# Copy 00_tools/ from OS into project
if [ -d "$OS_DIR/00_tools" ]; then
  shopt -s nullglob
  for tool in "$OS_DIR/00_tools/"*.md; do
    cp "$tool" "$PROJ_DIR/00_tools/" 2>/dev/null || true
  done
  shopt -u nullglob
fi

echo ""
echo "Project scaffolded: $PROJ_DIR"
echo ""
echo "Next steps (recommended order):"
echo "  1. Copy needed agents from $OS_NAME/00_agents/ into $PROJ_DIR/00_agents/"
echo "     (or invoke /agent-architect to do it for you)"
echo "  2. Run: $HOME/.claude/scripts/install-os-claude.sh \"$OS_DIR\""
echo "     (this picks up the new project and wires .claude/agents/ symlinks)"
echo "  3. Have agent-architect run the framing questions for you."
