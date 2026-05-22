---
type: project
name: Global USD Account
status: active
priority: critical
owner: Hamis Mahmood
related: [Keel, Due]
last_verified: 2026-05-18
tags: [iban, money-movement, swift, ach, primary-scope]
---

# MEMORY.md — Global USD Account

Banking IBAN scope inherited from Tahir Qureshi (departed). Covers Keel and Due partnerships, money movement squad, USD virtual accounts, and local payouts.

## Scope

- **Keel**: GBP BIC-coded IBANs that allow users to receive USD into their account, send forward, or off-ramp into various countries. Fasset operates as a distributor of the regulated EMI entity (KE, formerly Frost). Risk Appetite Statement v5.2 defines prohibited/restricted countries.
- **Due**: US-based IBANs unlocking ACH receiving and US local payouts. Same standard KYC works (no additional KYC unlike Keel for certain corridors). 21 prohibited countries. Named USD ACH/Wire/RTP accounts in customer's name. Fiat transfer pricing negotiated per deal, not published.
- Money movement squad emissions and the broader IBAN roadmap.

## Current State

- **Due contract — AML fee resolved (May 4).** Final per-user pricing landed at **$0.50/user Y1, $0.35/user Y2+**, with a Due-side API to deactivate dormant users so the fee stops accruing. Zane took the call with Vasco; no movement on price (EU compliance, 10-year retention, non-delegable). Saad recommended acceptance. Zainab proceeding with signature via Zeynep. Other Annex II / PSA pushback points (PEP exclusions, product instability notice, audit burdens, uncapped reserves) still open but not blocking signature. See "Open Questions / Negotiation Context" below.
- **Production blocker:** Taha and the IBAN team are waiting on Annex II signature to resume production testing and unblock ACH connectivity for inbound and outbound volume.
- **PKR payouts launched** for internal testing April 7, build pushed to all users.
- **Currency expansion roadmap:** BDT, IDR, SGD, KES.
- **Branding transition:** Frost → KE. T&Cs being updated.
- **Push for US-based USD accounts** from Keel (via Alexander Meijer).
- **ACH form automation** in progress to reduce user friction.

## Open Questions / Negotiation Context

The Due contract is structured as a **reliance model**: Due trusts Fasset's compliance SOPs rather than running its own diligence. Ibrahim's ask to Hamis (Apr 29): ascertain whether the reliance-model pricing is fair and scales reasonably with user growth, back-of-envelope is fine, then sign and send back.

### Pakistan pricing (first payout market)

Ibrahim's verdict (Apr 30, after reviewing the Transaction Pricing PDF):
- Overall pricing **reasonable for sample corridors** like Pakistan, in-line with competitor (Bridge), with better coverage.
- Mobile wallet rails (JazzCash, EasyPaisa) more expensive but acceptable since default methods are fine.
- 1-year lock-in is fine, risk discussed with Raafi and approved.
- Dormant user tax (separate point) is troublesome and should only apply to active users.

Hamis still owes:
- Plot the contract for scale (per-customer cost feasibility, fee spread to users).
- Sync with Malik Danish on Pakistan launch pricing strategy.
- Call Danish on the internal pricing structure.
- Loop in Saad and Zane for alignment before sending to Nawaz for Daniel's signature.

### Annex II (Compliance Annex) — pushback points

1. **The "Dormant User Tax" — RESOLVED May 4.** Final landed at **$0.50/user Y1, $0.35/user Y2+**, with Due exposing an API to deactivate dormant users (the only lever Fasset controls — deactivate before the Y2 anniversary to avoid the renewal charge). Zane took the call with Vasco after Altof's ComplyAdvantage/Sumsub overlap argument failed to move the price over email. Vasco's reasoning: EU compliance is strict, Due must run own continuous monitoring and store records for 10 years — non-delegable under reliance model. Saad's call (May 4): "we should go with it. there is an opportunity cost to every day that goes by, and I want to also maintain a good relationship with Due." Zainab proceeding with signature.

2. **Blanket PEP & Family Exclusions.** Due currently bans all Politically Exposed Persons and their family/associates. Too restrictive for a growth-stage fintech. Pushback: shift from blanket exclusion to **Enhanced Due Diligence (EDD)** so we can still onboard high-value institutional or family-office clients.

3. **Product Instability — zero notice changes.** Due can change API data requirements or block entire jurisdictions at any time. Could break our UI/UX overnight or wipe out a market. Pushback: require **60 days' written notice** for any material API or restricted-country changes.

4. **Audit Burdens.** Forced to respond to audits within **5 business days** and may have to pay for external audits Due decides to commission. Pushback: extend response window to **15 days**, and Due pays for its own external auditors unless they find a material breach on our end.

### Platform Service Agreement (Main Agreement) — pushback points

