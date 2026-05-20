---
type: vendor
name: Keel
website: https://keel.money
status: active
relationship: primary-iban-provider
primary_contact: Alexander Meijer
contract_status: signed
slack_channel: "#fasset-keel"
last_verified: 2026-05-04
tags: [iban, swift, gbp-bic, emi, fca]
---

## What they do
GBP BIC-code-based USD IBANs that allow users to receive USD into their account, then send forward or off-ramp. Fasset operates as a **distributor of the regulated EMI entity (KE, formerly Frost)**. Risk Appetite Statement v5.2 defines prohibited/restricted countries.

## Coverage
- Receives via SWIFT (no ACH support).
- Send via SWIFT — UAE corridor requires `paymentPurpose.proprietary` populated with 3-char UAE POP code (16 codes mapped via HOR-481).
- Push ongoing for **US-based USD accounts** (would unlock ACH).

## Contacts
- **Alexander Meijer** — primary POC (Account Manager). T&C updates, account setup.
- **Lukasz Kosidlo / 4rtsem** — engineering in #fasset-keel, webhook + transaction debugging.
- **Adam Smith, Rocco Limongelli** — compliance / Travel Rule walkthroughs.

## Open issues
- Webhook retry / stuck transaction issue — operational loop.
- AC accounts mistakenly registered as SWIFT — validation needed.
- Liabilities report (Hamis owes Nawaz/Ralf) — Sprint 9 scope.
- Ralf viewer/read-only access to Keel backoffice — pending Hamis + Taha sync.
- Keel pricing + signed contracts — Hamis owes Ibrahim before May 14 KT.

## History
- Frost → KE rebrand. T&C updated. Account statements clarify KE relationship while excluding ClearBank branding; FCA registration number permitted for transparency.
- Hamis took over relationship from Tahir.
- Apr 16 Keel meeting (Alexander Meijer): https://mail.google.com/mail/u/0/#all/19d95c23c800ba66
