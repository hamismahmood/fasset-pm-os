---
name: iclaude-weekly-hygiene
description: Fridays 9pm PKT — deep hygiene pass across all OS files, Jira, Slack, Calendar
---

## Context

This is the weekly deep clean for Hamis's iClaude PM OS. It runs after the 7pm daily refresher on Fridays and does heavier work that doesn't need to happen every day: frontmatter re-verification, pruning stale entries, drift detection, and index regeneration. It ends with a Slack summary DM.

Before running, read:
- `/Users/hamis.mahmood/Desktop/iClaude/MEMORY.md`
- `/Users/hamis.mahmood/Desktop/iClaude/context/SCHEMA.md`

---

## Task 1 — Re-verify frontmatter against live sources

Walk every typed file and check whether frontmatter still matches reality. Refresh `last_verified` on any file whose content was actually re-verified.

**`person` files (`context/People/*.md`):**
- Slack profile lookup: confirm `email`, `slack_id`, `role`, `team`. Update if changed.
- If `status: departing` and `last_day` is in the past → change to `departed`.
- If `status: onboarding` and person has been active >30 days → change to `active`.

**`project` files (`Projects/*/MEMORY.md`):**
- Cross-check Active Jira Tasks against live Jira.
- If `status: paused` and Jira shows recent activity → surface the discrepancy, don't auto-change.
- If a `deadline` field has passed → flag for Hamis to update next session.

**`vendor` files (`pm-partners/vendors/*.md`):**
- Check `contract_status` against `Projects/*/Partner Docs/` contract files.
- If a contract was signed since last week → update `contract_status: signed` and `last_verified`.

**`meeting` files (`context/Meetings/*.md`):**
- Check Google Calendar for actual cadence, time, and organizer. Flag any drift.
- If a recurring meeting hasn't appeared on Calendar in 4+ weeks → propose `status: paused` (don't auto-change).

**`initiative` files (`context/Initiatives/*.md`):**
- If `status: active` but `last_verified` >14 days ago and no related transcripts or Slack threads since → propose `status: watching` or `resolved` (don't auto-change).

---

## Task 2 — Prune stale entries

- **Departed people**: If `status: departed` for >6 months AND not referenced in any active project or vendor file → move to `context/People/Archive/`.
- **Resolved initiatives**: If `status: resolved` for >90 days → move to `context/Initiatives/Archive/`.
- **Old transcripts**: Transcripts >6 months old stay (historical record). Flag any with open action items that haven't moved in 30 days.

---

## Task 3 — Drift detection (full week lookback)

Scan Slack (Mon–Fri, same Tier 1/2/3 rules as daily-briefing) and Gmail for the past week.

Surface the following — do not auto-create files for any of these, just list them in the Slack summary:
- New people mentioned who don't have a file in `context/People/`
- New vendors or tools discussed that don't have a file in `pm-partners/vendors/`
- New recurring patterns or company-level themes that don't map to any existing initiative in `context/Initiatives/`
- Orphaned file references in any body text (e.g., "see Initiatives/foo.md" where foo.md doesn't exist)
- Frontmatter fields that don't match the SCHEMA spec for their type

---

## Task 4 — Index regeneration

Regenerate the following indexes from actual file frontmatter:
- `context/PEOPLE.md` — from `context/People/*.md`
- `context/MEETINGS.md` — from `context/Meetings/*.md` (not Transcripts)
- `context/Meetings/Transcripts/INDEX.md` — from `context/Meetings/Transcripts/*.md`

---

## Task 5 — Send weekly summary Slack DM

Send to `U0AMNTY21E3`. Format:

```
*iClaude Weekly Hygiene — <DD Mon YYYY>*

*Frontmatter updates:* <count>
*Pruned:* <count> (people archived: <n>, initiatives archived: <n>)
*Flags for Hamis:*
- Paused meetings proposed: <list>
- Watching/resolved initiatives proposed: <list>
- Passed deadlines needing update: <list>

*Drift detected:*
- New people without files: <list>
- New vendors/tools without files: <list>
- Orphaned references: <list>

Indexes regenerated. Log: context/Logs/YYYY-MM.md
```

---

## Rules

1. **Never auto-create** new initiative or vendor files. Surface proposals in the Slack summary.
2. **Never auto-archive** a person file if they are referenced in any active project or vendor file. Flag it instead.
3. **Match `context/SCHEMA.md` exactly** for every file write.
4. **Never touch** `Scheduled/` files, `CLAUDE.md` files, `HOW_I_WORK.md`, or `briefings/`.
