# PRD — Travel Rule for Crypto Receipts (UAE)

*Draft v1, 2026-05-05. Author: Hamis Mahmood.*

---

## 1. Background

VARA Travel Rule requires VASPs to collect, verify, and retain originator and beneficiary information for virtual asset transfers. For unhosted wallets and high-value inbound transfers, enhanced due diligence is required, including proof of wallet control where applicable.

**Current state of enforcement:**

- **Withdrawals:** Self-declaration flow is live. Users sending out crypto provide originator info above the threshold.
- **Deposits:** No enforcement today. A user can receive any amount with no declaration captured. This is the compliance gap.

This PRD specifies the deposit-side controls in two tiers:

| Tier | Range | Treatment |
| :---- | :---- | :---- |
| Tier 1 | $1,000 to $19,999.99 | In-app self-declaration of source and sender. Designs exist (mirror the live withdrawal flow). |
| Tier 2 | ≥ $20,000 | In-app self-declaration plus a CX-administered Satoshi test to prove control of the sending wallet. Net new. |

## 2. Objective

Bring deposit-side handling into VARA compliance by:

- Holding deposits above $1,000 in escrow until originator information is captured.
- For ≥ $20,000, additionally verifying that the user controls the source wallet via a Satoshi test.
- Memoizing previously declared / verified wallets so repeat senders skip re-verification at the appropriate tier.
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

| Receipt amount | Treatment |
| :---- | :---- |
| < $1,000 | No action, credit normally |
| $1,000 to $19,999.99, source wallet not previously declared | Tier 1: in-app declaration |
| $1,000 to $19,999.99, source wallet previously declared or Satoshi-verified | Credit normally, no friction |
| ≥ $20,000, source wallet not Satoshi-verified | Tier 2: declaration + Satoshi test |
| ≥ $20,000, source wallet Satoshi-verified | Credit normally, no friction |

## 4. User Flow

### 4.0 Detection and routing

1. Fireblocks confirms inbound tx.
2. System computes USD value at time of receipt.
3. Routing:
   - **< $1,000:** Deposit credits normally. End of flow.
   - **$1,000 to $19,999.99, wallet at Declared or Verified level:** Deposit credits normally. End of flow.
   - **$1,000 to $19,999.99, wallet not in store:** Enter **Tier 1** (4.1).
   - **≥ $20,000, wallet at Verified level:** Deposit credits normally. End of flow.
   - **≥ $20,000, wallet at Declared level or not in store:** Enter **Tier 2** (4.2).

### 4.1 Tier 1 — Self-declaration ($1,000 to $19,999.99)

**State on entry:** Deposit placed on hold. Funds not credited to available balance. State = *On Hold — Verification Required*.

**Notification:**
- Push: copy to be finalized with marketing.
- In-app banner on home.

**Screens (reuses the existing self-declaration design pattern):**

1. **Source of deposit.** *"Where did this deposit come from?"* Options: Exchange / platform, Private wallet.
2. **Exchange selection** (if applicable). Searchable dropdown of supported exchanges.
3. **Sender details.** First Name, Last Name, Country of Residence. Supporting copy explains the compliance requirement.
4. **Confirmation.** Deposit moves to *Processing*, then *Completed*, and funds credit to available balance.

Designs: Fasset App 4.5, node `29889:271732`.

**On submit:** Source wallet is added to the verified-wallet store at **Declared** level, attached to the user, with the submitted sender info. Future deposits from the same wallet within Tier 1 range skip the declaration. A subsequent ≥ $20K deposit from the same wallet still routes to Tier 2.

**No CX involvement.** The tier completes entirely on the user's side once they submit the form.

### 4.2 Tier 2 — Declaration + Satoshi test (≥ $20,000)

**State on entry:** Deposit placed in escrow. State = *On Hold — Verification Required*.

**Step 1: Notification.** Push + in-app banner. Copy to be finalized with marketing.

**Step 2: In-app declaration.** Same four screens as Tier 1 (Source → Exchange → Sender → Confirmation). Submitted data is attached to the deposit record. State moves to *Awaiting Verification*. The wallet is added to the verified-wallet store at **Declared** level.

**Step 3: Zendesk handoff.** After form submit, the app redirects the user to Zendesk Web Widget to start a chat with CX. No prefill, no custom fields, no conversation tags. The user opens the chat and tells CX they have a pending transaction, supplying the deposit ID. CX looks up the deposit in internal tooling and sees all submitted declaration info on the deposit record.

