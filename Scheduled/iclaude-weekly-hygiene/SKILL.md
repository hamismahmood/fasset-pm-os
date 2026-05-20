---
name: iclaude-weekly-hygiene
description: Friday 9pm PKT deeper hygiene pass — re-verifies frontmatter against live Jira/Slack/Calendar, prunes long-stale entries, archives resolved initiatives, surfaces drift.
---

# iClaude Weekly Hygiene

Run **Fridays at 9:00 PM PKT** (after the daily evening sync). This skill is heavier than the daily sync and does work that doesn't need to happen every day.

## Read first

1. `/Users/hamis.mahmood/Desktop/iClaude/CLAUDE.md`
2. `/Users/hamis.mahmood/Desktop/iClaude/MEMORY.md`
3. `/Users/hamis.mahmood/Desktop/iClaude/00_Resources/SCHEMA.md`

## Tasks

### 1. Re-verify frontmatter against live sources

Walk every typed file and check whether the frontmatter still matches reality:

- **`person` files**:
  - Slack profile lookups confirm `email`, `slack_id`, `role`, `team`. Update if changed.
  - If `status: departing` and `last_day` is in the past, change to `departed`.
  - If `status: onboarding` and the person has been active >30 days, change to `active`.

- **`project` files** (`0X_*/MEMORY.md`):
  - Cross-check the project's Active Jira Tasks against live Jira.
  - If `status: paused` and the project's Jira tickets show recent activity, surface the discrepancy.
  - If `deadline` has passed, prompt for status update.

- **`vendor` files**:
  - Check `contract_status` against the contracts folder (`0X_*/Partner Docs/<vendor>/Contracts/`).
  - If a contract was signed since last week, update `contract_status: signed` and `last_verified`.

- **`meeting` files**:
  - Check Google Calendar for actual cadence/time/organizer. Flag drift.
  - If a recurring meeting hasn't fired in 4+ weeks, propose `status: paused`.

- **`initiative` files**:
  - If `status: active` but `last_verified` >14 days ago and no related transcripts/threads since, propose `status: watching` or `resolved`.

Refresh `last_verified` on any entry whose body content was actually re-verified.

### 2. Prune

- **Departed people**: If `status: departed` for >6 months, move file to `00_Resources/People/Archive/`.
- **Resolved initiatives**: If `status: resolved` for >90 days, move to `00_Resources/Initiatives/Archive/`.
- **Old transcripts**: Transcripts older than 6 months stay where they are (historical record), but flag any with `status: active-followups` that haven't seen movement in 30 days.
- **Closed open loops**: Already pruned daily, but verify nothing slipped through.

### 3. Drift detection

- Find any new vendors, people, initiatives mentioned in the last week's Slack/Gmail/transcripts that don't yet have a file. List them in the output.
- Find any orphaned references in body text — e.g., "see Initiatives/foo.md" where `foo.md` doesn't exist.
- Find any frontmatter fields that don't match the SCHEMA spec for their type.

### 4. Index regeneration

Re-regenerate all derived indexes from frontmatter (same as daily sync, but a sanity pass):
- `PEOPLE.md`, `VENDORS.md`, `MEETINGS.md`, `INITIATIVES.md`, `Meetings/Transcripts/INDEX.md`.

### 5. Send weekly summary to Slack

At the end of the run, send a DM to Hamis (Slack user ID `U0AMNTY21E3`, i.e. self-DM) with this format:

```
*iClaude Weekly Hygiene — <date>*

*Frontmatter updates:* <count>
*Pruned:* <count> (people archived: <count>, initiatives archived: <count>)
*Drift detected:*
- New people without files: <list>
- New vendors without files: <list>
- New initiatives proposed: <list>
- Schema violations: <list with file paths>
*Stale entries (>30 days):* <count> (full list in Logs/)

Indexes regenerated. Logs at `00_Resources/Logs/YYYY-MM.md`.
```

## Rules

1. **Don't auto-create new initiative or vendor files.** Surface proposals, wait for Hamis to confirm next session.
2. **Don't auto-archive people files** if the person is referenced in any active project / open loop / vendor file. Skip and flag.
3. **Match `SCHEMA.md` exactly** for every write.
4. **Don't touch `Scheduled/` files.**
5. **Don't touch `HOW_I_WORK.md`.**
