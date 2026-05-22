# MEMORY.md — Mastercard Card Issuing
*Last updated: 2026-05-08*

---
type: project
name: Mastercard Card Issuing
status: active
priority: strategic
owner: Hamis Mahmood
support: Arundathi Belur (to be aligned before proposal)
related: [Mohammad Raafi Hossain, Yazan Samara, Kisan (licenses), Mastercard]
last_verified: 2026-05-08
---

## What This Is

A strategic exploration into whether Fasset should pursue a direct Mastercard relationship, rather than continuing to distribute cards through third-party issuers (Rain, Bridge, Reap). Initiated from a conversation between Hamis and Arundathi.

The core problem with the current model: Fasset is becoming a distribution unit for card issuers. Rain is both issuer and program manager, meaning Fasset does not own pricing, product rules, fraud parameters, data, or the customer relationship on the card side. Adding Bridge and Reap compounds the complexity without resolving the control problem.

The model is deliberately open-ended. What the right Mastercard relationship looks like (if any) is what the research determines.

## What We Know So Far

| Item | Status | Source |
|---|---|---|
| VARA (UAE) license permits direct Mastercard relationship | No | Yazan Samara DM, May 8 |
| Labuan (LFSA) license — card issuing scope | Pending | Yazan checking, awaiting reply |
| Bahrain (CBB Cat 3) — card issuing scope | Not yet asked | — |
| Indonesia (Bappebti) — card issuing scope | Not yet asked | — |
| Fasset license documents (all 4) stored in iClaude | No | Need to get from Kisan |
| Mastercard model to pursue | Unknown | Research not yet run |

## Research Plan

### Perplexity Deep Research — 5 queries (not yet run)

Run in this order:

**Query 1 — Mastercard's full participation framework**
> "What are all the different ways a non-bank fintech or digital asset company can have a formal relationship with Mastercard — membership tiers, program types, issuing models — and what does each one require in terms of licensing, capital, and operational obligations?"

**Query 2 — Crypto fintech precedents**
> "How have crypto and digital asset companies globally structured their Mastercard relationships — what model did companies like Nexo, Crypto.com, Binance, Coinbase use, who sponsors them, and how did they get there?"

**Query 3 — What Fasset's licenses permit**
> "What card issuing or payment program rights does a UAE VARA virtual asset broker-dealer license, a Bahrain CBB Category 3 crypto-asset license, or a Labuan LFSA money-broking license confer — can any of these support a direct or indirect Mastercard relationship?"

**Query 4 — MENA access routes**
> "How do fintechs in UAE and Bahrain access Mastercard card issuing — what are the realistic routes, which entities are intermediaries, and are there examples of crypto-native companies doing this in the region?"

**Query 5 — Mastercard's fintech programs**
> "Mastercard Engage, Mastercard Accelerate, Mastercard Fintech program — what do these actually offer to fintechs seeking card issuing capabilities, and what is the path to getting a dedicated BIN?"

### Internal Conversations (not yet had)

| Who | Question | Status |
|---|---|---|
| Yazan Samara (Legal/Compliance) | "What do our licenses actually allow on the card issuing side — full spectrum. VARA said no. What about CBB, LFSA, Bappebti?" | Labuan in progress, rest not yet asked |
| Arundathi Belur | "Walk me through what Rain controls today that we don't — pricing, fraud rules, country decisions, data access." | Not yet |
| Kazi or Taha (Engineering) | "If we moved to a different card infrastructure model, what's the engineering lift — order of magnitude?" | Not yet |

## Research Tool Decision

- **Perplexity Deep Research** — web search + synthesis for regulatory docs, Mastercard rules, issuing platform comparisons, MENA landscape.
- **Claude** — structure the analysis, identify gaps, draft internal question list, write the proposal.
- No local agent framework needed for a one-shot strategic proposal.

## Proposal Structure (draft, pending research)

Five sections once research and internal conversations are complete:

1. **Problem** — Multi-issuer sprawl gives distribution without control. Define exactly what Fasset doesn't own today.
2. **The model options** — What Mastercard relationships are available to an entity like Fasset, given our licenses and markets.
3. **Licensing gate** — What our licenses permit, which markets we can do this in now vs. what needs additional licensing.
4. **What it takes** — Platform or infrastructure requirement, engineering lift, ops requirements, timeline.
5. **Recommendation** — Go / No-Go with explicit kill criteria.

## Kill Criteria

The proposal is a no if:
- No Fasset license (current or achievable near-term) supports the required Mastercard relationship in UAE or Bahrain.
- No bank in MENA willing to sponsor a crypto-native entity under a Mastercard program.
- Engineering timeline pushes past a threshold that makes it irrelevant vs. iterating on Rain.

## Stakeholders

| Person | Role | Involvement |
|---|---|---|
| Mohammad Raafi Hossain | CEO | Mandate owner — cards are strategic priority. Proposal goes to him last. |
| Arundathi Belur | Card PM | Owns current card model. Must align before Rafi sees this. |
| Yazan Samara | Compliance/Legal | Licensing gate. VARA checked (no). Labuan in progress. |
| Kisan | Unknown (licenses) | Source for the 4 license documents. |

## Active Tasks

- [ ] Get all 4 license documents from Kisan. `status: pending`
- [ ] Await Yazan reply on Labuan card-issuing scope. `status: awaiting-reply`
- [ ] Run 5 Perplexity research queries. `status: pending`
- [ ] Have internal conversations (Arundathi, Yazan on remaining licenses, engineering). `status: pending`
- [ ] Build proposal once research + internal input is complete. `status: not-started`
