# iClaude OS Restructure Plan — Empty Shell

## Context

The current iClaude OS is over-built. CLAUDE.md is ~300 lines and loads everything regardless of task. OPEN_LOOPS.md is 250+ lines of metadata that never tracked what mattered. team-os-example-repo is sitting at the root with no purpose. The goal here is a genuine empty shell — minimal structure, domain-driven knowledge, nearly empty files that compound over time. No pre-populated bloat. Start clean, earn complexity.

---

## New Structure (the shell)

```
iClaude/
├── CLAUDE.md              (~50 lines: routing table + self-improve prompt)
├── MEMORY.md              (master facts: company, project index, Jira snapshot — kept as-is)
│
├── pm-execution/          PRDs, specs, user stories, sprints
│   ├── RULES.md           starts empty
│   └── tasks.md           replaces OPEN_LOOPS for this domain
│
├── pm-discovery/          user research, stakeholder interviews
│   ├── RULES.md           starts empty
│   ├── tasks.md
│   └── call-notes/        ← Insights/Call_Notes/ migrated here
│
├── pm-partners/           vendor management, contracts, negotiation
│   ├── RULES.md           starts empty
│   ├── tasks.md
│   └── vendors/           ← 00_Resources/Vendors/ migrated here
│                            Rain compliance data extracted from screenshots → rain.md
│
├── pm-strategy/           roadmap, prioritization, market research
│   ├── RULES.md           starts empty
│   └── tasks.md
│
├── pm-comms/              Slack, email, stakeholder updates
│   ├── RULES.md           starts empty
│   └── tasks.md
│
├── pm-data/               analytics, Metabase, Mixpanel, metrics
│   ├── RULES.md           starts empty
│   └── tasks.md
│
├── Projects/              (unchanged — time-bound deliverables)
├── Radar/                 (unchanged — flat .md files)
│
├── context/               cross-cutting reference (renamed from 00_Resources)
│   ├── People/            (unchanged — 49 stakeholder files)
│   ├── Meetings/          (unchanged — recurring meeting files)
│   │   ├── Transcripts/   (unchanged — 45 transcript files kept)
│   │   └── transcript-protocol.md  ← Gemini_Transcript_Findings.md renamed + updated for Tactiq
│   ├── Initiatives/       (unchanged — 11 company context files)
│   ├── PEOPLE.md
│   ├── MEETINGS.md
│   ├── COMPANY_ONGOINGS.md
│   ├── HOW_I_WORK.md
│   └── SCHEMA.md
│
├── Scheduled/             (unchanged — automated task definitions, except daily-update-iclaude updated)
├── .claude/               repo-level Claude Code config (auto-read when in this directory)
│   ├── settings.json      hooks, local MCP config, permissions — all repo-scoped
│   └── agents/            project-level agents (auto-discovered by Claude Code)
│
└── _system/               OS plumbing — source files, never loaded directly in sessions
    ├── agents/            agent .md source files (mirrored into .claude/agents/)
    ├── skills/            ← renamed from 00_skills/ + evening-sync moves here
    ├── hooks/             hook scripts (called by .claude/settings.json with relative paths)
    ├── tools/             ← renamed from 00_tools/
    └── setup.md           tool dependency manifest + agent/skill/hook inventory
```

---

## Why People/Meetings/Initiatives stay cross-cutting (in `context/`)

These aren't domain-specific — you reference Zane when writing comms, Ubaid when tracking execution, Keel when doing partner work, sprint state when doing strategy. Putting them in a single domain folder would mean loading them from the wrong place half the time. `context/` is the right home: shared reference data, loaded on-demand when the routing table says to.

---

## What changes vs current structure

### .claude/ and _system/ changes
- Create `iClaude/.claude/settings.json` — repo-level hooks, MCP config, permissions
- Create `iClaude/.claude/agents/` — copy agent .md files here so Claude Code auto-discovers them
- `_system/00_agents/` → renamed to `_system/agents/` (source of truth for agent files)
- `_system/00_skills/` → renamed to `_system/skills/`
- `_system/00_tools/` → renamed to `_system/tools/`
- Create `_system/hooks/` — hook scripts referenced from `.claude/settings.json`
- `_system/skills/evening-sync/` → stays in `_system/skills/`
- `_system/projects/` → deleted (old stubs from install)
- `_system/claude-os-setup/` → deleted (install templates, no longer needed)
- Global `~/.claude/agents/` → untouched (truly cross-identity agents only, nothing iClaude-specific)
- Global `~/.claude/settings.json` → remove any iClaude-specific hooks/MCPs and move them to `iClaude/.claude/settings.json`

