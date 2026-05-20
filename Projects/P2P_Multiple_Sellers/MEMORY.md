---
type: project
name: P2P Multiple Sellers
status: active
priority: high
deadline: ~Q3 2026 (current estimate)
owner: Hamis Mahmood
related: [Malik Danish, Zane Motiwala, Saad Pall]
last_verified: 2026-05-15
tags: [p2p, marketplace, seller-selection, pakistan, buy-flow]
---

# MEMORY.md — P2P Multiple Sellers

## Why

P2P Express currently locks users to one active seller at a time. Sellers run shifts — when a shift ends and the next seller hasn't come online, users hit a wall. With the Pakistan market scaling, liquidity risk and drop-off from seller unavailability are real concerns. A seller selection marketplace fixes this and creates healthy competition on rate and speed.

## Current State

- **"Change" button already exists** in the UI at two points: Confirm Buy screen and Order Created screen. It is currently non-functional.
- Feature scope: wire the "Change" button to a real seller list. Expand the seller pool from ~2-3 per day to more sellers available around the clock.
- **~2 weeks engineering effort** (Malik Danish's estimate, May 15). Flow already designed for single-seller — backend changes needed.
- Current roadmap position: **end of Q3 2026**. Malik committed to push internally; Hamis writing PRD as business case for Zane/Saad.

## Key Decisions

- Auto-assignment preserved: system picks highest-completion-rate available seller when user doesn't tap "Change."
- "Change" button shown only when ≥2 sellers are available.
- Post-payment seller change is blocked (fraud prevention).
- v1: buy flow only. Sell side out of scope.

## Active Jira Tasks

None yet. PRD must be written first before tickets are created.

## Stakeholders

| Person | Role in this project |
| :---- | :---- |
| Malik Danish | Country Manager PK, committed to push internally |
| Zane Motiwala | Interim Head of Product — sign-off required |
| Saad Pall | Chief Growth Officer — sign-off required |
| Designer (TBD) | Primary PRD recipient |
