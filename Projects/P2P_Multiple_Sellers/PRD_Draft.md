# PRD — P2P Multiple Sellers (Express Buy Flow)

## 1. Background

P2P Express lets users in buy USDT with local currency via peer-to-peer bank transfer. The current system auto-assigns a single seller at buy initiation — but sellers run shift-based schedules, so when a shift ends and no replacement is online, users hit a wall. This PRD specifies a seller-first flow: users see all available sellers and choose one before the order is created, eliminating the auto-assignment blind spot and creating light competition on response time and reliability. It is paired operationally with expanding the seller pool from the current 2-3 per day to a larger base covering more hours.

---

## 2. Objective

- Eliminate buyer drop-off caused by seller unavailability by surfacing the full active seller pool at buy initiation.
- Give buyers visible agency over who they transact with, creating competitive pressure on completion rate and response time.
- Keep the flow simple: one seller pick, then straight through to payment and confirmation.

---

## 3. Scope

| Dimension | v1 |
| :---- | :---- |
| Direction | Buy only |
| Market | All Jurisdictions |
| Seller selection | User picks from available sellers before order creation |
| Multiple concurrent orders | Not allowed — one active P2P order per user at a time |

| Sell side | Out of scope |

---

## 4. User Journey

---

## 5. Screen Specifications

### 5.1 Amount Entry

**When it appears:** Entry point to P2P Express.

**UI elements:**
- PKR amount input (numeric keyboard, currency label)
- USDT equivalent (updates in real time as user types)
- Exchange rate (e.g., "1 USDT = 285.00 PKR")
- "Buy with 0 Fee" CTA

**Conditional elements:** None at this step.

**CTA:** "Buy with 0 Fee" → checks seller availability. If ≥1 active seller exists, navigates to Seller List (5.2). If zero active sellers, surfaces inline error: "No sellers available right now. Please try again shortly." User stays on Amount Entry.

---

### 5.2 Seller List

**When it appears:** After user taps "Buy with 0 Fee" and at least one active seller is available.

**UI elements:**
- Screen title (e.g., "Choose a Seller")
- List of active sellers, each row showing:
  - Seller name
  - Verified badge (if applicable)
  - Trade count
  - Completion percentage
  - Average response time
- Sellers filtered to Active state only

**Conditional elements:**
- Empty state (defensive): if the list loads with no active sellers — unlikely given the check on Amount Entry, but must be handled. Show: "No sellers available right now. Please check back shortly." with a "Go Back" button.

**CTA per row:** Tapping a seller row assigns that seller immediately and navigates to Order Created (5.3). No intermediate profile screen.

---

### 5.3 Order Created

**When it appears:** User has selected a seller. Order exists in the system. Timer is running.

**UI elements:**
- Seller card (name, verified badge, trade count, completion %, avg response time)
- Countdown timer (10:59, counting down)
- 3-step instruction list:
  1. Make the bank transfer (account name, bank name, account number, PKR amount)
  2. Upload payment proof screenshot
  3. Tap "Paid, Notify the Seller"
- "Paid, Notify the Seller" CTA

**Conditional elements:** None. No "Change" button — seller is locked at order creation.

**CTA:** "Paid, Notify the Seller" → navigates to Paid / Proof Upload (5.4).

---

### 5.4 Paid / Proof Upload

**When it appears:** User taps "Paid, Notify the Seller" on Order Created.

**UI elements:**
- Prompt to upload payment screenshot
- File/image picker (camera or gallery)
- "Submit" CTA (enabled once proof is attached)

**Conditional elements:**
- "Submit" is disabled until at least one image is attached.

**CTA:** "Submit" → sends payment notification and proof to seller, navigates to Success (5.5).

---

### 5.5 Success

**When it appears:** Proof submitted. Order is pending seller confirmation.

**UI elements:**
- "You're all set!" heading
- Confirmation that USDT will be credited once the seller verifies payment
- Expected credit time: "Your USDT will be credited within 45 minutes"
- "Back to Home" CTA

**Conditional elements:** None.

**CTA:** "Back to Home" → navigates to home.

---

## 6. Seller States and Availability Logic

| State | Definition | Shown in Seller List |
| :---- | :---- | :---- |
| Active | Online, capacity available | Yes |
| At Capacity | Online, reached max concurrent orders | No |
| Paused | Temporarily offline (e.g., between shifts) | No |
| Offline | Not online | No |

The Seller List is fetched fresh when the screen loads — not a cached snapshot from the Amount Entry tap.

---

## 7. Edge Cases

### No sellers available

User taps "Buy with 0 Fee" and zero active sellers exist. Inline error shown on Amount Entry: "No sellers available right now. Please try again shortly." User does not navigate to Seller List.

### Seller goes offline between list load and row tap

User opens Seller List, a seller drops to Offline before they tap that row. On tap, surface: "This seller is no longer available." Refresh the list and remove the unavailable seller. If the list is now empty, show the empty state.

### Order timeout

Countdown reaches 0:00 before user taps "Paid, Notify the Seller." Pending order is cancelled automatically. User sees Order Timeout screen with two options: "Try Again" (restarts from Amount Entry) or "Cancel" (returns to home). The seller's capacity slot is freed immediately on timeout.

### Multiple concurrent orders

A user with an active P2P order cannot initiate a second one. If they navigate to Amount Entry while an order is active, surface a prompt: "You have an active P2P order. Complete or cancel it before starting a new one." Block order creation at the API level — do not rely on UI gating alone.

---

## 9. Analytics Events

| Event | Trigger | Key properties |
| :---- | :---- | :---- |
| `seller_list_viewed` | Seller List screen loads | `seller_count` (number of Active sellers in list) |
| `seller_selected` | User taps a seller row | `seller_id` |
| `order_created` | Order successfully created in system | `seller_id`, `pkr_amount`, `usdt_amount`, `rate` |
| `payment_proof_uploaded` | User submits proof on Paid / Proof Upload | `seller_id`, `order_id` |
| `order_timeout` | Countdown reaches 0:00 before payment confirmed | `seller_id`, `time_elapsed` |
| `order_completed` | USDT credited to user | `seller_id`, `pkr_amount`, `usdt_amount` |

---
## 13. Out of Scope

- Sell side (USDT → PKR).
- Seller-facing app changes or seller onboarding flows.
- Auto-assignment logic — system does not auto-pick a seller in v1.
- Seller profile / detail screen — row tap assigns immediately, no intermediate profile view.
- Rate negotiation between buyer and seller.
- Aggregation of P2P orders across users.
- Seller ratings or reviews by buyers.
- Markets outside Pakistan.
- Multiple concurrent P2P orders per user.
- Home screen order status notifications (separate initiative).
