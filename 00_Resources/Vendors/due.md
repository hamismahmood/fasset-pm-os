---
type: vendor
name: Due
website: https://due.network
status: onboarding
relationship: us-iban-and-local-payouts
primary_contact: Alan Poyatos
contract_status: signed
last_verified: 2026-05-06
tags: [iban, ach, us-based, local-payouts, contract-pushback]
---

## What they do
US-based USD IBANs unlocking **ACH receiving** and **US local payouts** — a major differentiator over Keel. Same standard KYC works (no additional KYC unlike Keel for certain corridors). 21 prohibited countries.

## Contacts
- **Alan Poyatos** (alan.poyatos@due.network) — primary POC.
- **Vasco** (vasco@due.network) — sales / commercial.
- **Rob** (rob@due.network) — technical contact.
- Sales: sales@due.dev.

## Coverage
- Local payouts: PKR launched Apr 7 (internal testing → all users). Expanded scope: BDD, IDR, S, KES.
- US ACH receiving — primary attraction.

## Final per-user pricing (landed May 4)

After Zane's call with Vasco (May 4), the AML maintenance fee is locked:
- **Year 1: $0.50/user/year** — flat, all onboarded users.
- **Year 2+: $0.35/user/year** — for users still onboarded.
- **Mitigation:** Due will expose an API to deactivate dormant users so the fee stops accruing. Only lever Fasset controls.

Vasco's reasoning: EU compliance is strict, Due must run own continuous AML monitoring and store records for 10 years — non-delegable under reliance model. ComplyAdvantage overlap argument did not move the price. Saad (May 4) recommended accepting given opportunity cost; Zane made the final call.

Zainab to proceed with signature on the other chat.

## Contract pushbacks (resolved)
Annex II signed by Zane on May 5 and sent to Due. Production unblocked. Source docs in `01_Global_USD_Account/Partner Docs/Due/Contracts/`.

- **Dormant User Tax ($0.50/year per user):** ✅ **Resolved May 4** at $0.50 Y1 / $0.35 Y2+ with deactivation API. See "Final per-user pricing" above.
- **Blanket PEP & family exclusion:** Push for EDD instead of blanket ban.
- **Product instability:** Push for 60 days' written notice on API or country changes.
- **Audit burdens:** 5-day → 15-day window; Due pays for own external auditors absent material breach.
- **Uncapped cash reserves:** Zane raised internally, not yet pushed externally.
- **1-year lock-in:** Ibrahim says OK per Raafi.

## Action items
- Plot the contract for scale (per-customer cost feasibility, fee spread). Ibrahim's Apr 29 ask.
- Call Malik Danish on PK launch pricing.
- Confirm ComplyAdvantage overlap directly with Due.
- Saad + Zane sync before sending to Nawaz for Daniel's signature.

## History
- Hamis took over relationship from Tahir.
- Apr 28 — Due diligence questionnaire thread (Altof, Yazan, Zane, Vasco).
- Apr 29 — Vasco resent Annex II + PSA Addendum (already sent to Daniel via Docusign).
- May 4 — Vasco rejected AML fee waiver, offered $0.35 after 12 months. Altof pushed ComplyAdvantage/Sumsub overlap angle; Vasco still declined.
- May 4 — Zane took the call with Vasco. Outcome: no movement. EU strict, own continuous monitoring, 10-year retention, non-delegable. Mitigation = deactivation API for dormants. Saad recommended acceptance for relationship + opportunity cost. **Final landed: $0.50 Y1 / $0.35 Y2+.** Zainab to proceed with signature.
- May 4 — Approved as mid-term IBAN payout solution in Product Standup. Zane to approve contract via Zeynep.
- May 4 — Side threads opened by Zane: Due has APAC on/off-ramp (overlap check with Transak via Rafiza — Altof clarified May 5 they're different use cases: Transak = funding gateway, Due = IBAN payouts/settlement) and US on/off-ramp (Zane to explore with Karim).
- May 5 — Zane signed Annex II and sent to Vasco/Alan. Contract execution complete. Due DDQ thread also active (TIN for EEA residents requirement noted by Alan).
