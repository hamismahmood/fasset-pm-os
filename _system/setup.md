# iClaude — Tool Dependencies
*Check this file at session start. If any tool is missing, surface it before proceeding.*

## Claude.ai Integrations (authenticate at claude.ai > Integrations)

| Tool | Purpose in this OS | Required for |
| :--- | :--- | :--- |
| Slack | Read channels, search, send messages | pm-comms, daily briefing |
| Gmail | Search threads, draft emails | pm-comms, daily update |
| Google Calendar | Read events, schedule | daily briefing |
| Google Drive | Read/write docs, fetch Tactiq transcripts | pm-execution, pm-partners, daily update |
| Atlassian (Jira + Confluence) | Ticket management, PRD docs | pm-execution |
| Figma | Design file access | pm-execution |
| Mixpanel | Analytics queries | pm-data |
| Granola | ~~Meeting transcripts~~ REPLACED BY TACTIQ | deprecated — remove |

## Claude Code MCPs (local — configured in ~/.claude/settings.json)

| Tool | Purpose | Install command |
| :--- | :--- | :--- |
| Graphiti | Persistent memory graph | see ~/.claude/settings.json |

## CLIs

| Tool | Purpose | Install |
| :--- | :--- | :--- |
| `gh` | GitHub CLI — for when this repo moves to GitHub | `brew install gh` |

## Tactiq transcript folder

Folder ID: `1i4EjU_F2LuEkOqHKh5u5YD0GctH0Zb-u`
URL: https://drive.google.com/drive/folders/1i4EjU_F2LuEkOqHKh5u5YD0GctH0Zb-u

Shared folder containing all Tactiq-saved call transcripts: Fasset internal calls, SIHA calls, and personal calls. Not all transcripts are Fasset-relevant — see daily-update-iclaude/SKILL.md for filtering logic.

## If a tool is missing
> "Tool [X] is listed in _system/setup.md but is not connected.
> Tasks that rely on it: [list]. To connect: [instruction]."
