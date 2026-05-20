# Brainstorm: P2P Marketplace — Buy + Sell Flow
*Session: 2026-05-20*

## Context

Current state: Fasset's P2P Express is a single-seller auto-assign flow. Users perceive Fasset as the counterparty (the seller/buyer), not as a marketplace platform. Competitors (Binance, Redot Pay) surface multiple independent sellers with their own rates, liquidity, and stats — giving users a sense of control and market transparency.

**Decision: build a parallel P2P Marketplace mode alongside Express, not as a replacement.**

- Sellers set their own PKR/USDT rates
- Both buy (PKR→USDT) and sell (USDT→PKR) sides in scope
- Express remains untouched as the default/fast path
- Marketplace is opt-in for users who want to browse and choose

Figma refs reviewed:
- Buy flow: https://www.figma.com/design/9nackJ4Zz8zfaiyvAEPaw2/Fasset-App-4.5--Copy-?node-id=22021-238326
- Sell flow: https://www.figma.com/design/9nackJ4Zz8zfaiyvAEPaw2/Fasset-App-4.5--Copy-?node-id=22021-238759

---

## Top 5 Recommendations

| Rank | Idea | Why | Quick Win? |
|------|------|-----|------------|
| 1 | Two Entry Cards (Express / Marketplace) | The entire concept's entry point. Minimal engineering — it's a navigation decision. | Yes |
| 2 | Express as Marketplace Fast Path | One backend serving both modes. Avoids parallel systems. The architectural decision everything else depends on. | No |
| 3 | Seller Card Led by Rate + Liquidity Bar | Sellers set their own rates — price is the primary differentiator. Card hierarchy must reflect that. | Yes |
| 4 | Atomic Order Reservation | Without inventory locking, two users can simultaneously claim a seller who only has capacity for one. | No |
| 5 | Amount-Based Seller Filtering at API Level | Filter sellers who can't fulfill the user's amount server-side before list renders. Prevents wasted taps and silent failures. | No |

---

## Full Idea Set

### PM Perspective

1. **Express / Marketplace Mode Split at Entry** — Two modes at the P2P entry screen. Express ("We pick the best available seller instantly") and Marketplace ("Browse sellers, compare rates, choose your own"). Express stays the default/recommended path. | Impact: H | Effort: M

2. **"Best Rate" Banner on Marketplace List** — Header showing best available rate vs. current Express rate. e.g., "Best available: 1 USDT = 287 PKR — 0.7% better than Express." Makes value of browsing tangible. | Impact: H | Effort: L

3. **Minimum and Maximum Order Size per Seller** — Sellers declare PKR range they accept (e.g., 1,000–100,000 PKR). Marketplace list filters to only sellers whose range covers the user's entered amount. | Impact: H | Effort: M

4. **Post-Trade Rating (Thumbs Up/Down)** — Single thumbs up/down after order completion. No text required. Feeds seller reliability score organically. | Impact: M | Effort: L

5. **Seller Availability Window** — Sellers declare working hours. List shows "Online now" vs "Online in 2 hrs." Reduces mid-order dropoff. | Impact: M | Effort: M

### Designer Perspective

1. **Two Entry Cards, Not Tabs** — Express vs Marketplace as two visual cards at entry, not a tab switch. User makes a deliberate choice. Default card is visually heavier. | Impact: H | Effort: L

2. **Seller Card Led by Rate** — Rate in large type at top of each seller card. Secondary: trade count, completion %, avg response time, available liquidity. Primary decision driver = price. | Impact: H | Effort: L

3. **Liquidity Bar on Each Seller Card** — Available liquidity as a visual bar (e.g., "Up to PKR 50,000 available"). Scarcity legible at a glance. | Impact: M | Effort: L

4. **Sort Controls: Rate / Speed / Reliability** — Persistent sort bar: "Best Rate | Fastest | Most Reliable." Default to Best Rate. Single-tap switching. | Impact: M | Effort: L

5. **Unified "Order in Progress" Screen** — Buy and sell order status screens currently look different. Unify design language for the waiting/pending state. | Impact: M | Effort: M

### Engineer Perspective

1. **Express as Marketplace Fast Path** — Express and Marketplace draw from the same seller pool and scoring engine. Express auto-applies "highest composite score" filter and skips the selection screen. One backend, not two. | Impact: H | Effort: M

2. **Real-time Seller Feed via WebSocket** — Seller rates and availability kept live. Seller goes offline = drops off instantly. Rate changes = reflects immediately. Eliminates stale-data trust issues. | Impact: H | Effort: M

3. **Atomic Order Reservation** — On "Place Order" tap, system locks seller's liquidity for 60 seconds. If user cancels or times out, lock releases. Prevents double-claiming. | Impact: H | Effort: M

4. **Seller Composite Score Engine** — Single score per seller: weighted completion rate + avg response time + dispute rate + cancellation rate + trade volume. Powers sort, Express auto-assignment, and "Best Match" badge. | Impact: M | Effort: M

5. **Amount-Based Seller Filtering at API Level** — Pass user's entered amount as param when fetching Marketplace list. Backend returns only sellers whose min/max and current liquidity cover that amount. | Impact: M | Effort: L

---

## Next Steps

- Validate entry card concept with Siddique before any spec is written
- Confirm sell-side scope for v1 with Malik — buy + sell doubles QA surface
- Architecture conversation with eng on "Express as fast path" — most consequential decision
- Figma prototypes for 2 options: "Mode Chooser" entry screen + Marketplace Seller List screen (blocked pending Figma full seat setup)
