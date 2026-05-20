# CLAUDE.md — Global USD Account

Project-specific behavioral rules for the Banking IBAN scope (Keel, Due, money movement). Cross-cutting rules live in the root `CLAUDE.md`. Project facts live in `MEMORY.md` (this folder).

## Reference Docs

When answering Keel API questions, consult `Partner Docs/Keel/KEEL_API_Documentation.md` (markdown reference) or `Partner Docs/Keel/keel_openapi.json` (raw OpenAPI spec) before responding. For Due API questions, consult `Partner Docs/Due/due_API_Documentation.md`. These are the primary sources, not summaries.

## Due Contract Documents

When the question is about Due contract terms, fees, pricing, signing, or negotiation positions, read the primary documents in `Partner Docs/Due/Contracts/` before responding. Do not rely on the `MEMORY.md` summary alone — it captures the live state of the negotiation but the source of truth for clauses, exact numbers, and obligations is the contract files themselves:

- `Fasset_Due_AnnexII_v3.docx` — Compliance Annex (most contested doc)
- `Fasset x Due Platform Service Agreement 20251215.pdf` — Main Agreement
- `[CONFIDENTIAL] Fasset __ Due _ Transaction Pricing 20250829.pdf` — pricing schedule
- Annex I and the PSA Addendum are not yet in the folder; flag this if a question depends on them.

## Country Coverage

When discussing IBAN-disabled countries or prohibited/restricted jurisdictions, cross-reference Keel's Risk Appetite Statement v5.2, Due's 21 prohibited countries, and the IBAN-disabled list maintained by Altof on Confluence. Show the overlap and the gaps explicitly.

## UAE SWIFT Transfers

Keel SWIFT transfers to the UAE require `paymentPurpose.proprietary` populated with the correct 3-char UAE POP code. 16 codes are mapped (HOR-481). Do not propose a UAE SWIFT flow that omits this field.
