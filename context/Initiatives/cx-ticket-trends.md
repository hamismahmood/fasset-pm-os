---
type: initiative
name: CX Ticket Trends
status: active
priority: high
trend: escalating
owner: Nashit Syed
last_verified: 2026-05-29
tags: [cx, support, tickets, escalations]
---

## Context
Weekly ticket volumes escalating. Drives PRD prioritization, deflection initiatives (Zendesk SDK Migration), and product fixes.

## Recent ticket volumes
| Week | Tickets | Escalations | Top Issues |
|------|---------|-------------|------------|
| ~Apr 3 | 488 | — | — |
| Apr 10 | 592 | 21 | KYC, USDT display, balance issues |
| ~Apr 14 | 618 | — | — |
| Apr 17 | 691 | 29 | Fasset Card, KYC, technical problems |
| Apr 24 | 793 | — | Fasset Card, general inquiries, KYC |

## Recurring issues
- USDT/USDC deposit failures (Fireblocks-related — missed deposits).
- Unexplained $4 deduction on silver sales.
- Card approved by Rain but failing to update internal system (manual approval needed).
- Payment failure from address character limit (FE fix scheduled).
- USDT rate display inconsistency (needs 4 decimal places).
- Name validation on global USD transfers (special characters causing failures).
- PoA success rate only 20-30% (missing identity docs, laminated docs rejected, >90 day docs rejected).
- KYC status miscommunication (verified users seeing "in progress" until cache cleared).
- **Fee transparency (May 6):** Users complaining about 1% fee on screen but being charged 1% + $0.54 platform fee. Kashmala raised in #product-cs-team. Siddique confirmed fee breakdown design already exists but is hidden behind an arrow. Nashit aligned: show "Platform fee" + "Transaction fee" labels without hardcoding percentage. Raafi endorsed May 7. Salman/Siddique/Saad/Nashit tagged.
- **USD Reference field pending (May 6):** Tahreem escalated user complaint — transfer stuck at pending, no reference field for brokerage deposits. Hamis confirmed HOR-473 (reference field) in QA, ETA ~1-2 weeks.
- **Card billing address not visible (May 6):** Kashmala raised — users asking for billing address visibility after applying. Salman noted it's "somewhat hidden" in card settings. Raafi called it a "good and reasonable need" on May 7. Arundathi tagged.
- **Keel restricted countries + Kenya/Nigeria status (May 8):** Kashmala asked Nashit in #product-cs-team for Keel's restricted countries list and whether Kenya/Nigeria are now off the restricted list. Hamis tagged for an update. Needs PM response — route to Arundathi for Rain/card visibility, handle Keel side directly.
- **USD account transaction types visibility (May 8):** Kashmala asked Siddique when the full transaction history view (showing all transaction types incl. IBAN on home page) will be moved to dev. Siddique confirmed it's in 4.5 design but product-level call on timing. Hamis tagged on this thread.

- **WhatsApp OTP 2-hour outage (May 13):** Nashit flagged in #bugs-reporting — OTP service was down for 2 hours. Nashit tagged Altof with a direct ask: plan for WhatsApp redundancy. Cannot afford this kind of downtime on OTP services. Altof to respond with plan.
- **Fasset x Tether landing page button broken (May 13):** Ayman Hassen reported in #bugs-reporting — Fasset x Tether button on landing page not hyperlinked anywhere.

## Owners
- Refund UI for CX team — being prioritized.
- Front-end fixes — Faseeh.
- Card sync issues — Hina/Mudassar/Inayat.
- Manual reviews — Kashmala (CX) + Rain.

## References
- CX Feedback Apr 10: https://mail.google.com/mail/u/0/#all/19d7764c8bc523c2
- CX Feedback Apr 17: https://mail.google.com/mail/u/0/#all/19d9b79f0797037e
- CX Feedback Apr 24: https://mail.google.com/mail/u/0/#all/19dbf85070fb9d34
