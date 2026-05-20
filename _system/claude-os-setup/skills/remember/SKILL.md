---
name: remember
description: Save everything from this session — dumps the full transcript to a markdown file AND pushes a memory summary to Graphiti at the right scope. One command, both done.
argument-hint: [scope:global|os|project] [optional note]
allowed-tools: Bash(python3 $HOME/.claude/scripts/save-session.py *), mcp__graphiti__add_memory, mcp__graphiti__search_memory_facts
---

# /remember — save session transcript + push to Graphiti

Does two things in one:
1. Dumps the full session transcript to a file
2. Saves a memory summary to Graphiti at the right scope

## Step 1 — Save the transcript

Run:

```!
python3 $HOME/.claude/scripts/save-session.py
```

Note the file path it outputs.

## Step 2 — Determine Graphiti scope

Parse `$ARGUMENTS`:
- If it starts with `scope:global`, `scope:os`, or `scope:project`, use that scope.
- Otherwise infer from context:
  - **global** — learning applies across all domains (communication style, universal rules, anti-patterns)
  - **os** — specific to this OS (e.g. `consulting_os`, `creative_os`)
  - **project** — specific to the active project slug

Resolve `group_id`:
- `global` → `group_id: global`
- `os` → detect from cwd (folder under `~/Documents/` or wherever the OS lives); slugify to lowercase with underscores
- `project` → detect from `projects/<slug>/` segment in cwd

If scope is ambiguous, default to the narrowest that fits.

## Step 3 — Check for duplicates

Call `mcp__graphiti__search_memory_facts` with a query matching the session's main topics, scoped to the resolved `group_id`. If a near-duplicate exists, merge rather than creating a new entry.

## Step 4 — Push to Graphiti

Call `mcp__graphiti__add_memory`:
- `name`: short label (e.g. "Session 2026-05-13 — consulting_os")
- `episode_body`: summary of this session. Include:
  - What was worked on
  - Decisions made
  - Files changed or created
  - What to pick up next time
  - Any corrections or preferences surfaced
- `group_id`: resolved above
- `source`: `text`
- `source_description`: `/remember — <scope>`

If `$ARGUMENTS` includes a freeform note after the scope prefix, append it to the episode body.

## Step 5 — Confirm

Print two lines:
```
Transcript saved: <file path>
Memory saved to <group_id>: <name>
```

## Hard rules
- Never save secrets — redact API keys, passwords, tokens before saving
- Never re-save the exact same memory at the same scope — merge instead
- Default to narrowest scope; promote to wider only when a pattern repeats
- If Graphiti is unreachable, still save the transcript and say so
