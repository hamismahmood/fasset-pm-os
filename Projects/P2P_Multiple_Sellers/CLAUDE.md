# CLAUDE.md — P2P Multiple Sellers

Project-specific behavioral rules go here. Cross-cutting rules live in the root `CLAUDE.md`. Project facts live in `MEMORY.md` (this folder).

## Seller Model

P2P Express sellers run shift-based availability, not 24/7. Different markets have different sellers. The feature being built is seller selection — wiring the existing "Change" button to a real list of available sellers. Auto-assignment to the highest-completion-rate seller should always be preserved as the default path.

## Scope Guard

v1 covers the **buy flow only** (PKR → USDT). The sell side is out of scope. Do not speculate about sell-side changes without flagging the scope boundary.

## Fraud Sensitivity

P2P is the highest-fraud surface on the platform. Any edge case involving payment state (sent, not sent, disputed) should be treated conservatively — default to blocking rather than allowing if uncertain.
