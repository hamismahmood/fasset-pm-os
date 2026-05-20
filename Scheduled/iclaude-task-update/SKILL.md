---
name: iclaude-task-update
description: Update tasks from Jira
---

At the end of each workday, go through Jira and update all tasks tracked in the iClaude master folder.

1. **Pull current Jira state**
   - Query all open Jira issues assigned to me or relevant to my project workspaces.
   - For each issue, capture: ticket ID, summary, status, assignee, and any recent updates or comments.

2. **Update the master MEMORY.md**
   - The file to update is `MEMORY.md` at the root of the iClaude folder (`/Users/hamis.mahmood/Desktop/iClaude/MEMORY.md`).
   - Reconcile the "Active Jira Tasks" table against the live Jira data:
     - Add any new tickets that aren't listed yet.
     - Update statuses for tickets that have changed (e.g., To Do → In Progress → QA → Done).
     - Move completed/closed tickets to an archive section or remove them from the active table.
     - Flag any tickets with new comments, blockers, or scope changes worth noting.
   - Update the "Last updated" timestamp at the top of the file to reflect the current date and time.

3. **Keep it clean**
   - Don't touch any other files — only the root `MEMORY.md`.
   - Preserve the existing table format and column structure.
   - Keep entries concise — one-line summaries, no verbose descriptions.
