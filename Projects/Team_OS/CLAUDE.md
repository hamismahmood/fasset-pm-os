# CLAUDE.md — Team OS

Project-specific behavioral rules go here. Cross-cutting rules live in the root `CLAUDE.md`. Project facts live in `MEMORY.md` (this folder).

## What This Project Is

Team OS is an initiative to build a Claude Code-powered operating system for Fasset's product team — modelled on the "team-os-example-repo" by Hannah Stulberg. The goal is to give every team member Claude sessions that are immediately useful, without requiring constant re-explanation of context.

## Scope

This is an internal tooling project, not a product feature. It does not ship to customers. Deliverables are documentation, memory files, `.claude/` configuration, and skills — not product code.

## Key Constraints

- This is exploratory / research phase. Do not create Jira tickets until scope is confirmed with a stakeholder.
- Any templates or structure proposed should be validated against the example repo (`team-os-example-repo`, cloned at `iClaude/team-os-example-repo/`) before recommending.
- The example repo uses Forge (fictional company) as a model. When adapting, always substitute Fasset-specific context (Jira = HOR project, design tool = Figma "Fasset App 4.5", transcripts = Granola, etc.).
