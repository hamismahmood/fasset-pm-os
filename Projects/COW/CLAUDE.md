# COW Project — Behavioral Rules

Customer Obsession Week (COW): Fasset-wide initiative to log 100 user conversations in 2 weeks (starting 11 May 2026). Insights feed into the H2 2026 roadmap presentation at Fasset Fusion (June 2026).

## Call Note Format

Call notes follow a fixed one-page structure. When creating a call note:

1. **Build a `.docx` using the builder script** at `Projects/COW/call_note_builder.py`. Do not create plain text or HTML — it loses all formatting.
2. **Upload to Google Drive as a Google Doc** using the Drive API with `sheets_token.json` credentials (see upload pattern in the builder script). Set `mimeType: GDOC_MIME` in metadata while uploading `DOCX_MIME` content — this triggers Drive's docx-to-Google-Doc conversion.
3. **Save the Google Doc link** in `Projects/COW/MEMORY.md` and in the COW Tracker (column P, "Link to Meeting Notes").

### Document structure (in order)

| Section | Content |
| :--- | :--- |
| Header | Dark background (#0f172a). Name in large white bold. Meta row: date · duration · location · context |
| Who He Is | Left column. Short paragraph on who the user is and their primary use case. |
| Why He's Happy | Right column. What they value about Fasset. Include a stat highlight box (green, bold number + label). Add a note below the box if there's a supporting quote or context. |
| Feedback | Numbered cards. Each card: title (bold) + tags + description. Tags: `PRODUCT` (purple), `UX` (yellow), `FOLLOW-UP NEEDED` (pink), `INSIGHT` (blue). |
| Follow-ups | Checkbox list. Concrete next actions, not vague themes. |
| Footer | "Fasset — Internal" left · "Hamis Mahmood · [date]" right |

### Tags

- `PRODUCT` — missing or underdeveloped feature
- `UX` — feature exists but has usability/discoverability issues
- `FOLLOW-UP NEEDED` — needs a follow-up conversation or investigation
- `INSIGHT` — behavioural observation, not a complaint (no product gap, but informs positioning/strategy)

## COW Tracker

Google Sheet: https://docs.google.com/spreadsheets/d/1lXfMo-93jn9HND7zIbKdrYg7HnBhO3wk/edit
Local copy: `Insights/Call_Notes/COW_Tracker.xlsx`

When filling in the tracker, always check the live Google Sheet first — it is ahead of the local copy. Fill in all 16 columns. Column P (Link to Meeting Notes) should point to the Google Doc.

## Upload credentials

- Token file: `~/.claude/.sheets_token.json`
- Credentials file: `~/.claude/gauth.json`
- The token has `https://www.googleapis.com/auth/drive` scope — use it for Drive API uploads and deletes.
- Note: this token is a different Google auth flow from the claude.ai MCP Drive integration. Files created via the MCP cannot be deleted via the direct API and vice versa.
