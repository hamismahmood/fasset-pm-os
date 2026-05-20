# OPEN_LOOPS.md
*Cross-cutting to-do list. Things Hamis owes someone, decisions pending, replies expected, threads to close. Scan first thing in the morning. Prune ruthlessly: when a loop closes, delete the line.*
*Last updated: 2026-05-18*

For tracked engineering work, see "Active Jira Tasks" in root `MEMORY.md`. For project-specific facts and history, see the relevant project `MEMORY.md`. For inline metadata schema, see `SCHEMA.md`.

> Each loop uses inline metadata: `created`, `owner` (default Hamis), `status` (`pending` / `blocked-on-<who>` / `in-progress` / `awaiting-reply`), `deadline`, `related`. Done items are pruned, not retained.

---

## AI Training Curriculum — Noman Hassan

- [ ] **Survey the team for voluntary AI training participation.** Agreed in Hamis/Noman 1:1 (May 15). Target enthusiastic volunteers across all roles, not just engineering.
  - `created: 2026-05-15` `status: pending` `owner: Hamis` `related: ai-blitz-fasset-forward, noman-hassan`

- [ ] **Build initial AI training framework draft.** Co-develop with Noman. Present at Bali trip, then roll out company-wide. Needs tailored tracks for non-engineering staff (terminal intimidation is a known blocker).
  - `created: 2026-05-15` `status: in-progress` `owner: Hamis + Noman` `deadline: bali-trip` `related: ai-blitz-fasset-forward, noman-hassan`

- [ ] **Confirm Noman's role/team + Slack ID** — missing from People file.
  - `created: 2026-05-15` `status: pending` `tier: admin`

---

## CipherX — Saâd Dhif (Islamic Crypto Fund)

- [ ] **Follow up end of June once Mufti review complete + final allocation locked.** Salman Khan is point person. Hamis stays in loop. Two DD gates: Shariah screen + fund due diligence on composition/performance. Transcript: [2026-05-15-saad-dhif-cipherx.md](Meetings/Transcripts/2026-05-15-saad-dhif-cipherx.md).
  - `created: 2026-05-15` `status: awaiting-reply` `owner: Salman (Hamis FYI)` `deadline: 2026-06-30` `related: saad-dhif`

---

## P2P Multiple Sellers

- [ ] **Review PRD v1 + share to designer + Zane/Saad for sprint planning push.** PRD v1 written May 18 at `Projects/P2P_Multiple_Sellers/PRD_Draft.md`. Malik committed to push internally. ~2 weeks effort, flow designed, backend changes needed. Q3 roadmap estimate. Transcript: [2026-05-15-malik-hamis.md](Meetings/Transcripts/2026-05-15-malik-hamis.md).
  - `created: 2026-05-15` `status: in-progress` `owner: Hamis` `related: malik-danish` `tier: strategic`

---

## Naseeha — Brand Partnerships

- [ ] **Share Naseeha data and proposal to Malik Danish.** PK brand partnerships route through him. Malik is open to co-branding university events and the Weekly Wealth Reset workshop format. Smaller events perform better per Malik.
  - `created: 2026-05-15` `status: pending` `owner: Hamis` `related: malik-danish` `tier: tactical`

---

## Statement of Account — Architecture

- [ ] **Confirm with Altof + Kazi whether Hina acknowledged the SoA / Fasset 4.5 unified cash balance overlap.** From May 12 Compliance meeting — they were going to surface it on their next call with Hina. If yes, SoA backend can be scoped into 4.5 work instead of a separate lift.
  - `created: 2026-05-15` `status: pending` `related: Projects/Statement_of_Account, kazi-hasan, altof-naufal, hina-aziz` `tier: strategic`

---

## Hard deadline May 22

- [ ] **Travel Rule declaration flow build.** HOR-479, 565, 566, 567 all In Progress (Ubaid). HOR-568 and HOR-627 still To Do. **No Slack or Jira movement since May 12-13. 4 days left. Check in with Ubaid today.**
  - `created: 2026-04-29` `status: in-progress` `deadline: 2026-05-22` `related: Projects/Travel_Rule, nashit-syed, ubaid-rajput` `tier: strategic`

## Hard deadline May 25

