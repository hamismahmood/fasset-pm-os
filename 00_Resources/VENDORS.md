# VENDORS.md (Index)
*Derived index. Source of truth = individual files in `00_Resources/Vendors/`. See `SCHEMA.md` for conventions.*
*Last regenerated: 2026-05-06 (evening sync)*

| Vendor | Relationship | Status | Contract | File |
|:--|:--|:--|:--|:--|
| Keel | Primary IBAN provider (USD via GBP-BIC EMI) | active | signed | [keel.md](Vendors/keel.md) |
| Due | US-IBAN + local payouts (ACH unlocking) | onboarding | signed | [due.md](Vendors/due.md) |
| Rain | Card issuer (Fasset Card) | active | signed | [rain.md](Vendors/rain.md) |
| Jumio | KYC (current, migrating away) | active | signed | [jumio.md](Vendors/jumio.md) |
| Sumsub | KYC replacement (planned) | exploring | unsigned | [sumsub.md](Vendors/sumsub.md) |
| ComplyAdvantage | AML/screening | active | signed | [complyadvantage.md](Vendors/complyadvantage.md) |
| Dinari | Tokenized US stocks | active | signed | [dinari.md](Vendors/dinari.md) |
| Lean | Card integration | active | signed | [lean.md](Vendors/lean.md) |
| Wetarseel | OTP onboarding (PK) | paused | unsigned | [wetarseel.md](Vendors/wetarseel.md) |
| Tether | XAUT gold token rewards / branded cards | active | signed | [tether.md](Vendors/tether.md) |
| Bridge | Alt card partner (dropped May 4) | paused | negotiating | [bridge.md](Vendors/bridge.md) |
| Reap | Alt card partner | exploring | negotiating | [reap.md](Vendors/reap.md) |
| Kiln.fi | Staking provider (recommended) | exploring | unsigned | [kiln-fi.md](Vendors/kiln-fi.md) |
| Notabene | Travel Rule | active | signed | [notabene.md](Vendors/notabene.md) |
| Fireblocks | Custody / wallets | active | signed | [fireblocks.md](Vendors/fireblocks.md) |

## Watching / mentioned (no file yet)
- **P2P.org** — staking, lost to Kiln.fi.
- **Veriff** — KYC alternative suggested by Kazi.
- **Shufti** — KYC outreach, forwarded by Tahir.
- **WalaPay** — cheaper local payout rates, investigate (KT item).
- **Thunes** — pricing email to review (KT item).
- **NI (Network International)** — card-based on-ramp (Kazi PRD this sprint).
- **Mesh** — ComplyAdvantage integration in progress.
