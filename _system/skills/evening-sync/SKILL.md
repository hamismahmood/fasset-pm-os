---
name: iclaude-evening-sync
description: Daily 8pm PKT consolidated sync — walks Gemini transcripts, Gmail, Slack, Calendar, and Jira; updates every typed memory file in iClaude with structured frontmatter; refreshes derived indexes; flags stale entries.
---

# iClaude Evening Sync

Run weekdays at **8:00 PM PKT**. This task replaces the previous `daily-update-iclaude` and `iclaude-task-update` skills with a single end-to-end pass that respects the typed memory schema in `00_Resources/SCHEMA.md`.

## Read first (every run, before any writes)

1. `/Users/hamis.mahmood/Desktop/iClaude/CLAUDE.md`
2. `/Users/hamis.mahmood/Desktop/iClaude/MEMORY.md`
3. `/Users/hamis.mahmood/Desktop/iClaude/00_Resources/SCHEMA.md` ← the contract for all writes
4. The relevant index files: `PEOPLE.md`, `VENDORS.md`, `MEETINGS.md`, `INITIATIVES.md`, `OPEN_LOOPS.md`, `COMPANY_ONGOINGS.md`, `Gemini_Transcript_Findings.md`.

## Inputs to scan

- **Gmail** — today's emails (especially Gemini transcript notifications, calendar invites, vendor threads, contract docs).
- **Google Calendar** — today's meetings + tomorrow's meetings.
- **Slack** — today's activity in: `#productsquad`, `#fasset-product-dev`, `#fasset-keel`, `#ask-dataengineering`, `#credit--product`, `#global-expansion`, `#tech-meets-fex`, `#fasset-claude-users`, `#ai-enablement`, `#product-cs-team`, `#bugs-reporting`. Plus DMs and group DMs Hamis is in.
- **Jira** — all open issues assigned to Hamis or in HOR/F40 projects.
- **Granola** — local meeting notes at `/Users/hamis.mahmood/Library/Application Support/Granola/cache-v6.json`. Parse `cache.state.documents` (a dict keyed by UUID). Each document has: `title`, `created_at`, `updated_at`, `notes_markdown`, `summary`, `people` (list of attendee objects), `google_calendar_event` (linked cal event with `summary` and `start.dateTime`). Process any document where `created_at` or `updated_at` is today's date and `notes_markdown` or `summary` is non-empty.

## Updates to perform

### 1. New transcripts → `00_Resources/Meetings/Transcripts/`

For each Gemini transcript that landed in Gmail today, and for each Granola note where `created_at` or `updated_at` is today:

- Create a new file at `Meetings/Transcripts/YYYY-MM-DD-<short-slug>.md`. Filename uses the meeting date (not today's date) and a kebab-case slug from the meeting title. If a Gemini transcript and a Granola note cover the same meeting (matched on calendar event title + date), merge them into a single file — don't create duplicates.
- Frontmatter follows the `transcript` type spec in `SCHEMA.md` (`type`, `name`, `meeting_date`, `attendees`, `related_initiative`, `related_project`, `source`, `status`, `last_verified`, `tags`). For Granola-sourced notes, set `source: granola`. For Gemini, set `source` to the Gmail link. For merged files, set `source: granola+gemini`.
- Body sections: `## Topics covered`, `## Decisions`, `## Action items`, `## References`. For Granola notes, populate `## Topics covered` and `## Action items` from `notes_markdown`; use `summary` as a one-paragraph overview at the top of the file.
- Append a row to `Meetings/Transcripts/INDEX.md` with date, title, status, source, related initiative/project.
- If the meeting introduced a new person not in `People/`, create a stub file using the `person` schema. For Granola notes, the `people` array contains attendee objects — use these to populate attendees.
- **Do not re-process a Granola document that already has a transcript file** — check `INDEX.md` for an existing entry with the same meeting date and slug before creating a new file.

### 2. Initiatives → `00_Resources/Initiatives/`

For each existing initiative file:

- If today's transcripts, Slack threads, or Gmail threads advance the initiative, update the relevant body section (`## Current state`, `## Open questions`, etc.) and refresh `last_verified` in frontmatter to today's date.
- If a new cross-cutting theme emerges that doesn't fit any existing initiative, propose it in the daily summary back to Hamis (don't create the file unilaterally — wait for confirmation).
- If an initiative reaches resolution (departure completes, sprint ends, event finishes), set `status: resolved` and add a closing note in the body.

### 3. Vendors → `00_Resources/Vendors/`

For each vendor file, scan today's Slack and Gmail for mentions:

- New contract status (negotiating → signed) → update `contract_status` + `last_verified`.
- New contact → add to `## Contacts` body section.
- New open issue → add to `## Open issues`.
- Resolved issue → remove from `## Open issues`, optionally add to `## History`.
- If a brand-new vendor is mentioned with substantive context (not just a passing reference), create a new vendor file using the `vendor` schema.

### 4. People → `00_Resources/People/`

For each person mentioned in today's Slack DMs, channels, or emails:

