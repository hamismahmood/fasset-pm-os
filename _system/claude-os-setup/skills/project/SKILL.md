---
name: bootstrap-project
description: Scaffold a new project inside the active OS. Creates projects/<slug>/ with CLAUDE.md, MEMORY.md, AGENT_LEARNINGS.md, spec/, code/, 00_agents/, 00_tools/ (copied from OS), and the .claude/agents/ symlinks. Use when starting a new project in any OS.
disable-model-invocation: true
argument-hint: <project-slug>
allowed-tools: Bash($HOME/.claude/scripts/bootstrap-project.sh *) Bash($HOME/.claude/scripts/install-os-claude.sh *)
---

# /bootstrap-project — scaffold a new project in the active OS

You are bootstrapping a new project inside the OS folder the user is
currently in. The script auto-detects the OS from cwd.

## Step 1 — Validate

If `$ARGUMENTS` is empty, ask: "What slug should the project use?
(lowercase, hyphenated, e.g. customer-portal-v2)"

Verify cwd is inside an OS folder (one with sibling `00_agents/` and
`projects/` directories). If not, tell the user to cd into the right OS
first.

## Step 2 — Hand off to agent-architect (recommended)

The `agent-architect` agent is the canonical project bootstrapper. It
asks the framing questions (platform, audience, AI features,
monetisation, maturity) and proposes the agent team.

If the user has already given the framing context in this session,
skip to step 3.

## Step 3 — Run the scaffold

```!
$HOME/.claude/scripts/bootstrap-project.sh "$ARGUMENTS"
```

This creates the folder + canonical files and copies 00_tools/ from
the OS.

## Step 4 — Copy agents

Based on agent-architect's proposal (or the user's direct instruction),
copy needed agent .md files from `<OS>/00_agents/` into
`projects/<slug>/00_agents/`. Then run:

```!
$HOME/.claude/scripts/install-os-claude.sh "$(pwd | sed 's|/projects/.*||')"
```

This wires the project's `.claude/agents/` symlinks.

## Step 5 — Save context

Save a Graphiti episode with `group_id: <project_slug>`:
- name: "Project bootstrapped: <slug>"
- body: framing answers + initial agent team

Then hand off to system-analyst for the spec.

## Hard rules
- Never overwrite an existing project folder
- Never skip the framing — even if it feels obvious, the agent team
  decision needs the answers
- Never copy more agents than needed — minimal team is the default