- [ ] **Bridge / Reap card partner contracts** must close to hit go-live. Arundathi-led, Hamis supports.
  - `created: 2026-04-30` `owner: Arundathi (Hamis support)` `status: in-progress` `deadline: 2026-05-25` `related: Radar/Card_Strategy, bridge, reap`

---

## iOS Release — today (May 18)

- [ ] **Force update going live today.** iOS 4.10 submitted to App Store for review May 17. During review, app unavailable in PK/BD on App Store. Expected approval 12-24h from submission. Coordinate with Taha and Nashit on timing — CX needs advance warning before push to avoid query spike from forced logouts.
  - `created: 2026-05-18` `status: in-progress` `owner: Taha (Hamis FYI)` `related: nashit-syed, taha-farooq`

---

## PM Numbers Biweekly

- [ ] **Respond to Altof's #productsquad message** proposing to restart biweekly PM numbers deep-dive. Hamis tagged alongside Salman, Mohsin, Arundathi, Kazi, Andre. Salman and Mohsin said yes. Confirm participation and help set cadence.
  - `created: 2026-05-18` `status: pending` `owner: Hamis` `related: altof-naufal` `tier: tactical`

---

## Replies / Decisions Owed (people waiting on me)

- [ ] **Gitesh** — propose 5 additional countries (after Egypt, SA, KSA, Ethiopia + Nigeria pending). Source from country prioritization sheet.
  - `created: 2026-04-21` `status: in-progress` `related: 04_Global_Expansion, gitesh`

- [ ] **Nawaz (WorldPay group DM `C0B1GRBN4LR`)** — top 10 countries for WorldPay underwriting. Need to ask before delivering: live/licensed markets vs net-new via Labuan.
  - `created: 2026-04-30` `status: pending` `related: 09_WorldPay_PSP_Onboarding, mohamed-nawaz`

- [ ] **Nashit (Zendesk SDK Migration)** — confirm PRD approved and Sprint 11 build is on track (Confluence page 1134755888).
  - `created: 2026-04-22` `status: in-progress` `related: 03_Zendesk_SDK_Migration, nashit-syed`

- [ ] **Altof** — confirm Product Coverage Confluence page before broader share.
  - `created: 2026-04-25` `status: awaiting-reply` `related: altof-naufal`

- [ ] **Arundathi (cards txn statement filter)** — confirmed scope to add filter for cards in universal txn history. Loop back when SoA scope ships.
  - `created: 2026-04-22` `status: pending` `related: 02_Statement_of_Account, arundathi-belur`


- [ ] **Approve Salman's + Siddique's Figma access to Travel Rules file.** Requests came via Figma on May 4.
  - `created: 2026-05-04` `status: pending` `related: 07_Travel_Rule, salman-khan, siddique-afridi`

- [ ] **Ping Raafi directly with feedback** to maintain open communication line. From May 5 1:1.
  - `created: 2026-05-05` `status: pending` `related: mohammad-raafi-hossain, leadership-transitions` `tier: tactical`

