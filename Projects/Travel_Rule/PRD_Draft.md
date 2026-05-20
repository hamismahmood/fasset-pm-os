# PRD — Travel Rule for Crypto Receipts (UAE)

*Draft v2, 2026-05-05. Author: Hamis Mahmood. For review by Salman Khan, Nashit Syed, Taha Farooq, Ibrahim Ali, Zane Motiwala.*

*Supersedes Draft v1 (≥$20K only). Now covers full tiered deposit compliance: declaration for $1K–$20K, declaration + Satoshi test for ≥$20K.*

---

## 1. Background

VARA Travel Rule requires VASPs to collect, verify, and retain originator and beneficiary information for virtual asset transfers. For unhosted wallets and high-value inbound transfers, enhanced due diligence is required, including proof of wallet control where applicable.

**Current state of enforcement:**

- **Withdrawals:** Self-declaration flow is live. Users sending out crypto provide originator info above the threshold.
- **Deposits:** No enforcement today. A user can receive any amount with no declaration captured. This is the compliance gap.

This PRD specifies the deposit-side controls in two tiers:

| Tier | Range | Treatment |
| :---- | :---- | :---- |
| Tier 1 | $1,000 to $19,999.99 | In-app self-declaration of source and sender. Designs exist (mirror the live withdrawal flow). Tracked under HOR-479. |
| Tier 2 | ≥ $20,000 | In-app self-declaration plus a CX-administered Satoshi test to prove control of the sending wallet. Net new. |

Both tiers fall under epic FO-1022 (Notabene Travel Rule).

## 2. Objective

Bring deposit-side handling into VARA compliance by:

- Holding deposits above $1,000 in escrow until originator information is captured.
- For ≥ $20,000, additionally verifying that the user controls the source wallet via a Satoshi test.
- Memoizing verified wallets so repeat senders skip re-verification at any tier.
- Reusing the live withdrawal self-declaration UI patterns to keep the deposit flow consistent for users who have seen it before.

## 3. Scope

| Dimension | v1 |
| :---- | :---- |
| Jurisdiction | UAE users only |
| Asset coverage | All crypto receipts |
| Threshold logic | Per-transaction, USD-equivalent at time of receipt |
| Aggregation | None in v1 |
| Direction | Receipts only. Outbound is constrained separately by an existing $20,000 hard send limit. |

**Tier matrix:**

| Receipt amount | Treatment | Implementation owner |
| :---- | :---- | :---- |
| < $1,000 | No action, credit normally | n/a |
| $1,000 to $19,999.99 | In-app declaration | HOR-479 (Sprint 9, Taha) |
| ≥ $20,000 from unverified source | Declaration + Satoshi test | New ticket under FO-1022 |
| ≥ $20,000 from verified source | Credit normally, no friction | Verified-wallet store covers this |

## 4. User Flow

### 4.0 Detection and routing

1. Fireblocks confirms inbound tx.
2. System computes USD value at time of receipt.
3. Routing:
   - **< $1,000:** Deposit credits normally. End of flow.
   - **$1,000 to $19,999.99:** Enter **Tier 1** (4.1).
   - **≥ $20,000, source address verified:** Deposit credits normally. No escrow, no banner, no chat. End of flow.
   - **≥ $20,000, source address not verified:** Enter **Tier 2** (4.2).

### 4.1 Tier 1 — Self-declaration ($1,000 to $19,999.99)

**State on entry:** Deposit placed on hold. Funds not credited to available balance. State = *On Hold — Verification Required*.

**Notification:**
- Push: *"Your deposit is on hold. Tap to verify."*
- In-app banner on home, plus a tagged entry in transaction history.

**Screens (reuses the existing self-declaration design pattern):**

1. **Source of deposit.** *"Where did this deposit come from?"* Options: Exchange / platform, Private wallet.
2. **Exchange selection** (if applicable). Searchable dropdown of supported exchanges.
3. **Sender details.** First Name, Last Name, Country of Residence. Supporting copy explains the compliance requirement.
4. **Confirmation.** *"Verification successful."* Deposit moves to *Processing*, then *Completed*, and funds credit to available balance.

