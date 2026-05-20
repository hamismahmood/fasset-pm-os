---
name: daily-refresher
description: 7am + 7pm PKT — silent OS update from Tactiq, Jira, Confluence, Slack, Gmail
---

## Context

This skill keeps the iClaude PM OS current. It runs twice a day and ingests new information from all sources, routing it to the right files. It does not summarise or brief — that is the daily-briefing's job. It writes facts.

Before running, read:
- `/Users/hamis.mahmood/Desktop/iClaude/MEMORY.md` (active projects, tickets, vendors)
- `/Users/hamis.mahmood/Desktop/iClaude/CLAUDE.md` (folder map and routing rules)

---

## Source 1 — Tactiq transcripts

Folder ID: `1i4EjU_F2LuEkOqHKh5u5YD0GctH0Zb-u`

1. Use Google Drive MCP to list files newer than the last run.
2. For each file, apply the relevance filter from `context/Meetings/transcript-protocol.md`.
3. For included transcripts:
   - Extract topics, decisions, action items per the protocol.
   - Write processed file to `context/Meetings/Transcripts/YYYY-MM-DD-<slug>.md`.
   - Update relevant `context/Initiatives/<initiative>.md` files and refresh `last_verified`.
   - If a new person is mentioned without a file in `context/People/`, create a stub.
   - Add a row to `context/Meetings/Transcripts/INDEX.md`.

---

## Source 2 — Jira (HOR project)

Query tickets where: reporter = Hamis OR ticket ID appears in any `Projects/*/MEMORY.md`.

For each ticket with a status change since last run:
- Update the **project** `MEMORY.md` Active Jira Tasks section only.

Root `MEMORY.md` gets updated **only** for:
- Ticket moved to Done → move to the "Recently archived" row in root MEMORY.md
- Brand-new ticket not yet tracked anywhere → add to Active Jira Tasks in root MEMORY.md

Never update root MEMORY.md for routine status moves (To Do → In Progress, In Progress → QA, etc.).

---

## Source 3 — Confluence (PF space)

Check for new comments since the last run on pages where Hamis is:
- The page author, or
- @mentioned in a comment

For new comments on a PRD or spec page: append a note to the relevant `Projects/*/MEMORY.md`.

---

## Source 4 — Slack

Channels: #productsquad, #fasset-product-dev, #fasset-keel, #global-expansion, #tech-meets-fex, #credit--product, #product-cs-team, DMs. Lookback: 12 hours.

Apply the same Tier 1/2/3 relevance rules as daily-briefing. For any message that represents a **confirmed fact** worth recording (a decision made, a blocker surfaced, a milestone confirmed, an agreement reached): append a timestamped entry to `context/COMPANY_ONGOINGS.md`.

Do not log noise, opinions, or in-progress discussions.

---

## Source 5 — Gmail (past 12 hours)

For threads where a material fact was confirmed (contract signed, deadline agreed, approval given, key decision made): append a timestamped entry to `context/COMPANY_ONGOINGS.md`.

---

## Write rules

| File | What to write | Rule |
| :--- | :--- | :--- |
| `context/COMPANY_ONGOINGS.md` | Confirmed facts from Slack + Gmail | Append only. Timestamp every entry. |
| `context/Meetings/Transcripts/*.md` | Processed transcripts | One file per meeting. |
| `context/Meetings/Transcripts/INDEX.md` | New transcript rows | Append row. |
| `context/Initiatives/*.md` | Initiative updates from transcripts | Update body + refresh `last_verified`. |
| `context/People/*.md` | New person stubs | Create stub only if person not already in `context/People/`. |
| `Projects/*/MEMORY.md` | Jira status changes + Confluence comments | Active Jira Tasks section only. |
| Root `MEMORY.md` | Done tickets + new untracked tickets | Minimal. Never routine Jira status moves. |

Never touch: any `CLAUDE.md` file, `Scheduled/` files, `HOW_I_WORK.md`, `pm-*/RULES.md`, `briefings/`.
