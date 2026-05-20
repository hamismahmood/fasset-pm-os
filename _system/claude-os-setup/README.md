# Claude OS Setup

A personal operating system for Claude Code — agents, skills, memory, and
project structure that loads automatically in every session.

---

## On a new machine — what to tell Claude

Open Claude Code and say exactly this:

> "Clone https://github.com/hamismahmood9/claude-os-setup and run the install script"

Claude will clone the repo and run `bash install.sh`. Once done, say:

> "Run /os to create a new workspace"

Claude will ask you what to call it and where to put it, then scaffold everything.

---

## What gets installed

```
~/.claude/
├── CLAUDE.md          universal operating model (loads every session)
├── settings.json      model, permissions, hooks config
├── scripts/           shell scripts (bootstrap, graphiti, session save)
├── hooks/             auto-fire on session start/end/stop
├── skills/            slash commands available everywhere
└── agents/            universal agents available everywhere
```

### Skills (slash commands)

| Command | What it does |
|---|---|
| `/os` | Create a new OS workspace — asks for name and location |
| `/project` | Create a new project inside the active OS |
| `/remember` | Save session transcript + push memory to Graphiti |
| `/api-and-interface-design` | API and interface design playbook |
| `/browser-testing-with-devtools` | Browser testing workflow |
| `/ci-cd-and-automation` | CI/CD and automation playbook |
| `/code-review-and-quality` | Code review workflow |
| `/code-simplification` | Simplification and refactor playbook |
| `/context-engineering` | Context and prompt engineering |
| `/debugging-and-error-recovery` | Debugging workflow |
| `/deprecation-and-migration` | Deprecation and migration playbook |
| `/documentation-and-adrs` | Docs and decision record writing |
| `/frontend-ui-engineering` | Frontend engineering playbook |
| `/git-workflow-and-versioning` | Git workflow |
| `/idea-refine` | Refine and pressure-test an idea |
| `/incremental-implementation` | Ship in small increments |
| `/performance-optimization` | Performance analysis and fixes |
| `/planning-and-task-breakdown` | Break work into tasks |
| `/security-and-hardening` | Security review playbook |
| `/shipping-and-launch` | Launch checklist |
| `/source-driven-development` | Development grounded in sources |
| `/spec-driven-development` | Spec-first development |
| `/test-driven-development` | TDD workflow |
| `/using-agent-skills` | How to wire up and use agent skills |

### Agents (available in every session)

| Agent | What it does |
|---|---|
| `agent-architect` | Bootstraps new projects, proposes agent teams |
| `system-analyst` | Writes specs, requirements, tickets |
| `devils-advocate` | Challenges assumptions, surfaces blind spots |
| `discovery-agent` | Maps problem space, builds engagement context |
| `trend-analyst` | Researches where markets and tech are heading |

### Hooks (automatic)

| Hook | When | What |
|---|---|---|
| `session-start` | Session opens | Queries Graphiti for context, greets with recent work |
| `session-end` | Session closes | Saves memory summary to Graphiti + session_log.md |
| `stop-notify` | Claude finishes a task | macOS notification (after 2+ min sessions) |
| `log-subagent` | Subagent spins up | Writes audit log entry |

---

## OS folder structure (created by `/os`)

```
<YourOS>/
├── CLAUDE.md           OS-level instructions
├── MEMORY.md           OS-level memory index
├── session_log.md      append-only session log
├── 00_agents/          agent .md files for this OS
├── 00_skills/          playbook skills
├── 00_tools/           tool docs (clickup.md, figma.md, etc.)
├── .claude/            Claude Code registration layer
│   ├── agents/         symlinks → 00_agents/
│   ├── skills/         symlinks → 00_skills/
│   ├── hooks/          symlinks → ~/.claude/hooks/
│   └── settings.json
└── projects/
    └── <project-slug>/  (created by /project)
        ├── CLAUDE.md
        ├── MEMORY.md
        ├── AGENT_LEARNINGS.md
        ├── 00_agents/
        ├── spec/
        └── code/
```

---

## Prerequisites

- **Claude Code CLI** — `npm install -g @anthropic-ai/claude-code`
- **Graphiti** (optional) — persistent memory across sessions. Without it,
  memory falls back to MEMORY.md files. See `scripts/graphiti-start.sh`.

---

## Manual install (without Claude)

```bash
git clone https://github.com/hamismahmood9/claude-os-setup.git
cd claude-os-setup
bash install.sh
```

Then edit `~/.claude/CLAUDE.md` and replace `<YOUR_NAME>` with your name.
