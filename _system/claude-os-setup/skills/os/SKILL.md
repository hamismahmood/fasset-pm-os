---
name: os
description: Scaffold a new OS folder at a location you specify. Creates the canonical structure (00_agents/, 00_skills/, 00_tools/, projects/, CLAUDE.md, MEMORY.md, session_log.md) and the .claude/ registration layer. Use when starting a new domain like Marketing_OS, Research_OS, Engineering_OS, etc.
disable-model-invocation: true
argument-hint: <OS_Folder_Name> [path]
allowed-tools: Bash($HOME/.claude/scripts/os.sh *)
---

# /os — scaffold a new OS folder

You are bootstrapping a new OS. An OS is a domain folder that holds
agents, skills, tools, and projects for one type of work (software,
consulting, creative, research, etc.).

## Step 1 — Get the name and location

Parse `$ARGUMENTS`:
- First word/token = OS folder name (e.g. `Consulting_OS`, `Engineering_OS`)
- Remaining = optional path (e.g. `/Users/hamis/Work`)

If `$ARGUMENTS` is empty, ask: "What should the OS be called?"

If no path is given, ask: "Where do you want to create it? (full path, or
press enter to use the current directory)"

Default to `$(pwd)` if they press enter or give no path.

Do not proceed without both a name and a confirmed location.

## Step 2 — Frame the OS (before scaffolding)

Ask the user (one at a time):
1. What domain does this OS cover? (one sentence)
2. Who's the primary user? (solo, a team, clients?)
3. What kind of agents will it need? (engineers, researchers, designers,
   content creators, advisors?) — informational only, not selecting yet.
4. Any overlap with existing OSes?

Save the answers to Graphiti with `group_id: <os_slug>` so the new OS
starts with context.

## Step 3 — Run the scaffold

Run:

```!
$HOME/.claude/scripts/os.sh "<name>" "<full-path>"
```

This creates the folder structure, writes templated CLAUDE.md /
MEMORY.md / session_log.md, and installs the `.claude/` layer.

## Step 4 — Seed the agent roster

The new OS has an empty `00_agents/`. Two paths:

- **Manual:** drop agent .md files into `00_agents/` then re-run
  `~/.claude/scripts/install-os-claude.sh <OS_path>`.
- **Architect-led:** invoke `agent-architect` to propose a roster
  based on the framing answers.

Ask which path the user wants.

## Step 5 — Save context to Graphiti

Save an episode with `group_id: <os_slug>`:
- name: "OS bootstrapped: <Name>"
- body: framing answers + agent roster decision + path

Confirm with the full path of the new OS folder and next recommended action.

## Hard rules
- Never overwrite an existing folder
- Never default to ~/Documents/ — always ask for the path
- Never proceed past framing without the user's answers
- Never seed an agent roster without explicit approval
