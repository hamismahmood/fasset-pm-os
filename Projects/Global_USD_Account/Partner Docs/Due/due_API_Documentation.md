# Due API Documentation

> **Source:** https://due.readme.io  
> **Scraped:** all guide & reference pages


## Table of Contents

1. [Overview](https://due.readme.io/docs/overview)
2. [Postman Collection](https://due.readme.io/docs/postman-collection)
3. [API Error Codes](https://due.readme.io/docs/api-error-codes)
4. [Geo Coverage](https://due.readme.io/docs/geo-coverage)
5. [Networks and Tokens](https://due.readme.io/docs/supported-tokens)
6. [Supported Currencies & Payment Methods](https://due.readme.io/docs/supported-payment-methods)
7. [Fees](https://due.readme.io/docs/fees)
8. [Creating Accounts](https://due.readme.io/docs/creating-customers)
9. [Wallet Linking](https://due.readme.io/docs/wallets)
10. [Individual KYC Process](https://due.readme.io/docs/individual-kyc-process)
11. [Individual KYC Requirements Diagram](https://due.readme.io/docs/individual-kyc-requirements-diagram)
12. [Sumsub KYC Sharing](https://due.readme.io/docs/sumsub-kyc-sharing)
13. [Hosted KYC Submission](https://due.readme.io/docs/hosted-kyc-submission)
14. [TOS Acceptance](https://due.readme.io/docs/tos-acceptance)
15. [Rails and Channels](https://due.readme.io/docs/rails-and-channels)
16. [Recipients](https://due.readme.io/docs/recipients-1)
17. [Financial Institutions](https://due.readme.io/docs/financial-institutions)
18. [Quotes](https://due.readme.io/docs/quotes)
19. [Transfer Flow](https://due.readme.io/docs/transfer-flow)
20. [Fiat to Stablecoin (Pay-In)](https://due.readme.io/docs/fiat-to-stablecoin-transfers-pay-in)
21. [Stablecoin to Fiat (Pay-Out)](https://due.readme.io/docs/stablecoin-to-fiat-transfers-pay-out)
22. [Cross-border Transfers](https://due.readme.io/docs/cross-border-transfers)
23. [Stablecoin Swaps](https://due.readme.io/docs/stablecoin-swaps)
24. [Virtual Accounts](https://due.readme.io/docs/virtual-accounts)
25. [FX Rates](https://due.readme.io/docs/fx-rates)
26. [Schemas](https://due.readme.io/docs/schemas)
27. [Using Webhooks](https://due.readme.io/docs/using-webhooks)
28. [Webhook Incoming Events](https://due.readme.io/docs/incoming-events)
29. [Due Wallets Overview](https://due.readme.io/docs/overview-1)
30. [Create Credential](https://due.readme.io/docs/create-credential)
31. [Additional Credentials](https://due.readme.io/docs/additional-credentials)
32. [Create Due Wallet](https://due.readme.io/docs/create-due-wallet)
33. [Sign with Due Wallet](https://due.readme.io/docs/sign-with-due-wallet)
34. [Common Signing Patterns](https://due.readme.io/docs/common-signing-patterns)
35. [Python Demo Script](https://due.readme.io/docs/python-demo-script)
36. [Sign with Privy](https://due.readme.io/docs/sign-with-privy)
37. [Signing from Kernel v3 Smart Accounts](https://due.readme.io/docs/signing-due-signables-from-kernel-v3-smart-accounts)
38. [API Reference](https://due.readme.io/reference)

---


## Overview

> Source: https://due.readme.io/docs/overview

- GETTING STARTED

# Overview

## Introduction

Due provides modern (borderless) payment infrastructure for global businesses and fintechs. Our APIs make it simple to move money across borders, connect traditional finance with blockchain networks, and accept payments in both fiat and digital assets — all through a unified interface.

With Due, businesses can expand into new markets, access global payment networks, and benefit from faster, more cost-effective transfers and settlements.

Accounts API

The Accounts API is the foundation of the Due platform. It allows platforms and developers to register and manage their end-user accounts — whether businesses or individuals — and streamline onboarding through automated KYC/KYB workflows.

You can create accounts, generate onboarding links, or securely share verified identity data directly via API. Once verified, these accounts can seamlessly send, receive, hold, and convert assets through other Due APIs.

Key capabilities

- Register client accounts (individuals or businesses)

- Generate hosted KYC/KYB verification links

- Submit and verify identity data directly via API

- Retrieve account status, verification outcomes, and limits

- Attach wallets, virtual accounts, and payment methods post-approval

Example use cases

- A fintech registers new customers via embedded onboarding

- A marketplace automates business onboarding and connects each merchant to a dedicated wallet

- A PSP verifies users via API and issues local/virtual accounts automatically

Transfers API

The Transfers API powers cross-border payments and asset transfers — bridging blockchain networks with local payment systems in 80 + countries and supporting SWIFT USD/EUR/GBP payments in 150 + jurisdictions.

Developers can move between fiat and stablecoins (USDC, EURC, USDT), transfer across networks, or settle local payments directly into digital assets — all through a single endpoint.

Supported payment methods include:

- Bank transfers (ACH, SEPA, FPS, SPEI, and more)

- Crypto rails / Stablecoins (USDC, USDT, ETH, etc. across multiple networks)

- International wires (SWIFT)

- Mobile money (e.g., M-Pesa)

- QR code payments (e.g. PIX, InstaPay)

- Coming soon: Cards, Open-banking and Wallets (e.g. AliPay)

Example use cases:

- Receive NGN via bank transfer → Settle in USDC on Base (Fiat Pay-In → Stablecoin)

- Send USDC on Polygon → USD in a bank account via ACH (Stablecoin → Fiat Payout)

- Transfer USDC from Arbitrum → USDC on Starknet (Cross-Chain Transfer)

- Send MXN via SPEI → Receive GBP via Faster Payments (Cross-border FX)

- Swap EURC →  USDC in your wallet (Digital Assset Exchange)

Virtual Accounts — programmable collection infrastructure

Virtual Accounts are one of Due’s core primitives.
They enable developers to programmatically generate static payment details (for fiat or stablecoin rails) that act as persistent deposit endpoints for end-users, merchants, or businesses.

Every time funds hit a Virtual Account, Due can automatically route, convert, and settle those funds into any target currency or rail — local, international, or on-chain.

This means each account functions as a programmable collection wallet that can execute logic such as FX conversion, on-chain minting, stablecoin settlement, or payout orchestration — instantly and without manual reconciliation.

Example flows:

- Issue virtual IBANs to collect EUR → Auto-settle into a USDC wallet (Virtual Accounts)

- Issue virtual stablecoin wallets to collect USDC/ USDT →  Auto-settle into BRL PIX ( Liquidation address /  reverse Virtual Accounts)

FX API

The FX API gives you public access to Due’s live pricing engine — letting you discover available currency pairs, check real-time exchange rates and spreads, estimate conversions, and retrieve historical price data. It's ideal for surfacing transparent pricing to your users, building internal tools, or powering analytics.

What you can do:

- Get real-time FX rates and spreads for fiat ↔️ stablecoin and fiat ↔️ fiat pairs

- Fetch indicative quotes for approximate conversions

- Access historical price data

- Explore all supported FX markets via public endpoints

- No authentication required for read-only access

Example use cases:

- Show your users an indicative “you send / you receive” quote at checkout

- Monitor spreads between USDC and local currencies

- Backtest conversion strategies using historical FX pricing

- Integrate pricing into dashboards or analytics pipelines

Vault API

The Vault API gives developers the tools to programmatically create and manage wallets, signers, and credentials for end-clients — all through a secure, non-custodial architecture powered by MPC (Multi-Party Computation) technology provided by DFNS.

MPC wallets can be created and managed across major EVM blockchains — Ethereum, Arbitrum, Optimism, Base, Polygon, and Avalanche — with Starknet and Solana support coming soon.

What you can do:

- Create signers and credentials — generate secure key shares for end-clients. Due never has access to private keys or signing material.

- Deploy MPC wallets across supported blockchains and attach them to client accounts.

- Enable secure transaction signing — authorize arbitrary on-chain actions (transfers, swaps, bridges, or smart-contract interactions).

- Set up recovery and back-up keys to ensure business continuity.

- Retrieve real-time balances across currencies, assets, and networks.

- Track inflows and outflows (deposits, withdrawals, transfers) for any wallet.

Example use cases:

- Provision USDC wallets for clients to collect deposits from external wallets or settle funds from Virtual Accounts.

- Use USDC / EURC / USDT wallet balances as virtual client balances or treasury

- Execute on-chain transfers or cross-chain bridges directly via API.

- Power embedded wallets within your product without handling private keys.

Developers can also bring their own wallet infrastructure using Fireblocks, Privy, Crossmint, or Turnkey — enabling seamless interoperability across existing user wallet solutions.

## Why use Due?

🌍 One API. Global Coverage.
Access local payment rails in 80+ countries and SWIFT in over 150+ countries— no need to integrate multiple providers.

💸 Lower FX & Transfer Costs
Save 5–10x on international payment fees compared to traditional wire systems.

⚡ Instant Settlement
Enjoy real-time conversions and payments with stablecoins and select local methods. See supported rails →

📉 Transparent FX Rates
No hidden fees or unfair spreads. Just competitive, real-time pricing.

## How to get in touch?

Interested in integrating Due or exploring a partnership?
Contact us at [email protected] — we'd love to chat.

Updated7 months ago

---


---


## Postman Collection

> Source: https://due.readme.io/docs/postman-collection

- GETTING STARTED

# Postman Collection

Developers who prefer Postman can use our Postman collection — simply fork it and give it a try!

Updated4 months ago

---


---


## API Error Codes

> Source: https://due.readme.io/docs/api-error-codes

- GETTING STARTED

# API Error Codes

All errors returned by the Due API follow a consistent structure. The error_code field in the response body uniquely identifies the error type and can be used for programmatic handling.

## Error response format
{
  "error_code": "err_recipient_not_found",
  "message": "Recipient is required",
  "http_code": 400
}
## Error codes
http_codeerror_codedescription
400err_account_no_walletsAccount has no wallets created
400err_account_cannot_be_completedAccount cannot be completed in its current status
400err_credential_already_approvedThis credential has already been approved
400err_credential_not_approvedThis credential has not been approved
400err_credential_session_invalidThis session is not a registration session
400err_credential_not_ownedCredential is not owned
400err_otp_invalidInvalid OTP code
400err_otp_requiredOTP code is required
400err_signin_jwt_requiredJWT token is required
400err_token_invalidInvalid token
400err_signup_email_requiredEmail is required
400err_user_address_takenThis address is already linked to another account
400err_user_address_not_ownedThis address does not belong to your account
400err_user_password_already_setA password has already been set
400err_user_email_takenThis email is already in use
400err_webhook_endpoint_invalid_urlInvalid URL provided
400err_webhook_event_not_supportedThe specified webhook event is not supported
400err_market_history_invalid_intervalThe specified interval is invalid
400err_channel_not_foundChannel not found
400err_channel_not_foundVirtual account channel not found
400err_channel_restrictedChannel is restricted in your country
400err_channel_restricted_categoryChannel is restricted for your category
400err_channel_recipient_country_restrictedRecipient country is not supported for this channel
400err_channel_sender_requiredThis channel requires a sender
400err_channel_sender_invalid_schemaSender schema is invalid
400err_purpose_requiredPurpose code is required for this destination
400err_purpose_invalidPurpose code does not match the channel's purpose code list
400err_purpose_not_supportedPurpose code is not supported for this destination
400err_endorsement_requiredRequired endorsements are missing
400err_recipient_type_not_supportedRecipient type is not supported for this destination
400err_channel_does_not_support_disposable_accountThis channel does not support disposable accounts
400err_channel_virtual_account_creation_restrictedThis channel does not support creation of new virtual accounts
400err_kyc_not_passedKYC not passed
400err_kyc_already_passedKYC has already been passed
400err_kyc_document_requirement_not_satisfiedRequirement for a document is not satisfied
400err_kyc_questionnaire_not_answeredThe required questionnaire has not been answered
400err_kyc_questionnaire_reference_answer_not_foundReference answer not found for the specified question
400err_kyc_questionnaire_answer_not_foundAnswer is missing for the specified question
400err_policy_usage_limit_exceededUsage limit exceeded
400err_policy_3rd_party_transfer_limit_exceededThird-party transfer limit exceeded
400err_policy_transfer_limit_exceededTransfer limit exceeded
400err_policy_breachedThis transfer could not be approved due to internal compliance policy
400err_quote_limit_below_minimumThe amount is below the required minimum. Please enter a greater amount.
400err_quote_limit_below_feeFees exceeded the estimated quote. Please try again with a higher amount.
400err_quote_limit_exceededThe amount exceeds the permissible limit. Please enter a smaller amount.
400err_estimate_invalid_source_channel_typeInvalid source channel type
400err_estimate_invalid_destination_channel_typeInvalid destination channel type
400err_quote_application_fee_outside_platformApplication fee is only available for platforms
400err_quote_application_fee_one_side_onlyEither source or destination application fee can be specified, not both
400err_quote_application_fee_exceeds_internal_feeApplication fee cannot exceed the transfer fee
400err_memo_unsupportedThis payment type does not support memos
400err_memo_requiredThe memo is required for this payment method
400err_memo_invalid_lengthMemo length is outside the allowed range
400err_memo_invalid_charactersMemo must only contain alphanumeric characters and & - . /
400err_memo_repeating_characterMemo must not consist of one repeating character
400err_rail_schema_unsupportedThe destination rail does not support this schema
400err_recipient_deletedThis recipient has been deleted
400err_recipient_invalidatedThis recipient is no longer valid
400err_recipient_requiredRecipient is required
400err_tos_ip_address_requiredIP address is required
400err_transfer_invalid_destination_idInvalid destination ID
400err_transfer_invalid_sender_idInvalid sender ID
400err_transfer_invalid_amountInvalid transfer amount
400err_transfer_intent_should_be_cryptoTransfer intent must be a crypto transfer
400err_wallet_invalid_addressThis wallet address is empty or invalid
400err_transfer_intent_failureTransfer intent failure
400err_transfer_intent_already_completedThis transfer intent has already been completed
400err_transfer_intent_has_different_idA pending intent with this reference has a different ID
400err_transfer_intent_invalid_tokenInvalid transfer intent token
400err_cctp_not_configuredCCTP not configured for this network
400err_cctp_chain_not_supportedChain is unsupported
400err_cctp_not_supportedCCTP is not supported
400err_cctp_network_does_not_support_session_keyThis network does not support session key execution
400err_cctp_nonce_requiredNonce is required
400err_relay_json_rpcA JSON RPC error occurred
400err_quote_no_amountInvalid quote request: you should specify either amount in or out
400err_insufficient_balanceInsufficient balance
401err_signin_invalid_credentialsInvalid credentials
401err_signin_jwt_invalidInvalid JWT token
401err_signin_jwt_expiredJWT token has expired
401err_wallet_signin_invalid_signatureInvalid signature
403err_aml_risk_score_hitTransaction flagged by compliance check
404err_credential_missingCredential is missing
404err_sumsub_applicant_not_foundSumsub applicant not found
404err_company_formation_document_not_foundCompany formation document not found
404err_company_ownership_document_not_foundCompany ownership document not found
404err_proof_of_address_not_foundProof of address not found
404err_id_doc_not_foundIdentity document not found
404err_liveness_check_not_foundLiveness check (selfie) not found
404err_occupation_not_foundOccupation not found
404err_ip_address_not_foundIP address not found
404err_kyc_questionnaire_not_foundQuestionnaire with this template ID not found
409err_account_external_id_conflictAn account with this external ID already exists
409err_webhook_endpoint_already_existsWebhook endpoint already exists
409err_kyc_applicant_invalid_statusInvalid applicant status for this operation
409err_kyc_sharing_invalid_statusSharing is unavailable for this account due to its current KYC status
409err_kyc_sharing_state_terminalSharing reached its terminal state
409err_endorsement_already_existsEndorsement already exists
409err_kyc_root_applicant_already_existsA root applicant for this account already exists
409err_recipient_already_existsRecipient already exists
422err_platform_deactivatedPlatform is deactivated
422err_user_email_requiredUser email is required
422err_user_name_requiredUser name is required
422err_invalid_signed_agreement_idInvalid signed agreement ID
422err_kyc_sharing_invalid_account_typeOnly individual accounts are supported
422err_kyc_sharing_not_possibleSharing is not possible due to an account restriction
422err_kyc_unsupported_param_combinationThe combination of country, account type, and role is not supported
422err_kyc_submission_finalizedSubmission must be open
422err_kyc_has_open_submissionsApplicant has open submissions
422err_kyc_document_request_invalidDocument of this type and variant was not found in submission requirements
422err_kyc_validation_errorValidation error
422err_recipient_validation_failedRecipient details failed validation. Check account information and try again.
422err_tos_region_not_configuredNot configured for your region
422err_transfer_not_awaiting_fundsTransfer is not awaiting funds
422err_derived_account_not_supportedThis account does not support derivation
428err_signup_requiredSignup required
428err_bvn_requiredBVN not found

Updated14 days ago

---


---


## Geo Coverage

> Source: https://due.readme.io/docs/geo-coverage

- COVERAGE

# Geo-coverage

Due can onboard businesses and individuals in most countries worldwide. Our compliance framework adheres to international KYC / AML standards and all applicable sanctions regulations, including those issued by OFAC, the EU, UN, UK, and MAS.

Onboarding eligibility depends on jurisdictional risk, regulatory obligations, and our banking and payment network policies.

## Prohibited countries

Due is unable to onboard entities or individuals that are domiciled in, operate from, or primarily owned by persons in the following jurisdictions:

- Belarus

- Central African Republic

- Cuba

- China

- DR Congo

- Eritrea

- Iran

- Guinea-Bissau

- Iraq

- Lebanon

- Libya

- Mali

- North Korea

- Russian Federation

- Somalia

- South Sudan

- Sudan

- Syria

- Territories of Ukraine that are in dispute/ occupied by the Russian Federation, including Donbas, Donetsk, Luhansk and Crimea, and other parts of Eastern Ukraine.

- Venezuela

- Yemen

- Zimbabwe

## Industry specific restrictions

Regardless of location, Due does not support entities involved in the following industries or activities:

- Arms, defense, military

- Atomic power

- Correspondent banks

- Counterfeit goods production, trading, or distribution

- CSAM

- Human trafficking

- Illicit drug production, trading, or distribution

- Proliferation financing

- Pyramid or Ponzi schemes

- Shell companies

- Unlicensed banks

- Unlicensed gambling or betting services

- Unlicensed pharmaceuticals

- Unlicensed/unregulated remittance agents

- Wildlife trafficking

- z.Any other illicit or criminal activity

- z.Any other unlicensed companies

Updated5 months ago

---


---


## Networks and Tokens

> Source: https://due.readme.io/docs/supported-tokens

- COVERAGE

# Networks and Tokens

Outlines the blockchain networks and tokens (assets) supported

Transfers support

Network

Tokens

Arbitrum

USDC, USDT

Base

USDC, EURC, BRLA

Optimism

USDC

Polygon

USDC, USDT

Ethereum

USDC, USDT, EURC, BRLA

Starknet

USDC

Tron

USDT

Avalanche

USDC

Solana

USDC, EURC, USDT,

USDG coming soon

Tempo

USDC

Plasma

USDT

BNB Chain (beta)

USDTcoming soon

Stable (beta)

USDTcoming soon

USDT is no available for clients in EU*

Updated26 days ago

---


---


## Supported Currencies & Payment Methods

> Source: https://due.readme.io/docs/supported-payment-methods

- COVERAGE

# Supported Currencies & Payment Methods

## Virtual Accounts

Due offers borderless virtual accounts, or local payment details unique to your account, that can be used to collect/receive payments locally. Virtual accounts are available for:

Live:・AED・BRL・EUR・GBP・MXN・NGN・USD Local (ACH/Wire/RTP)・USD SWIFT・PHP・COP
CurencyRailsAccount detailsPayouts
AEDIPP/ FTSNamedNamed (beta)
BRLPIX/ TEDQR code/ Pix-keyDue-named
EURSepa/ Sepa InstantDue-named (Named coming Q2 2026)Named coming Q2 2026
GBPFP/ BACS/ CHAPSDue-named (Named coming Q2 2026)Named coming Q2 2026
USDACH/WireNamedNamed
USDSWIFTNamedNamed
COPBRE-BQR Code / Breb-KeyDue-named
MXNSPEICLABEDue-named
NGNNIPNubanDue-named

You can also create virtual accounts for supported stablecoins on Ethereum, Arbitrum, Base, OP, Polygon, Avalanche Solana and Tron.

Coming Soon:   ・ARS・PEN・SGD・CAD・KES・GHS・IDR・VND・EGP・AUD・HKD

## Global Transfers
CurrencyDirectionPayment methodsSettlement timeLimit per tx
USDCBothEth, Arbitrum, Base, OP, Polygon, Avalanche, Starknet, Solana, TempoInstant-
USDTBothEthereum, Tron, PlasmaInstant-
EURCBothEthereum, BaseInstant-
BRLABothEthereum, BaseInstant
USDPay-inSWIFT (Global)T+1 to T+3-
USDPayoutSWIFT (Global)T+1 to T+3-
EURPayoutSWIFT (Global)T+1 to T+3-
GBPPayoutSWIFT (Global)T+1 to T+3-

## Europe Transfers
CurrencyDirectionPayment methodsSettlement timeLimit per tx
EURPay-inSEPA InstantInstant€100,000
EURPay-inSEPA CreditT+0 to T+1-
EURPayoutSEPA InstantInstant€100,000
EURPayoutSEPA CreditT+0 to T+1-
GBPPay-inFaster PaymentsInstant£1,000,000
GBPPay-inBACST+0 to T+1-
GBPPayoutFaster PaymentsInstant£1,000,000
GBPPayoutBACST+0 to T+1-
DKKPayoutLocal wireT+0-
NOKPayoutLocal wireT+0-
PLNPayoutLocal wireT+0-

## Americas Transfers
CurrencyDirectionPayment methodsSettlement timeLimit per tx
BRLPay-inPIXInstant-
BRLPayoutPIXInstant-
BOBPayoutLocal wireT+0BOB10,000,000
CADPayoutEFTT+0, T+1CA$600,000
CLPPayoutLocal wireT+1CLP89,000,000
COPPay-inBRE-BInstant-
COPPayoutBRE-BInstant to T+1-
CRCPayoutLocal wireInstant₡13,510,000
CRCPayoutPakoInstant₡540,800
DOPPayoutLocal wireT+1-
DOPPayoutBilletInstantRD$70,000
GTQPayoutLocal wireT+0Q58,605
GTQPayoutTigo MoneyInstantQ20,000
HNLPayoutLocal wireT+0L184,488
JMDPayoutLocal wireT+0-
JMDPayoutDigicelInstantJ$75,000
MXNPay-inSPEIInstant-
MXNPayoutSPEIInstant-
USD (US)Pay-inFedWire<2 hr-
USD (US)Pay-inRTP/FedNowInstant-
USD (US)Pay-inACHT+0 to T+1-
USD (US)PayoutFedWire<2 hr-
USD (US)PayoutRTP/FedNowInstant-
USD (US)PayoutACHT+0 to T+1-
USD (Ecuador)PayoutLocal wireT+0-
USD (El Salvador)PayoutLocal wireT+0$7,500
USD (El Salvador)PayoutTigo MoneyInstant$1,850
UYUPayoutLocal wireT+1U$5,000,000

## Africa Transfers
CurrencyDirectionPayment methodsSettlement timeLimit per tx
EGPPayoutLocal wireT+0-
GHSPay-inBank TransferInstantGHS 1,000,000
GHSPayoutBank TransferInstantGHS 1,000,000
KESPay-inM-PesaInstantKES 999,999
KESPayoutM-PesaInstantKES 999,999
NGNPay-inBank TransferInstant₦50,000,000
NGNPayoutBank TransferInstant₦50,000,000
RWFPay-inMobile MoneyInstantRWF 2,000,000
RWFPayoutMobile MoneyInstantRWF 2,000,000
SLEPay-inMobile MoneyInstantSLE 15,000
SLEPayoutMobile MoneyInstantSLE 15,000
TZSPay-inMobile MoneyInstantTZS 5,000,000
TZSPayoutMobile MoneyInstantTZS 5,000,000
UGXPay-inMobile MoneyInstantUGX 5,000,000
UGXPayoutMobile MoneyInstantUGX 5,000,000
XAFPay-inMobile MoneyInstantXAF 500,000
XAFPay-inLocal wireT+0 to T+1-
XAFPayoutMobile MoneyInstantXAF 500,000
XAFPayoutLocal wireT+0 to T+1-
XOFPay-inMobile MoneyInstantXOF 2,000,000
XOFPayoutMobile MoneyInstantXOF 2,000,000
ZMWPay-inMobile MoneyInstantZMW 20,000
ZMWPayoutMobile MoneyInstantZMW 20,000

## APAC & ME Transfers
CurrencyDirectionPayment methodsSettlement timeLimit per tx
AEDPay-inIPPInstantAED 50,000
AEDPay-inFTS<2 hr-
AEDPayoutIPPInstantAED 50,000
AEDPayoutFTS<2 hr-
AUDPayoutLocal wireT+0-
CNYPayoutLocal wireT+3-
CNYPayoutWeChatPayInstant¥50,000
CNYPayoutAliPayInstant¥50,000
HKDPayoutFPSInstant-
INRPayoutUPI / IMPSInstant-
IDRPay-inBI-FAST--
IDRPayoutBI-FASTInstantBased on Beneficiary Bank
ILSPayoutLocal wireT+1₪25,000
JPYPayoutLocal wireT+0JP¥1,000,000
KRWPayoutLocal wireInstant to T+1-
MYRPayoutRPP/ DuitNowInstant to T+1RM1,000,000
NZDPayoutLocal wireT+0-
PHPPay-inInstapay (banks + e-wallets)Instant₱50,000
PHPPay-inPesonet (banks + e-wallets)T+0 to T+1₱10,000,000
PHPPayoutInstapay (banks + e-wallets)Instant₱50,000
PHPPayoutPesonet (banks + e-wallets)T+0 to T+1₱10,000,000
PKRPayoutRaastInstant-
SARPayoutSarie InstantInstant to T+0-
SGDPayoutFASTInstantSGD200,000
THBPayoutPromptPayInstant฿49,999 - ฿9,999,999
TRYPayoutFASTInstant₺100,000
TRYPayoutEFTT+0 to T+1-
VNDPayoutNAPASInstant₫500,000
VNDPayoutNAPASInstant to T+0-
VNDPayoutE-walletsInstant₫50,000

## Coming Soon Corridors
CurrencyDirectionPayment methodsSettlement timeLimit per tx
ARSBothCBU/CVU & Transferencias 3.0Instant-
TRYPay-inFASTInstant₺100,000
TRYPay-inEFTT+0 to T+1-
CADPay-inEFTInstant to T+0-
CADPayoutInteracInstant
USDPayoutVenmo/ PaypalInstant
SGDPay-inFAST--
KESPay-inRTGST+0 to T+1-
KESPayoutRTGST+0 to T+1-
RWFPay-inLocal wireT+0 to T+1-
RWFPayoutLocal wireT+0 to T+1-
PENPay-inLocal wireT+0 to T+1-
PENPayoutLocal wire<1 hr-
TZSPay-inLocal wireInstant-
TZSPayoutLocal wireInstant-
UGXPay-inLocal wireT+0 to T+1-
UGXPayoutLocal wireT+0 to T+1-
VNDPay-inLocal wireInstant to T+0TBU
ZARPay-inEFTInstant-
ZARPayoutEFTInstant-

Updated6 days ago

---


---


## Fees

> Source: https://due.readme.io/docs/fees

- COVERAGE

# Fees

### Onchain payouts

All on-chain payouts are free — including cross-chain payouts (bridging assets across networks).

### Fiat transfers and conversions

Fiat payout, pay-in and conversion fees vary depending on the payment method, currency, and corridor.

For tailored pricing, please:

Book a demo via https://crm.due.dev/book/demo or say hi via [[email protected]]

### Application fee subsidies

You can now use applicationFeeBps and applicationFeeAmount to fully or partially subsidise Due fees, including FX fees.

This lets your platform either:

- Add markup on top of Due fees

- Reduce or fully cover Due fees by using negative application fee values

How it works for virtual accounts

For virtual accounts, the combined variable fee cannot be negative:

fxMarkupBps + sourceChannelBps + destinationChannelBps + applicationFeeBps >= 0

This means:

- A negative applicationFeeBps can fully or partially offset Due markup in basis points

- applicationFeeAmount works the same as before and must be less than sourceChannelFeeAmount

How it works for quotas

For quotas, validation is based on the total subsidised amount.

The total subsidy from applicationFeeAmount and applicationFeeBps cannot exceed Due’s fee. Your platform can cover the fee in full, but not more than that.

Example: valid subsidy

If Due’s fee is $5 and:

applicationFeeAmount = -2,
applicationFeeBps = -$1,
then the total subsidy is $3.

This is valid because the subsidy does not exceed the $5 fee.

Updated5 days ago

---


---


## Creating Accounts

> Source: https://due.readme.io/docs/creating-customers

- Account Management

# Creating accounts

# Accounts

The Accounts resource represents the core entity in Due.
An account can be:

- Business – registered company, merchant, or platform

- Individual – freelancer, sole trader, or personal account

Every payment, balance, and compliance flow in Due is linked to an account.

When you create an account, you immediately get:

- KYC/KYB link – to verify identity or company details

- Terms of Service link – for accepting the ToS & Privacy Policy before transacting

---

## Core Concepts

- 
Account Types

- business → For companies and legal entities.

- individual → For natural persons.

- 
Country Codes

- Must follow ISO 3166-1 alpha-2 (e.g., BR, GB, US).

- 
Categories

- Must be selected from Due’s allowed list (e.g., accounting_bookkeeping, ecommerce, consulting).

- Lists differ for business and individual accounts — use Get account categories to retrieve the actual data.

- 
KYC / KYB Process

- 
Response includes kyc.link — append it to the appropriate base URL with app.* prefix :

- Sandbox → https://app.sandbox.due.network

- Production → https://app.due.network

- 
Example:
https://app.due.network/api/bp/redirect/kyc/sumsub/sumsub_xXxExampleId12345

- 
Terms of Service Acceptance

- 
Response includes tos.link.

- 
Append to the base URL and optionally add a redirect:
https://app.due.network/tos/ta_exampletosid12345?redirect=https%3A%2F%2Fyourapp.com%2Fonboarding%2Fsuccess

- 
KYC Status Values

- pending – Not yet reviewed.

- passed – Approved.

- resubmission_required – Needs additional documentation.

- failed – Verification failed.

- 
Authentication

- 
All calls require:
Authorization: Bearer your_api_key

---

## Create Account

JSON
curl --request POST \
  --url https://api.due.network/v1/accounts \
  -H "Authorization: Bearer your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "business",
    "name": "Rio Co",
    "email": "[email protected]",
    "country": "BR",
    "category": "accounting_bookkeeping"
  }'
Parameters
FieldTypeRequiredDescription
typestring✅Allowed values: business, individual.
namestring✅Legal name of the account holder or company.
emailstring✅Contact email address.
countrystring✅ISO-2 country code.
categorystring❌Category from Due’s allowed list.

---

Example Response – Production (Redacted & Randomised)
{
  "id": "acct_XyZpT7HhAJFq12345",
  "type": "business",
  "name": "Rio Co.",
  "email": "[email protected]",
  "country": "BR",
  "category": "accounting_bookkeeping",
  "status": "active",
  "statusLog": [
    {
      "status": "onboarding",
      "timestamp": "2025-08-10T09:21:06.000Z"
    },
    {
      "status": "active",
      "timestamp": "2025-08-10T09:22:13.000Z"
    }
  ],
  "kyc": {
    "status": "passed",
    "link": "/api/bp/redirect/kyc/sumsub/sumsub_ExAmPlE123456"
  },
  "tos": {
    "id": "ta_AbCdEf123456",
    "entityName": "Due Brasil Ltda",
    "status": "accepted",
    "link": "/tos/ta_AbCdEf123456",
    "documentLinks": {
      "tos": "https://****.s3.eu-west-2.amazonaws.com/documents/tos/TOS.pdf",
      "privacyPolicy": "https://****.s3.eu-west-2.amazonaws.com/documents/tos/PP.pdf"
    },
    "acceptedAt": "2025-08-10T09:22:13.000Z"
  }
}
---

## Get Account by ID

Retrieves full account details, including status history, KYC status, and ToS acceptance.
curl --request GET \
  --url https://api.due.network/v1/accounts/acct_XyZpT7HhAJFq12345 \
  -H "Authorization: Bearer your_api_key"
Example Response
{
  "id": "acct_XyZpT7HhAJFq12345",
  "type": "business",
  "name": "Rio Co.",
  "email": "[email protected]",
  "country": "BR",
  "category": "accounting_bookkeeping",
  "status": "active",
  "statusLog": [
    {
      "status": "onboarding",
      "timestamp": "2025-08-10T09:21:06.000Z"
    },
    {
      "status": "active",
      "timestamp": "2025-08-10T09:22:13.000Z"
    }
  ],
  "kyc": {
    "status": "passed",
    "link": "/api/bp/redirect/kyc/sumsub/sumsub_ExAmPlE123456"
  },
  "tos": {
    "id": "ta_AbCdEf123456",
    "entityName": "Due Brasil Ltda",
    "status": "accepted",
    "link": "/tos/ta_AbCdEf123456",
    "documentLinks": {
      "tos": "https://****.s3.eu-west-2.amazonaws.com/documents/tos/TOS.pdf",
      "privacyPolicy": "https://****.s3.eu-west-2.amazonaws.com/documents/tos/PP.pdf"
    },
    "acceptedAt": "2025-08-10T09:22:13.000Z"
  }
}
---

## List Accounts

Lists all accounts linked to your API key.
# List active accounts
curl -H "Authorization: Bearer your_api_key" \
https://api.due.network/v1/accounts

# List all accounts, including inactive
curl -H "Authorization: Bearer your_api_key" \
"https://api.due.network/v1/accounts
Example Response
[
  {
    "id": "acct_XyZpT7HhAJFq12345",
    "type": "business",
    "name": "Rio Co.",
    "email": "[email protected]",
    "country": "BR",
    "status": "active"
  },
  {
    "id": "acct_QwErTyUiOp123456",
    "type": "individual",
    "name": "Jane Doe",
    "email": "[email protected]",
    "country": "US",
    "status": "onboarding"
  }
]
---

## Best Practices

- Create accounts early in your onboarding flow so users can complete KYC and accept ToS without delay.

- Always store theaccount.id — all transactions reference it.

- Poll or subscribe to webhooks for KYC status updates.

- Use the redirect query parameter on ToS URLs to send users back into your application post-acceptance.

Updated5 months ago

---


---


## Wallet Linking

> Source: https://due.readme.io/docs/wallets

- Account Management

# Wallet linking

# Link wallets to an account

Before an account can move money to or from any blockchain wallet (external or a Due wallet), the wallet must be linked to that account. Linking also enables Due to monitor and screen the wallet for compliance.

---

## Endpoints

- 
Create wallet (link)POST /v1/wallets
Links a wallet to the account.

Headers

- Authorization: Bearer <token>

- Accept: application/json

- Content-Type: application/json

- Due-Account-Id: <account_id>(required)

Body (evm)
{
  "address": "evm:0x1b7b5e051497f526ed41d177Bef603d51320322D"
}
Body (starknet)
{
  "address": "starknet:0x0322142e7b058c6a051d7a298e99ed9b8b5c6a5e3e4e689237a37b570287d2d3"
}
cURL
curl --request POST https://api.due.network/v1/wallets \
  --header "Authorization: Bearer $DUE_API_KEY" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --header "Due-Account-Id: acct_123" \
  --data '{ "address": "evm:0x1b7b5e051497f526ed41d177Bef603d51320322D" }'
Result

- 200 OK with the newly linked wallet record.

---

- 
List walletsGET /v1/wallets
Returns all wallets linked to the account (external and Due-issued).

Headers

- Authorization: Bearer <token>

- Accept: application/json

- Due-Account-Id: <account_id>(required)

cURL
curl --request GET https://api.due.network/v1/wallets \
  --header "Authorization: Bearer $DUE_API_KEY" \
  --header "Accept: application/json" \
  --header "Due-Account-Id: acct_123"
Result

- 200 OK with an array of wallet records linked to the account.

---

## Typical flow

- 
Link the wallet the account will use:

- External wallet → call Create wallet with its address.

- Due wallet → create/obtain the Due wallet, then ensure it’s linked (same endpoint).

- 
Verify it’s linked with List wallets.

- 
Move funds using Transfers API, input wallet_id  into the destination or sender fields;

Updated7 months ago

---


---


## Individual KYC Process

> Source: https://due.readme.io/docs/individual-kyc-process

- KYC

# Individual KYC process

# Core concepts

- The account KYC process is built around submissions, which are essentially sessions with requirements and data you put into them.

- After fulfilling all requirements, a submission may be closed and becomes uneditable.

- After the submission has been reviewed, the applicant becomes active.

- If new data is required, a new submission may be created for an applicant.

In this guide, we'll cover the KYC process for an individual account.

# Create an account

You want to call the create account endpoint first if you have not done it yet.
curl --request POST \
     --url https://api.due.network/v1/accounts \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>' \
     --header 'content-type: application/json' \
     --data '
{
  "type": "individual",
  "name": "John Snow",
  "email": "[email protected]",
  "country": "GB",
  "category": "employed"
}
'
Grab the id from the response - this is the ACCOUNT_ID.
{
    "id": "acct_DlsiOQ7RxG1hgJVL",
    // ...
}
# Initiate the KYC process
curl --request POST \
     --url https://api.due.network/v1/kyc \
     --header 'Due-Account-Id: <ACCOUNT_ID>' \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>'
This will return a submission entity containing all the requirements you need to fulfill.
{
  "id": "ksub_hvwkgs0ATW36rTpw",
  "applicantId": "acct_DlsiOQ7RxG1hgJVL",
  "status": "open",
  "reason": "initial",
  "requirements": [
    {
      "kind": "static",
      "info": [...],
      "documents": [...],
      "questionnaires": [...]
    },
    {
      "kind": "conditional",
      "if": [...],
      "then": [...]
    },
    {
      "kind": "oneOf",
      "oneOf": [...]
    }
  ],
  "documents": [],
  "questionnaires": []
}
The id field would be the SUBMISSION_ID.

# Understanding requirements

Want a visual overview? See the Individual KYC requirements diagram for the current verification flow without diving into the schema structure.

Note: The tax residence country used to determine applicable requirements is derived from the country field provided when creating the account.

The requirements field contains an array of requirement objects. The structure is uniform across all requirement types, allowing for flexible and composable verification flows.

Note: Examples in this documentation are illustrative and may not reflect actual requirements. Always refer to the requirements returned by the API for your specific account.

### Top-level structure

The requirements array uses AND logic — every item in the array must be satisfied for the submission to be complete.

### Requirement kinds

Each requirement object has a kind field indicating its type:
KindDescription
staticAlways required. Contains info, documents, and/or questionnaires fields.
conditionalOnly required when a condition is met. Contains if and then fields.
oneOfExactly one of the options must be satisfied. Contains a oneOf array.

### Static requirements

Static requirements are always required regardless of any conditions.
{
  "kind": "static",
  "info": [
    {
      "key": "firstName",
      "type": "string"
    },
    {
      "key": "lastName",
      "type": "string"
    }
  ],
  "documents": [
    {
      "category": "ID",
      "oneOf": [
        { "type": "PASSPORT" },
        { "type": "ID_CARD", "variants": ["FRONT_SIDE", "BACK_SIDE"] }
      ]
    }
  ],
  "questionnaires": [
    {
      "templateId": "pep_sanctions",
      "questions": [...]
    }
  ]
}
### Conditional requirements

Conditional requirements are only required when the if condition is satisfied. The if field contains an array of requirements (using AND logic) that act as the condition. The then field contains an array of requirements to fulfill when the condition is met.
{
  "kind": "conditional",
  "if": [
    {
      "kind": "static",
      "documents": [
        {
          "category": "ID",
          "oneOf": [
            { "type": "PASSPORT" }
          ]
        }
      ]
    }
  ],
  "then": [
    {
      "kind": "static",
      "info": [
        {
          "key": "passportExpiryDate",
          "type": "date",
          "required": true
        }
      ]
    }
  ]
}
In this example, the passportExpiryDate field is only required if a PASSPORT is provided.

### OneOf requirements

OneOf requirements allow the applicant to satisfy exactly one of the provided options.
{
  "kind": "oneOf",
  "oneOf": [
    {
      "kind": "static",
      "info": [
        {
          "key": "address",
          "type": "object",
          "fields": [
            { "key": "country", "type": "iso3166_1_alpha2" },
            { "key": "postCode", "type": "string" },
            { "key": "town", "type": "string" },
            { "key": "street", "type": "string" }
          ]
        }
      ]
    },
    {
      "kind": "static",
      "documents": [
        {
          "category": "PROOF_OF_ADDRESS",
          "oneOf": [
            { "type": "UTILITY_BILL" },
            { "type": "OTHER" }
          ]
        }
      ]
    }
  ]
}
In this example, the applicant can either provide a structured address or upload a proof of address document.

### Nesting

Requirements can be nested. For example, a conditional requirement's then clause can contain oneOf requirements, and vice versa. This allows for complex verification flows while maintaining a uniform structure.

### Document structure

The documents array describes required documents grouped by category. Each category contains a oneOf array listing acceptable document types.
{
  "category": "ID",
  "oneOf": [
    { "type": "PASSPORT" },
    { "type": "ID_CARD", "variants": ["FRONT_SIDE", "BACK_SIDE"] },
    { "type": "RESIDENCE_PERMIT", "variants": ["FRONT_SIDE", "BACK_SIDE"] }
  ]
}
The variants field indicates which parts of a document need to be uploaded. If no variants are specified, a single upload is expected.

# Provide applicant information

From the requirements, identify all info fields across static and applicable conditional requirements:
curl --request POST \
     --url https://api.due.network/v1/kyc/submissions/<SUBMISSION_ID>/info \
     --header 'Due-Account-Id: <ACCOUNT_ID>' \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>' \
     --header 'content-type: application/json' \
     --data '
{
  "firstName": "John",
  "lastName": "Snow",
  "dob": "1980-01-01",
  "phone": "+440000000000",
  "taxResidenceCountry": "GB"
}
'
# Add verification documents

### Step 1: Request document upload token

To upload a document, request a token specifying the document type, issuing country, and filename.
curl --request POST \
     --url https://api.due.network/v1/kyc/submissions/<SUBMISSION_ID>/documents \
     --header 'Due-Account-Id: <ACCOUNT_ID>' \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>' \
     --header 'content-type: application/json' \
     --data '
{
  "type": "PASSPORT",
  "issuingCountry": "GB",
  "filename": "passport.jpg"
}
'
For documents with variants, include the variant field:
{
  "type": "ID_CARD",
  "variant": "FRONT_SIDE",
  "issuingCountry": "GB",
  "filename": "id_card_front.jpg"
}
This returns a token for uploading:
{
    "token": "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9..."
}
### Step 2: Upload the document
curl --request POST \
     --url https://api.due.network/v1/kyc/submissions/documents/<TOKEN> \
     --header 'Due-Account-Id: <ACCOUNT_ID>' \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>' \
     --header 'content-type: image/jpeg' \
     --data-binary '@path/to/passport.jpg'
Repeat for all required documents based on the applicable requirements.

# Complete the submission

After all requirements are fulfilled, complete the submission:
curl --request POST \
     --url https://api.due.network/v1/kyc/submissions/<SUBMISSION_ID>/complete \
     --header 'Due-Account-Id: <ACCOUNT_ID>' \
     --header 'accept: application/json' \
     --header 'authorization: Bearer <API_KEY>'
After review and approval, a webhook is sent:
{
  "type": "bp.kyc.status_changed",
  "data": {
    "id": "<ACCOUNT_ID>",
    "kyc": {
      "status": "passed"
    }
  }
}
Updated4 months ago

---


---


## Individual KYC Requirements Diagram

> Source: https://due.readme.io/docs/individual-kyc-requirements-diagram

- KYC

# Individual KYC requirements diagram

flowchart TD
    Start([Start KYC])
    
    Start --> ResidenceCheck{Tax residence?}
    
    ResidenceCheck -->|EEA/GB*| POA_Required[Upload Proof
    of Address doc]
    POA_Required --> BasicInfo
    
    ResidenceCheck -->|Other| CountrySpecific{Country-specific?}
    
    CountrySpecific -->|US| SSN[Enter SSN]
    CountrySpecific -->|UM| TIN[Enter TIN]
    CountrySpecific -->|BR| CPF[Enter CPF]
    CountrySpecific -->|NG| BVN[Enter BVN]
    CountrySpecific -->|None| AddressChoice
    
    SSN --> AddressChoice
    TIN --> AddressChoice
    CPF --> AddressChoice
    BVN --> AddressChoice
    
    subgraph AddressChoice["Address Verification"]
        Addr_Choice{Choose one}
        Addr_Choice --> AddrWithCoordinates
        Addr_Choice --> POA_Doc[Upload Proof
        of Address doc]
        
        subgraph AddrWithCoordinates["Enter Address 
				and Coordinates"]
            AddrFields["• Country
            • Postal code
            • Town
            • Street"]
            CoordinatesFields["• Latitude
            • Longitude"]
        end
    end
    
    AddressChoice --> BasicInfo
    
    subgraph BasicInfo["Basic Info"]
        Info["• First name
        • Last name
        • Date of birth
        • Phone
        • Nationality"]
    end
    
    BasicInfo --> IDDoc
    
    subgraph IDDoc["ID Document"]
        ID_Choice{Choose one}
        ID_Choice --> Passport[PASSPORT]
        ID_Choice --> IDCard[ID_CARD
        front + back]
        ID_Choice --> ResPermit[RESIDENCE_PERMIT
        front + back]
    end
    
    IDDoc --> Questionnaire
    
    subgraph Questionnaire["Compliance Questions"]
        Questions["• Are you or relatives a PEP?
        • Are you facing sanctions?
        • Have you been convicted
				of a crime?"]
    end
    
    Questionnaire --> Selfie[Selfie]
    
    Selfie --> Complete([Complete])
    
    ResidenceCheck ~~~ Footnote
    Footnote["*EEA/GB includes
		EU overseas territories:
    Åland Islands,
    French Guiana, Guadeloupe,
    Martinique, Mayotte,
		Réunion, Saint Martin"]
    
    style Footnote fill:#f9f9f9,stroke:#ccc,stroke-dasharray: 5 5
Updated4 months ago

---


---


## Sumsub KYC Sharing

> Source: https://due.readme.io/docs/sumsub-kyc-sharing

- KYC

# Sumsub KYC Sharing

Import verified identity data from another Sumsub-integrated platform instead of requiring users to re-verify their identity.

## Overview

When your users have already completed KYC verification on another platform that uses Sumsub, you can import their verified data using a share token. This eliminates redundant verification while still allowing you to collect any additional information your platform requires.

How it works:

- You obtain a share token from the platform where the applicant originally completed KYC (generated via Sumsub's API)

- You call the sharing endpoint with the token and applicant info

- Due imports the available data from Sumsub and creates a KYC submission (see Individual KYC process for how to work with submissions)

- If all submission requirements are satisfied, the submission completes automatically

- If additional data is needed, a submission remains open for you to complete via the API

Note: Sharing imports data — it does not guarantee KYC approval. The applicant will still go through Due's verification process. Listen for transfers.kyc.sumsub.status_changed webhook to receive the final KYC decision.

## Important: Sumsub Data Sharing Limitations

When the response returns status: "resubmission_pending", it means some required data is missing — either because Sumsub didn't share it or because you didn't provide it in the request.

Sumsub controls what applicant data can be shared. Even if an applicant completed full KYC verification on another platform, Sumsub may not share:

- Certain document types

- Specific identity fields

- Questionnaire responses

- Verification results for particular checks

This is determined by Sumsub's policies and the original verification level. Due has no control over what data Sumsub chooses to share.

### What this means for your integration

- 
Always handle resubmission_pending — Even with a valid share token from a fully verified user, you may still need to collect additional data

- 
Don't assume sharing will succeed — The err_kyc_sharing_not_possible error means Sumsub rejected the sharing request entirely. Have a fallback to standard KYC

- 
The submission shows what's missing — When sharing partially succeeds, the submission's requirements indicate exactly what data Sumsub didn't provide and what you need to collect

## Prerequisites

- Account must be individual type (business accounts not supported)

- Account must not have an existing KYC status of passed or failed

- Valid Sumsub share token generated via Sumsub's Generate Share Token API

## Request
POST /v1/kyc/sharing/sumsub
### Headers
HeaderRequiredDescription
AuthorizationYesBearer token.
Due-Account-IdYesThe account ID to perform KYC for.

### Body
{
  "shareToken": "st_abc123...",
  "applicantInfo": {
    "nationality": "US",
    "phone": "+14155551234"
  },
  "questionnaire": {
    "templateId": "declarationsApi",
    "answers": [
      { "id": "is_pep", "value": "false" },
      { "id": "is_sanction", "value": "false" },
      { "id": "is_crime", "value": "false" }
    ]
  }
}
Required applicantInfo fields:

Due is legally required to collect the following data from applicants, which Sumsub currently cannot share:

- nationality — Country of citizenship (ISO 3166-1 alpha-2)

- phone — Contact phone number (E.164 format)

- Tax residence country — Taken from the account's country field (set when calling Create account)

### Parameters
FieldTypeRequiredDescription
shareTokenstringYesThe Sumsub share token.
applicantInfoobjectNoApplicant information. If omitted, submission will remain open for you to provide required data.
questionnaireobjectNoPre-filled questionnaire answers.

### Why provide applicantInfo and questionnaire?

The shared Sumsub data may not include all the information your platform requires. When the sharing process creates a submission, the applicantInfo and questionnaire you provide are pre-filled into that submission. This means:

- If all submission requirements are satisfied by the combination of Sumsub data + your pre-filled data, the submission completes automatically and the response returns status: "completed"

- If some requirements are still missing, the response returns status: "resubmission_pending" with a submissionId for you to complete via the submissions API

Example:

If you provide applicantInfo and questionnaire, and Sumsub shares all required documents, the submission completes automatically.

If any data is missing — whether because you didn't provide it or because Sumsub didn't share it — the response is status: "resubmission_pending" and you need to complete the submission via the API.

## Response
{
  "status": "completed",
  "submissionId": "ksub_..."
}FieldTypeDescription
statusstringcompleted or resubmission_pending
submissionIdstringSubmission ID (always present)

### Response Status Values
StatusDescriptionNext Step
completedAll submission requirements satisfied, submission completedAwait KYC decision via transfers.kyc.sumsub.status_changed webhook.
resubmission_pendingAdditional data neededComplete the submission via the submissions API.

## Completing a Pending Submission

When the response status is resubmission_pending, the submission data is also sent via the transfers.kyc.submission.created webhook (see below). To fetch the submission manually:
response = requests.get(
    f'https://api.due.network/v1/kyc/submissions/{submission_id}',
    headers={
        'Authorization': f'Bearer {access_token}',
        'Due-Account-Id': account_id
    }
)
submission = response.json()
The requirements field shows what data needs to be provided. See the Individual KYC process guide for details on completing submissions.

## Webhook Events

See Using Webhooks for general webhook setup and verification.

### transfers.kyc.submission.created

Sent when a submission is created but requirements are not fully satisfied.
{
  "id": "wh_evt__...",
  "type": "transfers.kyc.submission.created",
  "data": {
    "ownerId": "acct_...",
    "submission": {
      "id": "ksub_...",
      "applicantId": "acct_...",
      "status": "open",
      "info": {
        "nationality": "US",
        "phone": "+14155551234"
      },
      "requirements": [],
      "documents": [],
      "questionnaires": [
        {
          "templateId": "declarationsApi",
          "answers": [
            { "id": "is_pep", "value": "false" },
            { "id": "is_sanction", "value": "false" },
            { "id": "is_crime", "value": "false" }
          ]
        }
      ]
    }
  },
  "occurredAt": "2026-02-04T22:28:35.398380671Z",
  "attemptedAt": "2026-02-04T22:28:35.40067069Z"
}
## Errors
CodeHTTP StatusMessage
err_kyc_sharing_invalid_account_type422Only individual accounts are supported.
err_kyc_sharing_invalid_status409Sharing is unavailable for this account (kyc status = %status%).
err_kyc_sharing_state_terminal409Sharing reached its terminal state.
err_kyc_sharing_not_possible422Sharing is not possible.

### Error Details

err_kyc_sharing_invalid_account_type

KYC sharing is only available for individual accounts. Business accounts must use the standard KYC flow.

err_kyc_sharing_invalid_status

The account already has a completed KYC with status passed or failed. Sharing cannot override an existing KYC decision.

err_kyc_sharing_state_terminal

The sharing process encountered an unexpected state and cannot proceed. Contact support if this occurs.

err_kyc_sharing_not_possible

Sumsub does not allow this applicant's data to be shared. There are many reasons Sumsub may reject a sharing request — invalid token, applicant not eligible for sharing, compliance restrictions, and others. When this occurs, the user must complete standard KYC verification instead.

## Example Integration
RESULT=$(curl -s -X POST "https://api.due.network/v1/kyc/share/sumsub" \
  -H "Authorization: Bearer YOUR_API_KEY" \                                               
  -H "Due-Account-Id: ACCOUNT_ID" \                 
  -H "Content-Type: application/json" \                                                       
  -d '{                                                           
    "shareToken": "st_abc123...",
    "applicantInfo": {
      "nationality": "US",
      "phone": "+1234567890"
    }
  }')

STATUS=$(echo "$RESULT" | jq -r ".status")

# Step 2 - Check result
if [ "$STATUS" = "completed" ]; then
  # Submission completed — await transfers.kyc.sumsub.status_changed webhook for KYC decision
  echo "Pending review"
elif [ "$STATUS" = "resubmission_pending" ]; then
  # Some required data is missing — complete the submission
  echo "Submission ID: $(echo "$RESULT" | jq -r ".submissionId")"
  echo "Action: complete_submission"
else
  CODE=$(echo "$RESULT" | jq -r ".code")
  if [ "$CODE" = "err_kyc_sharing_not_possible" ]; then
    # Sumsub rejected sharing — fall back to standard KYC
    echo "Sharing rejected — start standard KYC"
  else
    echo "Error: $RESULT"
  fi
fi
import requests

API_BASE = "https://api.due.network"
API_KEY = "YOUR_API_KEY"

def onboard_with_shared_kyc(account_id: str, share_token: str, user_info: dict) -> dict:
    try:
        response = requests.post(
            f"{API_BASE}/v1/kyc/share/sumsub",
            headers={
                "Authorization": f"Bearer {API_KEY}",
                "Due-Account-Id": account_id,
                "Content-Type": "application/json"
            },
            json={
                "shareToken": share_token,
                "applicantInfo": {
                    "nationality": user_info["nationality"],
                    "phone": user_info["phone"]
                }
            }
        )
        response.raise_for_status()
        result = response.json()

        if result["status"] == "completed":
            # Submission completed — await transfers.kyc.sumsub.status_changed webhook for KYC decision
            return {"status": "pending_review"}

        if result["status"] == "resubmission_pending":
            # Some required data is missing — complete the submission
            return {
                "status": "incomplete",
                "submission_id": result["submissionId"],
                "action": "complete_submission"
            }

    except requests.HTTPError as e:
        error = e.response.json()
        if error.get("code") == "err_kyc_sharing_not_possible":
            # Sumsub rejected sharing — fall back to standard KYC
            return {
                "status": "sharing_rejected",
                "action": "start_standard_kyc"
            }
        raise

Updated3 months ago

---


---


## Hosted KYC Submission

> Source: https://due.readme.io/docs/hosted-kyc-submission

- KYC

# Hosted KYC Submission

We provide a hosted solution where your users complete KYC requirements through our web interface. To enable this, you generate a short-lived session token and present the resulting link to your user.

## When to use this

When you receive a transfers.kyc.submission.status_changed webhook event (or poll the get submission endpoint), the submission require your user to provide additional data. Create a session token for the relevant submission and redirect your user to the hosted flow.

Partial completion
You don't need to delegate the entire submission to the user. For example, you can programmatically submit identity documents and basic personal information via the API, leaving only the questionnaire for the user to complete. When the user opens the hosted link, they will only see the remaining unfilled steps.

## Create a session token
import requests

API_BASE = "https://api.due.network"
API_KEY = "YOUR_API_KEY"

response = requests.post(
    f"{API_BASE}/v1/kyc/sessions",
    headers={
        "Authorization": f"Bearer {API_KEY}",
        "Due-Account-Id": "<ACCOUNT_ID>",
        "Content-Type": "application/json"
    },
    json={
        "submissionId": "<SUBMISSION_ID>"
    }
)
response.raise_for_status()
token = response.json()["token"]
Response:
{
  "token": "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9..."
}
### Build the submission link

Construct the URL using the submission ID and the session token, then present it to your user:
https://app.due.network/kyc_submissions/<SUBMISSION_ID>?token=<TOKEN>
Updated26 days ago

---


---


## TOS Acceptance

> Source: https://due.readme.io/docs/tos-acceptance

- Terms of Service

# TOS Acceptance

Collect Terms of Service and Privacy Policy acceptance from your users.

## Overview

Before an account can transact, the user must accept Due's Terms of Service (TOS) and Privacy Policy. There are two ways to handle this:

- Due-hosted - Redirect the user to a Due-hosted acceptance page using the link field. Due handles presenting the documents and collecting acceptance. This is the simplest integration.

- Manual - Present the documents yourself using the documentLinks, collect the user's real IP address, and submit their acceptance via the API.

Both flows start the same way: create an account and extract the tos object from the response.

## Step 1 - Create an Account

Create an account via Create account. The response includes a tos object:
{
  "id": "acct_...",
  // ...
  "tos": {
    "id": "ta_...",
    "entityName": "DUE LTD",
    "status": "pending",
    "link": "/tos/token_1234567890",
    "documentLinks": {
      "tos": "https://link.to/terms_of_service",
      "privacyPolicy": "https://link.to/privacy_policy"
    },
    "acceptedAt": null,
    "token": "token_1234567890"
  }
}
TOS Object Fields:
FieldTypeDescription
statusstringCurrent TOS status. Either pending or accepted.
linkstringRelative URL to the Due-hosted TOS acceptance page. Use this for the hosted flow.
documentLinks.tosstringURL to the Terms of Service PDF.
documentLinks.privacyPolicystringURL to the Privacy Policy PDF.
tokenstringOne-time token used as the path parameter in the manual acceptance request.
entityNamestringName of the legal entity issuing the terms.
acceptedAtstring | nullISO 8601 timestamp of acceptance, or null if pending.

## Option A - Due-Hosted Acceptance

The simplest integration. Redirect the user to the Due-hosted acceptance page using the link field from the tos object:
https://app.due.network.network/tos/token_1234567890
Due handles everything: presenting the TOS and Privacy Policy documents, collecting the user's IP address, and recording the acceptance.

Once the user accepts, the tos.status on the account transitions to accepted.

## Option B - Manual Acceptance

If you need full control over the user experience, you can handle TOS acceptance in your own UI.

### Step 2 - Present the Documents

Display the TOS and Privacy Policy to the user using the URLs from documentLinks. These are publicly accessible S3 links to PDF documents.

Both documents must be presented before collecting acceptance:

- Terms of Service - documentLinks.tos

- Privacy Policy - documentLinks.privacyPolicy

The specific legal entity and document versions are determined by the user's country at account creation time.

### Step 3 - Collect the Client IP Address

Important: Real Client IP Required

The ipAddress parameter must contain the actual client's IP address, not the IP of any intermediate proxy, load balancer, or server.

If your application sits behind a proxy or load balancer, you need to extract the real client IP from headers such as X-Forwarded-For, X-Real-IP, or similar, depending on your infrastructure configuration.

### Step 4 - Submit TOS Acceptance

#### Request
POST /v1/tos/{token}
Path Parameters:
ParameterTypeRequiredDescription
tokenstringYesThe TOS token from Step 1.

Headers:
HeaderTypeRequiredDescription
AuthorizationstringYesBearer token.

Body:
{
  "ipAddress": "203.0.113.42"
}FieldTypeRequiredDescription
ipAddressstringYesThe real IP address of the user accepting the terms.

#### Response
{
  "id": "ta_...",
  "entityName": "DUE LTD",
  "status": "accepted",
  "link": "/tos/token_1234567890",
  "documentLinks": {
    "tos": "https://link.to/terms_of_service",
    "privacyPolicy": "https://link.to/privacy_policy"
  },
  "acceptedAt": "2026-02-04T22:26:24.30097021Z",
  "token": "token_1234567890"
}
## Retrieving TOS Data

You can retrieve the current TOS state at any time:
GET /v1/tos/{token}
Returns the same TOS acceptance object shown above.

## Webhook Events

When TOS is accepted, a tos_accepted webhook event is dispatched containing the full account object:
{
  "id": "evt_...",
  "type": "bp.tos_accepted",
  "data": {
    "id": "acct_...",
    "type": "individual",
    "name": "John Snow",
    "email": "[email protected]",
    "country": "US",
    "category": "self-employed",
    "status": "passed",
    "kyc": {
      "status": "passed",
      "link": "http://link.to/kyc",
    },
    "tos": {
      "id": "ta_...",
      "entityName": "DUE LTD",
      "status": "accepted",
      "link": "/tos/token_1234567890",
      "documentLinks": {
        "tos": "https://link.to/terms_of_service",
        "privacyPolicy": "https://link.to/privacy_policy"
      },
      "acceptedAt": "2026-02-04T22:26:24.30097021Z",
      "token": "token_1234567890"
    }
  },
  "occurredAt": "2026-02-04T22:28:35.398380671Z",
  "attemptedAt": "2026-02-04T22:28:35.40067069Z"
}
## Example integration
# Step 1 - Fetch account to get TOS data
ACCOUNT=$(curl -s -X GET "https://api.due.network/v1/accounts/ACCOUNT_ID" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json")

TOKEN=$(echo "$ACCOUNT" | jq -r ".tos.token")

echo "TOS:            $(echo "$ACCOUNT" | jq -r ".tos.documentLinks.tos")"
echo "Privacy Policy: $(echo "$ACCOUNT" | jq -r ".tos.documentLinks.privacyPolicy")"

# Step 2 - Present the document links to the user

# Step 3 - Submit TOS acceptance with the user's real IP
curl -X POST "https://api.due.network/v1/tos/$TOKEN" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"ipAddress": "203.0.113.42"}'
import requests

API_BASE = "https://api.due.network"
API_KEY = "YOUR_API_KEY"

def accept_tos(account_id: str, client_ip: str) -> dict:
    # Step 1 - Fetch account to get TOS data
    account = requests.get(
        f"{API_BASE}/v1/accounts/{account_id}",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json"
        }
    )
    account.raise_for_status()
    account = account.json()

    tos = account["tos"]
    token = tos["token"]

    # Step 2 - Present documents to user
    tos_url = tos["documentLinks"]["tos"]
    privacy_url = tos["documentLinks"]["privacyPolicy"]
    # Display these PDFs to the user in your UI

    # Step 3 - Submit TOS acceptance with the user's real IP
    response = requests.post(
        f"{API_BASE}/v1/tos/{token}",
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json"
        },
        json={
            "ipAddress": client_ip
        }
    )
    response.raise_for_status()
    result = response.json()

    if result["status"] == "accepted":
        return {
            "status": "accepted",
            "acceptedAt": result["acceptedAt"]
        }

    return {"status": "pending"}

Updated3 months ago

---


---


## Rails and Channels

> Source: https://due.readme.io/docs/rails-and-channels

- MOVE MONEY

# Rails and Channels

## Overview

Rails define the underlying transfer networks and methods available for moving money, while channels represent specific implementations of those rails with pricing, limits, and operational parameters.

## Key Concepts

### Rails

A rail represents a payment network or transfer mechanism with standardized characteristics:

- Bank networks: SEPA, SWIFT, ACH, Faster Payments

- Blockchain networks: Ethereum, Tron, Polygon, Base

- Local payment systems: PIX (Brazil), SPEI (Mexico), regional networks

- Processing speed: From instant to several business days

- Schema requirements: Technical format specifications for account details

### Channels

A channel is a specific implementation of a rail with operational parameters:

- Currency support: Which currency the channel processes

- Fee structure: Basis points (bps) + fixed fees

- Transaction limits: Minimum and maximum amounts

- Transfer direction: Deposits, withdrawals, or both

- KYC requirements: Identity verification levels needed

- Purpose Codes:  Which purpose codes are available and required for transfer creation

### Channel Types

- withdrawal: Send money out to external accounts

- deposit: Receive money with a fixed quote (time-limited)

- static_deposit: Receive money via virtual account (no quote needed)

---

## Get Available Channels

Retrieve all enabled payment channels with their specifications and pricing.
GET /v1/channels
### Response

Returns an array of available payment channels with their supported rails, currencies, fees, and capabilities.
{
  "channels": [
    {
      "rail": "sepa",
      "currencyCode": "EUR",
      "feeBps": 36,
      "feeFixed": "0.90",
      "type": "withdrawal",
      "kycLevels": [],
      "railSettings": {
        "speed": "Instant",
        "memoConfig": {
          "maxCharacters": 35,
          "minCharacters": 6
        },
        "schemas": ["bank_sepa"]
      }
    },
    {
      "rail": "ach",
      "currency_code": "USD",
      "feeBps": 30,
      "feeFixed": "0.50", 
      "type": "withdrawal",
      "kycLevels": [],
      "railSettings": {
        "speed": "1-2 days",
        "memoConfig": {
          "maxCharacters": 10,
          "minCharacters": 0
        },
        "schemas": ["bank_us"]
      },
      "purposeCodes": {
        "any": ["OTHER"],
        "individual": ["FAMILY_SUPPORT"],
        "business": ["LOAN_PAYMENT"] 
      }
    },
    {
      "rail": "ethereum",
      "currencyCode": "USDC",
      "feeBps": 0,
      "feeFixed": "0.00",
      "type": "withdrawal", 
      "kycLevels": [],
      "railSettings": {
        "speed": "Instant",
        "memoConfig": null,
        "schemas": ["evm"]
      }
    }
  ]
}
### Response Fields
FieldTypeDescription
railstringPayment rail identifier (e.g., "sepa", "ach", "tron")
currencyCodestringISO 4217 currency code or crypto symbol
feeBpsintegerFee in basis points (1 bps = 0.01%)
feeFixedstringFixed fee amount in the channel's currency
typestringChannel type: withdrawal, deposit, or static_deposit
kycLevelsarrayRequired KYC verification levels
railSettingsobjectRail-specific configuration and capabilities
purposeCodesobjectAvailable transfer purpose codes

### Rail Settings
FieldTypeDescription
speedstringExpected processing time
memoConfigobject|nullPayment reference requirements
schemasarraySupported account detail formats

### Purpose Codes
FieldTypeDescription
anyarrayPurpose codes for any type of destination
individualarrayPurpose codes for individual recipients
businessarrayPurpose codes for business recipients

### Memo Configuration
FieldTypeDescription
maxCharactersintegerMaximum memo length
minCharactersintegerMinimum memo length
requiredbooleanWhether memo is mandatory

---

## Available Payment Rails

The API supports multiple payment networks including:

- Bank transfers: SEPA (Europe), ACH/Wire (US), Faster Payments (UK), SWIFT (Global)

- Local networks: PIX (Brazil), SPEI (Mexico), MENA (Middle East), various Asian/African systems

- Cryptocurrency: Ethereum-compatible networks (USDC), Tron (USDT)

Each rail has different processing speeds, geographic coverage, and currency support. Use the /channels endpoint to see the complete list of available rails and their current specifications.

---

## Account Detail Schemas

Different payment rails require specific account detail formats when creating quotes and transfers. The schemas field in each channel's rail_settings indicates which formats are accepted for that rail.

For detailed information on schema formats, please see Schema.

Updated5 months ago

---


---


## Recipients

> Source: https://due.readme.io/docs/recipients-1

- MOVE MONEY

- Transfers

# Recipients

Recipients are payment destinations for your global transfers. Create once, use for multiple payments across traditional banking, mobile money networks, and cryptocurrency platforms.

## Core Concepts
TermDefinition
RecipientPayment destination with all required transfer details
SchemaField template for payment method (bank_us, bank_sepa, etc.)
ChannelComplete payment config (rail + currency + fees + timing + schemas)
Financial InstitutionBank/provider selection required for some schemas

## Payment Methods

- Traditional Banking - ACH, SWIFT, SEPA, Faster Payments, local rails

- Mobile Money - M-Pesa, MTN, Airtel, regional providers

- Cryptocurrency - USDC/USDT on major networks (Ethereum, Polygon, etc.)

- Get real-time channels: Use GET /channels for current fees, processing times, and availability

- Get field requirements: Use GET /schemas for up-to-date field definitions

## API Endpoints
MethodEndpointPurpose
POST/recipientsCreate new recipient
GET/recipientsList recipients (optional: include deleted)
GET/recipients/{id}Get recipient details
DELETE/recipients/{id}Delete recipient

## Create Recipients

Create a new recipient with the account details required for transfers.
POST /recipients
### Request Parameters
FieldTypeRequiredDescription
namestring✅Legal name or business name
detailsobject✅Schema-specific payment details
isExternalboolean✅Whether this is an external recipient (third-party account vs your own account)

The details object must include a schema field and conform to the specified payment schema. See Schemas for complete field definitions and validation rules.

### US Bank Transfer
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "John Smith",
  "details": {
    "schema": "bank_us",
    "bankName": "JPMorgan Chase Bank",
    "accountName": "John Smith", 
    "accountNumber": "123456789",
    "routingNumber": "021000021",
    "beneficiaryAddress": {
      "street_line_1": "123 Main Street",
      "city": "New York",
      "postal_code": "10001",
      "country": "USA",
      "state": "NY"
    }
  },
  "isExternal": true
}'
### SEPA Transfer (Europe)
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Marie Dubois", 
  "details": {
    "schema": "bank_sepa",
    "accountType": "individual",
    "firstName": "Marie",
    "lastName": "Dubois",
    "IBAN": "FR1420041010050500013M02606"
  },
  "isExternal": true
}'
### SWIFT Transfer (International)
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Singapore Tech Pte Ltd",
  "details": {
    "schema": "bank_swift",
    "accountType": "business", 
    "companyName": "Singapore Tech Pte Ltd",
    "bankName": "DBS Bank Ltd",
    "swiftCode": "DBSSSGSG",
    "accountNumber": "1234567890",
    "currency": "SGD"
  },
  "isExternal": true
}'
### African Bank (with Institution Selection)
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Adebayo Okafor",
  "details": {
    "schema": "bank_africa",
    "financialInstitutionId": "access_bank_ng",
    "accountNumber": "0123456789",
    "accountName": "Adebayo Okafor"
  },
  "isExternal": true
}'
### Cryptocurrency
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Alex Thompson", 
  "details": {
    "schema": "evm",
    "address": "0x742d35Cc6665C6c175E8c7CaB7CeEf5634123456"
  },
  "isExternal": false
}'
### Success Response
{
  "id": "recipient_1234567890abcdef",
  "label": "John Smith",
  "details": {
    "schema": "bank_us",
    "bankName": "JPMorgan Chase Bank",
    "accountName": "John Smith",
    "accountNumber": "123456789", 
    "routingNumber": "021000021",
    "beneficiaryAddress": {
      "street_line_1": "123 Main Street",
      "city": "New York",
      "postal_code": "10001",
      "country": "USA",
      "state": "NY"
    }
  },
  "isExternal": true,
  "isActive": true
}
## List Recipients
# All active recipients
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/recipients

# Include deleted recipients  
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
"https://api.due.network/v1/recipients?with_deleted=true"
## Get Single Recipient
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/recipients/{recipient_id}
## Delete Recipient
curl -X DELETE \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/recipients/{recipient_id}
## Validation Errors

When recipient creation fails due to invalid data, you'll receive a structured validation error:

Error Response (422 Unprocessable Entity):
{
  "statusCode": 422,
  "message": "Validation error",
  "code": "err_validation", 
  "details": {
    "routingNumber": "required",
    "beneficiaryAddress.street_line_1": "required"
  }
}
The details object maps field paths to the specific validation rule that failed. For complete validation rules and field requirements, see Schema.

## Duplicate Prevention

Recipients are automatically deduplicated based on their account details. If you attempt to create a recipient with identical account information to an existing recipient, you'll receive an error:

Error Response (400 Bad Request):
{
  "statusCode": 400,
  "message": "Recipient already exists", 
  "code": "err_recipient_already_exists"
}
## Financial Institution Selection

Some payment schemas require selecting a specific bank or provider before creating the recipient. For schemas like bank_africa, momo_africa, and bank_colombia, you must:

- Get available institutions for the country and schema

- Present options to your user

- Include the selected financialInstitutionId in the recipient details

For complete workflows and available institutions, see Financial Institutions.

## Important Notes

- Schema Requirements: Each payment method has specific required fields. Use /schemas endpoint or see Schemas for current requirements

- Deletion: Recipients with pending payments cannot be deleted

- Updates: Recipient details cannot be modified after creation (delete and recreate instead)

Updated9 months ago

---


---


## Financial Institutions

> Source: https://due.readme.io/docs/financial-institutions

- MOVE MONEY

- Transfers

- Recipients

# Financial Institutions

Discover and select specific banks and payment providers required for certain recipient schemas. Some payment methods require choosing from available financial institutions before creating recipients.

## Overview

Certain recipient schemas require selecting a specific financial institution (bank, mobile money provider, or payment processor) before creating the recipient. This ensures accurate routing and processing of payments through the correct provider networks.

---

## API Endpoints
MethodEndpointPurpose
GET/financial_institutions/{country}/{schema}List institutions for country and schema
GET/financial_institutions/{id}Get specific institution details

---

## Discover Required Institutions

Get the list of available financial institutions for a specific country and payment schema.
GET /financial_institutions/{country}/{schema}
### Request Parameters
ParameterTypeDescription
countrystringISO 3166-1 alpha-2 country code (NG, CO, KE)
schemastringPayment schema requiring institution selection

### Examples

Nigerian Banks:
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/financial_institutions/NG/bank_africa
Nigerian Mobile Money Providers:
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/financial_institutions/NG/momo_africa
Colombian Banks:
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/financial_institutions/CO/bank_colombia
### Response
[
  {
    "id": "fininst_qGGYZKST47dI8bRm",
    "name": "Enterprise Bank",
    "country": "NG",
    "schemas": ["bank_africa"]
  },
  {
    "id": "fininst_xyz123abc456def789",
    "name": "Access Bank Nigeria",
    "country": "NG", 
    "schemas": ["bank_africa"]
  },
  {
    "id": "fininst_mtn456def789ghi012",
    "name": "MTN Mobile Money",
    "country": "NG",
    "schemas": ["momo_africa"]
  }
]
Response Fields:

- id - Unique financial institution identifier to use in recipient creation

- name - Display name of the bank or provider

- country - ISO country code

- schemas - Supported payment schemas for this institution

---

## Creating Recipients with Financial Institutions

Once you've selected a financial institution, include the financialInstitutionId when creating recipients.

### Nigerian Bank Account
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Adebayo Okafor",
  "details": {
    "schema": "bank_africa",
    "financialInstitutionId": "fininst_qGGYZKST47dI8bRm",
    "accountNumber": "0123456789",
    "accountName": "Adebayo Okafor"
  },
  "isExternal": true
}'
### Colombian Bank Account
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Carlos Rodriguez",
  "details": {
    "schema": "bank_colombia",
    "accountType": "individual",
    "firstName": "Carlos",
    "lastName": "Rodriguez",
    "financialInstitutionId": "fininst_bancolombia_001",
    "bankAccountType": "cc",
    "accountNumber": "1234567890",
    "idType": "cc",
    "idNumber": "12345678"
  },
  "isExternal": true
}'
---

## Integration Workflow

### 1. Check Schema Requirements

Determine if a payment schema requires financial institution selection by checking in the schema list

### 2. Get the institutions

Fetch the list of institutions by schema and country

### 3. Create Recipient with Selection

Include the selected financialInstitutionId in the recipient creation request.

---

## Error Handling

### Missing Financial Institution

Error (422):
{
  "statusCode": 422,
  "message": "Validation error",
  "code": "err_validation",
  "details": {
    "financialInstitutionId": "required"
  }
}
Updated9 months ago

---


---


## Quotes

> Source: https://due.readme.io/docs/quotes

- MOVE MONEY

- Transfers

# Quotes

Get real-time pricing and exchange rates for transfers across traditional banking, mobile money, and cryptocurrency networks. Quotes provide transparent fee breakdowns, foreign exchange rates, and amount calculations for any supported rail-to-rail combination.

## Overview

Quotes calculate pricing for transfers between any two payment rails, whether you're sending a specific amount or ensuring the recipient receives an exact amount. The API supports bidirectional quoting - specify either the source amount you want to send or the destination amount the recipient should receive.

Key Features:

- Bidirectional pricing - Quote by send amount or receive amount

- Multi-rail support - Any combination of bank, mobile money, and crypto rails

- Real-time rates - Live foreign exchange rates with transparent markup

- Dual-sided fees - Separate fee calculations for source and destination rails

- Time-bound validity - Quotes expire after 2 minutes to ensure rate accuracy

---

## Create Quote

Generate a price quote for transfers between two payment rails with specified currencies and amounts.
POST /transfers/quote
### Request Parameters
FieldTypeRequiredDescription
sourceobject✅Source rail configuration
destinationobject✅Destination rail configuration

### Rail Configuration

Each rail configuration (source and destination) requires:
FieldTypeRequiredDescription
railstring✅Payment rail identifier
currencystring✅ISO 4217 currency code or crypto symbol
amountdecimal✅Transfer amount (specify in source OR destination, not both)

💡 Amount Specification: Provide the amount in either the source or destination configuration, with the other set to 0. The API prioritizes source amounts - if both amounts are provided, the source amount will be used for the quote calculation.

For available rails and currencies, see the Rails and Channels documentation.

### Send Amount Quote

Quote based on how much you want to send:
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "ethereum",
    "currency": "USDC", 
    "amount": "1000.00"
  },
  "destination": {
    "rail": "sepa",
    "currency": "EUR",
    "amount": "0"
  }
}'
### Receive Amount Quote

Quote based on how much the recipient should receive:
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "ach",
    "currency": "USD",
    "amount": "0"
  },
  "destination": {
    "rail": "bank_africa", 
    "currency": "NGN",
    "amount": "500000.00"
  }
}'
---

## Quote Response
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "source": {
    "rail": "ethereum",
    "currency": "USDC",
    "amount": "1000.00",
    "fee": "0.00"
  },
  "destination": {
    "rail": "sepa", 
    "currency": "EUR",
    "amount": "924.50",
    "fee": "3.33"
  },
  "fxRate": 0.9278,
  "fxMarkup": 50,
  "expiresAt": "2024-03-15T10:32:15Z"
}
### Response Fields
FieldTypeDescription
tokenstringJWT token representing this quote for transfer creation
sourceobjectSource rail pricing details
destinationobjectDestination rail pricing details
fxRatenumberForeign exchange rate applied
fxMarkupintegerFX markup in basis points (bps)
expiresAtstringISO 8601 timestamp when quote expires

### Rail Pricing Details
FieldTypeDescription
railstringPayment rail identifier
currencystringCurrency code
amountdecimalCalculated amount for this side
feedecimalRail-specific fees in the rail's currency

---

## Quote Expiration

Quotes are valid for 2 minutes from creation to ensure pricing accuracy, especially for volatile cryptocurrency and foreign exchange rates.

Best Practices:

- Create quotes as close to transfer execution as possible

- Monitor the expiresAt timestamp in your application

- Request new quotes if the current quote has expired

- For crypto transfers, account for potential network congestion affecting timing

Expired Quote Handling:
If you attempt to create a transfer with an expired quote token, you'll receive a validation error requiring a fresh quote.

---

## Error Responses

### Channel Not Found (404)
{
  "statusCode": 404,
  "message": "Channel not found",
  "code": "err_channel_not_found"
}
### Amount Below Fee Threshold (400)
{
  "statusCode": 400,
  "message": "Fees exceeded the estimated quote. Please try again with a higher amount",
  "code": "err_quote_limit_below_fee"
}
Updated9 months ago

---


---


## Transfer Flow

> Source: https://due.readme.io/docs/transfer-flow

- MOVE MONEY

- Transfers

# Transfer flow

Complete guide to executing transfers across traditional banking, mobile money, and cryptocurrency networks. This overview covers the universal steps required for all transfer types, with specific handling for crypto transactions that require blockchain signing.

## Overview

All transfers follow the same foundational steps regardless of transfer type. The process branches only when cryptocurrency networks are involved, requiring additional transaction signing steps for blockchain security.

Universal Steps (All Transfers):

- Discover available channels - Get supported rails and currencies

- Create payment recipients - Set up destination account details for outbound transfers

- Generate pricing quotes - Get real-time fees and exchange rates

- Create transfers - Initialize the payment with quote and recipient

- Complete transfer - Follow payment instructions or sign crypto transactions

Transfer Types:

- Fiat → Fiat: Traditional banking and mobile money transfers

- Crypto → Fiat: Cryptocurrency off-ramp to bank accounts

- Fiat → Crypto: Bank account funding to cryptocurrency wallets

---

## Step-by-Step Flow

### 1. Get Available Channels

Discover which payment rails and currencies are available for your transfers.
GET /channels
Purpose: Understand supported combinations of rails (ACH, SEPA, Ethereum, etc.) and currencies (USD, EUR, USDC, etc.) with their current fees and processing speeds.

See:Payment Channels Documentation

### 2. Create Recipients (Outbound Transfers Only)

Set up payment destinations with the required account details for your chosen rails.
POST /recipients
Purpose: Create reusable payment destinations with properly formatted account details (bank accounts, crypto addresses, mobile money accounts). Only required for outbound transfers where you're sending money to external accounts.

See:Recipients Documentation

### 3. Generate Quote

Get real-time pricing for your specific transfer amount and rail combination.
POST /transfers/quote
Purpose: Calculate exact fees, exchange rates, and amounts. Quotes are valid for 2 minutes and required for transfer creation.

See:Quotes Documentation

### 4. Create Transfer

Initialize the transfer using your quote token and recipient details.
POST /transfers
Request:
{
  "quote": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "sender": "wallet_1234567890abcdef",
  "recipient": "recipient_1234567890abcdef", 
  "memo": "Invoice #12345",
  "purposeCode": "OTHER"
}
Purpose: Create the transfer record with TransferStatusAwaitingFunds status. Transfer expires in 5 minutes.

The purposeCode field is optional and can be omitted, however, for channels including a non-empty purposeCodes object it is mandatory and has to be set to a correct value.

### 5. Transfer Completion (Branches by Type)

The final step depends on whether your transfer involves cryptocurrency networks:

#### For Fiat-to-Fiat Transfers

Follow deposit instructions provided in the transfer response to fund your transfer through banking or mobile money networks.

#### For Crypto Transfers

Create transfer intent to generate blockchain transaction data for signing:
POST /transfers/{transfer_id}/intent
Then sign and submit the blockchain transaction using your wallet infrastructure.

---

## Transfer Flow Diagram

Payout flow (crypto-fiat)

Payin flow (crypto - fiat)

---

## Transfer Types Explained

### Fiat-to-Fiat Transfers

Examples: USD ACH → EUR SEPA, mobile money transfers, domestic bank transfers

Completion: Follow the deposit instructions provided in the transfer response. This typically involves:

- Bank wire transfers with the provided routing details

- Mobile money deposits to specified accounts

- ACH transfers using the provided account information

### Crypto-to-Fiat Transfers

Examples: USDC → USD bank account, ETH → EUR SEPA transfer

Completion: Create a transfer intent to generate blockchain transaction data, then:

- Sign the transaction with your crypto wallet

- Submit the signed transaction to the blockchain network

- Monitor transaction confirmation

### Fiat-to-Crypto Transfers

Examples: USD bank → USDC wallet, EUR → ETH address

Completion: Similar to crypto-to-fiat, requiring transfer intent creation and blockchain transaction signing for the destination crypto network.

---

## Transfer status model

awaiting_funds

Indicates that a transfer has been initiated, and the system is waiting for funds to be received. At this stage, the transfer request has been created, but the funds have not yet arrived on our side.

funds_received

Indicates that the funds have been successfully received. Once the funds are received, the transfer moves to one of the following statuses:

- approved

- manual_review

approved

Indicates that the incoming transfer has successfully passed all policy checks. The transfer is now ready for payout processing. The next statuses will be:

- payment_submitted

- payment_processed

payment_submitted

Indicates that the payout request has been submitted to the payout partner and is currently being processed.

payment_processed

The final successful state of the transfer. This means that the funds were received from the client, and the payout has been completed on our side. If a transfer remains in the approved or payment_submitted status for an extended period, please contact our support.

manual_review

Indicates that the transfer did not pass automatic policy checks and requires manual review by our team. After the review is completed, the transfer will move to one of the following statuses:

- approved

- canceled

- action_required

- refund_submitted

action_required

Indicates that additional information or documents are required from the client to proceed with the transfer.

refund_submitted

Indicates that a refund process has been initiated and the funds will be returned to the sender.

refund_processed

Indicates that the refund has been completed and the funds have been returned to the sender.

failed

Indicates that the transaction has failed on the partner side. This status is set when our partner reports that the transaction could not be completed successfully. In such cases, the transfer will be handled according to internal procedures.

canceled

Indicates that the transfer has been manually canceled by our financial team. This typically happens when funds need to be returned to the sender through a manual process. After the refund is completed, the transfer status is updated to canceled.

The diagram below illustrates the transfer status flow described above.

---

## Important Timing Considerations
ComponentValidity PeriodPurpose
Quotes2 minutesEnsure rate accuracy for volatile markets
Transfers5 minutesAllow reasonable time for funding completion
Transfer IntentsVariesBlockchain-specific expiration times

Best Practices:

- Generate quotes immediately before transfer creation

- Complete crypto transaction signing promptly after intent creation

- Monitor transfer status for successful completion confirmation

Updated28 days ago

---


---


## Fiat to Stablecoin (Pay-In)

> Source: https://due.readme.io/docs/fiat-to-stablecoin-transfers-pay-in

*No content extracted (page may require JS)*


---


## Stablecoin to Fiat (Pay-Out)

> Source: https://due.readme.io/docs/stablecoin-to-fiat-transfers-pay-out

*No content extracted (page may require JS)*


---


## Cross-border Transfers

> Source: https://due.readme.io/docs/cross-border-transfers

*No content extracted (page may require JS)*


---


## Stablecoin Swaps

> Source: https://due.readme.io/docs/stablecoin-swaps

*No content extracted (page may require JS)*


---


## Virtual Accounts

> Source: https://due.readme.io/docs/virtual-accounts

- MOVE MONEY

# Virtual accounts

Generate dedicated receiving account details that automatically convert deposits between currencies and settlement methods. Provide customers with unique bank accounts, IBANs, and crypto addresses for seamless payment experiences.

## Overview

Virtual accounts create dedicated receiving details (bank accounts, crypto addresses) that automatically convert incoming deposits to your preferred settlement currency and method. Each virtual account is unique to a specific customer or use case, enabling automatic payment attribution without manual reference matching.

Key Features:

- Automatic conversion - Deposits convert instantly to your chosen settlement currency

- Unique attribution - Each virtual account maps to specific customers or purposes

- Multi-modal support - Fiat, crypto, and cross-network conversions

- Real-time settlement - Automatic delivery to your specified destination

Use Cases:

- Fiat-to-crypto on-ramps - Bank deposits auto-convert to stablecoins

- Cross-currency settlement - Accept one fiat currency, settle in another

- Crypto bridging - Receive on one network, settle on another network

- Crypto liquidation - Accept crypto deposits, settle to fiat accounts

---

## How Virtual Accounts Work

- Create virtual account - Specify input method and output destination

- Receive unique details - Get dedicated bank account, IBAN, or crypto address

- Customer deposits - Funds sent to the unique receiving details

- Automatic conversion - System converts and delivers to your settlement destination

---

## Virtual Account Types

### Fiat-to-Crypto On-Ramps

Accept traditional currency deposits, deliver stablecoins to crypto addresses.

Examples:

- EUR → USDC: Provide IBAN for Euro deposits, receive USDC on Ethereum

- USD → USDC: Provide ACH details for Dollar deposits, receive USDC on Polygon

- GBP → USDC: Provide UK account for Pound deposits, receive USDC

### Cross-Currency Settlement

Accept deposits in one fiat currency, settle to recipients in another currency.

Examples:

- MXN → EUR: Accept Mexican Peso deposits, settle Euros to European recipients

- USD → GBP: Accept Dollar deposits, settle Pounds to UK recipients

- Any supported pair: Automatic FX conversion with instant settlement

### Crypto Bridging

Accept crypto deposits on one network, deliver to addresses on different networks.

Examples:

- USDT Tron → USDC Arbitrum: Accept USDT on Tron, deliver USDC on Arbitrum

- USDC Polygon → USDC Ethereum: Cross-network stablecoin conversion

- Multi-network support: Bridge between supported blockchain networks

### Crypto Liquidation

Accept cryptocurrency deposits, automatically convert and settle to fiat accounts.

Examples:

- USDC → USD: Accept USDC deposits, settle USD to bank accounts

- USDT → EUR: Accept USDT deposits, settle EUR to SEPA recipients

- Automatic liquidation: Real-time crypto-to-fiat conversion

---

## API Endpoints
MethodEndpointPurpose
POST/virtual_accountsCreate new virtual account
GET/virtual_accountsList virtual accounts with filtering
GET/virtual_accounts/*Get virtual account by key

---

## Create Virtual Account

Generate dedicated receiving details with automatic conversion to your settlement method.
POST /virtual_accounts
### Request Parameters
FieldTypeRequiredDescription
destinationstring✅Crypto address or recipient ID for settlement
schemaInstring✅Input payment method (bank_sepa, bank_us, evm, tron)
currencyInstring✅Input currency (EUR, USD, USDC, USDT)
railOutstring✅Settlement rail (ethereum, polygon, sepa, ach)
currencyOutstring✅Output currency (USDC, EURC, EUR, USD)
referencestring✅Your unique reference for tracking

### Examples

EUR to USDC On-Ramp:
curl -X POST https://api.due.network/v1/virtual_accounts \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "destination": "wlt_e1NNNZ9HQyd01M0R",
  "schemaIn": "bank_sepa",
  "currencyIn": "EUR",
  "railOut": "ethereum",
  "currencyOut": "USDC",
  "reference": "customer_alice_eur_onramp"
}'
USDT Tron to USDC Arbitrum Bridge:
curl -X POST https://api.due.network/v1/virtual_accounts \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "destination": "wlt_e1NNNZ9HQyd01M0R",
  "schemaIn": "tron",
  "currencyIn": "USDT", 
  "railOut": "arbitrum",
  "currencyOut": "USDC",
  "reference": "customer_tron_arbitrum_bridge"
}'
USDC to USD Liquidation:
curl -X POST https://api.due.network/v1/virtual_accounts \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "destination": "{recipient_id}",
  "schemaIn": "evm",
  "currencyIn": "USDC",
  "railOut": "ach", 
  "currencyOut": "USD",
  "reference": "crypto_profits_liquidation"
}'
### Response
{
  "ownerId": "{account_id}",
  "destinationId": "wlt_e1NNNZ9HQyd01M0R",
  "schemaIn": "bank_sepa",
  "currencyIn": "EUR",
  "railOut": "ethereum",
  "currencyOut": "USDC",
  "nonce": "customer_alice_eur_onramp",
  "details": {
    "IBAN": "DE89370400440532013000",
    "bankName": "Due Payments Europe",
    "beneficiaryName": "Due Payments Europe"
  },
  "isActive": true,
  "createdAt": "2024-03-15T10:30:00Z"
}
Key Response Fields:

- destinationId - Settlement destination (crypto address or recipient ID)

- details - Receiving account details to share with depositors

- nonce - Your reference for tracking (internally stored as unique identifier)

- isActive - Whether the virtual account accepts deposits

*** Some virtual accounts are provisioned asynchronously (I.e: COP, AED, USD). When that happens, the initial create response may return "details": null" even though the account was created successfully. To get the populated account details, either:

- Poll the virtual account with a follow-up GET request

- Listen for the virtual_account.updated webhook and update your system when the provisioning finishes

---

## List Virtual Accounts

Retrieve virtual accounts with optional filtering by configuration or reference.
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
"https://api.due.network/v1/virtual_accounts?currencyIn=EUR&railOut=ethereum"
### Query Parameters
ParameterTypeDescription
destinationstringFilter by settlement destination
schemaInstringFilter by input payment method
currencyInstringFilter by input currency
railOutstringFilter by settlement rail
currencyOutstringFilter by output currency
referencestringFilter by your reference

---

## Get Virtual Account

Retrieve details for a specific virtual account by its unique key.
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/virtual_accounts/customer_alice_eur_onramp
---

## Discovering Available Configurations

Use the channels endpoint to find supported input and output combinations.
# Get available static deposit methods
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels | jq '.[] | select(.type == "static_deposit")'

# Get available settlement methods (withdrawal type)  
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels | jq '.[] | select(.type == "withdrawal")'
Updated11 days ago

---


---


## FX Rates

> Source: https://due.readme.io/docs/fx-rates

*No content extracted (page may require JS)*


---


## Schemas

> Source: https://due.readme.io/docs/schemas

- MOVE MONEY

# Schemas

Schemas define the required data structure and validation rules for different types of recipient accounts across various payment rails or geographic regions. Each schema specifies the exact fields, data types, and validation requirements needed to successfully create recipients and process transfers.

## Retrieving Available Schemas

Get all available payment schemas and their field definitions:
GET v1/schemas
Response:
[
  {
    "id": "bank_sepa",
    "category": "bank",
    "fields": [
      {
        "key": "accountType",
        "type": "string",
        "oneOf": ["individual", "business"],
        "required": true
      },
      {
        "key": "IBAN",
        "type": "iban",
        "required": true
      },
      {
        "key": "companyName",
        "type": "string",
        "requiredIf": "accountType=business"
      }
    ]
  },
  {
    "id": "evm",
    "category": "crypto",
    "fields": [
      {
        "key": "address",
        "type": "eth_addr",
        "required": true
      }
    ]
  }
]
## Understanding Schema Descriptors

Each schema descriptor contains:

- id - Unique schema identifier used when creating recipients

- category - Schema category (bank, mobile, crypto)

- fields - Array of field definitions with validation rules

### Field Properties
PropertyTypeDescription
keystringField name in JSON payload
typestringData type and validation rule
requiredbooleanWhether field is mandatory
requiredIfstringConditional requirement (e.g., "accountType=individual")
excludedUnlessstringField only allowed under condition
oneOfarrayAllowed enum values
fieldsarrayNested object fields (for type="object")

### Field Types

Common field types and their validation rules:
TypeDescriptionExample
stringText fieldAccount holder name
numericNumbers onlyAccount number, routing number
emailValid email format[email protected]
ibanValid IBAN formatGB82WEST12345698765432
bicValid BIC/SWIFT codeDEUTDEFF
sort_codeUK sort code format12-34-56
ifscIndian IFSC codeHDFC0000123
bsbAustralian BSB code123-456
clabeMexican CLABE format123456789012345678
cnapsChinese CNAPS code123456789012
eth_addrEthereum address0x742d35Cc6635C0532925a3b8D98d0dfBb67B1BF8
tron_addrTron addressTQn9Y2khEsLJW1ChVWFMSMeRDow5KcbLSE
starknet_addrStarknet address0x1234...abcd
objectNested object with sub-fieldsAddress object

## Schema Validation

When creating recipients with invalid schema data, you'll receive a structured validation error:

Error Response (422):
{
  "statusCode": 422,
  "message": "Validation error",
  "code": "err_validation",
  "details": {
    "routingNumber": "required",
    "accountNumber": "numeric",
    "beneficiaryAddress.street_line_1": "required"
  }
}
The details object maps field paths to the specific validation rule that failed. For nested objects, field paths use dot notation (e.g., beneficiaryAddress.street_line_1).

### Conditional Validation

Some schemas have conditional field requirements:

- requiredIf - Field required only when another field has specific value

- excludedUnless - Field only allowed when another field has specific value

Example: Colombian bank accounts require different fields for individual vs business accounts:
{
  "key": "firstName",
  "type": "string", 
  "requiredIf": "accountType=individual",
  "excludedUnless": "accountType=individual"
}
## Schema Categories

Schemas are organized into three main categories:

### Bank (bank)

Traditional banking payment methods including:

- Domestic bank transfers (US ACH, UK Faster Payments, etc.)

- International wire transfers (SWIFT)

- Regional payment systems (SEPA, UPI, etc.)

### Mobile (mobile)

Mobile money and digital wallet services:

- African mobile money providers

- Digital payment platforms

### Crypto (crypto)

Cryptocurrency and blockchain-based payments:

- EVM-compatible networks (Ethereum, Polygon, etc.)

- Tron network

- Starknet

Updated7 months ago

---


---


## Using Webhooks

> Source: https://due.readme.io/docs/using-webhooks

- Webhook notifications

# Using Webhooks

### Overview

Webhooks let your application receive real-time updates from Due. You register a public HTTPS URL; when a subscribed event occurs, we send an HTTP POST with a JSON payload to that URL.

Think of webhooks as a call to action — when something happens in Due, your system is immediately notified.

How it works

- You create an endpoint on your server that listens for POST requests.

- You register that endpoint by calling the Create webhook endpoint

- Whenever an event occurs, Due sends a JSON payload to your endpoint.

- Your server processes the event

### Setup

Step 1 — Discover available events

Check which events your account can subscribe to:
curl -X GET "https://api.due.network/v1/webhook_endpoints/events" \
  -H 'Authorization: Bearer <token>'

Step 2 — Register a webhook endpoint

Create a webhook endpoint and tell Due which events to send there:
curl -X POST "https://api.due.network/v1/webhook_endpoints" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "url": "https://example.com/webhooks/due",
    "events": ["<event_type_from_step_1>"],
    "description": "Production webhook"
  }'
Step 3 — Verify your endpoint

List your endpoints and confirm your new one is active:
curl -X GET "https://api.due.network/v1/webhook_endpoints" \
  -H "Authorization: Bearer <token>"
Step 4 — Receive your first event

Trigger an action in Due that emits one of the subscribed events. Due will POST the event payload directly to your webhook URL. In the sandbox environment, you can simulate pay-ins to see webhooks about transfers.

Manage endpoints (optional)

Update an endpoint
curl -X POST "https://api.due.network/v1/webhook_endpoints/<endpoint_id>" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "events": ["<updated_event_type>"],
    "description": "Updated endpoint"
  }'
Delete an endpoint
curl -X DELETE "https://api.due.network/v1/webhook_endpoints/<endpoint_id>" \
  -H "Authorization: Bearer <token>"
To see the full list of webhook endpoint methods, please refer to the API reference

Updated4 months ago

---


---


## Webhook Incoming Events

> Source: https://due.readme.io/docs/incoming-events

*No content extracted (page may require JS)*


---


## Due Wallets Overview

> Source: https://due.readme.io/docs/overview-1

- DUE WALLETS

# Overview

At Due, you have flexible options for managing your clients' cryptocurrency wallets:

External Wallets: Connect your clients' existing external wallets to your Due account to perform on-ramp and off-ramp operations.

Due Wallets: If your clients don't have existing wallets and you lack the infrastructure to manage user wallets on your side, you can create EVM-type Due Wallet. These wallets are securely hosted by our DFNS provider, allowing you to create individual Due Wallets for each client and link them to your Due account.

### Security Model

To work with Due Wallets, you must first create a private key and register it as a credential. This extra security step ensures that only you can approve wallet operations - Due cannot access wallet funds.

### Getting Started Workflow

- Create Credential - Generate and register your private key (one-time setup)

- Create Due Wallet - Set up a new DFNS-hosted wallet (per client)

- Link Wallet to Account - Connect the wallet to your Due account (per client)

Important: Create Credential is a one-time setup process. Once you have an approved credential, you can use it to create and manage multiple Due Wallets for all your clients.

Updated4 months ago

---


---


## Create Credential

> Source: https://due.readme.io/docs/create-credential

- DUE WALLETS

# Create credential

## Overview

This guide explains how to add a credential within a Due Wallet scope, which will be further used for all signing operations.

## Prerequisites

- OpenSSL toolkit installed (or any other key management tool you're comfortable with)

- API access token

- Basic understanding of EVM wallets and cryptographic signing

Supported algorithms:

- Elliptic Curve (secp256r1, ...)

## Step 1: Generate Key Pair

If you don't have a key pair, create one using OpenSSL:
# Generate a new private key and save it to private.pem file
openssl ecparam -genkey -name prime256v1 -out private.pem

# Derive a public key from the private key and save to public.pem file
openssl ec -in private.pem -pubout -out public.pem
Tip: To get your public key as a single-line string for easier use in JSON:
cat public.pem | jq -Rs .
Keep your private key secure - it will be used for all signing operations.

## Step 2: Add Credentials

Credentials are used for signing operations in the wallet system. Let's add your first credential. See Credentials API Reference for more details.

### Initialize Credential Creation

Note: This process uses Pattern 1: Direct JSON Signing - you'll construct and sign a JSON object directly.

Send an initialization request to start the credential creation process:
curl --location 'https://api.due.network/v1/vaults/credentials/init' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "name": "Primary key"
}'
Response:
{
    "challenge": "CONnem_8mBAOUeLPL55EQBKV9EfxpIaFHIqtl6b7nmw",
    "clientDataHash": "cff7a7e1bfd1b99996f40046db72a1d1dcd847d6b6c3df22e9ff4407a7e73a9d",
    "kind": "Key"
}
### Prepare and Sign the Challenge

You need to create a JSON object containing the clientDataHash from the response and your public key in PEM format.

Important: To avoid issues with escape sequences and special characters, create the JSON data in a file:
# Create JSON file with clientDataHash and public key
cat > challenge.json << EOF
{"clientDataHash":"<clientDataHash_from_response>","publicKey":$(cat public.pem | jq -Rs .)}
EOF
For example, your challenge.json file should look like:
{"clientDataHash":"cff7a7e1bfd1b99996f40046db72a1d1dcd847d6b6c3df22e9ff4407a7e73a9d","publicKey":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAERorJRL7hy7WQUQEcIHtcWeZVvwxf\nZlviYrhHHHogLJ7dNc94ObdRG9++bC+WfWsGlb24XhiDZGcBylSAmGps+g==\n-----END PUBLIC KEY-----\n"}
To sign this JSON, use the following command:
# Sign the JSON data from file (removing any trailing newline before signing)
cat challenge.json | tr -d '\n' | openssl dgst -sha256 -sign private.pem | xxd -p | tr -d '\n'
Command breakdown:

- cat challenge.json - Read the JSON file

- tr -d '\n' - Remove any trailing newline from the file

- openssl dgst -sha256 -sign private.pem - Create SHA256 hash and sign with your private key

- xxd -p - Convert binary signature to hexadecimal

- tr -d '\n' - Remove newlines from hex output for a clean string

Result: A hex-encoded signature like:
30450220129dd58d6492fc5b505d46a82887c708ba73cc189f1d868f6508ba8b093cdc20022100f7217bcb5d83da3ed1ee1231dd8edd852133b14fb54e0032baf463a1b64a0d04
### Finalize Credential Creation

Submit the signed challenge:
curl --location 'https://api.due.network/v1/vaults/credentials' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "signature": "30450220129dd58d6492fc5b505d46a82887c708ba73cc189f1d868f6508ba8b093cdc20022100f7217bcb5d83da3ed1ee1231dd8edd852133b14fb54e0032baf463a1b64a0d04",
    "publicKey": "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAERorJRL7hy7WQUQEcIHtcWeZVvwxf\nZlviYrhHHHogLJ7dNc94ObdRG9++bC+WfWsGlb24XhiDZGcBylSAmGps+g==\n-----END PUBLIC KEY-----\n",
    "challenge": "CONnem_8mBAOUeLPL55EQBKV9EfxpIaFHIqtl6b7nmw"
}'
Response:
{
    "id": "passkey_xonETR6gAv3wIyhy8ehjx",
    "kind": "Key",
    "algorithm": "ECDSA:256:P-256",
    "location": {
        "deviceType": "",
        "deviceOS": ""
    },
    "name": "Primary key",
    "publicKey": "...",
    "hasWalletAccess": true,
    "createdAt": "2025-09-09T17:09:28.313965114Z",
    "approveUntil": null,
    "isActive": true
}
Important Notes:

- The first credential is automatically approved and ready to use ("approveUntil": null)

- Additional credentials are created with "isActive": true but require approval if "approveUntil" is set (see Additional Credentials guide)

- The "approveUntil" field indicates if approval is needed:
- null = fully approved and ready to use

- timestamp = requires approval before this deadline

- Save the credential ID (passkey_xonETR6gAv3wIyhy8ehjx) - you'll need it for signing operations

You can always retrieve this ID later by making a request to the credentials endpoint.

## Next Steps

- Create Due Wallet - Use your credential to create a wallet

- Additional Credentials - Add backup or rotating keys for enhanced security

Updated4 months ago

---


---


## Additional Credentials

> Source: https://due.readme.io/docs/additional-credentials

*No content extracted (page may require JS)*


---


## Create Due Wallet

> Source: https://due.readme.io/docs/create-due-wallet

*No content extracted (page may require JS)*


---


## Sign with Due Wallet

> Source: https://due.readme.io/docs/sign-with-due-wallet

*No content extracted (page may require JS)*


---


## Common Signing Patterns

> Source: https://due.readme.io/docs/common-signing-patterns

- DUE WALLETS

# Common signing patterns

The Due API uses two distinct signing patterns for different operations:

## Pattern 1: Direct JSON Signing (Credential Creation Only)

Used only when creating credentials. You construct and sign a JSON object directly.

Flow:
1. API returns: challenge + clientDataHash
2. You create: JSON object with {clientDataHash, publicKey}
3. You sign: SHA256 hash of the JSON
4. Signature format: Hex-encoded
Example: See Create Credential guide

## Pattern 2: Challenge-Response Flow (Everything Else)

Used for all other secured operations: wallet creation, transaction signing, credential approval/deactivation, and any future secured endpoints.

### Universal Request Structure

All Pattern 2 operations follow the same request/response structure:

#### Step 1: Initial Request

Send your operation payload:
{
  "payload": {
    // Your operation-specific data
    // Can be empty object {} for some operations like wallet creation
  }
}
Examples of payloads:

- Wallet creation: {} (empty payload)

- Transaction signing: {"keyId": "key_xxx", "hash": "0xabc..."}

- Credential approval: {"credentialId": "passkey_xxx"}

- Credential deactivation: {"credentialId": "passkey_xxx"}

#### Step 2: Challenge Response (403)

The API always returns a 403 error with a challenge:
{
  "success": false,
  "message": "Please sign the following challenge to proceed",
  "httpCode": 403,
  "code": "ACTION_SIGNATURE_REQUIRED",
  "data": {
    "factors": {
      "Key": {
        "credId": "",
        "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZS...", // Base64 encoded challenge
        "signature": null
      }
    },
    "challengeIdentifier": "chid1DLr5F2ij7oyYLrGy6ekLnouxbE5SiiaN"
  }
}
Key fields:

- clientData: Base64url-encoded challenge data to sign (no padding). When decoding, you may need to add = padding before passing to a standard Base64 decoder, or use a Base64url decoder directly.

- challengeIdentifier: Unique ID for this challenge (valid for a limited time)

#### Step 3: Sign the Challenge

Decode and sign the clientData:
# Decode base64 → Sign with SHA256 → Encode to base64 URL-safe format
echo -n "<clientData_from_response>" | base64 -d | openssl dgst -sha256 -sign private.pem | base64 -w 0 | tr '+/' '-_' | tr -d '='
Note: openssl dgst -sha256 -sign performs hashing and signing in a single step — it takes raw input, computes the SHA-256 hash internally, and signs the result. If your library's sign function also hashes internally (e.g. Python's ECDSA(SHA256())), pass the decoded clientData bytes
directly. Do not hash first and then sign, as this would result in double-hashing.

Important: The signature must be in base64 URL-safe format (not hex like Pattern 1).

#### Step 4: Retry with Signature

Send the same request with both payload and signature:
{
  "payload": {
    // Same payload as Step 1
  },
  "signature": {
    "challengeIdentifier": "<challengeIdentifier_from_step2>",
    "firstFactor": {
      "kind": "Key",
      "credentialAssertion": {
        "credId": "<your_credential_id>",
        "clientData": "<original_clientData_from_step2>",
        "signature": "<your_base64_url_safe_signature>"
      }
    }
  }
}
Response: Success with operation-specific result.

### Complete Example: Vault Creation

#### Request 1 (Initial):
curl -X POST 'https://api.due.network/v1/vaults' \
-H 'Authorization: Bearer <token>' \
-H 'Content-Type: application/json' \
-d '{}'  # Empty payload for vault creation
#### Response 1 (Challenge):
{
  "success": false,
  "httpCode": 403,
  "code": "ACTION_SIGNATURE_REQUIRED",
  "data": {
    "factors": {
      "Key": {
        "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZS..."
      }
    },
    "challengeIdentifier": "chid1DLZSWZlpvQSGTmMrwhUZTpCIFOwaneRi"
  }
}
#### Sign:
echo -n "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZS..." | base64 -d | openssl dgst -sha256 -sign private.pem | base64 -w 0 | tr '+/' '-_' | tr -d '='
#### Request 2 (With Signature):
curl -X POST 'https://api.due.network/v1/vaults' \
-H 'Authorization: Bearer <token>' \
-H 'Content-Type: application/json' \
-d '{
  "signature": {
    "challengeIdentifier": "chid1DLZSWZlpvQSGTmMrwhUZTpCIFOwaneRi",
    "firstFactor": {
      "kind": "Key",
      "credentialAssertion": {
        "credId": "passkey_xonETR6gAv3wIyhy8ehjx",
        "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZS...",
        "signature": "MEUCIAlkmdPEf0B_5xVr4DKK6uvsN0y1YVzsFe4vAOMlPcn4AiEA..."
      }
    }
  }
}'
#### Response 2 (Success):
{
  "id": "key_2lRmxX5KBYRzMg",
  "address": "0x08bEB4Ad3D8D607646E4d5311eb355Ec2d2396F5"
}
### Operations Using Pattern 2
OperationEndpointPayload Structure
Create WalletPOST /v1/vaults{} (empty)
Sign TransactionPOST /v1/vaults/sign{"keyId": "<wallet_id>", "hash": "..."}
Approve CredentialPOST /v1/vaults/credentials/approve{"credentialId": "..."}
Deactivate CredentialPOST /v1/vaults/credentials/deactivate{"credentialId": "..."}
Activate CredentialPOST /v1/vaults/credentials/activate{"credentialId": "..."}

Note: In Sign Transaction, keyId is the Due Wallet ID (e.g., key_2lRmxX5KBYRzMg) returned when creating the wallet.

### Sequence Diagram
sequenceDiagram
    participant Client
    participant API as Due API
    participant Signer as Private Key

    Note over Client,API: Pattern 1: Credential Creation
    Client->>API: POST /credentials/init
    API-->>Client: challenge + clientDataHash
    Client->>Client: Create JSON {clientDataHash, publicKey}
    Client->>Signer: Sign SHA256(JSON)
    Signer-->>Client: Hex signature
    Client->>API: POST /credentials with signature
    API-->>Client: Credential created

    Note over Client,API: Pattern 2: Challenge-Response (All Other Operations)
    Client->>API: POST /endpoint with {payload}
    API-->>Client: 403 with base64 challenge
    Client->>Client: Decode base64 challenge
    Client->>Signer: Sign SHA256(decoded)
    Signer-->>Client: Base64 URL-safe signature
    Client->>API: POST /endpoint with {payload, signature}
    API-->>Client: Success response
Updated3 months ago

---


---


## Python Demo Script

> Source: https://due.readme.io/docs/python-demo-script

- DUE WALLETS

# Python demo script
# /// script
# requires-python = ">=3.10"
# dependencies = ["cryptography"]
# ///
"""
Due Managed Wallets API Demo
=============================
Self-contained script that walks through the complete managed wallets flow
against the Due sandbox API:

  1. Create first credential (primary signing key)
  2. Create a wallet (vault)
  3. Link the wallet to a Due account
  4. Add a second credential (backup key)
  5. Approve the backup credential using the primary key
  6. Create a second wallet using the backup key

Prerequisites
-------------
- Python 3.10+
- uv (https://docs.astral.sh/uv/) — recommended, handles dependencies automatically
- A Due sandbox API token (Bearer)
- A Due account ID

Running
-------
    uv run managed_wallet_demo.py

  The script will prompt for your API token and account ID.
  No manual `pip install` is needed — uv reads the inline metadata above
  and installs `cryptography` automatically.

  To reuse a primary key from a previous run:

    PRIMARY_KEY=primary_key.pem uv run managed_wallet_demo.py

  Alternatively, if you prefer pip:

    pip install cryptography
    python managed_wallet_demo.py

Important
---------
- Targets the sandbox environment (https://api.sandbox.due.network).
- On first run the primary private key is saved to `primary_key.pem`.
  Pass PRIMARY_KEY=primary_key.pem on subsequent runs to reuse it.
"""

import base64
import json
import os
import sys
import urllib.request
import urllib.error
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import hashes, serialization

BASE_URL = "https://api.sandbox.due.network"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def generate_keypair() -> tuple[ec.EllipticCurvePrivateKey, str]:
    """Generate a random EC P-256 keypair. Returns (private_key, public_pem_str)."""
    private_key = ec.generate_private_key(ec.SECP256R1())
    public_pem = private_key.public_key().public_bytes(
        serialization.Encoding.PEM,
        serialization.PublicFormat.SubjectPublicKeyInfo,
    ).decode()
    return private_key, public_pem

def export_private_pem(private_key: ec.EllipticCurvePrivateKey) -> str:
    """Export private key as PEM string."""
    return private_key.private_bytes(
        serialization.Encoding.PEM,
        serialization.PrivateFormat.PKCS8,
        serialization.NoEncryption(),
    ).decode()

def load_private_key(pem_path: str) -> tuple[ec.EllipticCurvePrivateKey, str]:
    """Load a private key from PEM file. Returns (private_key, public_pem_str)."""
    with open(pem_path, "rb") as f:
        private_key = serialization.load_pem_private_key(f.read(), password=None)
    public_pem = private_key.public_key().public_bytes(
        serialization.Encoding.PEM,
        serialization.PublicFormat.SubjectPublicKeyInfo,
    ).decode()
    return private_key, public_pem

def sign_hex(private_key: ec.EllipticCurvePrivateKey, data: bytes) -> str:
    """SHA-256 sign data and return hex-encoded DER signature."""
    sig = private_key.sign(data, ec.ECDSA(hashes.SHA256()))
    return sig.hex()

def sign_base64url(private_key: ec.EllipticCurvePrivateKey, data: bytes) -> str:
    """SHA-256 sign data and return base64url-encoded DER signature (no padding)."""
    sig = private_key.sign(data, ec.ECDSA(hashes.SHA256()))
    return base64.urlsafe_b64encode(sig).rstrip(b"=").decode()

def api_call(
    method: str,
    path: str,
    body: dict | None = None,
    token: str = "",
    account_id: str = "",
    expect_403: bool = False,
) -> dict:
    """Make an API call. Returns parsed JSON response.

    If expect_403 is True, a 403 is treated as a normal response (challenge).
    """
    url = BASE_URL + path
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    if account_id:
        headers["Due-Account-Id"] = account_id

    data = json.dumps(body or {}).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method=method)

    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        resp_body = e.read().decode()
        if expect_403 and e.code == 403:
            return json.loads(resp_body)
        print(f"  HTTP {e.code}: {resp_body}")
        raise

def challenge_response(
    path: str,
    payload: dict,
    private_key: ec.EllipticCurvePrivateKey,
    cred_id: str,
    token: str,
    account_id: str = "",
) -> dict:
    """Execute the challenge-response signing flow (Pattern 2).

    1. POST with payload → receive 403 with challenge
    2. Sign clientData with private_key
    3. Retry POST with signature block
    """
    # Step 1: initial request → 403 challenge
    resp = api_call("POST", path, body=payload, token=token,
                     account_id=account_id, expect_403=True)

    if resp.get("code") != "ACTION_SIGNATURE_REQUIRED":
        # If it succeeded directly (no challenge), just return
        return resp

    challenge_id = resp["data"]["challengeIdentifier"]
    client_data_b64 = resp["data"]["factors"]["Key"]["clientData"]

    # Step 2: sign (clientData may be base64url without padding)
    padded = client_data_b64 + "=" * (-len(client_data_b64) % 4)
    client_data_raw = base64.urlsafe_b64decode(padded)
    # sign() with ECDSA(SHA256) already hashes internally — pass raw data
    sig = sign_base64url(private_key, client_data_raw)

    # Step 3: retry with signature
    signed_body = {
        **payload,
        "signature": {
            "challengeIdentifier": challenge_id,
            "firstFactor": {
                "kind": "Key",
                "credentialAssertion": {
                    "credId": cred_id,
                    "clientData": client_data_b64,
                    "signature": sig,
                },
            },
        },
    }
    return api_call("POST", path, body=signed_body, token=token,
                     account_id=account_id)

# ---------------------------------------------------------------------------
# Flow steps
# ---------------------------------------------------------------------------

def step_create_credential(
    token: str, name: str, private_key: ec.EllipticCurvePrivateKey, public_pem: str,
) -> str:
    """Create a credential using Pattern 1 (direct signing). Returns credentialId."""
    print(f"\n--- Creating credential: {name} ---")

    # Init
    init = api_call("POST", "/v1/vaults/credentials/init",
                     body={"kind": "Key", "name": name}, token=token)
    challenge = init["challenge"]
    client_data_hash = init["clientDataHash"]
    print(f"  Challenge received: {challenge[:40]}...")

    # Build JSON to sign
    challenge_json = json.dumps(
        {"clientDataHash": client_data_hash, "publicKey": public_pem},
        separators=(",", ":"),
    )
    sig = sign_hex(private_key, challenge_json.encode())

    # Submit
    cred = api_call("POST", "/v1/vaults/credentials", token=token, body={
        "kind": "Key",
        "signature": sig,
        "publicKey": public_pem,
        "challenge": challenge,
    })
    cred_id = cred["id"]
    approved = cred.get("approveUntil") is None
    print(f"  Credential created: {cred_id}")
    print(f"  Approved: {approved}")
    return cred_id

def step_create_wallet(
    token: str,
    private_key: ec.EllipticCurvePrivateKey,
    cred_id: str,
) -> tuple[str, str]:
    """Create a wallet (vault) using Pattern 2. Returns (wallet_id, address)."""
    print("\n--- Creating wallet (vault) ---")
    resp = challenge_response("/v1/vaults", {}, private_key, cred_id, token)
    wallet_id = resp["id"]
    address = resp["address"]
    print(f"  Wallet ID: {wallet_id}")
    print(f"  Address:   {address}")
    return wallet_id, address

def step_link_wallet(token: str, address: str, account_id: str) -> dict:
    """Link wallet to an account."""
    print("\n--- Linking wallet to account ---")
    resp = api_call("POST", "/v1/wallets",
                     body={"address": address}, token=token,
                     account_id=account_id)
    print(f"  Linked wallet: {resp.get('id', resp)}")
    return resp

def step_approve_credential(
    token: str,
    target_cred_id: str,
    signer_key: ec.EllipticCurvePrivateKey,
    signer_cred_id: str,
) -> dict:
    """Approve a credential using Pattern 2 (signed by an already-approved cred)."""
    print(f"\n--- Approving credential: {target_cred_id} ---")
    resp = challenge_response(
        "/v1/vaults/credentials/approve",
        {"payload": {"credentialId": target_cred_id}},
        signer_key, signer_cred_id, token,
    )
    approved = resp.get("approveUntil") is None
    print(f"  Approved: {approved}")
    return resp

def find_credential_by_pubkey(token: str, public_pem: str) -> str | None:
    """Find an existing credential ID by matching public key. Returns credentialId or None."""
    url = BASE_URL + "/v1/vaults/credentials"
    req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
    with urllib.request.urlopen(req) as resp:
        creds = json.loads(resp.read())
    pub_normalized = public_pem.strip()
    for c in creds:
        if c.get("publicKey", "").strip() == pub_normalized:
            return c["id"]
    return None

def step_list_credentials(token: str) -> list[dict]:
    """List all credentials."""
    print("\n--- Listing credentials ---")
    url = BASE_URL + "/v1/vaults/credentials"
    req = urllib.request.Request(url, headers={
        "Authorization": f"Bearer {token}",
    })
    with urllib.request.urlopen(req) as resp:
        creds = json.loads(resp.read())
    for c in creds:
        print(f"  {c['id']}  name={c.get('name', '?'):20s}  "
              f"active={c.get('isActive')}  approveUntil={c.get('approveUntil')}")
    return creds

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    print("=" * 60)
    print("Due Managed Wallets — API Demo")
    print("=" * 60)

    token = input("\nAPI token (Bearer): ").strip()
    account_id = input("Account ID: ").strip()

    if not token or not account_id:
        print("Both token and account ID are required.")
        return

    # Step 1 — Load or generate primary keypair & resolve credential
    key_file = os.environ.get("PRIMARY_KEY")  # path to existing PEM
    if key_file and os.path.exists(key_file):
        print(f"\n[1] Loading primary key from {key_file}...")
        pk1, pub1 = load_private_key(key_file)
        # Find existing credential by matching public key
        cred1 = find_credential_by_pubkey(token, pub1)
        if cred1:
            print(f"  Found existing credential: {cred1}")
        else:
            print("  No existing credential found for this key, creating...")
            cred1 = step_create_credential(token, "Primary key", pk1, pub1)
    else:
        print("\n[1] Generating primary keypair...")
        pk1, pub1 = generate_keypair()
        out_path = key_file or "primary_key.pem"
        with open(out_path, "w") as f:
            f.write(export_private_pem(pk1))
        print(f"  Private key saved to: {out_path}")
        cred1 = step_create_credential(token, "Primary key", pk1, pub1)

    # Step 2 — Create wallet
    print("\n[2] Creating wallet...")
    wallet_id, address = step_create_wallet(token, pk1, cred1)

    # Step 3 — Link wallet to account
    print("\n[3] Linking wallet to account...")
    step_link_wallet(token, address, account_id)

    # Step 4 — Generate second keypair & create backup credential
    print("\n[4] Generating backup keypair...")
    pk2, pub2 = generate_keypair()
    cred2 = step_create_credential(token, "Backup key", pk2, pub2)

    # Step 5 — Approve backup credential (signed by primary)
    print("\n[5] Approving backup credential...")
    step_approve_credential(token, cred2, pk1, cred1)

    # Step 6 — Create second wallet using backup key
    print("\n[6] Creating second wallet (using backup key)...")
    wallet_id2, address2 = step_create_wallet(token, pk2, cred2)

    # Final — List credentials
    print("\n[7] Final credential state:")
    step_list_credentials(token)

    print("\n" + "=" * 60)
    print("Demo complete!")
    print("=" * 60)

if __name__ == "__main__":
    main()
Updated3 months ago

---


---


## Sign with Privy

> Source: https://due.readme.io/docs/sign-with-privy

- ALTERNATIVE WALLETS

# Sign with Privy

This guide shows how to use Privy embedded wallets to sign Due transfer intents via REST API.

## Prerequisites

- Privy App ID and Privy App Secret - found in your Privy application settings (App settings > Basics)

- Due Platform API key - contact Due Network team for access

- A Due account with a linked Privy wallet

For more information:

- Privy Wallets Overview

- Due Transfer Flow

## Signing Flow

When you create a crypto → fiat transfer in Due, you need to sign the transfer intent before funds can be moved. This involves:

- Creating a transfer intent

- Signing each signable object via Privy API

- Submitting the signed intent back to Due

### Step 1: Create a Transfer Intent

First, create a transfer intent for your existing transfer:
curl --request POST \
  --url https://api.due.network/v1/transfers/{transfer_id}/transfer_intent \
  --header 'Authorization: Bearer <YOUR_API_KEY>' \
  --header 'Content-Type: application/json' \
  --header 'Due-Account-Id: <ACCOUNT_ID>'
Response:
{
    "id": "ti_24QbulYAT9nfjU",
    "sender": "evm:0xcF5AaaBe14Ba42d9D765C8f2b9099c3b69a25321",
    "signables": [
        {
            "payload": {
                "kind": "typed_data",
                "value": {
                    "types": {
                        "Permit": [
                            {"name": "owner", "type": "address"},
                            {"name": "spender", "type": "address"},
                            {"name": "value", "type": "uint256"},
                            {"name": "nonce", "type": "uint256"},
                            {"name": "deadline", "type": "uint256"}
                        ]
                    },
                    "primaryType": "Permit",
                    "domain": {
                        "name": "USDC",
                        "version": "1",
                        "chainId": "2000",
                        "verifyingContract": "0xA52B297943dd6F3D5fFb41F50040BB2Bc6272F06"
                    },
                    "message": {
                        "owner": "0xcF5AaaBe14Ba42d9D765C8f2b9099c3b69a25321",
                        "spender": "0xC2E594095801A382894b761b511B44775e1716a6",
                        "value": "115792089237316195423570985008687907853269984665640564039457584007913129639935",
                        "nonce": "0",
                        "deadline": "1759424402"
                    }
                }
            },
            "hash": "0x7ab1ccbb88a8cf030de759744c4ac249f06b2512242e5624058bcda99daf2576"
        },
        {
            "payload": {
                "kind": "typed_data",
                "value": {
                    "types": {
                        "PayoutIntent": [
                            {"name": "sender", "type": "address"},
                            {"name": "relay", "type": "address"},
                            {"name": "calls", "type": "bytes[]"},
                            {"name": "nonce", "type": "bytes32"},
                            {"name": "deadline", "type": "uint256"}
                        ]
                    },
                    "primaryType": "PayoutIntent",
                    "domain": {
                        "name": "DuePayout",
                        "version": "1",
                        "chainId": "2000",
                        "verifyingContract": "0xC2E594095801A382894b761b511B44775e1716a6"
                    },
                    "message": {
                        "sender": "0xcF5AaaBe14Ba42d9D765C8f2b9099c3b69a25321",
                        "relay": "0xBADDA95F65be56Dc4cD737E865a2d35F0B672BAD",
                        "calls": ["0xb9b8bc50..."],
                        "nonce": "0xae7813992f91fd41c18bed8734c8d1914d13adad6bfb80f656869813cbc170ad",
                        "deadline": "1759424402"
                    }
                }
            },
            "hash": "0x51dc7acb50075ea1ac934409c5d40e52b1744df19922894d35ba261c86777f95"
        }
    ],
    "expiresAt": "2025-10-02T17:00:02.25776447Z"
}
The response contains a signables array - typically two objects: Permit (token approval) and PayoutIntent (the actual transfer).

Important: Transfer intents expire (see expiresAt field). Complete signing before expiration.

### Step 2: Sign Each Signable with Privy

For each object in the signables array, use Privy's eth_signTypedData_v4 method to generate a signature.

EIP-7702 / Kernel wallets: If your Privy wallets use EIP-7702 delegation (e.g. ZeroDev Kernel smart accounts), the signing process below won't work as is. The signature needs to be wrapped in Kernel's EIP-712 domain. See Signing from Kernel v3 Smart Accounts for the modified signing process.

Example: Signing the Permit
curl --request POST \
  --url https://api.privy.io/v1/wallets/<wallet_id>/rpc \
  -u "<your-privy-app-id>:<your-privy-app-secret>" \
  --header 'privy-app-id: <your-app-id>' \
  --header 'Content-Type: application/json' \
  --data '{
    "method": "eth_signTypedData_v4",
    "params": {
      "typed_data": {
        "domain": {
          "name": "USDC",
          "version": "1",
          "chainId": "2000",
          "verifyingContract": "0xA52B297943dd6F3D5fFb41F50040BB2Bc6272F06"
        },
        "types": {
          "Permit": [
            {"name": "owner", "type": "address"},
            {"name": "spender", "type": "address"},
            {"name": "value", "type": "uint256"},
            {"name": "nonce", "type": "uint256"},
            {"name": "deadline", "type": "uint256"}
          ]
        },
        "primary_type": "Permit",
        "message": {
          "owner": "0xcF5AaaBe14Ba42d9D765C8f2b9099c3b69a25321",
          "spender": "0xC2E594095801A382894b761b511B44775e1716a6",
          "value": "115792089237316195423570985008687907853269984665640564039457584007913129639935",
          "nonce": "0",
          "deadline": "1759424402"
        }
      }
    }
  }'
Response:
{
  "method": "eth_signTypedData_v4",
  "data": {
    "signature": "0xd99802ab7a14b535ad0bf9c69a7cfd862797a5f3b48270db20fdbd7a170a433e79970506944a3289e1ee2c7d0324b6097d9f67c51816792dbbac0f8c2c8af4b11b",
    "encoding": "hex"
  }
}
Repeat this process for the PayoutIntent signable, using its respective domain, types, and message values from the transfer intent response.

For more details, see Privy: Sign Typed Data.

### Step 3: Submit the Signed Intent

After obtaining signatures for all signables, submit the complete transfer intent with signatures to Due:
curl --request POST \
  --url https://api.due.network/v1/transfer_intents/submit \
  --header 'Authorization: Bearer <YOUR_API_KEY>' \
  --header 'Content-Type: application/json' \
  --header 'Due-Account-Id: <ACCOUNT_ID>' \
  --data '{
    "id": "ti_24QbulYAT9nfjU",
    "ownerId": "acct_DkRHlTg5q8VZM6Gn",
    "sender": "evm:0xcF5AaaBe14Ba42d9D765C8f2b9099c3b69a25321",
    "amountIn": "1177.29598",
    "to": {
      "evm:0xbad09Fb9781D9D57E1423231AC51f9bb9e0CABAD": "1177.29598"
    },
    "tokenIn": "USDC",
    "tokenOut": "USDC",
    "networkIdIn": "base",
    "networkIdOut": "base",
    "signables": [
      {
        "payload": {
          "kind": "typed_data",
          "value": { ... }
        },
        "hash": "0x7ab1ccbb88a8cf030de759744c4ac249f06b2512242e5624058bcda99daf2576",
        "signature": "0xd99802ab7a14b535ad0bf9c69a7cfd862797a5f3b48270db20fdbd7a170a433e..."
      },
      {
        "payload": {
          "kind": "typed_data",
          "value": { ... }
        },
        "hash": "0x51dc7acb50075ea1ac934409c5d40e52b1744df19922894d35ba261c86777f95",
        "signature": "0xa1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456..."
      }
    ],
    "nonce": "0xae7813992f91fd41c18bed8734c8d1914d13adad6bfb80f656869813cbc170ad",
    "hash": "0x51dc7acb50075ea1ac934409c5d40e52b1744df19922894d35ba261c86777f95",
    "token": "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2025-10-02T17:00:02.25776447Z",
    "createdAt": "2025-10-02T16:45:02.302661636Z",
    "reference": "tf_2ghR6HgkRHTQB8:deposit"
  }'
Response:
{
  "id": "ti_24QbulYAT9nfjU",
  "status": "payment_submitted",
  "txHashIn": "0x1234567890abcdef...",
  "createdAt": "2025-10-02T16:45:02Z"
}
The transfer is now submitted and will be processed by Due.

## Alternative: Funding Address

For a simpler approach that doesn't require signing, you can use a funding address instead. See Due: Stablecoin to Fiat Transfers for details.

## Additional Resources

- Privy REST API Documentation

- Due API Reference

- Due Transfer Flow

- Signing from Kernel v3 (EIP-7702) Smart Accounts

- EIP-712: Typed Data Signing

Updated18 days ago

---


---


## Signing from Kernel v3 Smart Accounts

> Source: https://due.readme.io/docs/signing-due-signables-from-kernel-v3-smart-accounts

- ALTERNATIVE WALLETS

# Signing Due Signables from Kernel v3 Smart Accounts

This guide explains how to properly sign Due's Permit and PayoutIntent messages when your account is a Kernel v3 (ZeroDev) smart contract account, including accounts set up via EIP-7702.

## Why Standard Signatures Don't Work

Both Due's contracts and modern token contracts (e.g. USDC) use SignatureChecker for signature verification, which supports:

- EOA accounts - standard ECDSA recovery (ecrecover)

- Smart contract accounts - ERC-1271 isValidSignature(hash, signature)

When your address has contract code (Kernel via EIP-7702), the verifying contract detects this and calls isValidSignature(hash, signature) on your account instead of using ecrecover. Kernel then wraps the original hash in its own EIP-712 domain before verifying the ECDSA signature. This means you must sign the wrapped hash, not the original one.

## How Kernel's Signature Verification Works

When isValidSignature(bytes32 hash, bytes signature) is called on your Kernel account:

- The first byte of signature is stripped as the mode byte (validation routing)

- The original hash is wrapped in Kernel's EIP-712 typed data:wrappedHash = keccak256(0x19 0x01 || kernelDomainSeparator || keccak256(abi.encode(KERNEL_WRAPPER_TYPE_HASH, hash)))

- The remaining signature bytes are verified via ECDSA against the wrappedHash

The Kernel EIP-712 domain is:
{
  name: "Kernel",
  version: "0.3.3",
  chainId: <chain ID>,
  verifyingContract: <your Kernel account address>
}
The wrapper type:
Kernel(bytes32 hash)
Tip: You can query the domain parameters directly from your Kernel account by calling eip712Domain() (EIP-5267). This is more robust than hardcoding values, especially if Kernel versions change.

## Step-by-Step Signing Process

For each signable returned by Due's API:

### 1. Get the original hash

Due's API returns a TransferIntent with signables[]. Each signable has:

- payload - the full EIP-712 typed data (domain, types, message)

- hash - the EIP-712 digest to sign

### 2. Sign the hash using Kernel's EIP-712 wrapper

Instead of signing hash directly, sign it as the hash field of a Kernel EIP-712 message:
import { TypedDataEncoder } from "ethers"

// The hash from Due's signable
const originalHash: string = signable.hash

// Sign using Kernel's wrapper domain
const kernelSignature = await signer.signTypedData(
  {
    name: "Kernel",
    version: "0.3.3",
    chainId: chainId,
    verifyingContract: yourKernelAccountAddress,
  },
  {
    Kernel: [{ name: "hash", type: "bytes32" }],
  },
  {
    hash: originalHash,
  },
)
### 3. Prepend the mode byte

Kernel uses the first byte of the signature to determine the validation mode. For accounts using the root ECDSA validator (the default for most Kernel 7702 accounts), the mode byte is 0x00:
import { concat, hexlify } from "ethers"

const finalSignature = concat([
  hexlify(new Uint8Array([0x00])),  // sudo/root mode
  kernelSignature,
])
The resulting signature is 66 bytes: 1 byte mode + 65 bytes ECDSA.

### 4. Return as the signable's signature

Set signable.signature = finalSignature and submit the TransferIntent back to Due's API.

## Complete Code Example
import { HDNodeWallet, concat, hexlify } from "ethers"

/**
 * Signs a Due signable hash for a Kernel v3 smart account.
 *
 * @param signer              EOA private key holder of the Kernel account
 * @param kernelAccountAddress Your Kernel smart account address
 * @param chainId             Chain ID of the network
 * @param originalHash        The `hash` field from Due's signable
 * @param modeByte            Kernel validation mode (default 0x00 = sudo/root)
 * @returns                   66-byte signature ready to submit to Due
 */
async function signForKernel(
  signer: HDNodeWallet,
  kernelAccountAddress: string,
  chainId: bigint,
  originalHash: string,
  modeByte: number = 0x00,
): Promise<string> {
  const signature = await signer.signTypedData(
    {
      name: "Kernel",
      version: "0.3.3",
      chainId,
      verifyingContract: kernelAccountAddress,
    },
    {
      Kernel: [{ name: "hash", type: "bytes32" }],
    },
    { hash: originalHash },
  )

  return concat([hexlify(new Uint8Array([modeByte])), signature])
}
### Usage with viem
import { hashTypedData, signTypedData, concat, toHex } from "viem"
import { privateKeyToAccount } from "viem/accounts"

async function signForKernelViem(
  privateKey: `0x${string}`,
  kernelAccountAddress: `0x${string}`,
  chainId: number,
  originalHash: `0x${string}`,
  modeByte: number = 0x00,
): Promise<`0x${string}`> {
  const account = privateKeyToAccount(privateKey)

  const signature = await signTypedData({
    privateKey,
    domain: {
      name: "Kernel",
      version: "0.3.3",
      chainId: BigInt(chainId),
      verifyingContract: kernelAccountAddress,
    },
    types: {
      Kernel: [{ name: "hash", type: "bytes32" }],
    },
    primaryType: "Kernel",
    message: { hash: originalHash },
  })

  return concat([toHex(modeByte, { size: 1 }), signature])
}
## Common Pitfalls

- 
Wrong verifyingContract - Must be your Kernel account address (the smart account), not the Kernel implementation contract address.

- 
Wrong version string - Must exactly match what your Kernel contract returns from _domainNameAndVersion(). Current version is "0.3.3". You can verify by calling eip712Domain() on your account.

- 
Missing mode byte - The signature must start with the mode byte (0x00 for sudo mode). Without it, Kernel will misparse the signature.

- 
Double-hashing - Do NOT compute the EIP-712 hash yourself from the typed data. Use the hash field from Due's signable directly. The token/payout contract computes the hash on-chain, and isValidSignature receives that exact hash.

- 
Signing the typed data directly - You must NOT call signTypedData with the original permit/payout typed data. Instead, compute the hash first and sign it through Kernel's wrapper. The original typed data is only used to display the signing request to the user.

## Validation Mode Bytes

Kernel v3 supports different validation modes via the first signature byte:
ModeByteDescription
Sudo/Root0x00Uses the account's root validator (default ECDSA)
Validator0x01Routes to a specific validator (21-byte prefix)
Permission0x02Routes to a permission policy (5-byte prefix)

Most EIP-7702 Kernel accounts use 0x00 (sudo mode) with the root ECDSA validator.

## Reference

- Kernel v3 source

- Kernel signature wrapping (_toWrappedHash)

- Kernel constants (KERNEL_WRAPPER_TYPE_HASH)

- ZeroDev EIP-7702 quickstart

Updated18 days ago

---


---


## API Reference

> Source: https://due.readme.io/reference

*No content extracted (page may require JS)*


---

---

# Additional Pages (Corrected URLs)

## Fiat to Stablecoin Transfers (On-ramps)

> Source: https://due.readme.io/docs/fiat-to-stablecoin-transfers-pay-ins

- MOVE MONEY

- Transfers

# Fiat to Stablecoin transfers (On-ramps)

Convert traditional currencies (USD, EUR, GBP) into stablecoins (USDC, USDT) by sending bank transfers with unique reference codes. The system automatically matches your fiat payment and delivers stablecoins to your specified crypto address.

## Overview

Fiat-to-stablecoin transfers enable crypto on-ramp functionality by accepting traditional bank payments and delivering equivalent stablecoins. You initiate the transfer through the API, receive bank transfer instructions with a unique reference code, then send the fiat payment using traditional banking rails.

Key Features:

- Traditional funding - Use ACH, wire transfers, SEPA, and other familiar payment methods

- Automatic matching - Reference codes link your bank payment to your crypto delivery

- Multi-network delivery - Receive stablecoins on Ethereum, Polygon, Tron, and other networks

- Real-time conversion - Live exchange rates with transparent fee breakdown

---

## Step-by-Step Process

### 1. Get Available Channels

Discover supported fiat-to-stablecoin combinations and their current pricing.

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels
```

Look for channels where:

- Source channels: type: "deposit" on fiat rails (ach, sepa, wire, swift)

- Destination channels: type: "withdrawal" on crypto rails (ethereum, polygon, tron)

### 2. Generate Quote

Get real-time pricing for your fiat-to-stablecoin conversion.

```
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "ach",
    "currency": "USD",
    "amount": "1000.00"
  },
  "destination": {
    "rail": "ethereum", 
    "currency": "USDC",
    "amount": "0"
  }
}'
```

Response:

```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "source": {
    "rail": "ach",
    "currency": "USD", 
    "amount": "1000.00",
    "fee": "5.00"
  },
  "destination": {
    "rail": "ethereum",
    "currency": "USDC",
    "amount": "995.00",
    "fee": "0.00"
  },
  "fxRate": 1.0,
  "fxMarkup": 0,
  "expiresAt": "2024-03-15T10:32:15Z"
}
```

### 3. Create Transfer

Initialize the fiat-to-stablecoin transfer using your quote and destination.

```
curl -X POST https://api.due.network/v1/transfers \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "quote": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "recipient": "{destination_id}",
  "memo": "Wallet funding - March 2024"
}'
```

Response:

```
{
  "id": "{transfer_id}",
  "ownerId": "{owner_id}",
  "status": "awaiting_funds",
  "source": {
    "amount": "1000.00",
    "fee": "5.00",
    "currency": "USD",
    "rail": "ach"
  },
  "destination": {
    "amount": "995.00",
    "fee": "0.00",
    "currency": "USDC", 
    "rail": "ethereum",
    "id": "{destination_id}",
    "label": "My Ethereum Wallet",
    "details": {
      "schema": "evm",
      "address": "0x742d35Cc6665C0532925a3b8D98d0dfBb67B1BF8"
    },
    "memo": "Wallet funding - March 2024"
  },
  "fxRate": 1.0,
  "fxMarkup": 0,
  "transferInstructions": {
    "kind": "details",
    "details": {
      "schema": "bank_us",
      "bankName": "Due Payments LLC",
      "accountName": "Due Payments LLC",
      "accountNumber": "1234567890",
      "routingNumber": "021000021",
      "beneficiaryAddress": {
        "street_line_1": "123 Financial District",
        "city": "New York",
        "postal_code": "10001",
        "country": "USA",
        "state": "NY"
      }
    },
    "memo": "REF-ABC123XYZ"
  },
  "createdAt": "2024-03-15T10:30:15Z",
  "expiresAt": "2024-03-15T10:35:15Z"
}
```

Key Response Fields:

- status: "awaiting_funds" - Transfer is waiting for your fiat payment

- transferInstructions.kind: "details" - Bank account details for your payment

- transferInstructions.memo - Critical reference code for payment matching

- expiresAt - Transfer expires in 5 minutes if not completed

### 4. Send Bank Payment

Send your fiat payment to the provided bank account details, ensuring you include the reference code.

ACH Transfer Example:

- Recipient Bank: Due Payments LLC

- Account Number: 1234567890

- Routing Number: 021000021

- Amount: $1,000.00

- Reference/Memo: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

Wire Transfer Example:

- Beneficiary: Due Payments LLC

- Account: 1234567890

- Routing: 021000021

- Amount: $1,000.00

- Wire Reference: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

SEPA Transfer Example:

- Beneficiary: Due Payments Europe

- IBAN: DE89370400440532013000

- Amount: €1,000.00

- Payment Reference: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

⚠️ Critical: Always include the exact reference code from transferInstructions.memo in your bank transfer. Without this reference, the system cannot match your payment to your transfer request, causing delays or failed delivery.

### 5. Monitor Transfer Status

Track your transfer progress as the system processes your fiat payment and delivers stablecoins.

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/transfers/{transfer_id}
```

The transfer status will update as your payment is processed and stablecoins are delivered to your destination.

Updated9 months ago

---

---

## Stablecoin to Fiat Transfers (Off-ramps)

> Source: https://due.readme.io/docs/stablecoin-to-fiat-transfers

- MOVE MONEY

- Transfers

# Stablecoin to Fiat transfers (Off-ramps)

## Overview

Send cryptocurrency from your wallet to traditional bank accounts, mobile money services, and other fiat payment rails. This guide covers the complete process including blockchain transaction signing and submission.

Key Features:

- Multi-network support - Ethereum, Polygon, Tron, and other blockchain networks

- Global fiat rails - Bank transfers (ACH, SEPA, SWIFT), mobile money, local payment systems

- Real-time conversion - Live exchange rates with transparent fee breakdown

- Secure signing - Client-side transaction signing maintains custody control

---

## Step-by-Step Process

### 1. Get Available Channels

Discover supported crypto-to-fiat combinations

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels
```

Look for channels where:

- Source channels: type: "deposit" on crypto rails (ethereum, tron, polygon)

- Destination channels: type: "withdrawal" on fiat rails (sepa, ach, bank_swift)

### 2. Create Recipient

Set up the bank account or mobile money destination for your payout.

```
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "John Smith",
  "details": {
    "schema": "bank_us",
    "bankName": "JPMorgan Chase Bank",
    "accountName": "John Smith",
    "accountNumber": "123456789",
    "routingNumber": "021000021",
    "beneficiaryAddress": {
      "street_line_1": "123 Main Street", 
      "city": "New York",
      "postal_code": "10001",
      "country": "USA",
      "state": "NY"
    }
  },
  "isExternal": true
}'
```

### 3. Generate Quote

Get real-time pricing for your crypto-to-fiat conversion.

```
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "ethereum",
    "currency": "USDC",
    "amount": "1000.00"
  },
  "destination": {
    "rail": "ach", 
    "currency": "USD",
    "amount": "0"
  }
}'
```

Response:

```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "source": {
    "rail": "ethereum",
    "currency": "USDC", 
    "amount": "1000.00",
    "fee": "0.00"
  },
  "destination": {
    "rail": "ach",
    "currency": "USD",
    "amount": "997.50",
    "fee": "2.50"
  },
  "fxRate": 1.0,
  "fxMarkup": 0,
  "expiresAt": "2024-03-15T10:32:15Z"
}
```

### 4. Create Transfer

Initialize the crypto-to-fiat transfer using your quote and recipient.

```
curl -X POST https://api.due.network/v1/transfers \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "quote": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "sender": "{wallet_id}",
  "recipient": "{recipient_id}",
  "memo": "Crypto payout - Invoice #12345"
}'
```

Response:

```
{
  "id": "{transfer_id}",
  "ownerId": "{owner_id}",
  "status": "awaiting_funds",
  "source": {
    "amount": "1000.00",
    "fee": "0.00", 
    "currency": "USDC",
    "rail": "ethereum",
    "id": "{wallet_id}",
    "label": "My Ethereum Wallet",
    "details": {
      "schema": "evm",
      "address": "0x742d35Cc6665C0532925a3b8D98d0dfBb67B1BF8"
    }
  },
  "destination": {
    "amount": "997.50",
    "fee": "2.50",
    "currency": "USD", 
    "rail": "ach",
    "id": "{recipient_id}",
    "label": "John Smith",
    "details": {
      "schema": "bank_us",
      "bankName": "JPMorgan Chase Bank",
      "accountName": "John Smith",
      "accountNumber": "123456789",
      "routingNumber": "021000021"
    },
    "memo": "Crypto payout - Invoice #12345"
  },
  "fxRate": 1.0,
  "fxMarkup": 0,
  "transferInstructions": {
    "type": "TransferIntent"
  },
  "createdAt": "2024-03-15T10:30:15Z",
  "expiresAt": "2024-03-15T10:35:15Z"
}
```

Key Response Fields:

- status: "awaiting_funds" - Transfer is waiting for blockchain transaction

- transferInstructions.type: "TransferIntent" - Indicates crypto transfer requiring intent creation

- expiresAt - Transfer expires in 5 minutes if not completed

### 5.a. Create Transfer Intent

Generate blockchain transaction data for signing.

```
curl -X POST https://api.due.network/v1/transfers/{transfer_id}/transfer_intent \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id"
```

Response:

```
{
  "token": "intent_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": "{intent_id}",
  "sender": "0x742d35Cc6665C0532925a3b8D98d0dfBb67B1BF8",
  "amountIn": "1000000000",
  "to": {
    "0x1234567890123456789012345678901234567890": "1000000000"
  },
  "tokenIn": "USDC",
  "tokenOut": "USDC", 
  "networkIdIn": "ethereum",
  "networkIdOut": "ethereum",
  "gasFee": "21000000000000000",
  "signables": [
    {
      "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
      "type": "EIP712",
      "data": {
        "types": {
          "Transfer": [
            {"name": "to", "type": "address"},
            {"name": "amount", "type": "uint256"},
            {"name": "nonce", "type": "uint256"}
          ]
        },
        "domain": {
          "name": "DueProtocol",
          "version": "1",
          "chainId": 1
        },
        "message": {
          "to": "0x1234567890123456789012345678901234567890",
          "amount": "1000000000",
          "nonce": "123"
        }
      }
    }
  ],
  "nonce": "0x7b",
  "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
  "reference": "{transfer_id}_deposit",
  "expiresAt": "2024-03-15T10:40:15Z",
  "createdAt": "2024-03-15T10:30:45Z"
}
```

Key Response Fields:

- signables - Array of transactions requiring cryptographic signatures

- gasFee - Estimated gas cost in wei for transaction execution

- to - Destination address mapping with amounts to transfer

- hash - Intent hash for verification and submission

### 5.b. Create Funding Address (Alternative to 5.a)

Instead of creating, signing, and submitting a transfer intent, you can obtain a temporary deposit address and send funds directly to complete the transfer.

Currently supported: EVM networks with USDC only (Ethereum, Polygon, Avalanche, Arbitrum, Base)

```
curl -X POST https://api.due.network/v1/transfers/{transfer_id}/funding_address \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id"
```

Response:

```
{
  "details": {
    "address": "0x2Fdb8B341f6c26Ee829455A9F25c83F037beb684",
    "schema": "evm"
  }
}
```

Important Requirements:

- Exact amount - Send the precise amount specified in source.amount from the transfer response

- Single transaction - The full amount must be sent in one transaction (splitting is not supported)

- Authorized sender - Transaction must originate from the wallet address specified in the transfer's sender field

- Time limit - Address remains valid until transfer is executed or expires (expiresAt)

Note: If you choose the funding address method (5.b), steps 6-7 are not required. The transfer will process automatically upon receiving the correct payment.

### 6. Sign Transaction

Use your wallet infrastructure to sign the blockchain transaction data.

Example using ethers.js:

```
import { ethers } from 'ethers';

// Connect to your wallet
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

// Extract signable data from transfer intent
const signable = transferIntent.signables[0];
const domain = signable.data.domain;
const types = signable.data.types;
const message = signable.data.message;

// Sign the EIP-712 message
const signature = await signer._signTypedData(domain, types, message);

console.log('Transaction signature:', signature);
```

### 7. Submit Signed Transaction

Submit the signed transaction to complete the crypto-to-fiat payout.

Important:

- In submit, you need to send the intent returned from the transfer_intent endpoint with signatures added to its signables.

- Each signable should have a separate signature.

```
curl -X POST https://api.due.network/v1/transfer_intents/submit \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "token": "intent_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": "{intent_id}",
  "sender": "0x742d35Cc6665C0532925a3b8D98d0dfBb67B1BF8",
  "amountIn": "1000000000",
  "to": {
    "0x1234567890123456789012345678901234567890": "1000000000"
  },
  "tokenIn": "USDC",
  "tokenOut": "USDC", 
  "networkIdIn": "ethereum",
  "networkIdOut": "ethereum",
  "gasFee": "21000000000000000",
  "signables": [
    {
      "signature": "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef12345678901c",
      "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
      "type": "EIP712",
      "data": {
        "types": {
          "Transfer": [
            {"name": "to", "type": "address"},
            {"name": "amount", "type": "uint256"},
            {"name": "nonce", "type": "uint256"}
          ]
        },
        "domain": {
          "name": "DueProtocol",
          "version": "1",
          "chainId": 1
        },
        "message": {
          "to": "0x1234567890123456789012345678901234567890",
          "amount": "1000000000",
          "nonce": "123"
        }
      }
    }
  ],
  "nonce": "0x7b",
  "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
  "reference": "{transfer_id}_deposit",
  "expiresAt": "2024-03-15T10:40:15Z",
  "createdAt": "2024-03-15T10:30:45Z"
}'
```

Upon successful submission, the blockchain transaction will be processed. Monitor the transfer status to track progress.

Updated7 months ago

---

---

## Fiat to Fiat Transfers (Cross-border)

> Source: https://due.readme.io/docs/fiat-to-fiat-tranfsers-cross-border

- MOVE MONEY

- Transfers

# Fiat to fiat transfers (Cross-border)

Send traditional currencies (USD, EUR, GBP) to bank accounts and mobile money services worldwide. Fund transfers through familiar banking rails and deliver payments to recipients across global financial networks.

## Overview

Fiat-to-fiat transfers enable traditional cross-border and domestic payments by accepting bank transfers, ACH, SEPA, and other fiat payment methods, then delivering equivalent amounts to recipient bank accounts or mobile money wallets worldwide.

Key Features:

- Global coverage - Send to bank accounts and mobile money services worldwide

- Traditional funding - Use ACH, wire transfers, SEPA, and other familiar payment methods

- Currency conversion - Automatic FX conversion with transparent rates and fees

- Automatic matching - Reference codes link your funding to recipient delivery

---

## Step-by-Step Process

### 1. Get Available Channels

Discover supported fiat-to-fiat combinations and their current pricing.

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels
```

Look for channels where:

- Source channels: type: "deposit" on fiat rails (ach, sepa, wire, swift)

- Destination channels: type: "withdrawal" on fiat rails (sepa, ach, bank_swift, momo_africa)

### 2. Create Recipient

Set up the destination bank account or mobile money account for your transfer.

US Bank Account:

```
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "John Smith",
  "details": {
    "schema": "bank_us",
    "bankName": "JPMorgan Chase Bank",
    "accountName": "John Smith",
    "accountNumber": "123456789",
    "routingNumber": "021000021",
    "beneficiaryAddress": {
      "street_line_1": "123 Main Street",
      "city": "New York",
      "postal_code": "10001",
      "country": "USA",
      "state": "NY"
    }
  },
  "isExternal": true
}'
```

African Mobile Money:

```
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "Grace Okafor",
  "details": {
    "schema": "momo_africa", 
    "financialInstitutionId": "mtn_ng",
    "accountNumber": "08123456789",
    "accountName": "Grace Okafor"
  },
  "isExternal": true
}'
```

### 3. Generate Quote

Get real-time pricing for your fiat-to-fiat conversion.

```
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "ach",
    "currency": "USD",
    "amount": "1000.00"
  },
  "destination": {
    "rail": "momo_africa",
    "currency": "NGN", 
    "amount": "0"
  }
}'
```

Response:

```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "source": {
    "rail": "ach",
    "currency": "USD",
    "amount": "1000.00",
    "fee": "5.00"
  },
  "destination": {
    "rail": "momo_africa",
    "currency": "NGN",
    "amount": "1580000.00",
    "fee": "2500.00"
  },
  "fxRate": 1585.0,
  "fxMarkup": 50,
  "expiresAt": "2024-03-15T10:32:15Z"
}
```

### 4. Create Transfer

Initialize the fiat-to-fiat transfer using your quote and recipient.

```
curl -X POST https://api.due.network/v1/transfers \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "quote": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "recipient": "{recipient_id}",
  "memo": "Family support - March 2024"
}'
```

Response:

```
{
  "id": "{transfer_id}",
  "ownerId": "{owner_id}",
  "status": "awaiting_funds",
  "source": {
    "amount": "1000.00",
    "fee": "5.00",
    "currency": "USD",
    "rail": "ach"
  },
  "destination": {
    "amount": "1580000.00",
    "fee": "2500.00",
    "currency": "NGN",
    "rail": "momo_africa",
    "id": "{recipient_id}",
    "label": "Grace Okafor",
    "details": {
      "schema": "momo_africa",
      "financialInstitutionId": "mtn_ng",
      "accountNumber": "08123456789",
      "accountName": "Grace Okafor"
    },
    "memo": "Family support - March 2024"
  },
  "fxRate": 1585.0,
  "fxMarkup": 50,
  "transferInstructions": {
    "kind": "details",
    "details": {
      "schema": "bank_us",
      "bankName": "Due Payments LLC",
      "accountName": "Due Payments LLC", 
      "accountNumber": "9876543210",
      "routingNumber": "021000021",
      "beneficiaryAddress": {
        "street_line_1": "123 Financial District",
        "city": "New York",
        "postal_code": "10001",
        "country": "USA",
        "state": "NY"
      }
    },
    "memo": "REF-XYZ789ABC"
  },
  "createdAt": "2024-03-15T10:30:15Z",
  "expiresAt": "2024-03-15T10:35:15Z"
}
```

Key Response Fields:

- status: "awaiting_funds" - Transfer is waiting for your fiat payment

- transferInstructions.kind: "details" - Bank account details for your funding

- transferInstructions.memo - Critical reference code for payment matching

- destination - Contains recipient details where funds will be delivered

- expiresAt - Transfer expires in 5 minutes if not funded

### 5. Send Bank Payment

Send your fiat payment to the provided bank account details, ensuring you include the reference code.

ACH Transfer Example:

- Recipient Bank: Due Payments LLC

- Account Number: 9876543210

- Routing Number: 021000021

- Amount: $1,000.00

- Reference/Memo: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

Wire Transfer Example:

- Beneficiary: Due Payments LLC

- Account: 9876543210

- Routing: 021000021

- Amount: $1,000.00

- Wire Reference: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

SEPA Transfer Example:

- Beneficiary: Due Payments Europe

- IBAN: DE89370400440532013000

- Amount: €1,000.00

- Payment Reference: Use the exact reference from transferInstructions.memo ⚠️ Required for payment matching

⚠️ Critical: Always include the exact reference code from transferInstructions.memo in your bank transfer. Without this reference, the system cannot match your funding to your transfer request, preventing delivery to your recipient.

### 6. Monitor Transfer Status

Track your transfer progress as the system processes your funding and delivers payment to the recipient.

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/transfers/{transfer_id}
```

The transfer status will update as your funding is processed and payment is delivered to the recipient's account.

---

## Cross-Currency Conversions

Fiat-to-fiat transfers automatically handle currency conversions with transparent pricing:

FX Rate Components:

- Base rate: Current market exchange rate between currencies

- FX markup: Additional spread applied (shown in basis points)

- Processing fees: Separate fees for source and destination rails

Rate Considerations:

- Quotes valid for 2 minutes to account for FX volatility

- Rates include all markup and fees for transparency

- Cross-currency transfers may have higher fees than domestic transfers

Updated9 months ago

---

---

## Stablecoin Swaps

> Source: https://due.readme.io/docs/stablecoin-to-stablecoin-transfers

- MOVE MONEY

- Transfers

# Stablecoin swaps

Convert stablecoins across different blockchain networks and currencies through crypto-to-crypto transfers. Swap between networks (Polygon to Base) and currencies (USDC to EURC) using blockchain transaction signing.

## Overview

Stablecoin swaps enable cross-network and cross-currency conversions between different stablecoins and blockchain networks. These are crypto-to-crypto transfers that require blockchain transaction signing to authorize the source stablecoin transfer and deliver the equivalent value to your destination network.

Common Use Cases:

- Network optimization - Move funds to networks with lower gas fees

- DeFi protocol access - Bridge to specific networks for protocol interactions

- Currency hedging - Convert between USD and EUR stablecoins

- Liquidity management - Optimize stablecoin positions across multiple networks

---

## Step-by-Step Process

### 1. Get Available Channels

Discover supported crypto-to-crypto swap combinations.

```
curl -H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
https://api.due.network/v1/channels
```

Look for channels where:

- Source channels: type: "deposit" on crypto rails (ethereum, polygon, arbitrum, base, tron)

- Destination channels: type: "withdrawal" on crypto rails (ethereum, polygon, arbitrum, base, tron)

### 2. Create Destination Recipient

Set up the destination crypto address where swapped stablecoins will be delivered.

```
curl -X POST https://api.due.network/v1/recipients \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "name": "My Base Wallet",
  "details": {
    "schema": "evm",
    "address": "0x742d35Cc6665C6c175E8c7CaB7CeEf5634123456"
  },
  "isExternal": false
}'
```

### 3. Generate Quote

Get real-time pricing for your stablecoin swap with exchange rates and network costs.

```
curl -X POST https://api.due.network/v1/transfers/quote \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "source": {
    "rail": "polygon",
    "currency": "USDC",
    "amount": "100.00"
  },
  "destination": {
    "rail": "base",
    "currency": "EURC", 
    "amount": "0"
  }
}'
```

Response:

```
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "source": {
    "rail": "polygon",
    "currency": "USDC",
    "amount": "100.00",
    "fee": "0.00"
  },
  "destination": {
    "rail": "base", 
    "currency": "EURC",
    "amount": "91.50",
    "fee": "0.00"
  },
  "fxRate": 0.915,
  "fxMarkup": 50,
  "expiresAt": "2024-03-15T10:32:15Z"
}
```

### 4. Create Transfer

Initialize the stablecoin swap using your quote and destination recipient.

```
curl -X POST https://api.due.network/v1/transfers \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "quote": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "sender": "{wallet_id}",
  "recipient": "{recipient_id}",
  "memo": "USDC to EURC cross-network swap"
}'
```

Response:

```
{
  "id": "{transfer_id}",
  "ownerId": "{owner_id}",
  "status": "awaiting_funds",
  "source": {
    "amount": "100.00",
    "fee": "0.00",
    "currency": "USDC",
    "rail": "polygon",
    "id": "{wallet_id}",
    "label": "My Polygon Wallet", 
    "details": {
      "schema": "evm",
      "address": "0x1234567890abcdef1234567890abcdef12345678"
    }
  },
  "destination": {
    "amount": "91.50",
    "fee": "0.00", 
    "currency": "EURC",
    "rail": "base",
    "id": "{recipient_id}",
    "label": "My Base Wallet",
    "details": {
      "schema": "evm", 
      "address": "0x742d35Cc6665C6c175E8c7CaB7CeEf5634123456"
    },
    "memo": "USDC to EURC cross-network swap"
  },
  "fxRate": 0.915,
  "fxMarkup": 50,
  "transferInstructions": {
    "type": "TransferIntent"
  },
  "createdAt": "2024-03-15T10:30:15Z",
  "expiresAt": "2024-03-15T10:35:15Z"
}
```

### 5. Create Transfer Intent

Generate blockchain transaction data for signing the source stablecoin transfer.

```
curl -X POST https://api.due.network/v1/transfers/{transfer_id}/transfer_intent \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id"
```

Response:

```
{
  "token": "intent_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": "{intent_id}",
  "sender": "0x1234567890abcdef1234567890abcdef12345678",
  "amountIn": "100000000",
  "to": {
    "0x9876543210987654321098765432109876543210": "100000000"
  },
  "tokenIn": "USDC",
  "tokenOut": "EURC",
  "networkIdIn": "polygon", 
  "networkIdOut": "base",
  "gasFee": "0",
  "signables": [
    {
      "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
      "type": "EIP712",
      "data": {
        "types": {
          "Transfer": [
            {"name": "to", "type": "address"},
            {"name": "amount", "type": "uint256"},
            {"name": "nonce", "type": "uint256"}
          ]
        },
        "domain": {
          "name": "DueProtocol",
          "version": "1",
          "chainId": 137
        },
        "message": {
          "to": "0x9876543210987654321098765432109876543210",
          "amount": "100000000",
          "nonce": "456"
        }
      }
    }
  ],
  "expiresAt": "2024-03-15T10:40:15Z",
  "createdAt": "2024-03-15T10:30:45Z"
}
```

### 6. Sign Transaction

Use your wallet to sign the Polygon USDC transfer transaction.

Example using ethers.js:

```
import { ethers } from 'ethers';

// Connect to Polygon network
const provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com');
const signer = provider.getSigner();

// Sign the transfer intent transaction
const signable = transferIntent.signables[0];
const signature = await signer._signTypedData(
  signable.data.domain,
  signable.data.types, 
  signable.data.message
);

console.log('Polygon USDC transfer signature:', signature);
```

### 7. Submit Signed Transaction

Submit the signed transaction to execute the stablecoin swap.

```
curl -X POST https://api.due.network/v1/transfer_intents/submit \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "intentToken": "intent_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "signatures": [
    "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef12345678901c"
  ]
}'
```

Upon successful submission, your USDC will be transferred from Polygon and EURC will be delivered to your Base network address.

Updated9 months ago

---

---

## Virtual Account Details Rendering

> Source: https://due.readme.io/docs/rendering-va-details

- MOVE MONEY

- Virtual accounts

# Virtual Account Details Rendering

Dynamic UI rendering for virtual account deposit instructions based on schema types - automatically display the correct bank details, crypto addresses, or payment information for each virtual account.

When virtual accounts are created, they return schema-specific details that need to be displayed to users as deposit instructions. This guide shows how to dynamically render the appropriate UI based on the schema type and details returned.

Base URL
https://api.due.network/v1

Authentication required: Include your API key in Authorization header and account ID in Due-Account-Id header.

---

## 🎯 Overview

Virtual accounts return different details objects based on their schemaIn type:

- Bank schemas (bank_sepa, bank_us, bank_uk) - Return bank account details

- Crypto schemas (evm, tron, starknet) - Return crypto addresses

The key is to:

- Get schema definitions from /schemas endpoint

- Match virtual account schema to the schema definition

- Render appropriate UI based on schema category and fields

---

## 📋 Get Schema Definitions

First, fetch all available schemas to understand field requirements:

```
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/schemas
```

Schema Response Structure:

```
[
  {
    "id": "bank_sepa",
    "category": "bank",
    "fields": [
      {
        "key": "accountType",
        "type": "string",
        "oneOf": ["individual", "business"],
        "required": true
      },
      {
        "key": "IBAN",
        "type": "iban",
        "required": true
      },
      {
        "key": "companyName",
        "type": "string",
        "requiredIf": "accountType=business"
      }
    ]
  },
  {
    "id": "evm",
    "category": "crypto",
    "fields": [
      {
        "key": "address",
        "type": "eth_addr",
        "required": true
      }
    ]
  }
]
```

---

## 🏦 Bank Schema Rendering

### SEPA (European) Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "bank_sepa",
  "currencyIn": "EUR",
  "details": {
    "accountType": "business",
    "companyName": "Your Company Ltd",
    "IBAN": "DE89370400440532013000",
    "bankName": "Commerzbank AG",
    "swiftCode": "COBADEFF"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions sepa">
  <h3>💶 EUR Deposit Instructions</h3>
  <div class="bank-details">
    <div class="detail-row">
      <label>IBAN:</label>
      <span class="copyable" data-copy="DE89370400440532013000">
        DE89 3704 0044 0532 0130 00
        <button class="copy-btn">📋</button>
      </span>
    </div>
    <div class="detail-row">
      <label>Bank Name:</label>
      <span>Commerzbank AG</span>
    </div>
    <div class="detail-row">
      <label>SWIFT/BIC:</label>
      <span class="copyable" data-copy="COBADEFF">COBADEFF</span>
    </div>
    <div class="detail-row">
      <label>Beneficiary:</label>
      <span>Your Company Ltd</span>
    </div>
  </div>
  <div class="important-note">
    <p>⚠️ <strong>Important:</strong> Only send EUR to this account. Other currencies will be rejected.</p>
  </div>
</div>
```

### US Bank Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "bank_us",
  "currencyIn": "USD",
  "details": {
    "bankName": "JPMorgan Chase Bank",
    "accountName": "Your Company LLC",
    "accountNumber": "123456789012",
    "routingNumber": "021000021"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions us-bank">
  <h3>💵 USD Deposit Instructions</h3>
  <div class="bank-details">
    <div class="detail-row">
      <label>Account Number:</label>
      <span class="copyable" data-copy="123456789012">
        123456789012
        <button class="copy-btn">📋</button>
      </span>
    </div>
    <div class="detail-row">
      <label>Routing Number:</label>
      <span class="copyable" data-copy="021000021">021000021</span>
    </div>
    <div class="detail-row">
      <label>Bank Name:</label>
      <span>JPMorgan Chase Bank</span>
    </div>
    <div class="detail-row">
      <label>Account Name:</label>
      <span>Your Company LLC</span>
    </div>
  </div>
  <div class="transfer-types">
    <p><strong>Supported:</strong> ACH Transfer, Wire Transfer</p>
    <p><strong>Processing Time:</strong> ACH (1-2 days), Wire (same day)</p>
  </div>
</div>
```

### UK Bank Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "bank_uk",
  "currencyIn": "GBP",
  "details": {
    "accountType": "business",
    "companyName": "Your Company Ltd",
    "accountNumber": "12345678",
    "sortCode": "123456",
    "bankName": "Barclays Bank PLC"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions uk-bank">
  <h3>💷 GBP Deposit Instructions</h3>
  <div class="bank-details">
    <div class="detail-row">
      <label>Account Number:</label>
      <span class="copyable" data-copy="12345678">12345678</span>
    </div>
    <div class="detail-row">
      <label>Sort Code:</label>
      <span class="copyable" data-copy="123456">12-34-56</span>
    </div>
    <div class="detail-row">
      <label>Account Name:</label>
      <span>Your Company Ltd</span>
    </div>
    <div class="detail-row">
      <label>Bank:</label>
      <span>Barclays Bank PLC</span>
    </div>
  </div>
  <div class="payment-info">
    <p><strong>Faster Payments:</strong> Instant transfer (up to £1M)</p>
    <p><strong>CHAPS:</strong> Same day (for larger amounts)</p>
  </div>
</div>
```

### Mexican Bank Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "bank_mexico",
  "currencyIn": "MXN",
  "details": {
    "clabe": "012345678901234567",
    "beneficiaryName": "Your Company Mexico SA",
    "bankName": "BBVA Mexico"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions mexico-bank">
  <h3>🇲🇽 MXN Deposit Instructions</h3>
  <div class="bank-details">
    <div class="detail-row">
      <label>CLABE:</label>
      <span class="copyable clabe" data-copy="012345678901234567">
        0123 4567 8901 2345 67
        <button class="copy-btn">📋</button>
      </span>
    </div>
    <div class="detail-row">
      <label>Beneficiary:</label>
      <span>Your Company Mexico SA</span>
    </div>
    <div class="detail-row">
      <label>Bank:</label>
      <span>BBVA Mexico</span>
    </div>
  </div>
  <div class="spei-info">
    <p><strong>SPEI Transfer:</strong> Instant processing 24/7</p>
    <p><strong>Maximum:</strong> No limit for SPEI transfers</p>
  </div>
</div>
```

---

## 💎 Crypto Schema Rendering

### Ethereum/EVM Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "evm",
  "currencyIn": "USDC",
  "railOut": "ethereum",
  "details": {
    "address": "0x1234567890abcdef1234567890abcdef12345678"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions crypto evm">
  <h3>⚡ USDC Deposit Instructions</h3>
  <div class="crypto-details">
    <div class="network-info">
      <span class="network-badge ethereum">Ethereum Network</span>
      <span class="token-badge usdc">USDC</span>
    </div>
    <div class="address-section">
      <label>Deposit Address:</label>
      <div class="address-container">
        <span class="address copyable" data-copy="0x1234567890abcdef1234567890abcdef12345678">
          0x1234567890abcdef1234567890abcdef12345678
        </span>
        <button class="copy-btn">📋 Copy</button>
      </div>
      <div class="qr-code">
        <img src="data:image/png;base64,..." alt="QR Code" />
        <p>Scan QR code with wallet</p>
      </div>
    </div>
  </div>
  <div class="crypto-warnings">
    <div class="warning">
      <p>⚠️ <strong>Only send USDC on Ethereum network</strong></p>
      <p>• Other tokens will be lost permanently</p>
      <p>• Minimum deposit: $1 USDC</p>
      <p>• Network fees apply</p>
    </div>
  </div>
</div>
```

### Tron Virtual Accounts

Virtual Account Response:

```
{
  "schemaIn": "tron",
  "currencyIn": "USDT",
  "railOut": "arbitrum",
  "details": {
    "address": "TQn9Y2khEsLJW1ChVWFMSMeRDow5KcbLSE"
  }
}
```

Rendered UI:

```
<div class="deposit-instructions crypto tron">
  <h3>🟢 USDT Deposit Instructions</h3>
  <div class="crypto-details">
    <div class="network-info">
      <span class="network-badge tron">Tron Network (TRC-20)</span>
      <span class="token-badge usdt">USDT</span>
      <span class="conversion-info">→ Auto-converts to USDC on Arbitrum</span>
    </div>
    <div class="address-section">
      <label>Deposit Address:</label>
      <div class="address-container">
        <span class="address copyable" data-copy="TQn9Y2khEsLJW1ChVWFMSMeRDow5KcbLSE">
          TQn9Y2khEsLJW1ChVWFMSMeRDow5KcbLSE
        </span>
        <button class="copy-btn">📋 Copy</button>
      </div>
    </div>
  </div>
  <div class="bridge-info">
    <div class="conversion-flow">
      <span class="step">USDT (Tron)</span>
      <span class="arrow">→</span>
      <span class="step">Auto-Bridge</span>
      <span class="arrow">→</span>
      <span class="step">USDC (Arbitrum)</span>
    </div>
    <p><strong>Processing:</strong> ~5 minutes after confirmation</p>
  </div>
</div>
```

---

## 💻 Dynamic Rendering Implementation

### React Component

```
import React, { useState, useEffect } from 'react';

const VirtualAccountDetails = ({ virtualAccount, onCopy }) => {
  const [schemas, setSchemas] = useState([]);
  
  useEffect(() => {
    // Fetch schemas on component mount
    fetchSchemas();
  }, []);
  
  const fetchSchemas = async () => {
    try {
      const response = await fetch('/api/due/schemas', {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Due-Account-Id': accountId
        }
      });
      const schemaData = await response.json();
      setSchemas(schemaData);
    } catch (error) {
      console.error('Failed to fetch schemas:', error);
    }
  };
  
  const getSchemaInfo = (schemaId) => {
    return schemas.find(s => s.id === schemaId);
  };
  
  const formatAddress = (address, type) => {
    if (type === 'iban') {
      return address.replace(/(.{4})/g, '$1 ').trim();
    } else if (type === 'clabe') {
      return address.replace(/(.{4})/g, '$1 ').trim();
    } else if (type === 'sort_code') {
      return address.replace(/(.{2})/g, '$1-').slice(0, -1);
    }
    return address;
  };
  
  const handleCopy = async (text, label) => {
    try {
      await navigator.clipboard.writeText(text);
      onCopy?.(label);
    } catch (error) {
      console.error('Failed to copy:', error);
    }
  };
  
  const renderBankDetails = () => {
    const { details, currencyIn, schemaIn } = virtualAccount;
    const schema = getSchemaInfo(schemaIn);
    
    const getCurrencyIcon = (currency) => {
      const icons = {
        'EUR': '💶',
        'USD': '💵', 
        'GBP': '💷',
        'MXN': '🇲🇽'
      };
      return icons[currency] || '💰';
    };
    
    const getNetworkName = (schemaId) => {
      const networks = {
        'bank_sepa': 'SEPA Transfer',
        'bank_us': 'ACH / Wire Transfer',
        'bank_uk': 'Faster Payments',
        'bank_mexico': 'SPEI Transfer'
      };
      return networks[schemaId] || 'Bank Transfer';
    };
    
    return (
      <div className={`deposit-instructions bank ${schemaIn}`}>
        <h3>{getCurrencyIcon(currencyIn)} {currencyIn} Deposit Instructions</h3>
        
        <div className="bank-details">
          {/* IBAN for SEPA */}
          {details.IBAN && (
            <div className="detail-row">
              <label>IBAN:</label>
              <div className="copyable-field">
                <span className="value">{formatAddress(details.IBAN, 'iban')}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.IBAN, 'IBAN')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
          
          {/* Account Number for US/UK */}
          {details.accountNumber && (
            <div className="detail-row">
              <label>Account Number:</label>
              <div className="copyable-field">
                <span className="value">{details.accountNumber}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.accountNumber, 'Account Number')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
          
          {/* Routing Number for US */}
          {details.routingNumber && (
            <div className="detail-row">
              <label>Routing Number:</label>
              <div className="copyable-field">
                <span className="value">{details.routingNumber}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.routingNumber, 'Routing Number')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
          
          {/* Sort Code for UK */}
          {details.sortCode && (
            <div className="detail-row">
              <label>Sort Code:</label>
              <div className="copyable-field">
                <span className="value">{formatAddress(details.sortCode, 'sort_code')}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.sortCode, 'Sort Code')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
          
          {/* CLABE for Mexico */}
          {details.clabe && (
            <div className="detail-row">
              <label>CLABE:</label>
              <div className="copyable-field">
                <span className="value">{formatAddress(details.clabe, 'clabe')}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.clabe, 'CLABE')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
          
          {/* Bank Name */}
          {details.bankName && (
            <div className="detail-row">
              <label>Bank:</label>
              <span className="value">{details.bankName}</span>
            </div>
          )}
          
          {/* Beneficiary Name */}
          {(details.accountName || details.companyName || details.beneficiaryName) && (
            <div className="detail-row">
              <label>Beneficiary:</label>
              <span className="value">
                {details.accountName || details.companyName || details.beneficiaryName}
              </span>
            </div>
          )}
          
          {/* SWIFT Code */}
          {details.swiftCode && (
            <div className="detail-row">
              <label>SWIFT/BIC:</label>
              <div className="copyable-field">
                <span className="value">{details.swiftCode}</span>
                <button 
                  className="copy-btn"
                  onClick={() => handleCopy(details.swiftCode, 'SWIFT Code')}
                >
                  📋
                </button>
              </div>
            </div>
          )}
        </div>
        
        <div className="payment-info">
          <p><strong>Payment Method:</strong> {getNetworkName(schemaIn)}</p>
          <p className="currency-warning">
            ⚠️ Only send {currencyIn} to this account. Other currencies will be rejected.
          </p>
        </div>
      </div>
    );
  };
  
  const renderCryptoDetails = () => {
    const { details, currencyIn, railOut, schemaIn } = virtualAccount;
    
    const getNetworkInfo = (schema, rail) => {
      if (schema === 'tron') {
        return { name: 'Tron', badge: 'tron', color: '#ff0000' };
      } else if (schema === 'evm') {
        const networks = {
          'ethereum': { name: 'Ethereum', badge: 'ethereum', color: '#627eea' },
          'polygon': { name: 'Polygon', badge: 'polygon', color: '#8247e5' },
          'arbitrum': { name: 'Arbitrum', badge: 'arbitrum', color: '#28a0f0' },
          'base': { name: 'Base', badge: 'base', color: '#0052ff' }
        };
        return networks[rail] || { name: 'EVM', badge: 'evm', color: '#627eea' };
      }
      return { name: 'Crypto', badge: 'crypto', color: '#f7931a' };
    };
    
    const getCurrencyIcon = (currency) => {
      const icons = {
        'USDC': '🔵',
        'USDT': '🟢',
        'EURC': '🔵'
      };
      return icons[currency] || '💎';
    };
    
    const networkInfo = getNetworkInfo(schemaIn, railOut);
    
    return (
      <div className={`deposit-instructions crypto ${schemaIn}`}>
        <h3>{getCurrencyIcon(currencyIn)} {currencyIn} Deposit Instructions</h3>
        
        <div className="crypto-details">
          <div className="network-info">
            <span className={`network-badge ${networkInfo.badge}`} style={{backgroundColor: networkInfo.color}}>
              {networkInfo.name} Network
            </span>
            <span className={`token-badge ${currencyIn.toLowerCase()}`}>
              {currencyIn}
            </span>
          </div>
          
          <div className="address-section">
            <label>Deposit Address:</label>
            <div className="address-container">
              <span className="address">{details.address}</span>
              <button 
                className="copy-btn primary"
                onClick={() => handleCopy(details.address, 'Address')}
              >
                📋 Copy Address
              </button>
            </div>
            
            <div className="qr-section">
              <QRCodeGenerator value={details.address} />
              <p>Scan with your wallet app</p>
            </div>
          </div>
        </div>
        
        <div className="crypto-warnings">
          <div className="warning">
            <p><strong>⚠️ Important:</strong></p>
            <ul>
              <li>Only send {currencyIn} on {networkInfo.name} network</li>
              <li>Other tokens or networks will result in permanent loss</li>
              <li>Minimum deposit: 1 {currencyIn}</li>
              <li>Network fees apply</li>
            </ul>
          </div>
        </div>
      </div>
    );
  };
  
  if (!virtualAccount) {
    return <div className="loading">Loading deposit instructions...</div>;
  }
  
  const schema = getSchemaInfo(virtualAccount.schemaIn);
  
  if (!schema) {
    return <div className="error">Unable to load deposit instructions</div>;
  }
  
  return (
    <div className="virtual-account-details">
      {schema.category === 'bank' && renderBankDetails()}
      {schema.category === 'crypto' && renderCryptoDetails()}
      
      {virtualAccount.railOut && virtualAccount.currencyOut && (
        <div className="conversion-info">
          <h4>💱 Auto-Conversion</h4>
          <div className="conversion-flow">
            <span>{virtualAccount.currencyIn}</span>
            <span className="arrow">→</span>
            <span>{virtualAccount.currencyOut}</span>
            <span className="network">on {virtualAccount.railOut}</span>
          </div>
          <p>Funds automatically convert upon deposit confirmation</p>
        </div>
      )}
    </div>
  );
};

// QR Code component
const QRCodeGenerator = ({ value }) => {
  const [qrUrl, setQrUrl] = useState('');
  
  useEffect(() => {
    // Generate QR code (using a library like qrcode)
    import('qrcode').then(QRCode => {
      QRCode.toDataURL(value, { width: 200 }).then(setQrUrl);
    });
  }, [value]);
  
  return qrUrl ? <img src={qrUrl} alt="QR Code" className="qr-code" /> : null;
};

export default VirtualAccountDetails;
```

### Vanilla JavaScript Implementation

```
class VirtualAccountRenderer {
  constructor(apiKey, accountId) {
    this.apiKey = apiKey;
    this.accountId = accountId;
    this.schemas = [];
  }
  
  async init() {
    await this.fetchSchemas();
  }
  
  async fetchSchemas() {
    try {
      const response = await fetch('https://api.due.network/v1/schemas', {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Due-Account-Id': this.accountId
        }
      });
      this.schemas = await response.json();
    } catch (error) {
      console.error('Failed to fetch schemas:', error);
    }
  }
  
  getSchema(schemaId) {
    return this.schemas.find(s => s.id === schemaId);
  }
  
  render(virtualAccount, container) {
    const schema = this.getSchema(virtualAccount.schemaIn);
    
    if (!schema) {
      container.innerHTML = '<div class="error">Schema not found</div>';
      return;
    }
    
    if (schema.category === 'bank') {
      this.renderBankAccount(virtualAccount, container);
    } else if (schema.category === 'crypto') {
      this.renderCryptoAccount(virtualAccount, container);
    }
    
    this.addCopyListeners(container);
  }
  
  renderBankAccount(virtualAccount, container) {
    const { details, currencyIn, schemaIn } = virtualAccount;
    
    const html = `
      <div class="deposit-instructions bank ${schemaIn}">
        <h3>${this.getCurrencyIcon(currencyIn)} ${currencyIn} Deposit Instructions</h3>
        <div class="bank-details">
          ${this.renderBankFields(details, schemaIn)}
        </div>
        <div class="payment-info">
          <p><strong>Payment Method:</strong> ${this.getPaymentMethod(schemaIn)}</p>
          <p class="warning">⚠️ Only send ${currencyIn} to this account</p>
        </div>
      </div>
    `;
    
    container.innerHTML = html;
  }
  
  renderCryptoAccount(virtualAccount, container) {
    const { details, currencyIn, schemaIn, railOut } = virtualAccount;
    
    const html = `
      <div class="deposit-instructions crypto ${schemaIn}">
        <h3>${this.getCurrencyIcon(currencyIn)} ${currencyIn} Deposit Instructions</h3>
        <div class="crypto-details">
          <div class="network-info">
            <span class="network-badge">${this.getNetworkName(schemaIn, railOut)}</span>
            <span class="token-badge">${currencyIn}</span>
          </div>
          <div class="address-section">
            <label>Deposit Address:</label>
            <div class="address-container">
              <span class="address" data-copy="${details.address}">${details.address}</span>
              <button class="copy-btn" data-copy="${details.address}">📋 Copy</button>
            </div>
          </div>
        </div>
        <div class="crypto-warnings">
          <p><strong>⚠️ Important:</strong> Only send ${currencyIn} on ${this.getNetworkName(schemaIn, railOut)} network</p>
        </div>
      </div>
    `;
    
    container.innerHTML = html;
  }
  
  renderBankFields(details, schemaIn) {
    let html = '';
    
    // IBAN for SEPA
    if (details.IBAN) {
      html += `
        <div class="detail-row">
          <label>IBAN:</label>
          <span class="value copyable" data-copy="${details.IBAN}">
            ${this.formatIBAN(details.IBAN)}
            <button class="copy-btn" data-copy="${details.IBAN}">📋</button>
          </span>
        </div>
      `;
    }
    
    // Account Number for US/UK
    if (details.accountNumber) {
      html += `
        <div class="detail-row">
          <label>Account Number:</label>
          <span class="value copyable" data-copy="${details.accountNumber}">
            ${details.accountNumber}
            <button class="copy-btn" data-copy="${details.accountNumber}">📋</button>
          </span>
        </div>
      `;
    }
    
    // Routing Number for US
    if (details.routingNumber) {
      html += `
        <div class="detail-row">
          <label>Routing Number:</label>
          <span class="value copyable" data-copy="${details.routingNumber}">
            ${details.routingNumber}
            <button class="copy-btn" data-copy="${details.routingNumber}">📋</button>
          </span>
        </div>
      `;
    }
    
    // Sort Code for UK
    if (details.sortCode) {
      html += `
        <div class="detail-row">
          <label>Sort Code:</label>
          <span class="value copyable" data-copy="${details.sortCode}">
            ${this.formatSortCode(details.sortCode)}
            <button class="copy-btn" data-copy="${details.sortCode}">📋</button>
          </span>
        </div>
      `;
    }
    
    // CLABE for Mexico
    if (details.clabe) {
      html += `
        <div class="detail-row">
          <label>CLABE:</label>
          <span class="value copyable" data-copy="${details.clabe}">
            ${this.formatCLABE(details.clabe)}
            <button class="copy-btn" data-copy="${details.clabe}">📋</button>
          </span>
        </div>
      `;
    }
    
    // Bank Name
    if (details.bankName) {
      html += `
        <div class="detail-row">
          <label>Bank:</label>
          <span class="value">${details.bankName}</span>
        </div>
      `;
    }
    
    // Beneficiary
    const beneficiary = details.accountName || details.companyName || details.beneficiaryName;
    if (beneficiary) {
      html += `
        <div class="detail-row">
          <label>Beneficiary:</label>
          <span class="value">${beneficiary}</span>
        </div>
      `;
    }
    
    // SWIFT Code
    if (details.swiftCode) {
      html += `
        <div class="detail-row">
          <label>SWIFT/BIC:</label>
          <span class="value copyable
```

Updated9 months ago

---

---

## Recipients

> Source: https://due.readme.io/docs/recipients

- MOVE MONEY

# Recipients

Recipients are payment destinations for your global transfers. Create once, use for multiple payments across traditional banking, mobile money networks, and cryptocurrency platforms.

Base URLhttps://api.due.network/v1

Authentication required: Include your API key in Authorization header and account ID in Due-Account-Id header.

---

## Core Concepts
TermDefinition
RecipientPayment destination with all required transfer details
SchemaField template for payment method (bank_us, bank_sepa, etc.)
ChannelComplete payment config (rail + currency + fees + timing+schemas)
Financial InstitutionBank/provider selection required for some schemas

---

## 📋 Payment Methods

- Traditional Banking - ACH, SWIFT, SEPA, Faster Payments, local rails

- Mobile Money - M-Pesa, MTN, Airtel, regional providers

- Cryptocurrency - USDC/USDT on major networks (Ethereum, Polygon, etc.)

Get real-time channels: Use GET /channels for current fees, processing times, and availability.
Get field requirements: Use GET /schemas for up-to-date field definitions.

---

## API Endpoints
MethodEndpointPurpose
POST/recipientsCreate new recipient
GET/recipientsList recipients (optional: include deleted)
GET/recipients/{id}Get recipient details
DELETE/recipients/{id}Delete recipient
GET/channelsAvailable payment channels
GET/schemasAll schema field definitions
GET/financial_institutions/{country}/{schema}Banks/providers for selection

---

## 1️⃣ Create Recipients

```
POST /v1/recipients
Authorization: Bearer {api_key}
Due-Account-Id: {account_id}
Content-Type: application/json
```

### Core Fields
FieldTypeRequiredDescription
idstring✅Your unique recipient identifier
countrystring✅ISO 3166-1 alpha-2 country code
namestring✅Legal name or business name
emailstring✅Recipient email
detailsobject✅Schema-specific payment details
isExternalbooleanExternal recipient flag (default: false)
isActivebooleanActive status (default: true)

### US Bank Transfer

```
curl -X POST https://api.due.network/v1/recipients \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "emp_john_001",
    "country": "US",
    "name": "John Smith",
    "email": "[email protected]",
    "details": {
			"schema": "bank_us",
      "bankName": "JPMorgan Chase Bank",
      "accountName": "John Smith",
      "accountNumber": "123456789",
      "routingNumber": "021000021",
      "beneficiaryAddress": {
        "street_line_1": "123 Main Street",
        "city": "New York",
        "postal_code": "10001",
        "country": "USA",
        "state": "NY"
      }
    }
  }'
```

### SEPA Transfer (Europe)

```
curl -X POST https://api.due.network/v1/recipients \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "contractor_marie_fr",
    "country": "FR",
    "name": "Marie Dubois",
    "email": "[email protected]",
    "details": {
      "schema": "bank_sepa",
      "accountType": "individual",
      "firstName": "Marie",
      "lastName": "Dubois",
      "IBAN": "FR1420041010050500013M02606"
    }
  }'
```

### SWIFT Transfer (International)

```
curl -X POST https://api.due.network/v1/recipients \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "supplier_sg_001",
    "country": "SG",
    "name": "Singapore Tech Pte Ltd",
    "email": "[email protected]",
    "details": {
			"schema": "bank_swift",
      "accountType": "business",
      "companyName": "Singapore Tech Pte Ltd",
      "bankName": "DBS Bank Ltd",
      "swiftCode": "DBSSSGSG",
      "accountNumber": "1234567890",
      "currency": "SGD"
    }
  }'
```

### African Bank (with Institution Selection)

Step 1: Get available banks

```
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/financial_institutions/NG/bank_africa
```

Step 2: Create recipient

```
curl -X POST https://api.due.network/v1/recipients \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  -H "Content-Type: application/json" \
  -d '{
  "id": "vendor_ng_001",
		
    "country": "NG",
    "name": "Adebayo Okafor",
    "email": "[email protected]",
    "details": {
			"schema": "bank_africa",
      "financialInstitutionId": "access_bank_ng",
      "accountNumber": "0123456789",
      "accountName": "Adebayo Okafor"
    }
  }'
```

### Cryptocurrency

```
curl -X POST https://api.due.network/v1/recipients \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  -H "Content-Type: application/json" \
  -d '{
  "id": "trader_eth_001",
    "country": "US",
    "name": "Alex Thompson",
    "email": "[email protected]",
    "details": {
			"schema": "evm",
      "address": "0x742d35Cc6665C6c175E8c7CaB7CeEf5634123456"
    }
  }'
```

---

## 2️⃣ List Recipients

```
# All active recipients
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/recipients

# Include deleted recipients
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  "https://api.due.network/v1/recipients?with_deleted=true"
```

---

## 3️⃣ Get Single Recipient

```
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/recipients/emp_john_001
```

---

## 4️⃣ Delete Recipient

```
curl -X DELETE \
  -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/recipients/emp_john_001
```

---

## 5️⃣ Get Schemas & Channels

### Get All Schema Definitions

```
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/schemas
```

### Get Available Channels

```
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/channels
```

### Get Financial Institutions

```
# Nigerian banks
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/financial_institutions/NG/bank_africa

# Kenyan mobile money providers
curl -H "Authorization: Bearer your_api_key" \
  -H "Due-Account-Id: your_account_id" \
  https://api.due.network/v1/financial_institutions/KE/momo_africa
```

---

## 💻 Python SDK

```
import requests

class DueRecipientsAPI:
    def __init__(self, api_key: str, account_id: str):
        self.base_url = "https://api.due.network/v1"
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Due-Account-Id": account_id,
            "Content-Type": "application/json"
        }
    
    def create_recipient(self, recipient_data: dict) -> dict:
        response = requests.post(f"{self.base_url}/recipients", 
                               headers=self.headers, json=recipient_data)
        response.raise_for_status()
        return response.json()
    
    def list_recipients(self, with_deleted: bool = False) -> dict:
        params = {"with_deleted": with_deleted} if with_deleted else {}
        response = requests.get(f"{self.base_url}/recipients", 
                              headers=self.headers, params=params)
        return response.json()
    
    def get_recipient(self, recipient_id: str) -> dict:
        response = requests.get(f"{self.base_url}/recipients/{recipient_id}", 
                              headers=self.headers)
        return response.json()
    
    def delete_recipient(self, recipient_id: str) -> dict:
        response = requests.delete(f"{self.base_url}/recipients/{recipient_id}", 
                                 headers=self.headers)
        return response.json()
    
    def get_schemas(self) -> list:
        response = requests.get(f"{self.base_url}/schemas", headers=self.headers)
        return response.json()
    
    def get_channels(self) -> list:
        response = requests.get(f"{self.base_url}/channels", headers=self.headers)
        return response.json()
    
    def get_financial_institutions(self, country: str, schema: str) -> list:
        response = requests.get(f"{self.base_url}/financial_institutions/{country}/{schema}", 
                              headers=self.headers)
        return response.json()

# Usage
api = DueRecipientsAPI("your_api_key", "your_account_id")

# Create US bank recipient
us_recipient = api.create_recipient({
    "id": "emp_sarah_001",
    "country": "US",
    "name": "Sarah Johnson", 
    "email": "[email protected]",
    "details": {
        "bankName": "Bank of America",
        "accountName": "Sarah Johnson",
        "accountNumber": "987654321",
        "routingNumber": "021000021",
        "beneficiaryAddress": {
            "street_line_1": "456 Oak St",
            "city": "Los Angeles",
            "state": "CA",
            "postal_code": "90210",
            "country": "USA"
        }
    }
})

# Get available schemas
schemas = api.get_schemas()
bank_schemas = [s for s in schemas if s['category'] == 'bank']
print(f"Available bank schemas: {[s['id'] for s in bank_schemas]}")

# Get Nigerian banks for institution selection
ng_banks = api.get_financial_institutions("NG", "bank_africa")
print(f"Nigerian banks: {[b['name'] for b in ng_banks]}")
```

---

## 📱 JavaScript SDK

```
class DueRecipientsAPI {
    constructor(apiKey, accountId) {
        this.baseURL = 'https://api.due.network/v1';
        this.headers = {
            'Authorization': `Bearer ${apiKey}`,
            'Due-Account-Id': accountId,
            'Content-Type': 'application/json'
        };
    }

    async createRecipient(recipientData) {
        const response = await fetch(`${this.baseURL}/recipients`, {
            method: 'POST',
            headers: this.headers,
            body: JSON.stringify(recipientData)
        });
        return response.json();
    }

    async listRecipients(withDeleted = false) {
        const params = withDeleted ? '?with_deleted=true' : '';
        const response = await fetch(`${this.baseURL}/recipients${params}`, {
            headers: this.headers
        });
        return response.json();
    }

    async getSchemas() {
        const response = await fetch(`${this.baseURL}/schemas`, {
            headers: this.headers
        });
        return response.json();
    }

    async getChannels() {
        const response = await fetch(`${this.baseURL}/channels`, {
            headers: this.headers
        });
        return response.json();
    }

    async getFinancialInstitutions(country, schema) {
        const response = await fetch(
            `${this.baseURL}/financial_institutions/${country}/${schema}`,
            { headers: this.headers }
        );
        return response.json();
    }
}

// Usage
const api = new DueRecipientsAPI('your_api_key', 'your_account_id');

// Create SWIFT recipient
const swiftRecipient = await api.createRecipient({
    id: 'supplier_hk_001',
    country: 'HK',
    name: 'Hong Kong Supplier Ltd',
    email: '[email protected]',
    details: {
        accountType: 'business',
        companyName: 'Hong Kong Supplier Ltd',
        bankName: 'HSBC Hong Kong',
        swiftCode: 'HSBCHKHHHKH',
        accountNumber: '123456789',
        currency: 'HKD'
    }
});
```

---

## 🔄 Institution Selection Workflow

For schemas requiring financial institution selection (bank_africa, momo_africa, etc.):

- Get institutions: Call /financial_institutions/{country}/{schema}

- User selects: Present options in your UI

- Create recipient: Use selected institution ID in financialInstitutionId field

```
# Complete workflow example
def create_african_recipient_with_selection(api, country, recipient_data):
    # Step 1: Get available institutions
    institutions = api.get_financial_institutions(country, "bank_africa")
    
    # Step 2: User selection (in real app, show dropdown)
    print("Available banks:")
    for i, inst in enumerate(institutions):
        print(f"{i+1}. {inst['name']}")
    
    selected_id = institutions[0]['id']  # Auto-select first for demo
    
    # Step 3: Create recipient with selected institution
    recipient_data['details']['financialInstitutionId'] = selected_id
    return api.create_recipient(recipient_data)
```

---

## 🚨 Important Notes

- Financial Institution Selection: Required for bank_africa, momo_africa, bank_colombia, etc.

- Schema Validation: Use /schemas endpoint to get current field requirements

- Rate Limits: Standard limits apply (see endpoint table)

- Deletion: Recipients with pending payments cannot be deleted

- Updates: Recipient details cannot be modified after creation (delete and recreate instead)

Updated7 months ago

---

---

## FX Rates

> Source: https://due.readme.io/docs/fx-engine

- MOVE MONEY

# FX Rates

Here we walk you through our public FX endpoints so you can quote, price, and chart currencies with just a few lines of code. Whether you're building a fintech app, e-commerce platform, or financial dashboard, our API provides enterprise-grade FX data with developer-friendly simplicity.

Base URL
https://api.due.network/fx

No authentication required for read-only endpoints, but requests are rate-limited. Please cache responses where possible to optimize performance.

---

## Key Concepts & Definitions
TermDefinition
Base CurrencyThe first currency in a pair (e.g., USD in USD/EUR). Represents what you're buying, with the rate showing how much quote currency needed for one unit.
Quote CurrencyThe second currency in a pair (e.g., EUR in USD/EUR). Shows the price of one unit of base currency.
Markup (bps)Fee added to mid-market rate in basis points (1 bps = 0.01%). A 18 bps markup = 0.18% fee, already included in ask rates.
Ask RateRate to buy base currency with quote currency. All API rates are ask rates (inclusive of markup) for conversion quotes.
Bid RateRate to sell base currency for quote currency. Get bid rates by requesting the reverse pair's ask rate.

---

## Market Coverage & Rate Structure

### Direct Rates Available

Direct rates are provided only with either of these major currencies:

- USD (US Dollar)

- EUR (Euro)

- USDC (USD Coin)

- USDT (Tether)

- EURC (Euro Coin)

### Cross-Rate Handling

For currency pairs not directly available (e.g., GBP/JPY, MXN/CAD):

- Single market requests: Returns computed cross-rates automatically

- Quote endpoint: Calculates optimal routing and final conversion

- Historical data: Retrieve constituent pairs separately (e.g., for MXN/EUR history, get MXN/USD and USD/EUR)

### Rate Display Best Practices

When rates return very small decimals (< 0.01), consider showing the reverse rate for better readability:

```
# For currencies like NGN, ARS, KRW, TZS
if rate < 0.01:
    display_rate = f"1 {quote_currency} = {1/rate:.2f} {base_currency}"
else:
    display_rate = f"1 {base_currency} = {rate:.4f} {quote_currency}"
```

---

## API Endpoints Overview
MethodEndpointPurposeRate Limit
GET/marketsAll tradable pairs with live ask rates60/min
GET/markets/{base}/{quote}Single pair live ask rate120/min
GET/markets/{base}/{quote}/historyHistorical ask rates30/min
POST/quoteExecutable FX quote with firm pricing100/min

All currency codes followISO-4217 standard (USD, EUR, GBP, etc.)

---

## 1️⃣ List All Markets

Get every available currency pair with current ask rates in one request.

```
GET /fx/markets
```

Example Request

```
curl -s https://api.due.network/fx/markets | jq .
```

Sample Response

```
[
  {
    "pair": { "base": "USD", "quote": "EUR" },
    "rate": 0.91342,
    "markupBps": 18,
    "updatedAt": "2025-07-19T10:04:12Z"
  },
  {
    "pair": { "base": "GBP", "quote": "JPY" },
    "rate": 184.25,
    "markupBps": 18,
    "updatedAt": "2025-07-19T10:04:12Z"
  }
]
```

Response Fields
FieldTypeDescription
pair.basestringBase currency code
pair.quotestringQuote currency code
ratenumberAsk rate inclusive of markup
markupBpsintegerMarkup in basis points
updatedAtstringLast update timestamp (UTC, RFC 3339)

---

## 2️⃣ Get Single Market Rate

Fetch the live ask rate for any supported currency pair.

```
GET /fx/markets/{base}/{quote}
```

Example - British Pound to Japanese Yen

```
curl -s https://api.due.network/fx/markets/GBP/JPY | jq .
```

This tells you how many Japanese yen you need to buy one British pound (ask rate with markup included).

Cross-Rate Example - Mexican Peso to Euro

```
curl -s https://api.due.network/fx/markets/MXN/EUR | jq .
```

Even though MXN/EUR isn't a direct market, our API automatically calculates the cross-rate via USD routing.

Response structure matches single market object from /markets endpoint.

---

## 3️⃣ Historical Price Data

Retrieve historical ask rates with customizable sampling intervals.

```
GET /fx/markets/{base}/{quote}/history?interval={minutes}
```

Query Parameters
ParameterDefaultDescription
interval15Sampling period in minutes

Common Intervals

- 1 - 1-minute (intraday trading)

- 5 - 5-minute (short-term analysis)

- 15 - 15-minute (default, balanced detail)

- 60 - 1-hour (daily monitoring)

- 1440 - Daily (long-term trends)

Example - EUR/USD 15-minute candles

```
curl -s "https://api.due.network/fx/markets/EUR/USD/history?interval=15" | jq .
```

Sample Response

```
[
  { "date": "2025-07-19T09:45:00Z", "rate": 1.0976 },
  { "date": "2025-07-19T10:00:00Z", "rate": 1.0979 },
  { "date": "2025-07-19T10:15:00Z", "rate": 1.0982 }
]
```

### 📈 Cross-Rate Historical Data

For cross-rate history (e.g., MXN/EUR), retrieve constituent pairs separately:

```
import requests

BASE = "https://api.due.network/fx"

# Get MXN/USD and USD/EUR history
mxn_usd = requests.get(f"{BASE}/markets/MXN/USD/history?interval=60").json()
usd_eur = requests.get(f"{BASE}/markets/USD/EUR/history?interval=60").json()

# Calculate MXN/EUR cross-rate for each timestamp
# MXN/EUR = MXN/USD * USD/EUR
cross_rates = []
for mxn_data, eur_data in zip(mxn_usd, usd_eur):
    if mxn_data["date"] == eur_data["date"]:
        cross_rate = mxn_data["rate"] * eur_data["rate"]
        cross_rates.append({
            "date": mxn_data["date"],
            "rate": cross_rate
        })
```

---

## 4️⃣ Create Executable Quote

Generate firm, tradable prices with 30-second validity. Perfect for checkout flows and real-time conversions.

```
POST /fx/quote
Content-Type: application/json
```

Request Body
ParameterTypeRequiredDescription
currencyInstring✅Source currency (what you're paying)
currencyOutstring✅Target currency (what you'll receive)
amountInstring✳️Input amount to convert
amountOutstring✳️Desired output amount

✳️ Provide exactly one ofamountIn or amountOut

Example 1 - Convert $1,000 USD to EUR

```
curl -X POST https://api.due.network/fx/quote \
     -H "Content-Type: application/json" \
     -d '{
           "currencyIn": "USD",
           "currencyOut": "EUR", 
           "amountIn": "1000"
         }' | jq .
```

Example 2 - Need exactly €500 EUR from USD

```
curl -X POST https://api.due.network/fx/quote \
     -H "Content-Type: application/json" \
     -d '{
           "currencyIn": "USD",
           "currencyOut": "EUR",
           "amountOut": "500"
         }' | jq .
```

Sample Response

```
{
  "currencyIn": "USD",
  "currencyOut": "EUR", 
  "amountIn": "1000",
  "amountOut": "913.42",
  "rate": 0.91342,
  "markupBps": 18,
  "createdAt": "2025-07-19T10:05:22Z",
  "expiresAt": "2025-07-19T10:05:52Z"
}
```

Response Fields
FieldDescription
rateExecutable ask rate used for calculation
markupBpsMarkup included in rate
createdAtQuote generation timestamp

Updated9 months ago

---

---

## Webhook Incoming Events

> Source: https://due.readme.io/docs/list-of-events

- Webhook notifications

# Incoming Events

### Overview

In the previous section, we learned how to work with webhook endpoints step by step. Once you've subscribed to the events, we start sending you an HTTP POST with a JSON payload.

The common structure of the webhook looks like

```
{
  "id": "wh_evt__123",
  "type": "transfer.status_changed",
  "data": { ..... },
  "occurredAt": "2025-09-22T12:00:00Z",
  "attemptedAt": "2025-09-22T12:00:00Z"
}
```

The full object is included in the data field of the JSON payload. In the example above, the event transfer.status_changed will include the whole transfer object. The same rule applied to all webhook events.

```
{
  "id": "wh_evt__123",
  "type": "transfer.status_changed",
  "data": {
    "id": "tf_XYZ123456789",
    "ownerId": "acct_98765ABCDE",
    "status": "payment_processed",
    "source": {
      "amount": "150.00",
      "fee": "2.50",
      "currency": "USDC",
      "rail": "polygon"
    },
    "destination": {
      "amount": "147.50",
      "fee": "2.50",
      "currency": "USD",
      "rail": "ach",
      "id": "rcp_QWERTY98765",
      "label": "Test Recipient",
      "details": {
        "accountName": "Demo Account",
        "accountNumber": "123456789",
        "bankName": "Example Bank",
        "routingNumber": "110000000",
        "schema": "bank_us"
      }
    },
    "fxRate": 1,
    "createdAt": "2025-09-22T12:00:00Z",
    "expiresAt": "2025-09-22T12:05:00Z"
  },
    "occurredAt": "2025-09-22T12:00:00Z",
			"attemptedAt": "2025-09-22T12:00:00Z"
}
```

After receiving an event, fetch the object by its identifier to confirm it belongs to your account and to retrieve the latest state. Example:

```
curl -X GET "https://api.due.network/v1/transfers/tf_XYZ123456789" \
  -H "Authorization: Bearer <token>" \
  -H "Due-Account-Id: acct_98765ABCDE"
```

### Security

All webhook requests are signed to guarantee authenticity and integrity. When a webhook endpoint is created, the API returns a public key in PEM format.

```
{
  "id": "whk_2l6qY9nCeKcyXD",
  ".....",
  "publicKey": "{webhook_endpoint_public_key}",
}
```

This key must be stored and used to verify incoming webhooks. Each webhook endpoint has its own unique key pair.

Webhook payloads are signed using Ed25519. The signature is generated from the raw request body and sent in the X-Webhook-Signature HTTP header as a hex-encoded string.

To verify a webhook, read the request body exactly as received and verify the signature using the stored public key. Any modification of the payload before verification will cause the check to fail.

```
var (
	publicKeyPem = "WEBHOOK_PUBLIC_KEY_PEM"
)

func Verify(requestData []byte, signatureHex string) bool {
	publicKey, err := parseEd25519PublicKeyFromPEM(publicKeyPem)
	if err != nil {
		return false
	}

	signature, err := hex.DecodeString(signatureHex)
	if err != nil {
		return false
	}

	return ed25519.Verify(publicKey, requestData, signature)
}

func parseEd25519PublicKeyFromPEM(pemStr string) (ed25519.PublicKey, error) {
	block, _ := pem.Decode([]byte(pemStr))
	if block == nil {
		return nil, fmt.Errorf("invalid PEM: no block found")
	}

	pubAny, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		return nil, err
	}

	pub, ok := pubAny.(ed25519.PublicKey)
	if !ok {
		return nil, fmt.Errorf("PEM is not an Ed25519 public key (got %T)", pubAny)
	}

	return pub, nil
}
```

### Retry

Webhook delivery may occasionally fail due to temporary network issues or endpoint unavailability. In such cases, an event can be retried manually.

```
curl -X POST "https://api.due.network/v1/webhook_endpoints/{whk_endpoint_id}/events/{whk_event_id}/retry" \
  -H "Authorization: Bearer <token>" \
  -H "Due-Account-Id: acct_98765ABCDE"
```

A retry sends the same payload again, signed in the same way as the original request. The request body and signature verification process remain unchanged — you can verify retried webhooks using the same stored public key.

Each retry updates the delivery status and response metadata, allowing you to track whether the webhook was eventually delivered successfully.

Updated3 months ago

---

---

## Additional Credentials

> Source: https://due.readme.io/docs/additional-credentials-and-activationdeactivation

- DUE WALLETS

# Additional Credentials and Activation/Deactivation

## Overview

For security reasons or convenience, you may want to add more than one signing key to Due Wallets. You can add several keys and store them as backups for when the main key is lost, or organize key rotation for security considerations.

While the first credential is automatically approved during creation, additional credentials require manual approval. You need to approve newly added keys with a previously created and approved credential. This ensures that even if your API key is compromised, an attacker cannot steal money by adding an additional key.

This allows you to:

- Create backup credentials for recovery scenarios

- Implement key rotation for enhanced security

Note: All credentials have equal access to wallet operations - there are no different permission levels or restricted access credentials.

## Prerequisites

- Existing active and approved credential (from the initial setup)

- OpenSSL toolkit installed

- API access token

## Step 1: Create Additional Credential

### Initialize Additional Credential Creation

The process is identical to creating the first credential - using Pattern 1: Direct JSON Signing. See Create Credential guide for detailed steps.

```
curl --location 'https://api.due.network/v1/vaults/credentials/init' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "name": "Backup key 1"
}'
```

### Generate New Key Pair

Generate a separate key pair for the additional credential:

```
# Generate new private key
openssl ecparam -genkey -name prime256v1 -out private_backup.pem

# Generate corresponding public key  
openssl ec -in private_backup.pem -pubout -out public_backup.pem
```

### Prepare Challenge Data

Create a JSON file with the challenge data to avoid issues with escape sequences:

```
# Create JSON file with clientDataHash and public key
cat > challenge.json << EOF
{"clientDataHash":"<clientDataHash_from_response>","publicKey":$(cat public_backup.pem | jq -Rs .)}
EOF
```

### Sign and Submit Additional Credential

Sign the challenge data:

```
# Sign the JSON data from file (removing any trailing newline before signing)
cat challenge.json | tr -d '\n' | openssl dgst -sha256 -sign private_backup.pem | xxd -p | tr -d '\n'
```

Submit the credential:

```
curl --location 'https://api.due.network/v1/vaults/credentials' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "signature": "<your_hex_signature>",
    "publicKey": "<your_public_key_pem>",
    "challenge": "<challenge_from_init_response>"
}'
```

Response for additional credential:

```
{
    "id": "passkey_xpbaGnRJUMsrmx4is6EKE",
    "kind": "Key",
    "algorithm": "ECDSA:256:P-256",
    "location": {
        "deviceType": "",
        "deviceOS": ""
    },
    "name": "Backup key 1",
    "publicKey": "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAENsRgOcOnWHVRyDI1JnCbh1+QglIF\n4ufYtmiP1c6Hxgiaeoxt2ZLzeQcCqvSIUSR15nZRbpYDABxNab9rhpSzSQ==\n-----END PUBLIC KEY-----\n",
    "hasWalletAccess": true,
    "createdAt": "2025-09-15T11:29:36.970110202Z",
    "approveUntil": "2025-09-15T11:42:46Z",
    "isActive": true
}
```

Note the difference from first credential:

- "isActive": true - credential is active (same as first credential)

- "approveUntil": "2025-09-15T11:42:46Z" - has a deadline, meaning it needs approval

## Step 2: Approve Additional Credential

Additional credentials require approval before the approveUntil deadline. Approval must be done using an existing fully approved credential.

Note: This process uses Pattern 2: Challenge-Response Flow.

### Request Approval Challenge

```
curl --location 'https://api.due.network/v1/vaults/credentials/approve' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "payload": {
        "credentialId": "passkey_xpbaGnRJUMsrmx4is6EKE"
    }
}'
```

You'll receive a 403 error with a challenge (standard Pattern 2 response).

### Sign Approval Challenge

Important: Sign with your existing fully approved credential's private key, not the new credential being approved.

```
# Sign the challenge with existing credential's private key
echo -n "<clientData_from_response>" | base64 -d | openssl dgst -sha256 -sign private.pem | base64 -w 0 | tr '+/' '-_' | tr -d '='
```

### Complete Approval

```
curl --location 'https://api.due.network/v1/vaults/credentials/approve' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "payload": {
        "credentialId": "passkey_xpbaGnRJUMsrmx4is6EKE"
    },
    "signature": {
        "challengeIdentifier": "<challengeIdentifier_from_response>",
        "firstFactor": {
            "kind": "Key",
            "credentialAssertion": {
                "credId": "passkey_xonETR6gAv3wIyhy8ehjx",
                "clientData": "<original_clientData>",
                "signature": "<your_signature>"
            }
        }
    }
}'
```

Response after successful approval:

```
{
    "id": "passkey_xpbaGnRJUMsrmx4is6EKE",
    "kind": "Key",
    "algorithm": "ECDSA:256:P-256",
    "location": {
        "deviceType": "",
        "deviceOS": ""
    },
    "name": "Backup key 1",
    "publicKey": "...",
    "hasWalletAccess": true,
    "createdAt": "2025-09-15T11:29:36.97011Z",
    "approveUntil": null,
    "isActive": true
}
```

Notice after successful approval:

- "approveUntil": null - no longer requires approval, fully approved and ready to use

## Step 3: Credential Deactivation

You can deactivate credentials that are no longer needed. This also uses Pattern 2.

### Request Deactivation

```
curl --location 'https://api.due.network/v1/vaults/credentials/deactivate' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "payload": {
        "credentialId": "passkey_xpbaGnRJUMsrmx4is6EKE"
    }
}'
```

### Sign and Complete Deactivation

Sign the challenge with an active credential and submit following Pattern 2 structure.

Response after deactivation:

```
{
    "id": "passkey_xpbaGnRJUMsrmx4is6EKE",
    "isActive": false
}
```

The credential is now deactivated ("isActive": false).

Updated4 months ago

---

---

## Create Due Wallet

> Source: https://due.readme.io/docs/create-due-vault

- DUE WALLETS

# Create Due Wallet

Note: This process uses Pattern 2: Challenge-Response Flow - you'll receive a challenge and need to retry with a signature.

#### Initial Request

```
curl --location 'https://api.due.network/v1/vaults' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{}'
```

Note: The payload is empty {} for wallet creation.

#### Challenge Response

You'll receive a 403 error with a challenge:

```
{
    "success": false,
    "message": "Please sign the following challenge to proceed",
    "httpCode": 403,
    "code": "ACTION_SIGNATURE_REQUIRED",
    "data": {
        "factors": {
            "Key": {
                "credId": "",
                "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZSI6ImNoYWxsZW5nZTFETnVrNmFIZlhNU05vWGZOYUFwQUlVaFZDOGhiQmM4ViIsIm9yaWdpbiI6Imh0dHBzOi8vYXBwLnNhbmRib3guZHVlLm5ldHdvcmsiLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
                "signature": null
            }
        },
        "challengeIdentifier": "chid1DLZSWZlpvQSGTmMrwhUZTpCIFOwaneRi"
    }
}
```

#### Sign the Challenge

Sign the base64-encoded clientData:

```
echo -n "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZSI6ImNoYWxsZW5nZTFETnVrNmFIZlhNU05vWGZOYUFwQUlVaFZDOGhiQmM4ViIsIm9yaWdpbiI6Imh0dHBzOi8vYXBwLnNhbmRib3guZHVlLm5ldHdvcmsiLCJjcm9zc09yaWdpbiI6ZmFsc2V9" | base64 -d | openssl dgst -sha256 -sign private.pem | base64 -w 0 | tr '+/' '-_' | tr -d '='
```

Important: The signature must be in base64 URL-safe format (not hex).

#### Complete Wallet Creation

Submit the signed challenge following Pattern 2 structure:

```
curl --location 'https://api.due.network/v1/vaults' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "signature": {
        "challengeIdentifier": "chid1DLZSWZlpvQSGTmMrwhUZTpCIFOwaneRi",
        "firstFactor": {
            "kind": "Key",
            "credentialAssertion": {
                "credId": "passkey_xonETR6gAv3wIyhy8ehjx",
                "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZSI6ImNoYWxsZW5nZTFETnVrNmFIZlhNU05vWGZOYUFwQUlVaFZDOGhiQmM4ViIsIm9yaWdpbiI6Imh0dHBzOi8vYXBwLnNhbmRib3guZHVlLm5ldHdvcmsiLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
                "signature": "MEUCIAlkmdPEf0B_5xVr4DKK6uvsN0y1YVzsFe4vAOMlPcn4AiEAkLxs0HAiDbNd8NeYxns3t1CSLfMjmDsg8JkNH2GqPy0"
            }
        }
    }
}'
```

Response:

```
{
    "id": "key_2lRmxX5KBYRzMg",
    "address": "0x08bEB4Ad3D8D607646E4d5311eb355Ec2d2396F5"
}
```

Your wallet is now created! Save the wallet ID and address for future use.

Important:

- The wallet ID (key_2lRmxX5KBYRzMg) is used as keyId when signing transactions

- You need to add this address to an account before you can use it

Updated4 months ago

---

---

## Sign with Due Wallet

> Source: https://due.readme.io/docs/sign-with-due-vault

- DUE WALLETS

# Sign with Due Wallet

Once you've created a transfer and intent (see Stablecoin to Fiat Transfers guide), you'll need to sign the transaction hashes.

Note: This process uses Pattern 2: Challenge-Response Flow - similar to wallet creation.

#### Request Signing Challenge

For each signable hash in your intent:

```
curl --location 'https://api.due.network/v1/vaults/sign' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "payload": {
        "keyId": "key_2lRmxX5KBYRzMg",
        "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
    }
}'
```

Note:keyId is the Due Wallet ID returned when you created the wallet (not the credential ID).

#### Challenge Response

You'll receive a 403 error with a challenge:

```
{
    "success": false,
    "message": "Please sign the following challenge to proceed",
    "httpCode": 403,
    "code": "ACTION_SIGNATURE_REQUIRED",
    "data": {
        "factors": {
            "Key": {
                "credId": "",
                "clientData": "eyJ0eXBlIjoia2V5LmdldCIsImNoYWxsZW5nZSI6ImNoYWxsZW5nZTFET0NNcDNFWWk4VFlZWU9ka25sOEJHZlZ3SzZQRkNwbSIsIm9yaWdpbiI6Imh0dHBzOi8vYXBwLnNhbmRib3guZHVlLm5ldHdvcmsiLCJjcm9zc09yaWdpbiI6ZmFsc2V9",
                "signature": null
            }
        },
        "challengeIdentifier": "chid1DLr5F2ij7oyYLrGy6ekLnouxbE5SiiaN"
    }
}
```

#### Sign the Challenge

```
echo -n "<clientData_from_response>" | base64 -d | openssl dgst -sha256 -sign private.pem | base64 -w 0 | tr '+/' '-_' | tr -d '='
```

#### Get Transaction Signature

Submit the signed challenge with the same payload:

```
curl --location 'https://api.due.network/v1/vaults/sign' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "payload": {
        "keyId": "key_2lRmxX5KBYRzMg",
        "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
    },
    "signature": {
        "challengeIdentifier": "chid1DLr5F2ij7oyYLrGy6ekLnouxbE5SiiaN",
        "firstFactor": {
            "kind": "Key",
            "credentialAssertion": {
                "credId": "passkey_xonETR6gAv3wIyhy8ehjx",
                "clientData": "<original_clientData>",
                "signature": "<your_signature>"
            }
        }
    }
}'
```

Response:

```
{
    "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
    "signature": "0xd37f997e3850ad3e2eff15f62ecaa06932671c069327987223d76ec63feadaa315af671042155724f4212c345abbee5a766d0984ad4c3848d1838df6fb4519691b"
}
```

#### Submit the Intent

Use the signature(s) to submit your transfer intent:

Important:

- In submit, you need to send the intent returned from the transfer_intent endpoint with signatures added to its signables.

- Each signable should have a separate signature.

- The signature should contain the transaction signature (from the response), not the challenge signatures.

```
curl -X POST https://api.due.network/v1/transfer_intents/submit \
-H "Authorization: Bearer your_api_key" \
-H "Due-Account-Id: your_account_id" \
-H "Content-Type: application/json" \
-d '{
  "token": "intent_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "id": "{intent_id}",
  "sender": "0x742d35Cc6665C0532925a3b8D98d0dfBb67B1BF8",
  "amountIn": "1000000000",
  "to": {
    "0x1234567890123456789012345678901234567890": "1000000000"
  },
  "tokenIn": "USDC",
  "tokenOut": "USDC", 
  "networkIdIn": "ethereum",
  "networkIdOut": "ethereum",
  "gasFee": "21000000000000000",
  "signables": [
    {
      "signature": "0xd37f997e3850ad3e2eff15f62ecaa06932671c069327987223d76ec63feadaa315af671042155724f4212c345abbee5a766d0984ad4c3848d1838df6fb4519691b",
      "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
      "type": "EIP712",
      "data": {
        "types": {
          "Transfer": [
            {"name": "to", "type": "address"},
            {"name": "amount", "type": "uint256"},
            {"name": "nonce", "type": "uint256"}
          ]
        },
        "domain": {
          "name": "DueProtocol",
          "version": "1",
          "chainId": 1
        },
        "message": {
          "to": "0x1234567890123456789012345678901234567890",
          "amount": "1000000000",
          "nonce": "123"
        }
      }
    }
  ],
  "nonce": "0x7b",
  "hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
  "reference": "{transfer_id}_deposit",
  "expiresAt": "2024-03-15T10:40:15Z",
  "createdAt": "2024-03-15T10:30:45Z"
}'
```

Updated4 months ago

---

---

## Create Credential

> Source: https://due.readme.io/docs/create-credential

- DUE WALLETS

# Create credential

## Overview

This guide explains how to add a credential within a Due Wallet scope, which will be further used for all signing operations.

## Prerequisites

- OpenSSL toolkit installed (or any other key management tool you're comfortable with)

- API access token

- Basic understanding of EVM wallets and cryptographic signing

Supported algorithms:

- Elliptic Curve (secp256r1, ...)

## Step 1: Generate Key Pair

If you don't have a key pair, create one using OpenSSL:

```
# Generate a new private key and save it to private.pem file
openssl ecparam -genkey -name prime256v1 -out private.pem

