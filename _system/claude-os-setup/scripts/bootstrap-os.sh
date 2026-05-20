#!/usr/bin/env bash
# bootstrap-os.sh — create a new OS folder under ~/Documents/<Name>/
# with the canonical structure and the .claude/ layer.
#
# Usage: bootstrap-os.sh <OS_Folder_Name>
#
# After running, you'll have:
#   ~/Documents/<Name>/
#     ├── CLAUDE.md, MEMORY.md, session_log.md
#     ├── 00_agents/ 00_skills/ 00_tools/ projects/
#     └── .claude/agents,skills,hooks,settings.json

set -euo pipefail

NAME="${1:-}"
if [ -z "$NAME" ]; then
  echo "Usage: $0 <OS_Folder_Name>" >&2
  echo "Example: $0 Marketing_OS" >&2
  exit 1
fi

OS_DIR="$HOME/Documents/$NAME"
if [ -e "$OS_DIR" ]; then
  echo "Folder already exists: $OS_DIR" >&2
  echo "If you meant to install the .claude/ layer into an existing OS, run:" >&2
  echo "  $HOME/.claude/scripts/install-os-claude.sh \"$OS_DIR\"" >&2
  exit 1
fi

echo "Creating OS folder: $OS_DIR"
mkdir -p "$OS_DIR"

OS_SLUG="$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')"

cat > "$OS_DIR/CLAUDE.md" <<EOF
# $NAME

[Operational instructions for this OS — fill in with the agent
roster, primary domains, and any OS-specific conventions.]

## How to operate

This OS follows the canonical OS layout. The universal operating
model lives at \`~/.claude/CLAUDE.md\` — this file holds OS-specific
overrides and context.

## Repo layout

\`\`\`
$NAME/
├── CLAUDE.md                this file
├── MEMORY.md                OS-level memory
├── session_log.md           append-only session entries
├── 00_agents/               canonical agents for this OS
├── 00_skills/               playbooks (agents read via SKILLS_INDEX.md)
├── 00_tools/                external tool docs (clickup.md, figma.md, etc.)
├── .claude/                 Claude Code registration layer
│   ├── agents/              symlinks to 00_agents/
│   ├── skills/              symlinks to packaged 00_skills/<name>/
│   ├── hooks/               symlinks to ~/.claude/hooks/
│   └── settings.json
└── projects/                one folder per project
\`\`\`

## Graphiti convention
- group_id \`$OS_SLUG\` for OS-level context
- group_id \`global\` for cross-cutting learnings (set in ~/.claude/CLAUDE.md)
- group_id \`<project_slug>\` for project-level context
EOF

cat > "$OS_DIR/MEMORY.md" <<EOF
# Memory — $NAME

OS-level memory. Add references to feedback, project, and reference
files below. The full memory entries live in
\`~/.claude-work-2/projects/<encoded-os-path>/memory/\` (auto-created by
Claude as needed).
EOF

cat > "$OS_DIR/session_log.md" <<EOF
# Session log — $NAME

Append entries with the standard format:

## [Date] — [Brief summary]

**Project:** [which project, or "global"]
**Work done:**
- [...]
**Status:** [completed / in progress / blocked]
**Follow-up:** [...]
**Decisions made:** [...]
EOF

mkdir -p "$OS_DIR/00_agents" "$OS_DIR/00_skills" "$OS_DIR/00_tools" "$OS_DIR/projects"

# Wire up .claude/
"$HOME/.claude/scripts/install-os-claude.sh" "$OS_DIR"

echo ""
echo "Bootstrapped: $OS_DIR"
echo "Next: drop your agent .md files into 00_agents/ and re-run install-os-claude.sh"
echo "Or invoke the agent-architect to seed the agent roster from the universal pool."
