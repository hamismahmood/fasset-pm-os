# iClaude OS

Universal preferences and operating principles live in `~/.claude/CLAUDE.md`
(loaded in every session). This file holds iClaude-specific context: folder
structure, memory routing, project workspace index, PM scope, and scheduled tasks.

## Folder Structure

The `iClaude/` workspace is a PM operating system. Projects are one component of it.

1. **Root** — `CLAUDE.md` (this file) and `MEMORY.md` (standing facts, project index, Jira snapshot).
2. **`Projects/`** — Work Hamis owns with active deliverables and deadlines. Flat list, no sub-domains. Each project has its own `CLAUDE.md` and `MEMORY.md`.
3. **`Radar/`** — Active work Hamis monitors or supports but does not lead. One `.md` file per item — no full workspaces.
4. **`Insights/`** — User research and qualitative feedback: `Call_Notes/` (HTML call notes, COW tracker) and `Screenshots/`.
5. **`00_Resources/`** — Cross-project reference: people, voice, company context, meetings, vendors.
6. **`Scheduled/`** — Automated task SKILL.md definitions. Do not modify during normal sessions.
7. **`_system/`** — OS plumbing (agents, skills, tools). Ignore during normal work.

When a question is project-scoped, open the relevant `Projects/<name>/` folder and read both `CLAUDE.md` and `MEMORY.md` before answering. For Radar items, read the single `.md` file in `Radar/`.

## Memory System

At the start of every session, read these files before responding: root `MEMORY.md`, `00_Resources/PEOPLE.md`, `00_Resources/HOW_I_WORK.md`, `00_Resources/COMPANY_ONGOINGS.md` (index → open relevant `Initiatives/*.md` as needed), `00_Resources/OPEN_LOOPS.md`. The other indexes (`VENDORS.md`, `MEETINGS.md`, `INITIATIVES.md`) plus the directories themselves (`People/`, `Vendors/`, `Meetings/`, `Initiatives/`, `Meetings/Transcripts/`) are loaded on-demand when the conversation references them. When the conversation is scoped to a specific project, also read that project's `CLAUDE.md` and `MEMORY.md`. Use what you find to inform your work. Don't announce what you found, just be informed by it.

When I say "remember this," write the information to the appropriate file immediately and confirm you've done it.

**Where things go:** Apply two tests when deciding where to save something. Test 1: Does it prescribe behavior? Look for words like "always," "never," "before doing X, do Y." If yes, route to a `CLAUDE.md` — root if cross-cutting, the project's `CLAUDE.md` if project-scoped. Test 2: Does it describe a fact about the world that could change? If yes, route to the right memory file (table below).