1. **Asymmetric 1-Year Lock-In.** Due can terminate for convenience with 60 days' notice; Fasset is locked in for the full year. If we find a better partner in month 4, we remain on the hook for the **$3,000/month minimum** for the remaining 8–9 months. (Ibrahim accepted this as ok, discussed with Raafi.)
2. **Uncapped Cash Reserves.** Due can demand an uncapped "Risk Reserve" cash lockup at their sole discretion, tying up our operational capital. Raised by Zane, not yet pushed back externally.

### Tech-stack overlap (basis of the AML pushback)

Both Fasset and Due (via Sumsub) appear to use **ComplyAdvantage** for screening. Altof's argument: information can be passed via API rather than Due running redundant screening. To be confirmed with Due directly.

### Signing authority

Originally Ibrahim was the signatory; with his transition out, Zane is taking over. Hamis raised the contract with Nawaz on Apr 29 to coordinate Daniel's signature once review is complete.

### Documents in scope

- **Annex II (Compliance Annex)** — already sent to Daniel via DocuSign.
- **Annex I** — shared by Vasco Apr 29.
- **Main Agreement (Platform Service Agreement)** — shared by Vasco Apr 29.
- **Addendum to Platform Service Agreement** — shared earlier on Apr 22 thread.
- **Transaction Pricing PDF** ([CONFIDENTIAL] Fasset · Due · Transaction Pricing 20250829) — shared by Ibrahim Apr 30.

## Key Partner Contacts

| Partner | Contact | Role |
| :---- | :---- | :---- |
| Keel | Alexander Meijer | Primary POC, T&Cs, USD account setup, form requirements |
| Keel | Lukasz Kosidlo, 4rtsem | Engineering — webhook retries, transaction debugging (#fasset-keel) |
| Due | Alan, Vasco | Primary contacts |
| Due | sales@due.dev | Sales |

## Active Tasks

- **Enable ACH Transfers via Due** (HOR-456, **QA**, Zain). Major milestone — US IBANs unlocking ACH receiving and local payouts. In QA as of May 13.
- **UAE Purpose of Payment Codes** (HOR-481, **QA**, Fazal). Keel SWIFT transfers to UAE need `paymentPurpose.proprietary` populated with the correct 3-char UAE POP code. 16 purpose codes mapped. Two blocked payment incidents (Dec 2025, Apr 2026) drove this.
- **USD IBAN — Downloadable transaction confirmation PDF** (HOR-537, **QA**, Zain). Originally raised by Tahreem. Moved to QA May 21.
- **IBAN promo code — cashApp, keel, FexApp** (HOR-542, HOR-560, HOR-561, **QA**, Adnan Khan). All three billing service integrations in QA.
- **Slack alert when non-USD deposit lands in Keel IBAN** (HOR-670, **QA**, Fazal E Rabbi). New ticket. Moved to QA May 18.
- **KYC reliance model with Due** (HOR-620, **In Progress**, Zain). Shifting to reliance model. Moved to In Progress May 21.
- **User pending IBAN-to-USDT internal transfer worriness.** Assigned to Hamis from #productsquad bug roundup. (Untracked in Jira.)

## Live Operational Issues

- Webhook failures causing stuck transactions. Keel retries with exponential backoff, but some older webhooks needed manual retry.
- Some AC accounts mistakenly registered as SWIFT accounts. Validation needed.
- **Keel/ClearBank SWIFT data via API unavailable (May 14).** Alexander Meijer confirmed ClearBank cannot provide SWIFT transaction data via API currently. Keel escalating internally. Impacts any downstream feature that requires SWIFT details programmatically.
- **Multi-currency IBAN Euro reception (May 15, confirmed by Keel Pawel):** Multi-currency IBAN can receive Euro by both SWIFT and SEPA. Rail choice is made at the sender's end.

## Reference Docs (in this folder)

- `Partner Docs/Keel/KEEL_API_Documentation.md`
- `Partner Docs/Keel/keel_openapi.json`
- `Partner Docs/Due/due_API_Documentation.md`
- `Partner Docs/Due/Contracts/` — Due contract documents (Annex I, Annex II, Main Agreement, Addendum, Transaction Pricing). See the README in that folder for what to drop where.

## Archive

- **HOR-618** — Enable USD IBAN for 19 countries with no Keel restriction (Done, May 20). Countries enabled: Argentina, Bolivia, Brazil, Chile, China, Colombia, Ecuador, Guyana, Kuwait, Nepal, Nigeria, Oman, Paraguay, Peru, Qatar, Saudi Arabia, Suriname, Uruguay. Assigned Zain.
- **HOR-461** — Account Statement Keel branding & regulatory clarification (Done).
- **HOR-470** — T&C disclaimer text on Activate USD Account screen, Frost → Keel rebrand (Done, Irfan).
- **HOR-532** — Sync legal name update from FEX to Keel automatically (Done, Adnan).
