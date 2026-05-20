# Session log — P2P Multiple Sellers

Append-only. One entry per session.

---

## 2026-05-18 — PRD v1 written

**Status at session end:** PRD draft complete. FigJam journey diagram created. Next step: Hamis reviews both, then shares to designer (TBD).

### What was done

- Created full PRD at `PRD_Draft.md` (13 sections).
- Scope: buy-only (PKR → USDT), Pakistan market, wiring the existing non-functional "Change" button to a real seller selection list.
- PRD covers: background, objectives, scope table, full Mermaid user journey flowchart, screen specs for all 7 screens (Amount Entry, Confirm Buy, Seller Selection List, Seller Profile, Order Created, Order Timeout, Success), seller state table, 7 edge cases, notifications, 7 analytics events, dependencies, stakeholders, acceptance criteria, out-of-scope list.
- FigJam user journey diagram built to match the Mermaid flowchart in section 4.

### Key decisions captured in PRD

- Auto-assignment preserved as default (highest completion rate, tie-break on avg response time).
- "Change" button always visible on Confirm Buy; opens list if ≥2 Active sellers, shows modal if only 1.
- Post-payment seller change blocked server-side (fraud lock). "Change" button hidden after user taps "Paid, Notify the Seller."
- Seller states: Active (shown), At Capacity / Paused / Offline (not shown in list).
- v1 buy side only. Sell side out of scope.
- One active P2P order per user at a time — enforced at API level, not just UI.

### What's left

- Hamis to review PRD and FigJam diagram.
- Updates to PRD and flow likely needed — session ended before those were made.
- Share to designer once reviewed.
- Jira tickets after PRD sign-off from Zane and Saad.

---