| File | What goes here | When to read it |
| :---- | :---- | :---- |
| Root `MEMORY.md` | Standing facts about Hamis and Fasset (company, regulators, retail product framework, tools, vendors, recurring meetings), the master index of project workspaces, and the aggregated Active Jira Tasks snapshot across all projects. Cross-cutting archive items live here too. | Every session, and any time I reference a vendor, regulator, tool, meeting, project folder, or open ticket |
| `Projects/<name>/MEMORY.md` | Project-specific facts, status, key decisions, active tasks, partner contacts, project archive | When a question is scoped to that project, or when I mention something tied to it |
| `Projects/<name>/CLAUDE.md` | Project-specific behavioral rules (e.g., "always populate `paymentPurpose.proprietary` for UAE SWIFT transfers") | At the start of any work scoped to that project |
| `Radar/<name>.md` | Single-file context for work Hamis monitors but does not own | When Hamis references a radar item |
| `Insights/Call_Notes/` | HTML call notes (one per user interview), COW tracker | When reviewing user research or logging a new conversation |
| `00_Resources/PEOPLE.md` | **Index** of internal stakeholders (and a few key external contacts). Source of truth = one file per person in `00_Resources/People/`, each with YAML frontmatter (role, status, last_verified, etc.) per `SCHEMA.md`. Read the index for fast scan; open the individual file when you need detail. | Every session (read index), and whenever I name a colleague or stakeholder (open their file) |
| `00_Resources/SCHEMA.md` | Conventions for memory file structure across the workspace — frontmatter fields, types (`person`, `project`, `vendor`, `meeting`), where each type lives, and freshness rules. Cowork automations rely on this. | Before adding/editing memory entries, or when proposing a new memory type |
| `00_Resources/HOW_I_WORK.md` | My voice, tone, register switching, words I use, words to avoid | Before producing any written content on my behalf (Slack messages, emails, PRD copy, vendor comms) |
| `00_Resources/COMPANY_ONGOINGS.md` | **Index** of cross-cutting evolving themes (leadership transitions, AI Blitz, sprint state, CX trends, KYC evolution, etc.). Source of truth = one file per theme in `00_Resources/Initiatives/` per `SCHEMA.md`. | Every session (read index), open the initiative file when relevant |
| `00_Resources/INITIATIVES.md` | Index of all initiative files in `Initiatives/`. | Same as above |
| `00_Resources/VENDORS.md` | Index of vendor files in `Vendors/` (Keel, Due, Rain, Jumio, Sumsub, etc.). Each vendor has its own file with status, contacts, contract status. | Whenever I reference a vendor or partner |
| `00_Resources/MEETINGS.md` | Index of recurring meetings (`Meetings/`) and past transcripts (`Meetings/Transcripts/`). | Whenever I reference a meeting, KT session, design session, or all-hands |
| `00_Resources/OPEN_LOOPS.md` | Cross-cutting to-do list with inline metadata schema (`created`, `owner`, `status`, `deadline`, `related`). Action-oriented. Distinct from Jira (eng work) and project `MEMORY.md` (facts). | Every session, and whenever I commit to following up on something, or close a loop |
| `00_Resources/Gemini_Transcript_Findings.md` | **Index** pointing to per-meeting transcript files in `00_Resources/Meetings/Transcripts/`. Each transcript is a standalone file with frontmatter (date, attendees, related initiative). | When reviewing meeting context — open the specific transcript file |

When unsure, suggest which file you think it belongs in and ask me to confirm.

## Project Workspaces

The master index of active project folders is maintained in the root `MEMORY.md` under "Project Workspaces." When I create or rename a project folder, update that table and seed the new folder with a `CLAUDE.md` (rules) and `MEMORY.md` (facts).

## Active Jira Tasks (sync rule)

Root `MEMORY.md` carries an "Active Jira Tasks" snapshot aggregated from every project workspace. Project `MEMORY.md` files remain the source of detail. Whenever a task is added, completed, re-scoped, or moved between projects, update both the project file and the root snapshot in the same pass. If they fall out of sync, trust the project file and reconcile root.

## iClaude-specific rules

- When I say "make a Jira ticket," I mean in Horizon (HOR) unless I specify a different project.

## Scheduled Tasks

The `Scheduled/` folder contains SKILL.md definitions for Cowork scheduled tasks that run automatically. These are not project workspaces — do not treat them as such, do not add them to the project index, and do not modify their contents during normal sessions. The scheduled tasks are:

| Task | Schedule | What it does |
| :---- | :---- | :---- |
| `daily-briefing` | Weekdays, 11:00 AM | Morning briefing — pulls Calendar, Gmail, and Slack into a single summary |
| `daily-update-iclaude` | Weekdays, 8:08 PM | Evening scan — updates `00_Resources/Gemini_Transcript_Findings.md` and `00_Resources/COMPANY_ONGOINGS.md` from meeting transcripts and Slack/Gmail |
| `iclaude-task-update` | Weekdays, 8:09 PM | Evening Jira sync — reconciles the "Active Jira Tasks" table in root `MEMORY.md` against live Jira data |

The `iclaude-evening-sync` task has been converted to a manual skill. Definition lives at `_system/skills/evening-sync/SKILL.md`. Trigger it in conversation by asking for an evening sync — do not run it automatically.

If I ask you to change a scheduled task's behavior, edit the relevant `Scheduled/<task-name>/SKILL.md` file. Otherwise, leave the folder alone.

## Scope Context

I'm a Senior PM at Fasset, a Shariah-compliant crypto super app. I took over the Banking IBAN scope (Keel, Due, money movement) from a departing PM and also own global expansion prioritization, travel rule flows, Zendesk SDK migration, and statement of account. I support the cards PM on day-to-day strategy. The company is going through leadership transitions — both the Head of Product and an Engineering Manager are departing simultaneously.
