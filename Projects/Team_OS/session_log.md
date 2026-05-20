# Session Log — Team OS

Append-only. One entry per session.

---

## 2026-05-18 — Session: TEAM-OS (Initial)

### What happened

Hamis discovered Hannah Stulberg's `team-os-example-repo` on GitHub and asked to clone it and understand what it was. The repo is a reference implementation of a "Team OS" — a shared knowledge base structured so that Claude Code sessions for any team member start with full context, without re-explanation.

The example company is **Forge**, a fictional 10-person AI prototyping startup. The repo contains:
- Root `CLAUDE.md` with team roster, Slack channels, and doc index
- `feature-index.yaml` — master lookup: every feature → PRDs, RFCs, plans, schemas, experiments, tickets
- `/product-development/` — PRDs, RFCs, design specs, analytics, experiment results, customer call notes, competitive research (organized by feature area)
- `/team/` — role-specific onboarding guides and retros (PM, EM, engineering, design, analytics, data engineering)
- `/.claude/agents/onboarding.md` — onboarding agent for new hires
- `/.claude/skills/customer-call-summary/` — structured skill for processing Granola transcripts into standardized summaries (style guide + quality checklist)
- `/.claude/commands/customer-call.md` — CLI command triggering the transcript processing flow

### Key observation

The `customer-call-summary` skill maps directly onto how Hamis already processes call notes (Granola → HTML in `Insights/Call_Notes/`). Highest-value quick win for a Fasset adaptation.

### Decisions made

- Created project workspace at `Projects/Team_OS/` (CLAUDE.md + MEMORY.md)
- Added to root MEMORY.md project index
- Example repo retained at `iClaude/team-os-example-repo/` as reference material
- No Jira tickets yet — research phase

### Next steps (not committed)

1. Decide whether to pursue Fasset adaptation — needs stakeholder alignment
2. If yes, start with the `customer-call-summary` skill as the first deliverable
3. Then scaffold a Fasset `feature-index.yaml` and team-level `CLAUDE.md`