**Step 4: CX workflow.** Agent picks up the chat (workflow in section 5). State = *Awaiting Satoshi*.

**Step 5: Satoshi test.** CX manually checks the asset and source address on the deposit record, then issues:

> *"To complete verification, please send $10 worth of [ASSET] from the same wallet that sent your original deposit, to [Fasset address]. You have 7 days. Once we receive it, your deposit will be credited."*

User sends $10 of the same asset from the same source address.

CX manually verifies in Fireblocks that the test transaction was received from the original source address within 7 days. Tolerance band $9 to $11 USD-equivalent at time of receipt.

**On match:**
- CX upgrades the wallet from *Declared* to *Verified* in the wallet store.
- CX releases escrow via internal tool. Original deposit + Satoshi amount credited atomically.
- CX confirms in chat and closes.

**On 7-day timeout / wrong amount / wrong source / wrong chain:**
- CX makes one outreach attempt during the window.
- After 7 days with no resolution, CX triggers fund-return to source via Fireblocks.
- User notified by push + in-app. Copy to be finalized with marketing.
- State = *Returned*.

### 4.3 Repeat sender (verified wallet)

If the source address is already in the verified-wallet store at **Verified** level, deposits credit normally regardless of amount. No escrow, no banner, no chat, no CX.

If the source address is at **Declared** level, deposits within Tier 1 range credit normally. Deposits ≥ $20K still route to Tier 2.

## 5. CX Workflow (Tier 2 only)

Tier 1 has no CX touchpoint.

Verified-wallet deposits never reach CX at any tier. This workflow applies only to ≥ $20K deposits from wallets at *Declared* level or not in the wallet store.

**Step 1 — Identify the deposit.** User opens chat with a deposit ID. CX looks up the deposit in internal tooling and confirms it is in *Awaiting Verification* state with declaration info attached.

**Step 2 — Issue Satoshi test.** CX checks the asset and source wallet on the deposit record, then sends the Satoshi instruction (copy in 4.2 step 5). Set chat status to *Awaiting Satoshi*.

**Step 3 — Verify.** Within the 7-day window, CX checks Fireblocks for a matching incoming transaction on the source address. Tolerance band $9 to $11 USD-equivalent.

**Step 4 — On match:** Upgrade the wallet to *Verified* in the wallet store. Release escrow via internal tool. Credit original deposit + Satoshi amount atomically. Confirm and close.

**Step 5 — On 7-day timeout:** Make one outreach attempt during the window. If no resolution by day 7, trigger fund-return via Fireblocks, send the failure notification, close.

## 6. Deposit States

| State | Tier | Description |
| :---- | :---- | :---- |
| Pending | All | Tx confirmed on-chain, system processing |
| On Hold — Verification Required | 1, 2 | Awaiting user action on declaration |
| Processing | 1 | Tier 1 declaration submitted, funds being credited |
| Awaiting Verification | 2 | Declaration submitted, redirected to Zendesk |
| Awaiting Satoshi | 2 | CX requested test, awaiting CX manual confirmation |
| Releasing | 2 | Match confirmed, releasing escrow |
| Completed | All | Funds credited |
| Returned | 2 | Verification failed, funds returned to source |

## 7. Verified Wallet Store

Engineering owns implementation. PRD requirements:

- Scoped per user × source address. Chain-agnostic. Applies to both tiers.
- Two levels:
  - **Declared:** Sender info captured via Tier 1 or Tier 2 declaration form. Sufficient to skip the declaration on subsequent Tier 1 deposits.
  - **Verified:** Wallet control proven via Satoshi test. Sufficient to skip both declaration and Satoshi for any subsequent deposit at any amount.
- A wallet can be upgraded from *Declared* to *Verified*. Cannot be downgraded automatically.
- Retention / expiry: TBC with compliance (Yazan).
- Manual revocation by compliance is supported.
- Audit log retained per VARA requirements.

## 8. Notifications

| Event | Channel |
| :---- | :---- |
| Hold triggered (any tier) | Push + in-app banner |
| Tier 1 declaration accepted | Push + in-app |
| Tier 2 verification successful | Push + in-app |
| Tier 2 verification failed / return | Push + in-app |

Copy to be finalized with marketing before launch.

## 9. Edge Cases

