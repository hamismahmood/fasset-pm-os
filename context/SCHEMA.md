# SCHEMA.md
*Conventions for memory file structure across iClaude/. Last updated: 2026-05-04.*

This file is the contract every memory entry follows. Cowork automations rely on this. If a use case isn't covered, propose a new `type` and add it to this doc before using it.

## How to read this doc

Every typed memory file starts with **YAML frontmatter** between two `---` lines, followed by **freeform markdown body**. Frontmatter is the structured part automations parse. Body is for nuance that doesn't fit a field.

## Required fields (all types)

| Field | Type | Notes |
|:--|:--|:--|
| `type` | enum | Required. Drives which schema applies. |
| `name` | string | Display name. |
| `last_verified` | ISO date | `YYYY-MM-DD`. Updated when body is reviewed and confirmed accurate. |
| `status` | enum | Type-specific. See per-type sections. |

## Optional but recommended

| Field | Notes |
|:--|:--|
| `aliases` | List of alternative names/spellings. |
| `tags` | List of cross-cutting tags. |
| `source` | Where the entry was last verified against — Slack permalink, Confluence page, Jira ticket, Gmail link, conversation date. |

## Types

### `person`
Individuals — internal stakeholders, vendor contacts, regulators.

```yaml
---
type: person
name: Nashit Syed
email: syed.nashit@fasset.com
slack_id: U060MRWG5ND
role: Head of CX
team: CX/Ops
status: active   # active | onboarding | departing | departed | external
last_verified: 2026-05-04
aliases: [Nashit]
tags: [cx, vara-reporting]
---
```

Body sections: `## Owns`, `## Working style`, `## Recent`.

### `project`
Workstream folders. Frontmatter at the top of `0X_*/MEMORY.md`.

```yaml
---
type: project
name: Global USD Account
status: active   # active | paused | shipped | archived
priority: critical   # critical | high | medium | low
owner: Hamis Mahmood
related: [Keel, Due]
last_verified: 2026-05-04
---
```

### `vendor`
External partners (Keel, Due, Rain, Jumio, etc.). One file per vendor in `00_Resources/Vendors/`.

```yaml
---
type: vendor
name: Keel
website: https://keel.money
status: active                # active | onboarding | exploring | paused | terminated
relationship: primary-iban-provider
primary_contact: Alexander Meijer
contract_status: signed       # signed | negotiating | unsigned | expired
slack_channel: "#fasset-keel"
last_verified: 2026-05-04
tags: [iban, swift]
---
```

Body sections: `## What they do`, `## Coverage`, `## Contacts`, `## Open issues`, `## History`.

### `meeting`
Recurring meetings. One file per meeting in `00_Resources/Meetings/`.

```yaml
---
type: meeting
name: IBAN Standup
cadence: daily              # daily | weekly | biweekly | monthly | adhoc
time: 12:00 PKT
duration_minutes: 30
organizer: Taha Farooq
attendees: [Zain, Adnan, Faseeh, Hamis]
status: active              # active | paused | retired
last_verified: 2026-05-04
tags: [iban, eng-sync]
---
```

Body sections: `## Purpose`, `## Recurring agenda`, `## Notes`.

### `transcript`
A specific past meeting (one-off, KT, design session, all-hands). One file per meeting in `00_Resources/Meetings/Transcripts/`. Filename format: `YYYY-MM-DD-short-slug.md`.

```yaml
---
type: transcript
name: Tahir/Hamis IBAN Knowledge Transfer
meeting_date: 2026-04-09
attendees: [Tahir Qureshi, Hamis Mahmood]
related_initiative: leadership-transitions
related_project: 01_Global_USD_Account
source: https://mail.google.com/mail/u/0/#all/19d71cb5cf3363bf
status: archived            # archived | active-followups
last_verified: 2026-05-04
tags: [kt, iban, due, keel]
---
```

Body sections: `## Topics covered`, `## Decisions`, `## Action items`, `## References`.

### `initiative`
Cross-cutting themes that span multiple meetings/projects (leadership transitions, AI Blitz, sprint state, CX trends, KYC evolution, competitor watch). One file per initiative in `00_Resources/Initiatives/`.

```yaml
---
type: initiative
name: Leadership Transitions
status: active              # active | resolved | watching
priority: critical
started: 2026-04-08
expected_resolution: 2026-05-14
owner: Saad Pall
last_verified: 2026-05-04
tags: [departures, kt, backfilling]
---
```

Body sections: `## Context`, `## Current state`, `## Stakeholders`, `## Open questions`.

### `voice`
Singleton — Hamis's voice/style/communication preferences. Lives at `00_Resources/HOW_I_WORK.md`.

```yaml
---
type: voice
name: Hamis Mahmood — Voice & Communication Style
status: active
last_verified: 2026-05-04
---
```

## Where types live

| Type | Location | Layout |
|:--|:--|:--|
| `person` | `00_Resources/People/` | One file per person, kebab-case. |
| `project` | `0X_<Project_Name>/MEMORY.md` | Frontmatter at top of MEMORY.md. |
| `vendor` | `00_Resources/Vendors/` | One file per vendor. |
| `meeting` | `00_Resources/Meetings/` | One file per recurring meeting. |
| `transcript` | `00_Resources/Meetings/Transcripts/` | One file per past meeting, `YYYY-MM-DD-slug.md`. |
| `initiative` | `00_Resources/Initiatives/` | One file per cross-cutting theme. |
| `voice` | `00_Resources/HOW_I_WORK.md` | Singleton. |

## Index files

Each typed directory gets a sibling index file (`PEOPLE.md`, `VENDORS.md`, `MEETINGS.md`, `INITIATIVES.md`). The index is **derived**, not authoritative — generated from frontmatter for fast scanning. Cowork regenerates indexes on a schedule or on demand. Never edit an index by hand to add facts.

Indexes have no frontmatter.

## OPEN_LOOPS.md inline schema

Open loops are too granular for one-file-per-loop. Keep as a single file. Each loop entry uses this inline structure:

```markdown
- [ ] **Short title.** Body description with context.
  - `created: 2026-05-04` `owner: Hamis` `status: blocked-on-taha` `deadline: 2026-05-04` `related: 01_Global_USD_Account, nashit-syed`
```

Required inline fields: `created`, `status`. Optional: `owner` (default Hamis), `deadline`, `related`. Status values: `pending`, `blocked-on-<who>`, `in-progress`, `awaiting-reply`, `done`. Done items get pruned, not retained.

## Freshness rules

- `last_verified` more than **30 days old** → surfaced in daily briefing as "stale, please verify."
- `status: departed | terminated | resolved | retired | archived` are kept but excluded from active-state queries.
- `last_verified` updated by Cowork after a successful verification pass, or manually by Hamis.

## Free-text vs structured

If a fact has a clear field, use the field. Don't write `Email: foo@bar.com` in the body when there's an `email:` slot in frontmatter.

If a fact doesn't fit a field, leave it as a body bullet under the appropriate section.

## Adding a new type

1. Propose the new type in conversation. Define its fields and directory.
2. Update this doc with the frontmatter spec.
3. Migrate or create entries.
