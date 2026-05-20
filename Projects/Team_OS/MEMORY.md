---
type: project
name: Team OS
status: active
priority: medium
deadline: TBD
owner: Hamis Mahmood
related: []
last_verified: 2026-05-18
tags: [internal-tooling, claude, ai, team-productivity, knowledge-base]
---

# MEMORY.md — Team OS

*Last updated: 2026-05-18*

## Why

The product team lacks shared AI context. Every Claude session starts from scratch — team members re-explain Fasset's product, team structure, vendors, and workflows every time. A Team OS modelled on Hannah Stulberg's `team-os-example-repo` would give every session immediate, full context: who's who, what's being built, where things live, and agreed workflows.

## Reference Material

- **Example repo:** `team-os-example-repo` (cloned at `iClaude/team-os-example-repo/`)
  - Source: https://github.com/in-the-weeds-hannah-stulberg/team-os-example-repo
  - Author: Hannah Stulberg ("In the Weeds")
  - Model company: Forge (10-person AI prototyping startup)

## What the Example Repo Contains

| Layer | What it is |
| :---- | :---- |
| `CLAUDE.md` (root) | Team roster, Slack channels, doc index — everything Claude needs to know "who's who and where things live" |
| `feature-index.yaml` | Master lookup: every feature → its PRDs, RFCs, plans, schemas, experiments, and tickets |
| `/product-development/` | PRDs, engineering RFCs, design specs, analytics dashboards, experiment results, customer call notes, competitive research — organized by feature area |
| `/team/` | Role-specific onboarding guides and retros (PM, EM, engineering, design, analytics, data engineering) |
| `/.claude/agents/onboarding.md` | Onboarding agent that walks new hires through role-specific setup |
| `/.claude/skills/customer-call-summary/` | Structured skill for processing customer call transcripts into standardized summaries (style guide + quality checklist) |
| `/.claude/commands/customer-call.md` | CLI command triggering transcript processing (Granola check, action items, summaries) |

## Key Insight

The `customer-call-summary` skill is directly applicable to Fasset. The pattern — Granola transcript → structured summary with action items — maps exactly onto how Hamis already processes call notes. This is the highest-value quick win to adapt first.

## Current State

- Phase: research / exploration
- Cloned example repo for reference
- No Fasset-specific implementation started yet
- No stakeholder alignment done yet

## Potential Scope (Fasset Adaptation)

1. **`CLAUDE.md` (team-level)** — team roster, Slack channels, Jira project index, doc locations
2. **`feature-index.yaml`** — map every Fasset feature to its Confluence PRD, Figma file, HOR epic, and Mixpanel dashboard
3. **Role onboarding guides** — starting with PM onboarding
4. **Customer call skill** — adapt `customer-call-summary` skill for Fasset (Granola → HTML call note in `Insights/Call_Notes/`)
5. **Shared `.claude/` config** — agents and skills available to any team member who opens the repo

## Active Jira Tasks

None. Research phase — no tickets yet.

## Stakeholders

| Person | Role in this project |
| :---- | :---- |
| Hamis Mahmood | Owner and initiator |
| TBD | Other PMs / EMs to adopt once scaffolded |
