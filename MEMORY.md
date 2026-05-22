# MEMORY.md
*Last updated: 2026-05-22*


## Project Workspaces

Active project folders live at the root of `iClaude/`. Each folder contains its own `CLAUDE.md` (project-specific behavioral rules) and `MEMORY.md` (project facts, status, contacts, active tasks, archive). This table is the master at-a-glance index — keep it in sync whenever a workspace is added, renamed, or archived.

### Owned Projects

| Folder | Project | Status |
| :---- | :---- | :---- |
| `Projects/Global_USD_Account/` | Banking IBAN scope — Keel, Due, money movement (inherited from Tahir) | Active — critical |
| `Projects/Travel_Rule/` | AML compliance, tiered verification | Active — deadline May 22 |
| `Projects/Statement_of_Account/` | Downloadable/emailed account statements | Active — Bahrain deadline June 15 |
| `Projects/Global_Expansion/` | Country prioritization and marketing-led expansion | Active |
| `Projects/Mastercard_Issuing/` | Strategic exploration: direct Mastercard relationship | Research phase — not started |
| `Projects/P2P_Multiple_Sellers/` | P2P Express marketplace — multiple seller selection, PKR→USDT buy flow | Active — PRD v1 written May 18 |
| `Projects/Team_OS/` | Claude Code team operating system for Fasset — modelled on Hannah Stulberg's team-os-example-repo | Research phase |
| `Projects/COW/` | Customer Obsession Week — 100 user conversations by 25 May 2026, insights for Fasset Fusion (June 2026) | Active — ends May 25 |

When adding a new project, create `Projects/<name>/` with `CLAUDE.md` and `MEMORY.md`, then add a row here.

### Radar

| File | Item | Role |
| :---- | :---- | :---- |
| `Radar/Card_Strategy.md` | Cards product — Rafi's top priority | Supporting Arundathi |
| `Radar/WorldPay_PSP.md` | WorldPay PSP onboarding | Country analysis task for Nawaz |
| `Radar/Business_Banking.md` | Titan pilot for 3 business clients | Light-touch owner |
| `Radar/Zendesk_SDK.md` | Native SDK migration — PRD done, Sprint 12 planned | Tracking delivery |
| `Radar/Fasset_4.5.md` | Major app redesign — design paused | Not directly involved |

## Active Jira Tasks

Aggregated snapshot of open work across all project workspaces. This is a derived index — project `MEMORY.md` files remain the source of detail. Update both this section and the relevant project file whenever a task is added, completed, or re-scoped. Status as of last Jira reconciliation.

