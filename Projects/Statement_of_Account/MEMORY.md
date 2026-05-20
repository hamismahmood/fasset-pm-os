---
type: project
name: Statement of Account
status: active
priority: medium
owner: Hamis Mahmood
related: [Ibrahim Ali, Keel]
last_verified: 2026-05-02
tags: [statements, pdf, monthly-annual, awaiting-final-review]
---

# MEMORY.md — Statement of Account

Downloadable and emailed account statements for retail users.

## Scope

- On-request statements (HOR-489)
- Automated monthly/annual statements (HOR-493)
- PDF content definition (HOR-496)
- Generation engine (HOR-500)
- Epic: HOR-488

## Current State

- PRD on Confluence: space PF, page 1148092424.
- Through multiple rounds of editing with Ibrahim.
- Awaiting final review.

## Key Decisions

- **Password-protected PDF via email** with birth year as the password.
- **Institutional/business statements out of scope** for this PRD.
- **KE (Keel) relationship clarified** in the statement, but ClearBank branding excluded. FCA registration number is permitted for transparency.

## Architecture Blocker (surfaced May 12 Compliance meeting)

Fasset has **no centralized ledger** — running balances aren't stored anywhere. Each product (IBAN, crypto, cards, staking) is a separate service. To generate a statement, a middleware layer would need to aggregate fetch requests across all services in real time. This is why Hina rejected Zane's data-only workaround.

**Key overlap:** The centralized ledger/middleware required for SoA is the same backend work needed for Fasset 4.5 unified cash balance (HOR-644). Hamis asked Altof + Kazi to surface this overlap with Hina on their unified cash balance call. If Hina acknowledges the overlap, SoA backend work could be scoped together with 4.5 rather than as a separate lift.

**Bahrain regulatory ask (June 15 deadline):** Zane is negotiating with Mohammed (Bahrain country head). Hina has confirmed engineering work is unavoidable — no data shortcut. Status: in negotiation.