### Killed entirely
- `OPEN_LOOPS.md` → replaced by per-domain `tasks.md` files
- `team-os-example-repo/` → deleted (reference material, not OS content)
- `claude-os-setup.zip` → deleted (setup artifact)
- `WRITING_STYLE_PROFESSIONAL.md` → deleted (redundant with `HOW_I_WORK.md`)
- `Insights/Screenshots/Travel Rules/` → deleted (folder is empty)
- `Insights/Screenshots/Rain/` → deleted after extracting content into `pm-partners/vendors/rain.md`
- `Insights/Screenshots/` → deleted (empty after above)
- `Insights/` folder → deleted entirely once Call_Notes and Screenshots are migrated
- `00_Resources/VENDORS.md` (index file) → vendors now live directly in `pm-partners/vendors/`
- `00_Resources/INITIATIVES.md` → redundant; `COMPANY_ONGOINGS.md` already indexes initiatives
- `00_Resources/CipherX_Call_Prep.html` → deleted (stale one-off prep doc)
- `00_Resources/Swiss_Islamic_Finance_Primer.html` → deleted (stale reference)

### Migrated
- `00_Resources/Vendors/` → `pm-partners/vendors/`
- `Insights/Call_Notes/` → `pm-discovery/call-notes/`
- `00_Resources/Gemini_Transcript_Findings.md` → `context/Meetings/transcript-protocol.md` (content updated for Tactiq)
- `00_Resources/` (remainder: People, Meetings, Initiatives, HOW_I_WORK, SCHEMA, COMPANY_ONGOINGS, PEOPLE.md, MEETINGS.md) → `context/`

### Unchanged
- `Projects/` (all 8 workspaces)
- `Radar/` (all 5 items)
- `Scheduled/` (all 4 task folders — but `daily-update-iclaude/SKILL.md` content updated)
- `MEMORY.md` (content updated — see below)

---

## Screenshot extraction: Rain → pm-partners/vendors/rain.md

The 4 Rain screenshots are pages from the Rain Platform Compliance document (confidential, rain.xyz). Extract into a compliance section in `pm-partners/vendors/rain.md`:

**Section A — Countries where Rain allows card issuance to consumers (48 countries)**
Antigua & Barbuda, Argentina, Australia, Bahamas, Barbados, Bangladesh, Belize, Bolivia, Brazil, Cayman Islands, Colombia, Costa Rica, Côte d'Ivoire, Dominica Republica, Dominicana, Ecuador, Egypt, El Salvador, Ghana, Grenada, Guatemala, Guyana, Honduras, Japan, Kenya, Malaysia, Mexico, Morocco, New Zealand, Pakistan, Panama, Paraguay, Peru, Philippines, Saint Kitts and Nevis, Saint Lucia, Saint Vincent and the Grenadines, Senegal, Singapore, South Africa, Suriname, Thailand, Trinidad and Tobago, Turks & Caicos Islands, United Arab Emirates, Uganda, Uruguay, Zambia

**Section B — US states where Rain allows issuance to US consumers (31 states)**
Alabama, Alaska, Arkansas, California, Colorado, Connecticut, Florida, Hawaii, Illinois, Indiana, Iowa, Kansas, Kentucky, Maine, Massachusetts, Michigan, Minnesota, Montana, Nebraska, New Hampshire, New Jersey, New York, North Carolina, Oklahoma, Pennsylvania, South Carolina, Texas, Utah, Virginia, West Virginia, Wyoming

**Section C — Countries where Rain partners CANNOT issue cards (18 countries)**
Belarus, China (Mainland), Cuba, Hong Kong, India, Iran, Iraq, Israel, Myanmar, Nepal, Nicaragua, North Korea, Russia, Syria, Turkey, Ukraine, Venezuela, Vietnam

**Section D — Enhanced review countries (require Rain licensing/compliance approval)**
Nigeria

**Section II — Consumer Spending Standards**
Rain cards cannot be used for consumer cardholder spending in: Cuba, Iran (+ others on page not fully captured)

Delete screenshots after extraction.

---

## MEMORY.md updates (specific changes)

