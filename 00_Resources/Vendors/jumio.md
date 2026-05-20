---
type: vendor
name: Jumio
status: active
relationship: kyc-provider
primary_contact: Altof Naufal (internal owner)
contract_status: signed
last_verified: 2026-05-04
tags: [kyc, docproof, iban-onboarding, migration-planned]
---

## What they do
KYC provider — DocProof for IBAN onboarding. Currently used for advanced KYC across Fasset.

## Status
- **Migration to Sumsub planned** — 3-4 month phased rollout (Altof owns context).
- Both systems will run temporarily during migration to avoid forcing users to redo KYC.
- KYC Reliance Model: Keel using Jumio data once Due-side changes complete.

## Open issues
- Investigate Jumio fix with Nashit / Alexander (KT item from Tahir).
- PoA success rate only 20-30% (missing identity document pictures, >90 day docs rejected).
- Open operational tickets under review (as of May 4).

## History
- 2026-05-04 - **Laminated IDs now accepted** for Bangladesh and India. Previously a major rejection cause. Eases onboarding and increases success rates.
