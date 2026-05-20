---
type: initiative
name: Sprint State
status: active
priority: high
current_sprint: 10
sprint_started: 2026-05-08
owner: Zara Adalat
last_verified: 2026-05-13
tags: [sprint, planning, capacity]
---

## Sprint 9 history (closed)
Sprint 9 focus carrying forward from Sprint 8:
- Affiliate program (rolled out Apr 30, demo done).
- Due changes (BDD, IDR, SGD, KES expansion).
- NI implementation (Network International card-based on-ramp via e-commerce).
- Physical card and savings/yield product scheduled.
- P2P changes for Bangladesh prioritized (user safety, turning off on-ramp, off-ramp stays).

**May 4 standup additions:**
- Rain confirmed as card provider (Bridge dropped). Physical card flow with Comp Secure queued for roadmap.
- Rewards program vendors finalized: Cosmo Points (travel) + Totally Rewards (AI bundle). Mohsin NDA/MSA in progress.
- Vue approved as mid-term IBAN payout solution. Zane to approve contract.
- Travel Rule form (>$20K) on hard deadline May 22. Manual CX process as interim.
- Tether savings product PRD assigned to Salman.
- Fasset 4.9 (0) builds pushed to TestFlight (iOS, both Dev and Production).

## Key carry-forward decisions
- Manual KYC verification kicked off in Sprint 8 Week 2.
- Event mapping required as implicit requirement in every task and PRD going forward.
- Only half of engineering hiring targets met — roadmap scope reduced.
- Growth Squad proposed by Arundathi/Hina.

## Sprint 7 completed/extended items (referenced in #productsquad)
- Billing service: live for crypto, stocks, metals. Extended to banking layer.
- Due PK rollout, ID app localization, DocProof (PoA automation), deep links, FEX improvements, Revenue Engine data fixing, Dinari V2, Fasset 4.5 design, withdraw/deposit flow improvements.

## May 6 roadmap session (Product Daily Standup)
Q2 6-focus-area roadmap presented by Hina, targeting July 2026:
1. Global Rails: local payouts (ACHP, NI May, WorldPay). Blocker: partner onboarding by May 25.
2. US Card Enablement/BIN expansion: Rain managed model + Reap.
3. Affiliate Program: nearly done, minor deep-link changes remain.
4. Card Cashback and Rewards (Cosmo and internal options).
5. Private Banking: configurable limits and billing profiles.
6. Onboarding: Sumsub integration + Unified Account Center.

Compliance risks (both unmapped, flagged by Hamis):
- Dubai: Travel Rule form on deposits. **Deadline May 22.** In-scope.
- Bahrain: Consolidated account statement. **Deadline June 15.** ~2-week lift. Saad + Zane to manage regulator comms.

Roadmap is at ~90% capacity with current team. No new hires factored in. Contractors explored.

Fasset 4.5: design-before-PRD process failure surfaced. Kazi taking PRD ownership from Arundathi.
Designs to lock May 12. Dev starts May 10 sprint.

Roadmap 2/2 H1 session scheduled May 8, 11:00 AM PKT.

## May 8 — Sprint 10 launched
Sprint #10 Planning ran at 17:00 PKT. Attendees: Altof, Arundathi, Hamis, Hanya, Hina, Kazi, Mohsin, Salman, Siddique, Zara, Taha. Sprint 10 is now active (started 2026-05-08). CX & Product Feedback meeting also resumed today at 17:00 PKT (Nashit organizer — meeting status corrected to active in Meetings/cx-product-feedback.md).

Travel Rule stories created in Jira (assigned to Taha Farooq May 8, **reassigned to Ubaid Rajput by May 11**):
- HOR-565: Travel Rule Tier 1 UAE Deposit Self-Declaration ($1,000-$20K)
- HOR-566: Travel Rule Tier 2 UAE High-Value Deposit Verification (>=20K)
- HOR-567: Travel Rule Verified Wallet Store (Tier 2 dependency)
- HOR-568: CX Tooling for Tier 2 Escrow Management

Other new HOR tickets spotted in Jira (May 6-7 activity):
- HOR-561, 542, 560: IBAN promo code billing service integration (QA, Adnan Khan)
- HOR-563: NI card buy webhook handling (QA, Inayat Ullah)
- HOR-562: Marketing reward disbursement — $5 FIGB credit (In Progress, Adnan Khan)

Roadmap 2/2 H1 session also ran at 11:00 PKT today (Hina organizer). Lead assignments and compliance risk decisions expected — no transcript yet.

## May 11 — Sprint 10, Day 4

**Statement of Account CBB scope** — Active group DM (Hamis, Hina, Ibrahim, Saad, Mohamed, Zane). Hamis clarified regulatory vs design scope:
- CBB mandates: monthly auto (7 business days), on-request (5 working days), annual (7 business days of FY-end). Content: opening + closing balance, all transactions, crypto holdings with quantity and month-end price, fees, licensee/client details.
- Fasset-designed on top: transaction category taxonomy, asset-type balance sub-breakdown, password-protected PDF, in-app Statements section.
- CBB scope is Bahrain-only; Ibrahim's call to scope for all markets to avoid per-market rebuilds.

