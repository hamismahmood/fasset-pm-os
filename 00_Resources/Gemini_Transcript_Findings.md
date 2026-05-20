# Gemini_Transcript_Findings.md
*This file is now an index pointing into `00_Resources/Meetings/Transcripts/`.*
*Last updated: 2026-05-04*

Per-meeting transcripts (with frontmatter for `meeting_date`, `attendees`, `related_initiative`, `related_project`, source Gmail link) live as one file per meeting. New transcripts append as new files instead of growing this single doc.

## Where transcripts live

- One file per meeting at `00_Resources/Meetings/Transcripts/YYYY-MM-DD-short-slug.md`.
- Index of all transcripts: `00_Resources/Meetings/Transcripts/INDEX.md`.

## Cowork automation contract

When Cowork ingests a new Gemini transcript:
1. Create a new file at `Meetings/Transcripts/YYYY-MM-DD-<slug>.md` with the `transcript` frontmatter spec from `SCHEMA.md`.
2. Body sections: `## Topics covered`, `## Decisions`, `## Action items`, `## References`.
3. Update `Meetings/Transcripts/INDEX.md` with a row.
4. If the transcript advances or changes an active `initiative`, update that initiative's file (`Initiatives/<initiative>.md`) and refresh its `last_verified`.
5. If the transcript creates a new action item for Hamis, add it to `OPEN_LOOPS.md` using the inline schema.
6. If a new person is mentioned who isn't already in `People/`, create a stub file.

The synthesis logic that previously lived as numbered sections in this file (Leadership Transitions, Card Strategy, Fasset 4.5, etc.) now lives as standalone initiative files under `00_Resources/Initiatives/`.