Designs: Fasset App 4.5, node `29889:271732`.

**No CX involvement.** The tier completes entirely on the user's side once they submit the form.

### 4.2 Tier 2 — Declaration + Satoshi test (≥ $20,000)

**State on entry:** Deposit placed in escrow. State = *On Hold — Verification Required*.

**Step 1: Notification.** Same banner and push as Tier 1, with a different deeplink target.

**Step 2: In-app declaration.** Same four screens as Tier 1 (Source → Exchange → Sender → Confirmation). Submitted data is attached to the deposit record. After submit, state moves to *Awaiting Verification* and the app opens the Zendesk Web Widget.

**Step 3: Zendesk handoff (WebView).** Via the Zendesk Web Widget API, the app prefills:

- **Identity:** user ID, name, email.
- **Custom fields / tags:** `deposit_id`, `tx_hash`, `source_address`, `asset`, `chain`, `usd_amount`, plus tag `travel_rule_20k`.
- **Declared sender info:** name + country from the declaration step.

User lands in a chat thread with all context attached before they type anything. No repetition required.

**Step 4: CX workflow.** Agent picks up the chat (workflow in section 5). State = *Awaiting Satoshi*.

**Step 5: Satoshi test.** CX issues:

> *"To complete verification, please send approximately $10 worth of [ASSET] from the same wallet that sent your original deposit, to [Fasset address]. Anything close to $10 works. The exact amount can shift slightly with price. You have 7 days. Once we receive it, your deposit will be credited."*

User sends ~$10 of the same asset from the same source address.

Fireblocks watcher matches against:
- Source address = original source address
- USD amount in tolerance band $9.00–$11.00 at time of detection
- Received within 7 days of CX issuing the request

**On match:**
- Source address added to user's verified-wallet store.
- Escrow released. Original deposit + Satoshi amount credited atomically.
- CX confirms in chat and closes.

**On 7-day timeout / wrong amount / wrong source / wrong chain:**
- CX makes one outreach attempt during the window.
- After 7 days with no resolution, funds returned to source via Fireblocks.
- User notified: *"We were unable to verify your deposit. Funds have been returned to the sending wallet."*
- State = *Returned*.

### 4.3 Repeat sender (verified wallet)

If the source address is already in the user's verified-wallet store at step 4.0, the deposit credits normally regardless of amount. No escrow, no banner, no chat, no CX involvement.

**Cross-direction memoization:** Verified-wallet status is set by *either* direction of travel rule completion — deposit or withdrawal. If a user has already completed a travel rule submission for a given address on the withdrawal side, that address is in their verified-wallet store and any inbound deposit from it auto-credits with no friction. The same applies in reverse: an address verified via the deposit Satoshi test is treated as verified for outbound purposes. One verification per address, regardless of direction.

## 5. CX Workflow (Tier 2 only)

Tier 1 has no CX touchpoint.

Provided to CX as a Zendesk workflow doc + macros. Owned by Nashit, with training run by Ralf Jayaprakash.

Verified-wallet deposits never reach CX. The system auto-credits and the workflow below applies only to unverified-wallet receipts at ≥ $20K.

**Trigger:** chat opens with conversation tag `travel_rule_20k`.

**Step 1 — Verify context.** Confirm the prefilled fields (`source_address`, `asset`, `chain`, `usd_amount`, declared sender info) are present. If missing, escalate to engineering.

**Step 2 — Issue Satoshi test.**
- Fire macro `satoshi_test_request` (copy in 4.2 step 5).
- Set chat status to "Awaiting Satoshi."
- Wait for Fireblocks watcher signal or 7-day timeout.

**Step 3 — On watcher match:**
- Fire macro `satoshi_received_credit`.
- Confirm wallet now in verified store.
- Use internal tool to release escrow.
- Close chat.

