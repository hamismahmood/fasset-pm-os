# iClaude OS

Hamis Mahmood, Senior PM at Fasset (Shariah-compliant crypto super app, UAE/Bahrain/Indonesia/Malaysia).

## Folder map

- `Projects/` — active deliverables (each with CLAUDE.md + MEMORY.md)
- `Radar/` — monitored-not-owned work (flat .md files)
- `pm-execution/` — PRDs, specs, stories, sprints
- `pm-discovery/` — user research, interviews, call notes
- `pm-partners/` — vendor management, contracts, partner comms
- `pm-strategy/` — roadmap, prioritization, market research
- `pm-comms/` — Slack, email, stakeholder updates
- `pm-data/` — analytics, Mixpanel, Metabase, metrics
- `context/` — people, meetings + transcripts, initiatives, voice guide
- `briefings/` — daily morning briefing files (one per day, auto-generated)
- `Scheduled/` — automated task definitions (never modify in normal sessions)
- `_system/` — skills, tools (ignore in normal sessions)

## Knowledge routing

| Task type | Load before starting |
| :--- | :--- |
| PRD, spec, user story | `pm-execution/RULES.md` |
| User interview, research synthesis | `pm-discovery/RULES.md` |
| Vendor comms, contract, negotiation | `pm-partners/RULES.md` + relevant `pm-partners/vendors/<vendor>.md` |
| Roadmap, prioritization, market analysis | `pm-strategy/RULES.md` |
| Slack message, email, internal update | `pm-comms/RULES.md` + `context/HOW_I_WORK.md` |
| Any writing task (PRD, vendor email, doc) | also load `context/HOW_I_WORK.md` |
| Analytics, metrics, Mixpanel | `pm-data/RULES.md` |
| Project-scoped work | `Projects/<name>/CLAUDE.md` + `Projects/<name>/MEMORY.md` |
| Someone is mentioned | `context/People/<name>.md` |
| New meeting transcript | `context/Meetings/transcript-protocol.md` |

Session start: load `MEMORY.md` only. Then check `_system/setup.md` — if any required tool is not connected, surface the missing tool(s) before proceeding. Everything else loads on-demand.

## Self-improvement

1. Before starting any task, review the relevant domain RULES.md.
2. Apply confirmed rules by default.
3. After completing work and receiving feedback, update the domain RULES.md.

## Rules

- Jira tickets go to HOR unless specified otherwise.
- "Remember this" → write to the right file immediately, confirm it's done.
- Any writing (PRD, email, Slack, doc): load `context/HOW_I_WORK.md` — applies to all writing, not just comms.
- No em dashes in anything written on Hamis's behalf.
- `Scheduled/` and `_system/` files are never modified in normal sessions.