- If they have a file: refresh `last_verified` if anything new happened, append to `## Recent` body section with date prefix (`2026-05-04 — <one-line summary>`).
- If status change (`departed`, `onboarding` → `active`, etc.): update frontmatter.
- If they don't have a file but had a substantive interaction with Hamis: create a stub file using the `person` schema.

### 5. Open Loops → `00_Resources/OPEN_LOOPS.md`

Use the inline schema from `SCHEMA.md`:

- **Add** new loops surfaced today (action items from transcripts, Granola notes, Slack commitments, Gmail asks). Each new entry must include: `created`, `status`, `owner` (default Hamis), `deadline` if applicable, `related` (project IDs and/or person/vendor slugs).
- **Update** statuses on existing loops based on observed activity (`pending` → `in-progress`, `awaiting-reply` → `pending` if reply received, etc.).
- **Prune** loops that closed today. Done items are deleted, not retained.
- Refresh the `*Last updated:*` line at the top.

### 6. Active Jira Tasks → root `MEMORY.md`

- Pull all open Jira issues assigned to Hamis or in HOR/F40 projects.
- Reconcile the "Active Jira Tasks" table:
  - Add new tickets.
  - Update statuses (To Do → In Progress → QA → Done).
  - Move Done tickets to "Recently archived" subsection.
  - Flag tickets with new comments / blockers / scope changes.
- Update the project-specific `MEMORY.md` for any ticket that's also tracked at the project level. Project files are source of truth — keep them and the root snapshot in sync.
- Refresh the `*Last updated:*` line.

### 7. Indexes → regenerate from frontmatter

Walk each typed directory and regenerate the corresponding index file from the source files' frontmatter:

- `00_Resources/People/` → `PEOPLE.md`
- `00_Resources/Vendors/` → `VENDORS.md`
- `00_Resources/Meetings/` → `MEETINGS.md` (recurring section)
- `00_Resources/Meetings/Transcripts/` → `Meetings/Transcripts/INDEX.md`
- `00_Resources/Initiatives/` → `INITIATIVES.md`

Indexes are derived. Never edit an index directly to add facts — always edit the source file.

### 8. Freshness audit

Walk every typed file (`person`, `project`, `vendor`, `meeting`, `transcript`, `initiative`). Collect any file where `last_verified` is more than **30 days** older than today.

Append a "Stale entries" section to today's evening summary with the list. Do not auto-update `last_verified` unless the body actually changed.

## Output

Append a one-screen summary to a daily log. Format:

```markdown
## 2026-05-04 (Mon)

**Transcripts added:** 3 (file links) — note source per entry: gemini / granola / merged
**Initiatives updated:** 2 (links)
**Vendors updated:** 1 (link)
**People updated/added:** 4 (links)
**Open Loops:** +5 added, 2 updated, 3 closed
**Jira:** 7 reconciled (1 new, 4 status changes, 2 moved to archive)
**Stale entries (>30 days):** [list of files]
**Notes:** anything that needs Hamis's attention manually.
```

Daily log location: `00_Resources/Logs/YYYY-MM.md` (one file per month, append-only).

After writing the log, **send a DM to Hamis on Slack** (user ID `U0AMNTY21E3`, i.e. self-DM) with the same summary content, formatted for Slack (markdown bold via `*asterisks*`, bullet lists, no horizontal rules). Keep it tight — one screen, scannable. Include direct links to any files that need Hamis's attention.

## Rules

1. **Never edit `Scheduled/` files during this run.** The skill itself is metadata, not subject.
2. **Never invent `last_verified` updates.** Only refresh when the body changed in this run.
3. **Be conservative on initiative creation.** New initiative files require Hamis's confirmation. Surface a proposal in the daily summary instead.
4. **Match the `SCHEMA.md` contract exactly.** If a use case doesn't fit, surface it in the summary; don't write outside the schema.
5. **Don't touch `0X_*/Partner Docs/` or any other partner doc folders.** Read-only.
6. **Don't touch `HOW_I_WORK.md`.** That's curated by Hamis manually.
7. **Don't update `Scheduled/` skill files.**
8. **Voice for body updates** must match `HOW_I_WORK.md` if the update includes prose. No em dashes. Concise.

## Initial run (one-time)

The first run should also:

- Backfill any Gemini transcripts from Apr 7–30 that weren't migrated during the May 4 schema migration.
- Backfill any vendor/person/initiative data from existing root `MEMORY.md` content that wasn't fully captured.
- Establish the `Logs/` directory.

After the initial run, behave incrementally — only process today's new inputs.

## Supersedes

This skill is intended to replace these two earlier scheduled tasks once Hamis is satisfied with its output:

- `daily-update-iclaude` (8:08 PM) — was Gemini findings + COMPANY_ONGOINGS narrative updates.
- `iclaude-task-update` (8:09 PM) — was Jira reconciliation only.

Run this skill in parallel for 1-2 weeks before disabling the old ones. The `daily-briefing` (11 AM) task is unaffected and continues separately.
