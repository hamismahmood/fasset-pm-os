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

## Installed plugins

All project-scoped. Marketplace: `claude-plugins-official` (default) + `phuryn/pm-skills` (GitHub).

### PM Skills (`phuryn/pm-skills`)

| Plugin | Key commands | Use for |
| :--- | :--- | :--- |
| `pm-product-discovery` | `/discover`, `/interview`, `/triage-requests`, `/setup-metrics` | Ideation, assumption testing, interview synthesis, feature prioritization |
| `pm-product-strategy` | `/strategy`, `/business-model`, `/value-proposition`, `/pricing`, `/market-scan` | Vision, strategy canvas, lean canvas, SWOT, Porter's, Ansoff, monetization |
| `pm-execution` | `/write-prd`, `/write-stories`, `/sprint`, `/plan-okrs`, `/pre-mortem`, `/transform-roadmap` | PRDs, OKRs, roadmaps, user stories, sprints, retros |
| `pm-market-research` | — | Personas, segmentation, competitive analysis, sentiment analysis |
| `pm-data-analytics` | — | SQL generation, cohort analysis, A/B test analysis |
| `pm-go-to-market` | `/plan-launch`, `/growth-strategy`, `/battlecard` | GTM strategy, growth loops, ICP, beachhead segments |
| `pm-marketing-growth` | — | North Star metric, positioning, product naming, value prop statements |
| `pm-toolkit` | — | Grammar check, NDA drafting, privacy policy, resume review |

### Official plugins (`claude-plugins-official`)

| Plugin | Use for |
| :--- | :--- |
| `atlassian` | Jira issue creation/search/transitions, Confluence pages — use for all ticket work |
| `figma` | Read/write Figma designs, design-to-code, component inspection |
| `github` | PR reviews, issue management, repo operations |
| `superpowers` | Meta-skills: parallel agents, git worktrees, TDD, brainstorming, plans |
| `frontend-design` | UI component building, layout, production-quality frontend |
| `supabase` | Database queries, schema management, Supabase MCP |
| `claude-md-management` | Update and improve CLAUDE.md files |
| `skill-creator` | Create new custom skills |

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
