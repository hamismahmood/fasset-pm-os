---
name: daily-update-iclaude
description: Fetch new Tactiq transcripts from Google Drive + scan Slack/Gmail for company context
---

1. Use Google Drive MCP to list files in the Tactiq folder (ID: `1i4EjU_F2LuEkOqHKh5u5YD0GctH0Zb-u`).
   - Read any transcript file newer than the last run.
   - For each transcript, apply the relevance filter below before processing.

   **Relevance filter — include if ANY of these are true:**
   - An attendee matches a name in `context/People/` (Fasset colleagues)
   - The title or content references: Fasset, HOR, IBAN, Travel Rule, Rain, Keel, Due, Notabene, Sumsub, Jumio, product squad, sprint, roadmap, or any active project name from `MEMORY.md`
   - The meeting was organised by or includes a @fasset.com email address

   **Exclude if ALL of these are true:**
   - No Fasset colleagues as attendees
   - No Fasset product/project terminology in title or content
   - Looks like a personal or SIHA-only call

   **If unclear:** log the filename and title in a `## Review queue` section at the bottom of `context/Meetings/Transcripts/INDEX.md` — don't process, don't discard.

   **For each included transcript:**
   - Extract topics, decisions, action items per `context/Meetings/transcript-protocol.md`.
   - Write a processed file to `context/Meetings/Transcripts/YYYY-MM-DD-<slug>.md`.
   - Update relevant initiative files in `context/Initiatives/` and refresh `last_verified`.
   - If a new person is mentioned without a file in `context/People/`, create a stub.
   - Update `context/Meetings/Transcripts/INDEX.md` with a new row.

2. Scan Slack and Gmail for the past 24 hours. Find things relevant to Hamis and things relevant to the company broadly. Update `context/COMPANY_ONGOINGS.md` — sequential stream with timestamps. Append only, never rewrite existing entries.

Only write to: new transcript files, INDEX.md, initiative files (when triggered), People stubs (when new person found), COMPANY_ONGOINGS.md.