1. **Remove** the routing table row for `OPEN_LOOPS.md` — it no longer exists.
2. **Update all `00_Resources/` path references** to `context/` throughout the file.
3. **Remove** the `OPEN_LOOPS.md` row from the "What goes here / When to read it" table.
4. **Update** the Gemini_Transcript_Findings.md reference → `context/Meetings/transcript-protocol.md`.
5. **Update** the VENDORS.md reference → vendors now in `pm-partners/vendors/`.
6. **Update** "Recurring Meetings" section: remove the note about the Scheduled task reading Gemini — Tactiq is now the transcript source.
7. Add row to routing table:
   | `context/Meetings/transcript-protocol.md` | Protocol for ingesting Tactiq transcripts | When adding a new meeting transcript |

---

## Scheduled task update: daily-update-iclaude/SKILL.md

**Current behaviour:** Reads Google Calendar, checks Gmail for Gemini-integrated transcripts, updates `Gemini_Transcript_Findings.md` and `COMPANY_ONGOINGS.md`.

**New behaviour:**
- Transcript source: Tactiq auto-saves to a Google Drive folder after each call. Daily task fetches from there using the existing Google Drive MCP. Free, automatic, no Zapier.
- The SKILL.md should be updated to:
  1. Use Google Drive MCP to list files in the Tactiq auto-save folder (e.g. `Fasset/Transcripts/`)
  2. Read any transcript newer than the last run
  3. Process per `context/Meetings/transcript-protocol.md`
  4. Update `COMPANY_ONGOINGS.md` from Slack + Gmail scan (unchanged)
  5. Remove all references to Gemini and Gmail as transcript sources
  6. Update file paths from `00_Resources/` → `context/`

**New SKILL.md content:**
```markdown
---
name: daily-update-iclaude
description: Fetch new Tactiq transcripts from Google Drive + scan Slack/Gmail for company context
---

1. Use Google Drive MCP to list files in the Tactiq auto-save folder (e.g. `Fasset/Transcripts/`).
   - Read any transcript file newer than the last run.
   - For each: extract topics, decisions, action items per `context/Meetings/transcript-protocol.md`.
   - Write a processed file to `context/Meetings/Transcripts/YYYY-MM-DD-<slug>.md`.
   - Update relevant initiative files in `context/Initiatives/` and refresh `last_verified`.
   - If a new person is mentioned without a file in `context/People/`, create a stub.
   - Update `context/Meetings/Transcripts/INDEX.md` with a new row.

2. Scan Slack and Gmail for the past 24 hours. Find things relevant to Hamis and things relevant to the company broadly. Update `context/COMPANY_ONGOINGS.md` — sequential stream with timestamps. Append only, never rewrite existing entries.

Only write to: new transcript files, INDEX.md, initiative files (when triggered), People stubs (when new person found), COMPANY_ONGOINGS.md.
```

---

## Tactiq: free auto-fetch via Google Drive (no Zapier)

Tactiq has a native Google Drive integration — configure it to auto-save transcripts to a specific Google Drive folder after every call. Free, automatic, no third-party paid tools.

You already have the Google Drive MCP connected. The daily task reads from the designated folder, picks up any new transcripts, and processes them.

**One-time setup (manual, in Tactiq settings):**
- In Tactiq: Settings → Integrations → Google Drive → enable auto-save → point to a folder e.g. `Fasset/Transcripts/`

**How daily-update-iclaude uses it:**
- Uses Google Drive MCP to list files in the designated folder
- Reads any transcript file newer than the last run
- Processes per `context/Meetings/transcript-protocol.md`
- No manual export needed after setup

**Until configured:** manually export from Tactiq and drop into `context/Meetings/Transcripts/`.

**Claude routines (future):** automating more of this via Claude scheduled routines is noted as a future direction — not in scope for this restructure.

Document in `_system/setup.md` as a one-time setup step.

---

## _system/setup.md — tool dependency manifest

Repo-scoped (not machine-scoped). When opened on any machine, Claude checks this file at session start and surfaces missing tools before proceeding.