**IBAN enablement push (Altof)** — Altof tagged Hamis + Salman in #productsquad: enable IBAN for the 23 IBAN-disabled countries that have no Keel restriction match. Linked to live CX case: China-resident user getting "coming soon" on IBAN. Hamis committed to flagging Taha.

**Compliance - Prioritization** — Altof sent calendar invite for May 12, 3:00–3:45 PM PKT. Attendees: Hamis, Kazi, Salman. Expected items: KYC Expiry Handling (VARA request), Notabene Multitenant, Chainalysis Multitenant.

**Zendesk SDK** — Active DM (Hamis, Ibrahim, Nashit). Nashit expected Sprint 10 build; Hamis pushed to Sprint 11 (compliance items displaced it). Zendesk admin access being shared by Nashit. Knowledge base completion pending.

**AI Enablement** — Mandatory Claude Training Session at 10:00–10:30 PKT completed. Org-wide. Next: mandatory AI Enablement x Product session May 12, 11:00 PKT (Nauheen organizer).

## May 12 — Sprint 10, Day 5

**Fasset 4.5 design lock deadline: today.** Per the May 6 roadmap session ("Designs to lock May 12"). Confirm with Siddique/Kazi if this was achieved.

**Mandatory AI Enablement x Product session** — 11:00 PKT, Nauheen organizer. Org-wide continuation of AI Enablement series.

**Compliance - Prioritization meeting (Altof)** — 3:00–3:45 PM PKT. Attendees: Hamis, Kazi, Salman, Altof. Granola notes captured May 15. Key outcomes:
- **Compliance capacity rule:** max 10% engineering per sprint (1 item/sprint). 90% stays on North Star goals. Hard regulatory deadlines override.
- **Notabene multitenant (Sprint 10):** In sprint, assigned to Ubaid. Confirmed in progress.
- **Chainalysis multitenant:** Postponed — needs urgency confirmation from Hasan/Zara before scheduling. Salman waiting for Hasan to initiate.
- **KYC expiry handling (VARA):** Pushed to **Sprint 13 (July)** — high effort, can't fit sooner.
- **SIF implementation:** Sprint 12, Kazi leads, estimated 1 sprint.
- **Account statement (Bahrain):** Stalled — Zane's data-only workaround rejected by Hina. Root cause: Fasset has no centralized ledger; running balances aren't stored — every service would need to service a fetch request via a middleware layer. Overlaps with Fasset 4.5 unified cash balance work (HOR-644). Altof + Kazi to surface overlap with Hina in their next call.
- **Altof** created Confluence "Compliance Request" page — team to consolidate all compliance asks there; review before each sprint planning.

**New HOR tickets spotted (Sprint 10, week 1):**
- HOR-620: "Shifting to KYC reliance model with Due" — To Do, Muhammad Zain. Significant dependency shift for 01_Global_USD_Account.
- HOR-645: "Card-Based Deposit via NI Masking (v1)" — In Progress, Muhammad Zain. NI card-based on-ramp build.
- HOR-646: "PRD - Card Based Deposit via NI Masking" — To Do, Muhammad Zain.
- HOR-644: "[Fst 4.5] Unified Cash Balance (Fiat & Stablecoin Consolidation)" — To Do, unassigned.

**Jira closures (May 10–11):**
- HOR-473 (Reference Field, USD Send Money) → Done.
- HOR-546 (Beneficiary search empty state) → Done.
- HOR-562 (Marketing reward $5 FIGB) → Done.

**HOR-537** (Transaction PDF) moved from To Do → In Progress (Zain).

## May 12 standup (9pm PKT)

**Transcript:** [2026-05-12-pm-standup.md](../Meetings/Transcripts/2026-05-12-pm-standup.md). Source: Otter.ai (Karim) + Fathom.

- **Denali stock split — hard deadline May 18.** New, complex task for Denali-listed stocks. Salman's squad. Data team coordination required. This is sprint-critical.
- **Enterprise product:** Amen joined to work on enterprise product with Daniel (COO). New person — likely a new hire or external engagement, not yet in People/.
- **Altof (PK market):** Balance reconciliation issues + merchant dashboard upgrades.
- **Salman:** Fireblocks pending transactions flagged. KYC finance model issues flagged. Both need data team.
- **Fasset 4.10 (1) and (2)** pushed to TestFlight on May 12 — version jump from 4.9.
- **HOR-479** (Travel Rule implementation, Ubaid Rajput) moved to **In Progress** as of May 12.
- **Compliance-Prioritization session** ran 3pm PKT — Altof/Kazi/Salman/Hamis. Altof created Confluence "Compliance Request" page. Outcomes not yet transcribed.
- **WhatsApp OTP 2-hour outage (May 13 midnight PKT):** Nashit flagging to Altof in #bugs-reporting — needs redundancy plan.

## References
- Sprint Planning Apr 24: https://mail.google.com/mail/u/0/#all/19dbf5a9485f659c
- PM Standup May 6 (Fathom): https://mail.google.com/mail/u/0/#all/19dfdaa6bfe97ea6