**Step 4 — On 7-day timeout:**
- Fire macro `verification_failed_return`.
- Trigger fund-return via Fireblocks (engineering tool).
- Close chat.

**Macros to be authored** (drafts in this PRD, final copy with Ameera before launch):
- `satoshi_test_request`
- `satoshi_received_credit`
- `verification_failed_return`

## 6. Deposit States

| State | Tier | Description |
| :---- | :---- | :---- |
| Pending | All | Tx confirmed on-chain, system processing |
| On Hold — Verification Required | 1, 2 | Awaiting user action on declaration |
| Processing | 1 | Tier 1 declaration submitted, funds being credited |
| Awaiting Verification | 2 | Declaration submitted, in CX chat |
| Awaiting Satoshi | 2 | CX requested test, watching for $10 match |
| Releasing | 2 | Match received, releasing escrow |
| Completed | All | Funds credited |
| Returned | 2 | Verification failed, funds returned to source |

## 7. Verified Wallet Store

Engineering owns implementation. PRD requirements:

- Scoped per user × source address. Chain-agnostic. One Satoshi proves control of the address; subsequent deposits from that address on any chain auto-credit.
- Verified status is set by either direction of travel rule completion — deposit Satoshi test or withdrawal self-declaration. Cross-direction: an address verified via withdrawal is treated as verified for inbound deposits, and vice versa.
- Verified status applies only to Tier 2 routing (≥ $20K). Tier 1 declarations are not memoized in v1.
- No expiry. Wallet remains verified until manually revoked by compliance.
- Audit log retained per VARA requirements.

## 8. Notifications

| Event | Channel | Copy direction |
| :---- | :---- | :---- |
| Hold triggered (any tier) | Push + in-app banner | "Deposit on hold. Tap to verify." |
| Tier 1 declaration accepted | Push + in-app | "Deposit confirmed. Funds available." |
| Satoshi test issued | Zendesk chat (CX-driven) | See macro 4.2 step 5 |
| Tier 2 verification successful | Push + in-app | "Deposit confirmed. Funds available." |
| Tier 2 verification failed / return | Push + in-app | "Could not verify deposit. Funds returned to sender." |

Final copy reviewed with Ameera before launch.

## 9. Edge Cases

- **User abandons declaration form (either tier).** Deposit stays in *On Hold — Verification Required* indefinitely. User can resume via banner. No auto-return for Tier 1; Tier 2 only auto-returns after the Satoshi 7-day timer expires post-CX issuance.
- **User abandons mid-Satoshi.** 7-day timer runs from CX issuance regardless of user activity. Times out into return path.
- **Price slippage on Satoshi.** Tolerance band $9.00–$11.00 USD-equivalent at time of detection.
- **User sends Satoshi from a different wallet.** Watcher does not match. CX flags and reissues instruction.
- **Multiple ≥ $20K deposits from same unverified wallet.** First triggers Satoshi. Subsequent stack in *On Hold*. Single Satoshi success unlocks all of them.
- **Repeat Satoshi from same wallet.** Idempotent. Wallet stays verified.
- **Source wallet ownership change** (e.g., compromised exchange address). Out of v1 scope. Compliance can manually revoke verification.
- **Deposit lands at boundary** (e.g., $999.50 → $1,000.10 due to price flux during confirmation). USD value is fixed at time of Fireblocks confirmation. No re-routing.
- **Deposit jumps the tier** (declaration submitted at $19,500, but USD value at confirmation is $20,100). Routes by the *amount at time of receipt*. If the lookup pushes it to Tier 2, the user is asked to continue into the CX flow rather than auto-crediting on Tier 1.

## 10. Dependencies

