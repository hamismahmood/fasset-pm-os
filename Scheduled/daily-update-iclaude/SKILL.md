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
