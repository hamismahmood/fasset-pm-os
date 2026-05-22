---
type: project
name: Travel Rule / AML Compliance
status: active
priority: high
deadline: 2026-05-22
owner: Hamis Mahmood
related: [Salman Khan, Nashit Syed, Taha Farooq, Ralf Jayaprakash, Ameera Iqbal, Notabene, Fireblocks]
last_verified: 2026-05-22
tags: [aml, declaration-flow, satoshi-test, tiered-verification, vara]
---

# MEMORY.md — Travel Rule / AML Compliance

Driven by 2025 AML inspection findings (VARA Travel Rule).

## Tiered Verification

| Receipt amount | Action | Owner |
| :---- | :---- | :---- |
| Under $1,000 | No action | n/a |
| $1,000 to $19,999.99 | Declaration form (beneficiary verification) | HOR-479 (existing flow) |
| ≥ $20,000 | In-app declaration + CX-administered Satoshi test ($10 of same asset, 7-day window, tolerance $9 to $11) | HOR-552 (this PRD) |

## Current State

- **PRD v2** (this folder, `PRD_Draft.md`, May 5) now covers **both tiers** in a single doc per Salman's May 5 ask. Per Hamis's call, the PRD lives as a Confluence document, not a Jira ticket.
- **HOR-552** was created May 4 as a Jira PRD but is now empty with summary "delete" — marked for admin deletion. Replaced by the Confluence-bound PRD draft.
- **HOR-565 (In Progress)** — Tier 1: UAE Deposit Self-Declaration ($1K–$20K). Ubaid Rajput.
- **HOR-566 (In Progress)** — Tier 2: UAE High-Value Deposit Verification (≥$20K Satoshi). Ubaid Rajput.
- **HOR-567 (In Progress)** — Verified Wallet Store (Tier 2 dependency). Ubaid Rajput.
- **HOR-627 (To Do)** — [SAFE Phase 1] Integrate Basic Travel Rule Support with Notabene. Ubaid Rajput. New as of May 13.
- Salman flagged (May 5 Slack DM) that withdrawal self-declaration is shipped, deposit self-declaration is designed but not built. PRD reuses the live withdrawal UI patterns.
- Engineering target for declaration flow build: **May 22**.
- Zendesk WebView only, no native SDK. Web Widget API used to prefill identity, custom fields, conversation tags (Tier 2 only).
- Ralf Jayaprakash training CX on Satoshi test procedures.

## Key Decisions

- v1 is UAE only. Phase 2 expands to other jurisdictions.
- Per-transaction trigger. No aggregation across deposits.
- USD valuation at time of receipt.
- Verified-wallet store is chain-agnostic, scoped per user × source address. One Satoshi proves control of the address forever, across any chain.
- Verified wallets auto-credit with no CX involvement, no escrow, no banner. Repeat senders get zero friction.
- Outbound is out of scope (handled by separate $20K hard send limit).
- VARA sign-off on the $20K threshold not required (confirmed May 4).
- Chain-specific dust edge cases not in scope.

## Active Jira Tasks

| Ticket | Status | Summary |
| :---- | :---- | :---- |
| HOR-479 | In Progress | Implementation of UAE Virtual Assets Travel Rule Requirements. Ubaid Rajput. Last Jira update May 12. |
| HOR-565 | In Progress | Tier 1: UAE Deposit Self-Declaration ($1K-$20K). Ubaid Rajput. Last Jira update May 13. |
| HOR-566 | In Progress | Tier 2: UAE High-Value Deposit Verification (≥$20K Satoshi Test). Ubaid Rajput. Last Jira update May 13. |
| HOR-567 | In Progress | Verified Wallet Store (Tier 2 dependency). Ubaid Rajput. Last Jira update May 13. |
| HOR-568 | To Do | CX Tooling for Tier 2 Escrow Management. Ubaid Rajput. |
| HOR-627 | To Do | [SAFE Phase 1] Integrate Basic Travel Rule Support with Notabene. Ubaid Rajput. |
| HOR-552 | to-delete | Original PRD ticket. Now empty (summary "delete"), awaiting admin deletion. PRD migrated to Confluence document. |

**DEADLINE ALERT (May 18):** 4 days to May 22 build deadline. All 6 active tickets unchanged since May 12-13. No Slack discussion visible. Urgent check-in with Ubaid Rajput needed today to confirm whether the May 22 date is still achievable.

## Open Items

- CX response SLA on Zendesk chat. Nashit to define.
- Compliance owner for manual wallet-verification revocation.

## Stakeholders

- **Salman Khan** — Eng PM partner. Authored HOR-479 spec; flagged the deposit self-declaration build gap.
- **Taha Farooq** — Tech lead. Owns Tier 1 (HOR-479) and Tier 2 build. Notabene + Fireblocks integration.
- **Nashit Syed** — CX Sponsor on Tier 2. Owns chat workflow + SLA definition.
- **Ralf Jayaprakash** — CX training on Satoshi procedure.
- **Ameera Iqbal** — Final macro copy review before launch.

## Reference

- FigJam board: https://www.figma.com/board/HLHLLuLHkLIzIIoV8bPNyP (Satoshi Test v3 is the current flow).
- Declaration screens: Fasset App 4.5, node `29889:271732`.
- Parent epic: FO-1022 (Notabene - Travel Rule).
