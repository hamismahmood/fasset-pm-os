# Transcript Protocol
*Last updated: 2026-05-20*

Per-meeting transcripts live as one file per meeting in `context/Meetings/Transcripts/`. Tactiq is the transcript source — it auto-saves to Google Drive after each call.

## Where transcripts live

- One file per meeting at `context/Meetings/Transcripts/YYYY-MM-DD-short-slug.md`.
- Index of all transcripts: `context/Meetings/Transcripts/INDEX.md`.

## Source: Tactiq via Google Drive

Tactiq auto-saves all call transcripts to a shared Google Drive folder (ID: `1i4EjU_F2LuEkOqHKh5u5YD0GctH0Zb-u`). The folder contains Fasset calls, SIHA calls, and personal calls — not everything is ingested. See filtering logic in `Scheduled/daily-update-iclaude/SKILL.md`.

The daily-update-iclaude task reads new files from that folder using the Google Drive MCP.

## Processing contract

When ingesting a new transcript:
1. Create a new file at `context/Meetings/Transcripts/YYYY-MM-DD-<slug>.md` with frontmatter: `meeting_date`, `attendees`, `related_initiative`, `related_project`, source.
2. Body sections: `## Topics covered`, `## Decisions`, `## Action items`, `## References`.
3. Update `context/Meetings/Transcripts/INDEX.md` with a new row.
4. If the transcript advances or changes an active initiative, update that initiative's file (`context/Initiatives/<initiative>.md`) and refresh `last_verified`.
5. If a new person is mentioned who isn't in `context/People/`, create a stub file.
