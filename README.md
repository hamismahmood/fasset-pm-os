# fasset-pm-os

Hamis Mahmood's PM operating system for Fasset. Built on Claude Code.

## What this is

A structured workspace for PM work at Fasset — discovery, strategy, execution, GTM, analytics, comms — with context, memory, and workflows baked in. Any Claude instance that opens this repo gets the full setup.

## First-time setup (new machine or account)

### 1. Register the pm-skills marketplace

```bash
claude plugin marketplace add phuryn/pm-skills
```

This tells Claude Code where to fetch the PM Skills plugins from. It's a one-time step per machine — not stored in the repo because Claude Code only reads marketplace sources from global settings.

### 2. Install the plugins

```bash
# PM Skills (phuryn/pm-skills)
claude plugin install pm-product-discovery@pm-skills --scope project
claude plugin install pm-product-strategy@pm-skills --scope project
claude plugin install pm-execution@pm-skills --scope project
claude plugin install pm-market-research@pm-skills --scope project
claude plugin install pm-data-analytics@pm-skills --scope project
claude plugin install pm-go-to-market@pm-skills --scope project
claude plugin install pm-marketing-growth@pm-skills --scope project
claude plugin install pm-toolkit@pm-skills --scope project

# Official plugins
claude plugin install atlassian@claude-plugins-official --scope project
claude plugin install figma@claude-plugins-official --scope project
claude plugin install github@claude-plugins-official --scope project
claude plugin install superpowers@claude-plugins-official --scope project
claude plugin install frontend-design@claude-plugins-official --scope project
claude plugin install supabase@claude-plugins-official --scope project
claude plugin install claude-md-management@claude-plugins-official --scope project
claude plugin install skill-creator@claude-plugins-official --scope project
```

After this, `settings.json` already has everything declared — the plugins just need to be cached locally.

### 3. Open the project in Claude Code

```bash
cd fasset-pm-os
claude
```

---

## Plugins installed

### PM Skills (`phuryn/pm-skills`)

65 skills and 36 commands covering the full PM workflow. Skills are plain markdown files encoding PM frameworks (OST, SWOT, JTBD, etc.) that load automatically. Commands are slash-triggered workflows that chain skills together.

| Plugin | Key commands |
| :--- | :--- |
| `pm-product-discovery` | `/discover`, `/brainstorm`, `/interview`, `/triage-requests`, `/setup-metrics` |
| `pm-product-strategy` | `/strategy`, `/market-scan`, `/value-proposition`, `/business-model`, `/pricing` |
| `pm-execution` | `/write-prd`, `/write-stories`, `/plan-okrs`, `/sprint`, `/pre-mortem`, `/transform-roadmap` |
| `pm-market-research` | `/competitive-analysis`, `/analyze-feedback` |
| `pm-data-analytics` | `/analyze-test`, `/analyze-cohorts`, `/write-query` |
| `pm-go-to-market` | `/plan-launch`, `/growth-strategy`, `/battlecard` |
| `pm-marketing-growth` | `/north-star`, `/market-product` |
| `pm-toolkit` | `/review-resume`, `/draft-nda`, `/privacy-policy`, `/proofread` |

### Official plugins (`claude-plugins-official`)

| Plugin | What it does |
| :--- | :--- |
| `atlassian` | Create/search/transition Jira issues, read/write Confluence pages |
| `figma` | Read designs, generate UI, inspect components |
| `github` | PR reviews, issue management, repo operations |
| `superpowers` | Parallel agents, git worktrees, TDD, brainstorming, planning |
| `frontend-design` | Production-quality UI components and layouts |
| `supabase` | Database queries and schema management |
| `claude-md-management` | Update and improve CLAUDE.md files |
| `skill-creator` | Build new custom skills |

---

## How plugins work

Skills and commands are **plain markdown files** — no code, no binaries. A skill encodes a framework (e.g. Teresa Torres' Opportunity Solution Tree) as context that Claude loads automatically when relevant. A command defines a step-by-step workflow that Claude follows when you type `/command-name`.

Plugin files are cached at `~/.claude/plugins/cache/` on each machine. The repo only carries `settings.json` — the manifest that declares which plugins are active. Same pattern as `package.json` vs `node_modules/`.

---

## Folder structure

```
Projects/          active deliverables (each with CLAUDE.md + MEMORY.md)
Radar/             monitored-not-owned work
pm-execution/      PRDs, specs, stories, sprints
pm-discovery/      user research, interviews, call notes
pm-partners/       vendor management, contracts, partner comms
pm-strategy/       roadmap, prioritization, market research
pm-comms/          Slack, email, stakeholder updates
pm-data/           analytics, Mixpanel, Metabase, metrics
context/           people, meetings, initiatives, voice guide
briefings/         daily morning briefing files (auto-generated)
.claude/           Claude Code config (settings, hooks, skills, commands)
_system/           internal tools and skills (do not modify)
```