- Price conversion service for USD-equivalent calc (shared between tiers).
- Fireblocks: escrow state + watcher tuned to source address + asset + chain + amount range + window (Tier 2).
- Zendesk Web Widget API: prefill identity, custom fields, tags, declared sender info (Tier 2).
- Verified-wallet store (engineering build, Tier 2).
- Self-declaration screens (designs in Fasset App 4.5, node `29889:271732`; UI patterns reused from live withdrawal flow).
- Internal tool for CX to release escrow / trigger fund-return (Tier 2).
- CX team training (Ralf Jayaprakash) for Tier 2.
- Final macro copy (Ameera review) for Tier 2.

## 11. Stakeholders

| Role | Owner |
| :---- | :---- |
| PM | Hamis Mahmood |
| Engineering — Tier 1 (declaration) | Taha Farooq (HOR-479) |
| Engineering — Tier 2 (Notabene + Fireblocks + Satoshi) | Taha Farooq |
| Engineering — IBAN backend | Adnan, Zain |
| Eng PM partner | Salman Khan |
| CX workflow design | Nashit Syed |
| CX training | Ralf Jayaprakash |
| Design | Siddique Afridi (banner, state surfaces; declaration screens reuse the live withdrawal pattern) |
| Copy review | Ameera Iqbal |
| Compliance review | TBC |

## 12. Open Items

- CX response SLA on Zendesk chat for Tier 2. Nashit to define. Can ship without, but the user-facing banner copy depends on it.
- Compliance owner for manual wallet-verification revocation.
- Decision on whether to memoize Tier 1 declarations across deposits in v2 (currently per-transaction).

## 13. Acceptance Criteria

### Tier 1 — Self-declaration ($1,000 to $19,999.99)

- [ ] Crypto receipts in this band (UAE users) auto-enter *On Hold — Verification Required* on Fireblocks confirmation.
- [ ] User cannot access funds until declaration is submitted.
- [ ] Push and in-app banner fire within 5 minutes of confirmation.
- [ ] Declaration form captures source type (exchange/private wallet), exchange name (if applicable), and sender first name, last name, country of residence.
- [ ] On submit, deposit transitions to *Processing* and credits to available balance.
- [ ] Submitted data is stored and linked to the transaction record.
- [ ] UI matches the designs at Fasset App 4.5, node `29889:271732`.

### Tier 2 — Declaration + Satoshi (≥ $20,000)

- [ ] Crypto receipts ≥ $20,000 from unverified source addresses auto-enter escrow on Fireblocks confirmation.
- [ ] Crypto receipts ≥ $20,000 from verified source addresses credit normally with no escrow, banner, or chat.
- [ ] User cannot access escrowed funds until verification completes.
- [ ] Push and in-app banner fire within 5 minutes of Fireblocks confirmation for unverified-source deposits.
- [ ] In-app declaration form captures the same fields as Tier 1 and submits to Zendesk.
- [ ] Zendesk WebView chat opens with deposit context and declared sender info prefilled.
- [ ] CX agent has a documented workflow with macros for Satoshi request, success, and timeout paths.
- [ ] Fireblocks watcher matches Satoshi against source address, $9–$11 USD-equivalent range, and 7-day window.
- [ ] Successful match adds source address to user's verified-wallet store (chain-agnostic).
- [ ] Original deposit + Satoshi amount credited atomically on success.
- [ ] 7-day timeout triggers fund-return to source via Fireblocks.
- [ ] All declaration data, Satoshi outcomes, and state transitions logged for audit.

## 14. Out of Scope (v1)

- Non-UAE jurisdictions. Phase 2 expansion.
- Outbound transfers ≥ $20K (handled by hard send limit, separate workstream).
- Aggregation logic across multiple sub-threshold deposits.
- Memoization of Tier 1 declarations across deposits.
- Auto-revocation of verified wallets on compromise.
- AI-driven deflection of the Tier 2 verification chat (Phase 2 of Zendesk SDK migration).

---

**Reference materials:**
- HOR-479 (Tier 1 implementation): https://fasset.atlassian.net/browse/HOR-479
- FO-1022 (parent epic, Notabene Travel Rule)
- Fasset App 4.5 designs, node `29889:271732`
- FigJam: Travel Rules board, Satoshi Test v3