| Ticket / Item | Status | Workspace | Summary |
| :---- | :---- | :---- | :---- |
| HOR-481 | QA | Global_USD_Account | UAE Purpose of Payment Codes — `paymentPurpose.proprietary` for Keel SWIFT to UAE (Fazal). |
| HOR-537 | In Progress | Global_USD_Account | USD IBAN downloadable transaction confirmation PDF (Zain). In progress as of May 12. |
| (untracked) | — | Global_USD_Account | User pending IBAN-to-USDT internal transfer worriness (#productsquad bug roundup). |
| HOR-488 (epic) | To Do | Statement_of_Account | Statement of Account v1 — unassigned, deprioritized. |
| HOR-489 | To Do | Statement_of_Account | On-request statements — unassigned. |
| HOR-493 | To Do | Statement_of_Account | Automated monthly/annual statements — unassigned. |
| HOR-496 | To Do | Statement_of_Account | PDF content definition — unassigned. |
| HOR-500 | To Do | Statement_of_Account | Generation engine — unassigned. |
| HOR-569 | To Do | Radar/Zendesk_SDK | Zendesk SDK: Replace WebView with Native Messaging SDK (React Native bridge). Under HOR-175 epic. |
| HOR-570 | To Do | Radar/Zendesk_SDK | Zendesk SDK: JWT Authentication — tie support sessions to Fasset identity. Under HOR-175 epic. |
| HOR-571 | To Do | Radar/Zendesk_SDK | Zendesk SDK: Push Notifications for agent replies (FCM + APNs). Under HOR-175 epic. |
| HOR-572 | To Do | Radar/Zendesk_SDK | Zendesk SDK: Remove legacy WebView integration. Blocked until 569-571 are live. Under HOR-175 epic. |
| (untracked) | — | Global_Expansion | Propose 5 additional countries to Gitesh. |
| (untracked) | — | Global_Expansion | Nigeria T&C update for Rain — unblocks card KYC re-enablement. |
| (untracked) | — | Global_Expansion | Altof's Product Coverage Confluence page — awaiting PM team confirmation. |
| (untracked) | — | Global_Expansion | Cross-reference IBAN-disabled (33) vs Keel restricted vs Due 21 prohibited — 10 Keel-restricted not IBAN-disabled. |
| (untracked) | — | Radar/Card_Strategy | Card operator pricing comparison (Ibrahim/Rafi ask). |
| (untracked) | — | Radar/Card_Strategy | Card issuance payment friction — payment gateway vs USDT/wallet balance (Kazi). |
| HOR-552 | to-delete | Travel_Rule | PRD: Travel Rule for High-value Crypto Receipts (≥$20K) Satoshi Verification. Summary changed to "delete" — awaiting admin deletion. PRD migrated to Confluence. |
| HOR-479 | In Progress | Travel_Rule | Implementation of UAE Virtual Assets Travel Rule Requirements (>$1K declaration flow). Ubaid Rajput. |
| HOR-565 | In Progress | Travel_Rule | Travel Rule Tier 1: UAE Deposit Self-Declaration ($1K-$20K). Ubaid Rajput. |
| HOR-566 | In Progress | Travel_Rule | Travel Rule Tier 2: UAE High-Value Deposit Verification (>=20K). Ubaid Rajput. |
| HOR-567 | In Progress | Travel_Rule | Travel Rule Verified Wallet Store (Tier 2 dependency). Ubaid Rajput. |
| HOR-568 | To Do | Travel_Rule | Travel Rule CX Tooling for Tier 2 Escrow Management. Ubaid Rajput. |
| HOR-627 | To Do | Travel_Rule | [SAFE Phase 1] Integrate Basic Travel Rule Support with Notabene. Ubaid Rajput. Added May 13. |
| HOR-561 | QA | Global_USD_Account | IBAN promo code billing service integration (FexApp). Adnan Khan. |
| HOR-542 | QA | Global_USD_Account | IBAN promo code billing service integration (cash). Adnan Khan. |
| HOR-560 | QA | Global_USD_Account | IBAN promo code billing service integration (keel). Adnan Khan. |
| HOR-670 | QA | Global_USD_Account | Slack alert when non-USD deposit lands in Keel IBAN. Fazal E Rabbi. New — moved to QA May 18. |
| HOR-563 | QA | Radar/Card_Strategy | NI card buy — correctly handle non-success webhooks. Inayat Ullah. |
| HOR-663 | In Progress | Radar/Card_Strategy | Card billing address: new card creation flow. Inayat Ullah. Created May 13. |
| HOR-664 | In Progress | Radar/Card_Strategy | Card billing address: existing users. Inayat Ullah. Created May 13. |
| (untracked) | — | Radar/Business_Banking | Confirm Keel permission status for corporate entities. |
| (untracked) | — | Radar/Business_Banking | Define IBAN assignment requirements for corporate accounts. |
| (untracked) | — | Radar/Business_Banking | Business Banking Website 1st iteration — Markup.io review (Abigail, Hamza). |
| HOR-620 | To Do | Global_USD_Account | Shifting to KYC reliance model with Due. Muhammad Zain. New May 11. |
| HOR-456 | QA | Global_USD_Account | Enable ACH Transfers (Receive & Send USD) via Due (Zain). Major milestone — in QA as of May 13. |
| (untracked) | — | Radar/WorldPay_PSP | Top-10 country market analysis for WorldPay underwriting (Nawaz ask) — pending framing clarification. |

**Statement of Account note:** Epic HOR-488 and its 5 active stories have never been prioritized into a sprint and remain unassigned. PRD has been through review rounds with Ibrahim. Carry forward to next sprint planning. **NEW (May 7):** Bahrain regulator has requested a consolidated account statement by June 15, flagged as a ~2-week engineering lift. Saad + Zane to manage regulator comms on timeline.

**Recently archived (Done in Jira):**
- HOR-618 — Enable USD IBAN for 19 countries with no Keel restriction (Global_USD_Account). Done May 20. Countries: Argentina, Bolivia, Brazil, Chile, China, Colombia, Ecuador, Guyana, Kuwait, Nepal, Nigeria, Oman, Paraguay, Peru, Qatar, Saudi Arabia, Suriname, Uruguay.
- HOR-461 — Account Statement Keel branding & regulatory clarification (01_Global_USD_Account).
- HOR-470 — T&C disclaimer text Frost → Keel rebrand (01_Global_USD_Account).
- HOR-532 — Sync legal name update FEX → Keel (01_Global_USD_Account). Completed this week.
- HOR-473 — Reference Field on USD Send Money flow (Zain). Done as of May 10.
- HOR-546 — Send Money beneficiary search empty state copy (Irfan). Done as of May 10.
- HOR-562 — Marketing reward disbursement — $5 FIGB credit (Adnan Khan). Done as of May 8.

**Marked `to-delete` in Jira (awaiting admin deletion — Hamis lacks delete permission):**
- Junk: F40-708, HOR-535, FO-1462, HOR-387.
- Superseded SoA stories (also labelled `superseded`): HOR-490, HOR-491, HOR-492, HOR-494, HOR-495, HOR-497, HOR-498, HOR-499, HOR-501, HOR-502, HOR-503.

## Company Context Update

- **$51M Series B raised (May 15, 2026).** Announced publicly. Keel team congratulated on #fasset-keel. Customer email went out. Company-wide milestone.

## Cross-Cutting Archive

Items not tied to any single project workspace.

- Staking API evaluation — team recommended Kiln.fi over P2P.org.
- Claude Onboarding Guide — internal doc for Fasset colleagues distinguishing Claude Code (technical) vs Cowork (non-technical).

## About Me
- **Name:** Hamis Mahmood
- **Role:** Senior Product Manager at Fasset
- **Email:** hamis.mahmood@fasset.com
- **Based in:** Pakistan (PKT timezone, UTC+5)
- **What Fasset is:** A Shariah-compliant digital assets super app and crypto exchange dual-headquartered in Dubai and Jakarta. Offers trading, USD IBANs, the Fasset Card (prepaid), staking, and fiat on/off ramps. Serves 500,000+ retail customers across 125+ countries with $6B+ in annualised transaction volume. Institutional client base grew 10x in 2025. Mission: financial inclusion for the pan-Islamic belt (Asia, Africa, Middle East). Licensed and operating in UAE, Bahrain, Indonesia, and Labuan (Malaysia), with Fasset Labuan Limited as the default legal entity for other jurisdictions.

## Fasset Regulatory Footprint

1. **UAE (Dubai)** — Fasset FZE is licensed as a Broker-Dealer by the Virtual Assets Regulatory Authority (VARA), Dubai. License No. VL/23/07/002.
2. **Bahrain** — Fasset Financial Services W.L.L. is a Category 3 Crypto-Asset Licensee regulated by the Central Bank of Bahrain.
3. **Labuan (Malaysia)** — Fasset Labuan Limited is licensed by the Labuan Financial Services Authority (LFSA). Money-Broking Licence No. MB/21/0070; Credit Token Licence No. CT/21/0012; Payment System Approval No. LFSA.400-14/LFA/MB/117/2021.
4. **Indonesia** — PT Gerbang Aset Digital is licensed by Bappebti (Commodity Futures Trading Regulatory Agency) by virtue of Bappebti Decree No. 005/BAPPEBTI/CPFAK/04/2023.

## Retail Product Framework (CMSBC-BFS-OOO)

C — Crypto · M — Metals (tokenized gold) · S — Stocks (tokenized US equities) · B — Bonds (Sukuk) · C — Currencies (stablecoins/FX) · B — Bundles · F — Financing (Shariah-compliant collateralised lending) · S — Staking · O — Onboarding (KYC) · O — On-ramp · O — Off-ramp

Tech: **Own** — Ethereum L2 on Arbitrum for settling regulated RWAs on-chain. Visa-linked crypto debit card with Apple Pay / Google Pay support. React Native front-end mobile stack.

## Tools & Infrastructure
- **Google Workspace** — Gmail, Calendar, Drive, Docs, Sheets, Slides. Primary communication and document platform. MCP integrations set up via Cowork-based daily briefing.
- **Slack** — Key channels: #productsquad (private), #fasset-product-dev, #fasset-keel, #ask-dataengineering, #credit--product, #global-expansion, #tech-meets-fex.
- **Jira** — Projects: **Horizon (HOR)** for current product work, **FASSET-4.0 (F40)** for the main app. Atlassian site: fasset.atlassian.net.
- **Confluence** — Space: PF (Product - Fasset). PRDs, BRDs, and product coverage docs live here.
- **Figma** — Design files and design system. Siddique is the primary designer. "Fasset App 4.5" is the active design file.
- **Mixpanel** — Event tracking/analytics. Not yet connected via MCP.
- **Miro** — Used for strategy boards (e.g., Global Expansion).
- **Zendesk** — Customer support. Suite Professional plan. Currently WebView-based, migrating to native SDK.
- **Metabase** — Analytics dashboards (KYC drop-off, P2P, IBAN promo tracking, etc.).
- **Claude (Anthropic)** — Daily driver for PM work. Use Cowork for daily briefings (Calendar + Gmail + Slack), drafting PRDs, vendor docs, internal proposals. Org on business plan via Richard Germie.

## Key Vendors & Partners

Source of truth: one file per vendor in `pm-partners/vendors/`.

| Vendor | Relationship | Status |
| :---- | :---- | :---- |
| Keel | Primary IBAN provider | active |
| Due | US-IBAN + local payouts | onboarding |
| Rain | Card issuer | active |
| Jumio | KYC (current) | active |
| Sumsub | KYC replacement (planned) | exploring |
| ComplyAdvantage | AML/screening | active |
| Dinari | Tokenized stocks | active |
| Lean | Card integration | active |
| Wetarseel | OTP onboarding (PK) | paused |
| Tether | XAUT gold rewards | active |
| Bridge / Reap | Alt card partners | exploring |
| Kiln.fi | Staking (recommended) | exploring |
| Notabene | Travel Rule | active |
| Fireblocks | Custody / wallets | active |

## Recurring Meetings & Cadence

Source of truth: one file per meeting in `context/Meetings/`. Index: `context/MEETINGS.md`.

| Meeting | Cadence | Time | Organizer | Status |
| :---- | :---- | :---- | :---- | :---- |
| Product Daily Standup | daily | 19:00 PKT | Zane (interim) | active |
| IBAN Standup | daily | 12:00 PKT | Taha Farooq | active |
| Sprint Planning | biweekly | Fri 16:00 PKT | Zara Adalat | active |
| CX & Product Feedback | weekly | Fri 17:00 PKT | Nashit Syed | active |

**Sprint cycle:** Sprint 10 (started May 8). Sprint #10 Planning ran May 8 at 17:00 PKT.