- **User abandons declaration form (either tier).** Deposit stays in *On Hold — Verification Required* indefinitely. User can resume via banner. No auto-return for Tier 1; Tier 2 only auto-returns after the Satoshi 7-day timer expires post-CX issuance.
- **User abandons mid-Satoshi.** 7-day timer runs from CX issuance regardless of user activity. Times out into return path.
- **User sends Satoshi from a different wallet.** CX does not find a match in Fireblocks. CX flags and reissues the instruction.
- **Multiple ≥ $20K deposits from same unverified wallet.** First triggers Satoshi. Subsequent stack in *On Hold*. Single Satoshi success unlocks all of them and upgrades the wallet to *Verified*.
- **Repeat Satoshi from same wallet.** Idempotent. Wallet stays *Verified*.
- **Source wallet ownership change** (e.g., compromised exchange address). Out of v1 scope. Compliance can manually revoke verification.
- **Deposit lands at boundary** (e.g., $999.50 vs $1,000.10 due to price flux during confirmation). USD value is fixed at time of Fireblocks confirmation. No re-routing.
- **Deposit jumps the tier** (declaration submitted at $19,500, but USD value at confirmation is $20,100). Routes by amount at time of receipt. If the lookup pushes it to Tier 2, the user is taken into the CX flow rather than auto-crediting.

## 10. Dependencies

- Price conversion service for USD-equivalent calc.
- Fireblocks: escrow state for ≥ $20K deposits + manual CX lookup for Satoshi confirmation + fund-return on timeout.
- Zendesk Web Widget: redirect target for Tier 2 chat handoff.
- Verified-wallet store (engineering build, both tiers).
- Self-declaration screens (designs at Fasset App 4.5, node `29889:271732`; UI patterns reused from live withdrawal flow).
- Internal tooling for CX to look up deposits, release escrow, and trigger fund-return.
- CX team training on Satoshi procedure (Ralf Jayaprakash).
- Final notification copy from marketing.

## 11. Open Items

- CX response SLA on Zendesk chat for Tier 2.
- Verified wallet store retention and expiry rules — confirm with compliance (Yazan).
- Compliance owner for manual wallet-verification revocation.
- Decision on whether *Declared* level should also expire / require periodic refresh.

## 12. Acceptance Criteria

### Tier 1 — Self-declaration ($1,000 to $19,999.99)

- [ ] Crypto receipts in this band (UAE users) from wallets not in the verified-wallet store auto-enter *On Hold — Verification Required* on Fireblocks confirmation.
- [ ] Crypto receipts in this band from wallets at *Declared* or *Verified* level credit normally with no friction.
- [ ] User cannot access funds until declaration is submitted.
- [ ] Push and in-app banner fire within 5 minutes of confirmation.
- [ ] Declaration form captures source type (exchange / private wallet), exchange name (if applicable), and sender first name, last name, country of residence.
- [ ] On submit, deposit transitions to *Processing* and credits to available balance.
- [ ] On submit, source wallet is added to the verified-wallet store at *Declared* level with the submitted sender info attached.
- [ ] Submitted data is stored and linked to the transaction record.
- [ ] UI matches the designs at Fasset App 4.5, node `29889:271732`.

### Tier 2 — Declaration + Satoshi (≥ $20,000)

- [ ] Crypto receipts ≥ $20,000 from wallets not at *Verified* level auto-enter escrow on Fireblocks confirmation.
- [ ] Crypto receipts ≥ $20,000 from wallets at *Verified* level credit normally with no escrow, banner, or chat.
- [ ] User cannot access escrowed funds until verification completes.
- [ ] Push and in-app banner fire within 5 minutes of confirmation for unverified-source deposits.
- [ ] In-app declaration form captures the same fields as Tier 1.
- [ ] On declaration submit, app redirects user to Zendesk Web Widget. No custom fields, tags, or prefill.
- [ ] CX agent has internal tooling to look up the deposit by ID and view all declaration data.
- [ ] CX has a documented workflow for issuing the Satoshi instruction, manually confirming receipt in Fireblocks, releasing escrow, and triggering fund-return on timeout.
- [ ] CX upgrade of wallet to *Verified* in the wallet store on Satoshi success.
- [ ] Original deposit + Satoshi amount credited atomically on success.
- [ ] 7-day timeout triggers fund-return to source via Fireblocks.
- [ ] All declaration data, Satoshi outcomes, and state transitions logged for audit.