# Derive a public key from the private key and save to public.pem file
openssl ec -in private.pem -pubout -out public.pem
```

Tip: To get your public key as a single-line string for easier use in JSON:

```
cat public.pem | jq -Rs .
```

Keep your private key secure - it will be used for all signing operations.

## Step 2: Add Credentials

Credentials are used for signing operations in the wallet system. Let's add your first credential. See Credentials API Reference for more details.

### Initialize Credential Creation

Note: This process uses Pattern 1: Direct JSON Signing - you'll construct and sign a JSON object directly.

Send an initialization request to start the credential creation process:

```
curl --location 'https://api.due.network/v1/vaults/credentials/init' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "name": "Primary key"
}'
```

Response:

```
{
    "challenge": "CONnem_8mBAOUeLPL55EQBKV9EfxpIaFHIqtl6b7nmw",
    "clientDataHash": "cff7a7e1bfd1b99996f40046db72a1d1dcd847d6b6c3df22e9ff4407a7e73a9d",
    "kind": "Key"
}
```

### Prepare and Sign the Challenge

You need to create a JSON object containing the clientDataHash from the response and your public key in PEM format.

Important: To avoid issues with escape sequences and special characters, create the JSON data in a file:

```
# Create JSON file with clientDataHash and public key
cat > challenge.json << EOF
{"clientDataHash":"<clientDataHash_from_response>","publicKey":$(cat public.pem | jq -Rs .)}
EOF
```

For example, your challenge.json file should look like:

```
{"clientDataHash":"cff7a7e1bfd1b99996f40046db72a1d1dcd847d6b6c3df22e9ff4407a7e73a9d","publicKey":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAERorJRL7hy7WQUQEcIHtcWeZVvwxf\nZlviYrhHHHogLJ7dNc94ObdRG9++bC+WfWsGlb24XhiDZGcBylSAmGps+g==\n-----END PUBLIC KEY-----\n"}
```

To sign this JSON, use the following command:

```
# Sign the JSON data from file (removing any trailing newline before signing)
cat challenge.json | tr -d '\n' | openssl dgst -sha256 -sign private.pem | xxd -p | tr -d '\n'
```

Command breakdown:

- cat challenge.json - Read the JSON file

- tr -d '\n' - Remove any trailing newline from the file

- openssl dgst -sha256 -sign private.pem - Create SHA256 hash and sign with your private key

- xxd -p - Convert binary signature to hexadecimal

- tr -d '\n' - Remove newlines from hex output for a clean string

Result: A hex-encoded signature like:

```
30450220129dd58d6492fc5b505d46a82887c708ba73cc189f1d868f6508ba8b093cdc20022100f7217bcb5d83da3ed1ee1231dd8edd852133b14fb54e0032baf463a1b64a0d04
```

### Finalize Credential Creation

Submit the signed challenge:

```
curl --location 'https://api.due.network/v1/vaults/credentials' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <token>' \
--data '{
    "kind": "Key",
    "signature": "30450220129dd58d6492fc5b505d46a82887c708ba73cc189f1d868f6508ba8b093cdc20022100f7217bcb5d83da3ed1ee1231dd8edd852133b14fb54e0032baf463a1b64a0d04",
    "publicKey": "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAERorJRL7hy7WQUQEcIHtcWeZVvwxf\nZlviYrhHHHogLJ7dNc94ObdRG9++bC+WfWsGlb24XhiDZGcBylSAmGps+g==\n-----END PUBLIC KEY-----\n",
    "challenge": "CONnem_8mBAOUeLPL55EQBKV9EfxpIaFHIqtl6b7nmw"
}'
```

Response:

```
{
    "id": "passkey_xonETR6gAv3wIyhy8ehjx",
    "kind": "Key",
    "algorithm": "ECDSA:256:P-256",
    "location": {
        "deviceType": "",
        "deviceOS": ""
    },
    "name": "Primary key",
    "publicKey": "...",
    "hasWalletAccess": true,
    "createdAt": "2025-09-09T17:09:28.313965114Z",
    "approveUntil": null,
    "isActive": true
}
```

Important Notes:

- The first credential is automatically approved and ready to use ("approveUntil": null)

- Additional credentials are created with "isActive": true but require approval if "approveUntil" is set (see Additional Credentials guide)

- The "approveUntil" field indicates if approval is needed:
- null = fully approved and ready to use

- timestamp = requires approval before this deadline

- Save the credential ID (passkey_xonETR6gAv3wIyhy8ehjx) - you'll need it for signing operations

You can always retrieve this ID later by making a request to the credentials endpoint.

## Next Steps

- Create Due Wallet - Use your credential to create a wallet

- Additional Credentials - Add backup or rotating keys for enhanced security

Updated4 months ago

---

---

---

# API Reference — Endpoint Details

## Create account

> `post v1 accounts`  
> Source: https://due.readme.io/reference/post_v1-accounts

# Create account
posthttps://api.sandbox.due.network/v1/accounts
Creates a new customer account (business or individual)
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body ParamstypestringnamestringemailstringcountrystringcategorystringexternalIdstringkycReturnUrlstringResponse
# 

Updated8 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## List accounts

> `get v1 accounts`  
> Source: https://due.readme.io/reference/get_v1-accounts

# List accounts
gethttps://api.sandbox.due.network/v1/accounts/
Lists all accounts linked to your platform or user.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Response
# 

Updated8 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get account

> `get v1 accounts accountid`  
> Source: https://due.readme.io/reference/get_v1-accounts-accountid

# Get account
gethttps://api.sandbox.due.network/v1/accounts/{accountId}
Retrieves full account details, including status history, KYC status, and ToS acceptance.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Path ParamsaccountIdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get account categories

> `get v1 account categories`  
> Source: https://due.readme.io/reference/get_v1-account-categories

# Get account categories
gethttps://api.sandbox.due.network/v1/account_categories/
Retrieves a list of available account categories
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Query ParamsnextstringaccountTypestringResponse
# 

Updated7 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated7 months ago

---

## List account wallets

> `get v1 wallets 1`  
> Source: https://due.readme.io/reference/get_v1-wallets-1

# List wallets
gethttps://api.sandbox.due.network/v1/wallets
Lists all wallets linked to the account
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…HeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Create wallet

> `post v1 wallets 1`  
> Source: https://due.readme.io/reference/post_v1-wallets-1

# Create wallet
posthttps://api.sandbox.due.network/v1/wallets
Creates wallet and links it to the account
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body ParamsaddressstringHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearer
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get channels

> `get v1 channels`  
> Source: https://due.readme.io/reference/get_v1-channels

# List all channels
gethttps://api.sandbox.due.network/v1/channels
Retrieve a list of all transfer channels.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Query ParamsonlyAvailablebooleantruefalseHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get financial institutions schema

> `get v1 financial institutions country2 schema`  
> Source: https://due.readme.io/reference/get_v1-financial-institutions-country2-schema

# List financial institutions
gethttps://api.sandbox.due.network/v1/financial_institutions/{country2}/{schema}
List all financial institutions by schema and country.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Path Paramscountry2stringrequired
Two-letter country code (ISO 3166-1 alpha-2).
schemastringrequired
Payment method schema (e.g., bank_us, momo_africa).
HeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get financial institution

> `get v1 financial institutions id`  
> Source: https://due.readme.io/reference/get_v1-financial-institutions-id

# Get financial institution
gethttps://api.sandbox.due.network/v1/financial_institutions/{id}
Get financial institution details by id.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Path Paramsidstringrequired
Unique identifier for the resource.
HeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Get KYC submission

> `get v1 kyc submissions submissionid`  
> Source: https://due.readme.io/reference/get_v1-kyc-submissions-submissionid

# Get submission
gethttps://api.sandbox.due.network/v1/kyc/submissions/{submissionId}Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Path ParamssubmissionIdstringrequiredResponse
# 

Updatedabout 1 month ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updatedabout 1 month ago

---

## Create KYC session

> `post v1 kyc sessions`  
> Source: https://due.readme.io/reference/post_v1-kyc-sessions

# Create submission session
posthttps://api.sandbox.due.network/v1/kyc/sessionsRecent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body ParamssubmissionIdstringResponse
# 

Updatedabout 1 month ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updatedabout 1 month ago

---

## Initiate KYC

> `post v1 kyc`  
> Source: https://due.readme.io/reference/post_v1-kyc

# Initiate KYC
posthttps://api.sandbox.due.network/v1/kyc
Initiate standard KYC/KYB for an account.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…HeadersDue-Account-IdstringrequiredResponse
# 

Updated5 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated5 months ago

---

## Create recipient

> `post v1 recipients`  
> Source: https://due.readme.io/reference/post_v1-recipients

# Create recipient
posthttps://api.sandbox.due.network/v1/recipients
Creates a new recipient with the provided details.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body Paramsnamestringdetailsbank_africabank_aubank_bdbank_bobank_brbank_br_pixbank_cabank_clbank_cnbank_co_brebbank_colombiabank_crbank_dobank_egbank_gtbank_hkbank_hnbank_ibanbank_idbank_ilbank_inbank_in_upibank_jmbank_jpbank_krbank_menabank_mexicobank_mybank_phbank_pkbank_pk_ibanbank_sabank_sepabank_sgbank_svbank_swiftbank_swift_ibanbank_thbank_trbank_ukbank_usbank_us_jpmbank_vnevmewalletewallet_alipayewallet_doewallet_gtewallet_idewallet_phewallet_pkewallet_wechatpaymomo_africamomo_africa.senderqr_brazilsolanastarknettronisExternalbooleantruefalseHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## List recipients

> `get v1 recipients`  
> Source: https://due.readme.io/reference/get_v1-recipients

# List all recipients
gethttps://api.sandbox.due.network/v1/recipients
List a paginated list of recipients
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Query ParamswithDeletedboolean
Include recipients that have been marked as deleted.
truefalsenextstring
Cursor for pagination to fetch the next set of results.
orderstring
Order in which results should be returned (e.g., asc, desc).
limitint32
Number of results to return per page.
HeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Create transfer

> `post v1 transfers`  
> Source: https://due.readme.io/reference/post_v1-transfers

# Create transfer
posthttps://api.sandbox.due.network/v1/transfers
Initiate a transfer for a created quote and provided details.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body Paramsquotestringrequiredrecipientstringrequiredsenderbank_africabank_aubank_bdbank_bobank_brbank_br_pixbank_cabank_clbank_cnbank_co_brebbank_colombiabank_crbank_dobank_egbank_gtbank_hkbank_hnbank_ibanbank_idbank_ilbank_inbank_in_upibank_jmbank_jpbank_krbank_menabank_mexicobank_mybank_phbank_pkbank_pk_ibanbank_sabank_sepabank_sgbank_svbank_swiftbank_swift_ibanbank_thbank_trbank_ukbank_usbank_us_jpmbank_vnevmewalletewallet_alipayewallet_doewallet_gtewallet_idewallet_phewallet_pkewallet_wechatpaymomo_africamomo_africa.senderqr_brazilsolanastarknettronmemostringpurposeCodestringHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## List transfers

> `get v1 transfers`  
> Source: https://due.readme.io/reference/get_v1-transfers

# List all transfers
gethttps://api.sandbox.due.network/v1/transfers
Retrieves a paginated list of transfers.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Query Paramsnextstring
Cursor for pagination to fetch the next set of results.
orderstring
Order in which results should be returned (e.g., asc, desc).
limitint32
Number of results to return per page.
startDatedate-time
Start date for filtering results (ISO 8601 format).
endDatedate-time
End date for filtering results (ISO 8601 format).
includeEmptybooleantruefalseHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## Create virtual account

> `post v1 virtual accounts`  
> Source: https://due.readme.io/reference/post_v1-virtual-accounts

# Create virtual account
posthttps://api.sandbox.due.network/v1/virtual_accounts
Creates a new virtual account with the provided details.
Recent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Body ParamsdestinationstringrequiredschemaInstringrequiredcurrencyInstringrailOutstringrequiredcurrencyOutstringrequiredreferencestringrequiredHeadersDue-Account-IdstringrequiredResponse
# 

Updated8 months ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updated8 months ago

---

## List virtual accounts

> `get v1 virtual accounts`  
> Source: https://due.readme.io/reference/get_v1-virtual-accounts

# Get a virtual account
gethttps://api.sandbox.due.network/v1/virtual_accountsRecent RequestsLog in to see full request historyTimeStatusUser Agent
Retrieving recent requests…
Loading…Query ParamsdestinationstringrequiredschemaInstringrequiredcurrencyInstringrailOutstringrequiredcurrencyOutstringrequiredreferencestringHeadersDue-Account-IdstringrequiredResponse
# 

Updatedabout 1 month ago
LanguageCredentialsBearerURL
```
Loading…
```
ResponseClick Try It! to start a request and see the response here! Or choose an example:application/json
Updatedabout 1 month ago

---