```markdown
# iClaude — Tool Dependencies
*Check this file at session start. If any tool is missing, surface it before proceeding.*

## Claude.ai Integrations (authenticate at claude.ai > Integrations)

| Tool | Purpose in this OS | Required for |
| :--- | :--- | :--- |
| Slack | Read channels, search, send messages | pm-comms, daily briefing |
| Gmail | Search threads, draft emails | pm-comms, daily update |
| Google Calendar | Read events, schedule | daily briefing |
| Google Drive | Read/write docs | pm-execution, pm-partners |
| Atlassian (Jira + Confluence) | Ticket management, PRD docs | pm-execution |
| Figma | Design file access | pm-execution |
| Mixpanel | Analytics queries | pm-data |
| Granola | ~~Meeting transcripts~~ REPLACED BY TACTIQ | deprecated — remove |

## Claude Code MCPs (local — configured in ~/.claude/settings.json)

| Tool | Purpose | Install command |
| :--- | :--- | :--- |
| Graphiti | Persistent memory graph | see ~/.claude/settings.json |

## CLIs

| Tool | Purpose | Install |
| :--- | :--- | :--- |
| `gh` | GitHub CLI — for when this repo moves to GitHub | `brew install gh` |

## Required setup (not yet connected)

| Tool | How to connect | Impact if missing |
| :--- | :--- | :--- |
| Tactiq → Google Drive | In Tactiq settings: enable Google Drive integration, point to a folder e.g. `Fasset/Transcripts/` | Transcripts must be manually exported until configured |

## If a tool is missing
> "Tool [X] is listed in _system/setup.md but is not connected.
> Tasks that rely on it: [list]. To connect: [instruction]."
```

---

## Global ~/.claude/CLAUDE.md trim

The global file is already lean (75 lines, nothing Fasset-specific). Only two changes needed:

**Line 52 — update path:**
```
Before: "Before producing written content on Hamis's behalf, read `HOW_I_WORK.md` to match his voice."
After:  "Before producing written content on Hamis's behalf, read `context/HOW_I_WORK.md` in the active OS folder."
```

**Lines 16-25 (Universal agents) — update path reference:**
```
Before: "OS-specific agents live in `<OS>/00_agents/` and are auto-registered via `<OS>/.claude/agents/` symlinks when working inside that OS."
After:  "OS-specific agents live in `<OS>/_system/agents/` and are registered via `<OS>/.claude/agents/`."
```

No other changes. All iClaude-specific hooks, MCPs, and settings live in `iClaude/.claude/settings.json` — not in the global file. The global file is for truly cross-identity, cross-OS rules only.

---

## New iClaude CLAUDE.md (full content, ~55 lines)

```markdown
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
- `Scheduled/` — automated task definitions (never modify in normal sessions)
- `_system/` — agents, skills, tools (ignore in normal sessions)

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
| Writing a PRD | use `_system/agents/spec-writer.md` |
| Stakeholder comms | use `_system/agents/stakeholder-comms.md` |
| Strategic framing | use `_system/agents/pm-strategist.md` |

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
```

---

## tasks.md format (per domain — starts nearly empty)

```markdown
# [Domain] — Open Tasks
*Last updated: YYYY-MM-DD*

## Pending
<!-- One line per item. Who's waiting, what for, by when if there's a deadline. -->

## Blocked
<!-- Items I can't move without someone else acting first. -->
```

No metadata schema. No "created / owner / related" on every line. Just what's actionable.

---

## RULES.md format (per domain — starts empty, compounds over time)

```markdown
# [Domain] — Rules & Hypotheses
*Last updated: YYYY-MM-DD*

## Confirmed rules
<!-- Validated through feedback. Applied by default. -->

## Hypotheses
<!-- Patterns to test. Upgrade to Confirmed when validated. -->
```

Self-improving: after completing any domain work and receiving feedback, update this file.

---

## First step of execution

Copy this plan file into the repo before doing anything else:
```
~/.claude/plans/i-want-to-organize-majestic-fairy.md → iClaude/_system/RESTRUCTURE_PLAN.md
```

It lives in `_system/` so it's in version control, travels to GitHub, and is easy to find without digging into `~/.claude/`.

---

## Verification

After restructure:
- New session to write a PRD → only MEMORY.md + pm-execution/RULES.md load
- New session on a vendor topic → pm-partners/RULES.md + the relevant vendor file load
- All 6 domain folders exist with RULES.md + tasks.md (both nearly empty)
- `context/` contains People/, Meetings/ (with transcript-protocol.md), Initiatives/, HOW_I_WORK.md, SCHEMA.md
- `pm-partners/vendors/rain.md` contains the extracted Rain compliance country lists
- `team-os-example-repo/`, `claude-os-setup.zip`, `Insights/Screenshots/`, stale HTML files are gone
- `OPEN_LOOPS.md` is gone; MEMORY.md no longer references it
- `Scheduled/daily-update-iclaude/SKILL.md` references Tactiq, not Gemini
- `_system/setup.md` exists and flags Tactiq as a known gap
- Global `~/.claude/CLAUDE.md` has updated path for HOW_I_WORK.md and _system/00_agents/