- [ ] **Fee transparency issue (Kashmala, #product-cs-team).** Users see 1% fee but are charged 1% + $0.54 platform fee. Needs breakdown on the fee screen. Raafi endorsed May 7. Kashmala pinged Hamis directly for update on May 8 00:20 PKT. Siddique tagged — design exists but hidden. Someone needs to create a ticket.
  - `created: 2026-05-06` `status: pending` `related: 01_Global_USD_Account, kashmala-ahmad, siddique-afridi` `tier: strategic`

- [ ] **Kashmala asking for Keel restricted countries list (#product-cs-team, May 8).** Also asking if Kenya and Nigeria are no longer restricted. Hamis tagged. Answer directly for Keel side; route Rain/card side to Arundathi.
  - `created: 2026-05-08` `status: pending` `related: 04_Global_Expansion, kashmala-ahmad, keel` `tier: tactical`

- [ ] **USD Account balance showing as "Trading Balance" and "Cash" under Investments.** Duplicating and inflating home page value. Malik Danish reported in #bugs-reporting May 6, tagged Taha.
  - `created: 2026-05-06` `status: pending` `related: 01_Global_USD_Account, malik-danish, taha-farooq`

- [ ] **Card billing address visibility.** HOR-663 and HOR-664 created May 13 (Inayat Ullah) — covering both new card creation and existing users. Tracking delivery.
  - `created: 2026-05-07` `status: in-progress` `owner: Arundathi (Hamis FYI)` `related: Radar/Card_Strategy.md, arundathi-belur, kashmala-ahmad`

- [ ] **Roadmap 2/2 H1 outcomes — confirm lead assignments.** Meeting ran today at 11:00 PKT. No transcript yet. Confirm which compliance items (Travel Rule, Bahrain SoA) got sprint owners and lead assignments.
  - `created: 2026-05-07` `status: pending` `deadline: 2026-05-11` `related: sprint-state, hina-aziz, zane-motiwala` `tier: strategic`

- [ ] **Follow up on Yazan Samara (Compliance) Labuan card-issuing scope.** Hamis asked what Labuan license allows on card issuing — direct Mastercard relationship potential. Yazan checking Labuan. VARA confirmed not to allow it.
  - `created: 2026-05-08` `status: awaiting-reply` `related: 06_Card_Strategy, yazan-samara` `tier: strategic`

---

## Due Contract Negotiation (Resolved)

Production blocked on Annex II signature.

- [ ] **Plot the contract for scale** (per-customer cost feasibility, fee spread to users). Still relevant for Due pricing decisions.
  - `created: 2026-04-29` `status: pending` `related: due`

- [ ] **Call Malik Danish on PK launch pricing** + sync on internal pricing structure.
  - `created: 2026-04-29` `status: pending` `related: due, malik-danish`

- [ ] **Build internal process to deactivate Due dormant users before Y2 anniversary** — Due will expose an API. Operationalize this so the $0.35/user/Y2 fee doesn't accrue on inactive accounts.
  - `created: 2026-05-05` `status: pending` `related: due`

- [ ] **PEP & family blanket exclusion** — push for EDD model. Not yet sent externally.
  - `created: 2026-04-29` `status: pending` `related: due`

- [ ] **Product instability** — push for 60 days' written notice on API/country changes. Not yet sent externally.
  - `created: 2026-04-29` `status: pending` `related: due`

- [ ] **Audit burdens** — push for 15-day response window + Due pays for own external auditors absent material breach. Not yet sent externally.
  - `created: 2026-04-29` `status: pending` `related: due`

- [ ] **Uncapped cash reserves** — Zane raised internally, not yet pushed back to Due.
  - `created: 2026-04-29` `status: pending` `related: due, zane-motiwala`


Source docs: `01_Global_USD_Account/Partner Docs/Due/Contracts/`. Annex I and PSA Addendum not yet in folder.

- [ ] **Review Karim's credit card 0% APR product presentation.** Shared in #credit--product May 11. Karim sent it to Faraz Adam after a call. Review for card strategy + Shariah compliance implications.
  - `created: 2026-05-11` `status: pending` `related: 06_Card_Strategy, karim-elgabry, faraz-adam` `tier: tactical`

---

## Active by Project

### 01_Global_USD_Account

- [ ] **HOR-537 (In Progress)** — USD IBAN downloadable transaction confirmation PDF (Zain). Originally raised by Tahreem. In progress as of May 12.
  - `created: 2026-04-22` `owner: Zain` `status: in-progress` `related: 01_Global_USD_Account, muhammad-zain, tahreem`

- [ ] **HOR-481 (QA)** — UAE Purpose of Payment Codes for Keel SWIFT (Fazal). Watch through to Done.
  - `created: 2026-04-15` `owner: Fazal` `status: in-progress` `related: 01_Global_USD_Account, keel`

- [ ] **User pending IBAN-to-USDT internal transfer worriness** (untracked in Jira). From #productsquad bug roundup.
  - `created: 2026-04-30` `status: pending` `related: 01_Global_USD_Account`

- [ ] **Webhook retry / stuck transaction issue** — open operational loop with Keel.
  - `created: 2026-04-22` `status: pending` `related: 01_Global_USD_Account, keel, lukasz-kosidlo`

- [ ] **AC accounts mistakenly registered as SWIFT** — validation needed.
  - `created: 2026-04-16` `status: pending` `related: 01_Global_USD_Account, keel`

### 02_Statement_of_Account

- [ ] **Get HOR-488 epic + 5 stories prioritized into a sprint.** Currently unassigned, never made it into sprint planning.
  - `created: 2026-04-25` `status: pending` `related: 02_Statement_of_Account, sprint-state`

- [ ] **SoA PRD — identify new reviewer now Ibrahim is gone.** Confluence page 1148092424. Zane is interim product lead — route to him.
  - `created: 2026-04-25` `status: pending` `related: 02_Statement_of_Account, zane-motiwala`

### 03_Zendesk_SDK_Migration

- [x] **PRD review with Ibrahim + Nashit** (Confluence 1134755888). PRD confirmed approved May 8. Tickets created: HOR-569, 570, 571, 572 (all under HOR-175 epic). ~~Closed~~

### 04_Global_Expansion

- [ ] **Propose 5 additional countries to Gitesh.**
  - `created: 2026-04-21` `status: in-progress` `related: 04_Global_Expansion, gitesh`

- [ ] **Nigeria T&C update for Rain** — unblocks card KYC re-enablement (blocked since 2024 due to Checkout.com fraud). Owner TBD — not Nashit (CX, no Rain visibility).
  - `created: 2026-04-16` `status: pending` `related: 04_Global_Expansion, rain`

- [ ] **Confirm 10 Keel-restricted countries that are NOT IBAN-disabled** — potential coverage gap. Cross-reference IBAN-disabled (33) vs Keel restricted vs Due 21 prohibited.
  - `created: 2026-04-30` `status: pending` `related: 04_Global_Expansion, keel, due`

- [ ] **Altof Product Coverage Confluence** — confirm before broader sharing.
  - `created: 2026-04-25` `status: awaiting-reply` `related: altof-naufal`

### 05_Fasset_4.5

- [ ] Design paused for unified account view. Reconnect with Siddique + Kazi when wallet architecture stabilizes.
  - `created: 2026-04-29` `status: blocked-on-architecture` `related: 05_Fasset_4.5, siddique-afridi, kazi-hasan`

### 06_Card_Strategy

- [ ] **Card operator pricing comparison** — Raafi ask. Compare pricing charged by all card operators to customers.
  - `created: 2026-04-08` `status: pending` `related: 06_Card_Strategy, rain`

- [ ] **Card issuance payment friction** — Kazi raised. Payment gateway vs USDT/wallet balance.
  - `created: 2026-04-22` `status: pending` `related: 06_Card_Strategy, kazi-hasan`

### 07_Travel_Rule

- [ ] **Spec ≥$20K crypto receipt operational + product flow with Nashit** (May 22 build deadline).
  - `created: 2026-04-29` `status: in-progress` `deadline: 2026-05-22` `related: 07_Travel_Rule, nashit-syed`

### 08_Business_Banking

- [ ] **Confirm Keel permission status for corporate entities.**
  - `created: 2026-04-16` `status: pending` `related: 08_Business_Banking, keel`

- [ ] **Define IBAN assignment requirements for corporate accounts.**
  - `created: 2026-04-16` `status: pending` `related: 08_Business_Banking`

- [ ] **Review Business Banking Website 1st iteration on Markup.io** (Abigail, Hamza).
  - `created: 2026-04-22` `status: pending` `related: 08_Business_Banking, abigail-xavier, hamza-siddiqui`

### 09_WorldPay_PSP_Onboarding

- [ ] **Clarify framing with Nawaz before delivering country list** — live/licensed markets vs Labuan-enabled net-new.
  - `created: 2026-04-30` `status: pending` `related: 09_WorldPay_PSP_Onboarding, mohamed-nawaz`

- [ ] **Deliver top 10 countries** once framing confirmed. Then Legal review, then external.
  - `created: 2026-04-30` `status: blocked-on-nawaz` `related: 09_WorldPay_PSP_Onboarding, mohamed-nawaz`

---

## Standing / Recurring

- IBAN Standup — 12:00–12:30 PKT daily (Taha organizes).
- Product Standup — 7:00 PKT daily (Zane interim).
- Sprint Planning — Fri 4:00 PKT, biweekly (Zara).
- CX & Product Feedback — Fri 5:00 PKT (Nashit). Active as of May 8 (was paused).
- Friday 1-1 with Zane (booked) — push for IBAN squad independence + clear ownership lines.

---

## Admin / Background

- [ ] **Jira admin deletion** of items I lack permission to remove: F40-708, HOR-535, FO-1462, HOR-387 (junk); HOR-490, 491, 492, 494, 495, 497, 498, 499, 501, 502, 503 (superseded SoA stories).
  - `created: 2026-05-02` `status: pending` `related: jira`

