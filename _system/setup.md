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

## Required setup (not yet connected)

| Tool | How to connect | Impact if missing |
| :--- | :--- | :--- |
| Tactiq → Google Drive | In Tactiq settings: enable Google Drive integration, point to a folder e.g. `Fasset/Transcripts/` | Transcripts must be manually exported until configured |

## If a tool is missing
> "Tool [X] is listed in _system/setup.md but is not connected.
> Tasks that rely on it: [list]. To connect: [instruction]."
