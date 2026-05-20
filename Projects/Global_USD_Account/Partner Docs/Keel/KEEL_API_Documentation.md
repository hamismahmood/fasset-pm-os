# BaaS Public API Documentation

> **OpenAPI Version:** 3.1.0  
> **Generated from:** https://baas-openapi.dev.aws.frost.app/openapi.json

## Servers

- `http://localhost:8080` — Generated server url

# Welcome
Welcome to the Keel API documentation. Here you can learn everything about Keel banking as a service API.

# API Overview
The Keel API constitutes a JSON REST interface, facilitating seamless interaction with products under Keel management.
Employing webhooks, it delivers asynchronous event notifications in real-time, encompassing transactions confirmations and account reconciliations as they transpire.

## Authentication
Before you can integrate with our API, you need to have been onboarded by us as a customer and have a valid authentication profile set up.
This authentication profile includes your Digital Certificate and secure API token. The API token needs to be included in the header of all REST API calls.

### Create authentication token
Your Keel authentication token serves as the nexus between your institution and your public key, necessitating its validity.
The authentication token comprises the following components:
  - A key pair (public/private)
  - A client-id and client-secret pair
To craft a valid authentication token, follow these steps:
  - Generate your RSA public key and private key pair in PEM format. Note: Only RSA keys are supported; EC (Elliptic Curve) keys are not compatible with our system.
  - Log in to the Keel Portal (website address provided upon Keel API customer onboarding).
  - Navigate to Authentication tokens -> Create token
  - Upload your public key
  - Specify the Token Name and select an Expiry Date.
  - Click Create authentication token to create your token. Your token will be visible in your browser.

*Note: The maximum token validity length is one year from the creation date. You can opt for a shorter validity period if necessary. Additionally, your token will be viewable only once, at the time of creation. Ensure secure storage to avoid the need for regeneration.

### Generate a Digital Signature
A digital signature is employed to safeguard the integrity of a request body sent to us. The complete HTTP request body, in its original format, is used to generate a digital signature, ensuring specificity to each request body.

>> Below is the recommended reference for generating digital signatures in our system. Although an older approach (signing only the request body) remains accepted for backward compatibility, ***it is deprecated***. We strongly recommend signing both the request body and the X-Idempotency-Id to benefit from enhanced security and replay-attack protection.

The creation of a digital signature adheres to the following specifications:

  - Raw message encoding: UTF-8
  - Message digest algorithm: SHA-256
  - Signing algorithm: RSA
  - Padding: PKCS#1 v1.5
  - Digital signature encoding: Base64

To generate a digital signature, adhere to these steps:
  - Prepare the request body (e.g., your JSON payload).
    - The exact string used here must match the request body you send (any variations, including spaces, yield a distinct digital signature).
  - Obtain or generate a unique X-Idempotency-Id for the request
    - Place this value in the X-Idempotency-Id header
  - Concatenate the request body and the X-Idempotency-Id into a single message string
    - combinedMessage = requestBody + xIdempotencyId
  - UTF-8 encode the combinedMessage.
  - Hash the encoded value using SHA-256.
  - Solicit a digital signature for the hash value from your security module.
  - The output is the message digital signature.
  - Transmit the Base64 encoded string representation of the digital signature in the HTTP header `X-Digital-Signature` for all requests with a request body.

## Versioning
Keel API incorporates a versioning system designed to facilitate backward compatibility.
When contract changes occur, a new version of each impacted resource becomes available, ensuring that the old version does not immediately become obsolete.

Versioning is seamlessly integrated into API requests through the url paths e.g /api/baas/v1/ibans

## Webhooks
When certain events occur, Keel API generate and send out a webhook message to your defined URL.
You can subscribe to the webhooks you wish to receive. When you receive a webhook, you will need to respond to it to confirm receipt - receipt must be signed with digital signature, .
If the confirm receipt response is erroneous or invalid, the Keel API adopts a retry mechanism, attempting to resend a webhook at 2 hour intervals over a span of 24 hours.

Webhooks are asynchronous events and can be delivered in any order. We provide at-least-once delivery of webhooks.
Because webhooks may be sent more than once, your webhook handlers must be idempotent.
You can check for duplicates based on the X-Webhook-Notification-Id header value.

**Important:** Webhook payloads may be extended with new fields at any time without prior notice. Clients must implement a tolerant/loose schema model and ignore unknown fields to ensure forward compatibility.

Authorization of webhooks and of receipt confirmation messages is based on Digital Signature.

Webhooks are send from Keel API to client's API. All Keel API webhooks have following structure

    | Element                     | Type    | Send in | Description                                                 |
    | --------------------------- | ------- | ------- | ------------------------------------------------------------|
    | X-Digital-Signature         | string  | Header  | Digital signature generated by Keel API                     |
    | X-Webhook-Version           | int     | Header  | Version of webhook                                          |
    | X-Webhook-Notification-Id   | UUID    | Header  | Deduplication id, used by consumer to check for duplication |
    | Payload                     | object  | Body    | Body of webhook event                                       |

Receipt confirmation is a response to the webhook. All receipt confirmations have following structure ("notificationId" value in a Payload
equals a X-Webhook-Notification-Id value from webhook request, "clientId" must be complementary with privateKey used to create digital signature)

    | Element              | Type    | Send in | Description                                                              |
    | -------------------- | ------- | ------- | ------------------------------------------------------------------------ |
    | X-Digital-Signature  | string  | Header  | Digital signature generated by client API                                |                                    |
    | Payload              | object  | Body    | Body of webhook event - {"notificationId": string, "clientId": string }  |

## Requests
API requests to the Keel API must:
  - identify who the requester is
  - what information they wish to retrieve or which action they wish to perform.

To put together an API request you will need to combine:
  - HTTP verb
  - URI to the resource
  - HTTP headers (authentication, versioning, content negiotiations, idempotency, and other)
  - Payload (if required)

## Responses
The response to a request contains either a payload in negiotiated content type or an error response

Error response consists of:
  - `statusCode` (4xx or 5xx HTTP status code)
  - `message` (describing error causes)
  - `errorCode` (4 digits code, error codes are predefined in Keel API and will be presented to consumer)

## Idempotency

Keel API guarantees that an idempotent request is processed **at most once**, letting you safely retry operations without creating duplicates. 

Add the `X-Idempotency-Id` header—using a newly generated `UUID` — whenever you send a state-changing request (`POST`, `PUT`, `PATCH`, `DELETE`). `GET` requests are inherently idempotent and do not require this header.


**Idempotent operations are cached for 30 days**. After this period, they are automatically removed from the system. If a `X-Idempotency-Id` header is reused after expiration, Keel will treat it as a new request and process it accordingly. To prevent accidental misuse, the idempotency layer ensures that every retry’s parameters exactly match the original request; any difference triggers an error response. It’s important to note that Keel does not cache failed requests. Responses are only cached for successful operations that return a 2xx status code. If a request fails due to validation errors or business logic, the result of operation will not be cached, and the request can be retried with the same `X-Idempotency-Id` header.

### How the server handle idempotency

* **First request** – when successful operation, response cached for 30 days.
* **Identical retry after successful operation** (same `X-Idempotency-Id` *and* payload) – processing is skipped and the cached response is returned.
* **Retry In-progress retry** (same `X-Idempotency-Id` *and* payload received while the first call is still running) – server replies `409 Conflict`.
* **Mismatch** (same `X-Idempotency-Id` with a *different* payload) – server replies `409 Conflict`.
* **Stale entry** (same `X-Idempotency-Id` *and* payload after the five-minute window expired) – server replies `409 Conflict`. Client must issue a new `X-Idempotency-Id`.
* Capacity limits reached – `429 Too Many Requests`.
* Unexpected storage issue – `500 Internal Server Error`.

### Integration guidelines
* For every new request generate a new `X-Idempotency-Id` value in `UUID` format.
* Reuse the same `X-Idempotency-Id` only when retrying **exactly** the same request.
* Never recycle an `X-Idempotency-Id` for a different endpoint or payload.
* Keep client-side retries within the five-minute window so the cached result can be returned instead of a conflict.

By adhering to these guidelines, you can ensure that your requests are processed correctly and consistently.


## Security Schemes

### Bearer

- **Type:** `http`
- **Scheme:** `bearer`
- **Bearer Format:** `JWT`

---

## API Endpoints

## Accounts API

### `GET /api/baas/accounts`

**Get accounts**

> ⚠️ **DEPRECATED**

Fetch all account with pagination. Ability to filter accounts by userId.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `userId` | query | `string` | No |  |
| `ownerId` | query | `uuid` | No | Filter accounts by ownerId |
| `includeBalance` | query | `boolean` | No |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Accounts fetched

Response body (`application/json`):
  **`AccountsPageResponse`**
  - **`content`**: `array`
      Items:
        **`AccountResponse`**
        - **`accountId`**: `string` (uuid)
        - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
        - **`balance`** *(required)*: `AmountDocument`
        - **`bic`**: `string`
        - **`createdAt`**: `string` (date-time)
        - **`currencyCode`**: `string`
        - **`iban`**: `string`
        - **`ownerId`**: `string` (uuid)
        - **`scan`**: `SCAN`
        - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/accounts/{accountId}`

**Get account**

> ⚠️ **DEPRECATED**

Fetch account details

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `accountId` | path | `uuid` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Account fetched

Response body (`application/json`):
  **`AccountWithBalanceResponse`**
  - **`accountId`**: `string` (uuid)
  - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
  - **`balance`** *(required)*: `AmountDocument`
  - **`bic`**: `string`
  - **`createdAt`**: `string` (date-time)
  - **`currencyCode`**: `string`
  - **`iban`**: `string`
  - **`ownerId`**: `string` (uuid)
  - **`scan`**: `SCAN`
  - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/accounts/{accountId}/bank-statement`

**Get account's bank statement**

Generates PDF bank statement for given date range

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `accountId` | path | `string` | Yes |  |
| `since` | query | `date` | Yes | Start of date range (inclusive) |
| `until` | query | `date` | Yes | End of date range (exclusive) |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Bank statement generated

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

Response body (`application/pdf`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

Response body (`application/pdf`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Bank statement not found for account

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

Response body (`application/pdf`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**406** — Incorrect mime type requested

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

Response body (`application/pdf`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/ibans`

**Orders new IBAN provision**

Order new IBAN provision:
- `STANDARD` variant:
    - Requests an IBAN that will be associated with exactly one account in Keel.
    - One account ID will be returned in the response object.
    - A single webhook for the account ID will be dispatched to the client once account creation is completed.
    - `currencCodes` field not supported for this variant - skipped in execution, may return 400 if invalid list is provided
- `MULTICURRENCY` variant:
    - Requests an IBAN that will be associated with multiple accounts in Keel (based on `currencies` in request), each account with a distinct currency.
    - A list of account IDs will be returned in the response object.
    - Multiple webhooks (one for each account ID) will be dispatched to the client once each account creation is completed.
    - If currencyCodes field is not provided, default currencyCode will be used (USD - configurable per tenant)
    - Supported currencies: ['CAD', 'CHF', 'CZK', 'DKK', 'EUR', 'HUF', 'NOK', 'PLN', 'RON', 'SEK', 'USD']

`IMPORTANT` - Multicurrency IBANs are public and support all currencies from the list above. This may lead to the following scenario:
An IBAN is provisioned for ["USD", "EUR"], resulting in the creation of two accounts. A transfer is then initiated (from an external bank)
to this IBAN in "NOK" currency. Keel must accept the transfer settlement and dynamically create an account in "NOK" currency. As a result,
an "account created" webhook will be triggered.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Idempotency-Id` | header | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`ProvisionIbanRequest`**
- **`currencyCodes`**: `array` — Currencies associated with IBAN
**Key points:**
This parameter is applicable only to MULTICURRENCY variant.
STANDARD variant can have only single ('GBP') currency code

    Items:
- **`ownerId`** *(required)*: `string` (uuid) — Id of account owner - Customer must exist before account can be created
- **`variant`** *(required)*: `string` enum: `STANDARD` | `MULTICURRENCY` — Variant

**Responses:**

**202** — Request accepted

Response body (`application/json`):
  **`ProvisionIbanResponse`**
  - **`accounts`**: `array`
      Items:
        **`AccountDocument`**
        - **`accountId`** *(required)*: `string` (uuid)
        - **`currencyCode`** *(required)*: `string`
        - **`state`** *(required)*: `string` enum: `ORDERED` | `ACCOUNT_ALREADY_EXISTS`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `DELETE /api/baas/v1/ibans/{iban}`

**Close IBAN and all associated accounts**

Close the IBAN and all accounts associated with it. This operation:
- Closes all accounts (standard and multicurrency) under the IBAN
- Terminates all cards associated with these accounts
- Requires all accounts to have zero balance


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `iban` | path | `string` | Yes | IBAN to close |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Responses:**

**204** — IBAN and associated accounts closed successfully

**401** — Unauthorized

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — IBAN not found

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — IBAN has accounts with non-zero balance

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `PATCH /api/baas/v1/ibans/{iban}/currency-accounts`

**Update currency accounts list for multicurrency IBAN**

Applicable only for multicurrency IBANs. This will update the account list for the provided IBAN and currency combinations, resulting in
the creation of new accounts if necessary.

Example:
- Input: {"add": ["USD", "EUR"]}
    - If there are currently no accounts for the provided IBAN with the "USD" or "EUR" currencies, two new accounts will be created,
     and two webhooks will be broadcasted in result.
    - If an account for "USD" or "EUR" already exists for the provided IBAN, no new account will be created for that currency.
    The status will be provided in the response body.
Supported currencies:
- ['CAD', 'CHF', 'CZK', 'DKK', 'EUR', 'HUF', 'NOK', 'PLN', 'RON', 'SEK', 'USD']


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `iban` | path | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`UpdateIbanCurrencyAccountsRequest`**
- **`add`** *(required)*: `array` — List of 3-letter currency codes
    Items:

**Responses:**

**202** — Request accepted

Response body (`application/json`):
  **`UpdateIbanCurrencyAccountsResponse`**
  - **`accounts`** *(required)*: `array`
      Items:
        **`AccountDocument`**
        - **`accountId`** *(required)*: `string` (uuid)
        - **`currencyCode`** *(required)*: `string`
        - **`state`** *(required)*: `string` enum: `ORDERED` | `ACCOUNT_ALREADY_EXISTS`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Multicurrency IBAN not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/v2/accounts`

**Get accounts**

Fetch all accounts with pagination and optional balance information. This endpoint returns detailed account information including balance data when requested.

**Account Types:**
- `STANDARD_ACCOUNT` - Standard GBP account
- `STANDARD_SAVINGS_ACCOUNT` - Standard GBP account with associated savings account
- `MULTICURRENCY_ACCOUNT` - Account with multicurrency iban

**Account Status:**
- `ENABLED` - Account is active and operational
- `DISABLED` - Account is temporarily disabled
- `CLOSED` - Account is permanently closed

**Balance Information (when includeBalance=true):**
- `balance` - Total booked funds in the account (balance including all settled transactions, not including pending outbounds)
- `availableBalance` - Funds immediately available for transactions (excludes amounts reserved for pending transactions)


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `userId` | query | `string` | No |  |
| `ownerId` | query | `uuid` | No | Filter accounts by ownerId |
| `includeBalances` | query | `boolean` | No |  |
| `status` | query | `string` | No | Optional account status filter. Repeat param or comma separated. Allowed: ENABLED, DISABLED, CLOSED |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Accounts fetched

Response body (`application/json`):
  **`AccountsPageResponseV2`**
  - **`content`**: `array`
      Items:
        **`AccountResponseV2`**
        - **`accountId`**: `string` (uuid)
        - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
        - **`balances`**: `AccountBalancesDocument`
        - **`bic`**: `string`
        - **`createdAt`**: `string` (date-time)
        - **`currencyCode`**: `string`
        - **`iban`**: `string`
        - **`ownerId`**: `string` (uuid)
        - **`scan`**: `SCAN`
        - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/v2/accounts/{accountId}`

**Get account**

Fetch detailed information for a specific account including complete balance data.

**Account Types:**
- `STANDARD_ACCOUNT` - Standard GBP account
- `STANDARD_SAVINGS_ACCOUNT` - Standard GBP account with associated savings account
- `MULTICURRENCY_ACCOUNT` - Account with multicurrency iban

**Account Status:**
- `ENABLED` - Account is active and operational
- `DISABLED` - Account is temporarily disabled
- `CLOSED` - Account is permanently closed

**Balance Information (when includeBalance=true):**
- `balance` - Total booked funds in the account (balance including all settled transactions, not including pending outbounds)
- `availableBalance` - Funds immediately available for transactions (excludes amounts reserved for pending transactions)


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `accountId` | path | `uuid` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Account fetched

Response body (`application/json`):
  **`AccountWithBalanceResponseV2`**
  - **`accountId`**: `string` (uuid)
  - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
  - **`balances`**: `AccountBalancesDocument`
  - **`bic`**: `string`
  - **`createdAt`**: `string` (date-time)
  - **`currencyCode`**: `string`
  - **`iban`**: `string`
  - **`ownerId`**: `string` (uuid)
  - **`scan`**: `SCAN`
  - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## BACS Direct Debit Mandates API

### `GET /api/baas/mandates`

**Get mandates**

Fetch all mandates with pagination. Ability to filter by accountId and/or userId.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No | Page number |
| `size` | query | `integer` | No | Page size |
| `accountId` | query | `uuid` | No | Filter accounts by accountId |
| `search` | query | `string` | No | Search for mandates by payer name, originator name or reference |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Mandates fetched

Response body (`application/json`):
  **`MandatesPageResponse`**
  - **`content`**: `array`
      Items:
        **`MandateResponse`**
        - **`accountId`**: `string` (uuid)
        - **`createdAt`**: `string` (date-time)
        - **`mandateId`**: `string` (uuid)
        - **`originator`**: `Participant`
        - **`payer`**: `Participant`
        - **`reference`**: `string`
        - **`serviceUserNumber`**: `string`
        - **`status`**: `string` enum: `ACTIVE` | `CANCELLED`
        - **`type`**: `string` enum: `ELECTRONIC` | `PAPER`
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/mandates`

**Order new mandate**

Initiates a paper mandate creation. Webhook to be sent to client once creation completed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`OrderMandateRequest`**
- **`accountId`** *(required)*: `string` (uuid) — Links mandate to account (managed by Keel or by client).
- **`iban`** *(required)*: `string` — Originator account IBAN - you can generate IBAN on https://www.iban.com/calculate-iban if not provided on Paper Direct Debit Mandate
- **`originatorName`** *(required)*: `string` — Originator Name - must be between 0 and 18 characters. Uppercase and can include numbers . & / - ]
- **`reference`** *(required)*: `string` — Reference - must be between 1 and 18 characters. Uppercase and can include numbers . & / - ]
- **`serviceUserNumber`** *(required)*: `string` — Service user number - must be exactly 6 digits

**Responses:**

**202** — Order accepted

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Not Found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Mandate cannot be ordered

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Internal Server Error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/mandates/{mandateId}`

**Get mandate details**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `mandateId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Accounts fetched

Response body (`application/json`):
  **`MandateDetailsResponse`**
  - **`accountId`**: `string` (uuid)
  - **`createdAt`**: `string` (date-time)
  - **`mandateId`**: `string` (uuid)
  - **`nextPaymentAt`**: `string` (date-time)
  - **`originator`**: `Participant`
  - **`payer`**: `Participant`
  - **`pendingPayment`**: `PaymentDocument`
  - **`previousPayments`**: `array`
      Items:
        **`PaymentDocument`**
        - **`amount`** *(required)*: `AmountDocument`
        - **`paymentDate`**: `string` (date)
  - **`reference`**: `string`
  - **`serviceUserNumber`**: `string`
  - **`status`**: `string` enum: `ACTIVE` | `CANCELLED` | `RETURNED`
  - **`type`**: `string` enum: `ELECTRONIC` | `PAPER`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `DELETE /api/baas/mandates/{mandateId}`

**Order mandate cancellation**

Mandate cancellation ordered. Webhook to be sent to client once cancellation completed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `mandateId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Responses:**

**204** — Order accepted

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Internal Server Error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## Cards API

### `GET /api/baas/cards`

**Get cards**

Fetches cards with pagination.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `ownerId` | query | `uuid` | No | Filter cards by ownerId |
| `accountId` | query | `uuid` | No | Filter cards by accountId |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Cards fetched

Response body (`application/json`):
  **`CardsPageResponse`**
  - **`content`**: `array`
      Items:
        **`CardResponse`**
        - **`accountIds`** *(required)*: `array` — Set of linked account identifiers
            Items:
              Format: `uuid`
        - **`cardHolderName`** *(required)*: `string` e.g. `JOHN DOE` — Name printed on the card
        - **`cardId`** *(required)*: `string` (uuid) e.g. `card_12345678-90ab-cdef-1234-567890abcdef` — Unique card identifier
        - **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of the card
        - **`expiryDate`** *(required)*: `string` e.g. `12/25` — Card expiry date in MM/YY format
        - **`lastFourPanDigits`** *(required)*: `string` e.g. `1234` — Last four digits of the card PAN
        - **`status`** *(required)*: `string` enum: `ACTIVE` | `ORDERED` | `LOST` | `STOLEN` | `SUSPECTED_FRAUD` | `SUSPECTED_FRAUD_ORDERED` | `SUSPECTED_FRAUD_BLOCKED` | `FRAUD_REPORTED` | `DESTROYED` | `BLOCKED` | `FULL_BLOCKED` e.g. `ACTIVE` — Current status of the card
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards`

**Create new card**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`CreateCardRequest`**
- **`accountIdLinks`** *(required)*: `array` — Links card to accounts. Linked accounts to be debited or credited after card transfer
    Items:
      **`AccountIdLink`**
      - **`id`** *(required)*: `string` (uuid) e.g. `12345678-90ab-cdef-1234-567890abcdef` — Account identifier
- **`cardCurrencyCode`**: `string` e.g. `GBP` — Needed only for specific card processors, if not specified in programme/product
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of card to create
- **`deliveryAddress`**: `Address`
- **`productId`** *(required)*: `string` (uuid) e.g. `7c803aea-82ff-47b4-a0c2-df7013d01e11` — Product identifier for card configuration

**Responses:**

**201** — Card created

Response body (`application/json`):
  **`CreateCardResponse`**
  - **`cardId`**: `string` (uuid) e.g. `c1234567-89ab-cdef-0123-456789abcdef` — The unique identifier of the created card

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be created

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/cards/{cardId}`

**Get card details**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Card details fetched

Response body (`application/json`):
  **`CardDetailsResponse`**
  - **`accountIds`** *(required)*: `array` — Set of linked account identifiers
      Items:
        Format: `uuid`
  - **`cardHolderName`** *(required)*: `string` e.g. `JOHN DOE` — Name printed on the card
  - **`cardId`** *(required)*: `string` (uuid) e.g. `12345678-90ab-cdef-1234-567890abcdef` — Unique card identifier
  - **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of the card
  - **`expiryDate`** *(required)*: `string` e.g. `12/25` — Card expiry date in MM/YY format
  - **`maskedPan`** *(required)*: `string` e.g. `************1234` — Masked card PAN (Primary Account Number)
  - **`status`** *(required)*: `string` enum: `ACTIVE` | `ORDERED` | `LOST` | `STOLEN` | `SUSPECTED_FRAUD` | `SUSPECTED_FRAUD_ORDERED` | `SUSPECTED_FRAUD_BLOCKED` | `FRAUD_REPORTED` | `DESTROYED` | `BLOCKED` | `FULL_BLOCKED` e.g. `ACTIVE` — Current status of the card

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Card not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/3ds-challenges/{challengeId}`

**Submit 3DS challenge result**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `challengeId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`A3DSChallengeResult`**
- **`reason`**: `string`
- **`result`** *(required)*: `string` enum: `APPROVED` | `DECLINED`

**Responses:**

**200** — Challenge result accepted

**400** — Bad request

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Card and/or Challenge not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**410** — Challenge expired

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Unexpected error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `PUT /api/baas/cards/{cardId}/3ds-password`

**Update card 3DS password**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`UpdateCard3dsPassword`**
- **`encryptedPassword`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — New encrypted 3DS password (Base64 encoded)

**Responses:**

**204** — Card 3DS password updated

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be updated

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/activate`

**Activate card**

Activates card, after it was ordered. Once activated card is ready to be used

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Responses:**

**204** — Card activated

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be updated

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/block`

**Block card**

Block card temporarily - can be unblocked later

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Responses:**

**204** — Card blocked

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be blocked

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/pin`

**Get card PIN**

Fetch encrypted card PIN using client-provided encrypted cipher

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`GetCardPinRequest`**
- **`encryptedCipher`** *(required)*: `string` e.g. `dGVzdEVuY3J5cHRlZENpcGhlcg==` — Client-provided encrypted cipher for secure PIN retrieval (Base64 encoded)

**Responses:**

**200** — Card PIN fetched (encrypted)

Response body (`application/json`):
  **`CardPinResponse`**
  - **`pin`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted card PIN

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `PUT /api/baas/cards/{cardId}/pin`

**Update card PIN**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`UpdateCardPin`**
- **`encryptedPin`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — New RSA encrypted PIN (Base64 encoded)

**Responses:**

**204** — Card PIN updated

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be updated

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/secure-details`

**Get secure card details**

Fetch encrypted PAN and CVV using client-provided encrypted cipher

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`GetSecureCardDetailsRequest`**
- **`encryptedCipher`** *(required)*: `string` e.g. `hHzMlX4bhUAoAFHPLQ2eXlddXe+XuIVw...` — Client-provided encrypted cipher for secure data exchange (Base64 encoded)

**Responses:**

**200** — Secure details fetched

Response body (`application/json`):
  **`SecureCardDetailsResponse`**
  - **`cvv`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted Card Verification Value (CVV)
  - **`pan`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted Primary Account Number (PAN)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Card not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/cards/{cardId}/secure-key`

**Get customer secure key**

Fetches customer's public key for encryption

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Secure key fetched

Response body (`application/json`):
  **`CustomerSecureKeyResponse`**
  - **`secureKey`** *(required)*: `string` e.g. `MHwwDQYJKoZIhvcNAQEBBQADawAwaAJhAJq2...` — Customer's public key for encryption

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Card not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/terminate`

**Terminate card**

Terminate card - once completed card cannot be used anymore

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`TerminateCardRequest`**
- **`reason`** *(required)*: `string` enum: `STOLEN` | `LOST` | `DESTROYED` | `FRAUD` e.g. `LOST` — Reason for card termination

**Responses:**

**200** — Card terminated

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be terminated

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/cards/{cardId}/unblock`

**Unblock card**

Unblock previously blocked card

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `cardId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Responses:**

**204** — Card unblocked

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Card cannot be unblocked

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## Case Management

### `GET /api/baas/v1/cases`

**Get all cases with optional filtering and sorting**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `sort` | query | `string` | No |  |
| `dir` | query | `string` | No |  |
| `search` | query | `string` | No |  |
| `status` | query | `string` | No |  |
| `excludeStatus` | query | `string` | No |  |
| `assigneeId` | query | `string` | No |  |
| `keelAssigneeId` | query | `string` | No |  |
| `tenantAssigneeId` | query | `string` | No |  |
| `reporterId` | query | `string` | No |  |
| `unassignedOnly` | query | `boolean` | No |  |
| `notAssignedToKeel` | query | `boolean` | No |  |
| `notAssignedToTenant` | query | `boolean` | No |  |
| `waitingOnTeam` | query | `string` | No |  |
| `subjectType` | query | `string` | No |  |
| `subjectId` | query | `string` | No |  |

**Responses:**

**200** — Cases found

Response body (`*/*`):
  **`CasesPageResponse`**
  - **`content`**: `array`
      Items:
        **`CaseResponse`**
        - **`assigneeId`**: `string`
        - **`createdAt`**: `string` (date-time)
        - **`description`**: `string`
        - **`id`**: `string`
        - **`keelAssigneeId`**: `string`
        - **`messages`**: `array`
            Items:
              **`CaseMessageResponse`**
              - **`caseId`**: `string`
              - **`content`**: `string`
              - **`id`**: `string`
              - **`senderId`**: `string`
              - **`timestamp`**: `string` (date-time)
        - **`reporterId`**: `string`
        - **`status`**: `string` enum: `OPEN` | `IN_PROGRESS` | `BLOCKED` | `CLOSED`
        - **`subjects`**: `array`
            Items:
              **`CaseSubjectResponse`**
              - **`caseId`**: `string`
              - **`id`**: `string`
              - **`subjectId`**: `string`
              - **`subjectType`**: `string`
        - **`tenantAssigneeId`**: `string`
        - **`title`**: `string`
        - **`updatedAt`**: `string` (date-time)
        - **`waitingOnTeam`**: `string` enum: `KEEL` | `TENANT`
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

---

### `GET /api/baas/v1/cases/{caseId}`

**Get a case by ID**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `caseId` | path | `string` | Yes |  |

**Responses:**

**200** — Case found

Response body (`*/*`):
  **`CaseResponse`**
  - **`assigneeId`**: `string`
  - **`createdAt`**: `string` (date-time)
  - **`description`**: `string`
  - **`id`**: `string`
  - **`keelAssigneeId`**: `string`
  - **`messages`**: `array`
      Items:
        **`CaseMessageResponse`**
        - **`caseId`**: `string`
        - **`content`**: `string`
        - **`id`**: `string`
        - **`senderId`**: `string`
        - **`timestamp`**: `string` (date-time)
  - **`reporterId`**: `string`
  - **`status`**: `string` enum: `OPEN` | `IN_PROGRESS` | `BLOCKED` | `CLOSED`
  - **`subjects`**: `array`
      Items:
        **`CaseSubjectResponse`**
        - **`caseId`**: `string`
        - **`id`**: `string`
        - **`subjectId`**: `string`
        - **`subjectType`**: `string`
  - **`tenantAssigneeId`**: `string`
  - **`title`**: `string`
  - **`updatedAt`**: `string` (date-time)
  - **`waitingOnTeam`**: `string` enum: `KEEL` | `TENANT`

---

### `GET /api/baas/v1/cases/{caseId}/messages`

**Get all messages for a case with attachments**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `caseId` | path | `string` | Yes |  |

**Responses:**

**200** — Messages found

Response body (`*/*`):
  Array of:
    **`CaseMessageWithAttachmentsResponse`**
    - **`attachments`**: `array`
        Items:
          **`AttachmentResponse`**
          - **`contentType`**: `string`
          - **`fileName`**: `string`
          - **`fileSize`**: `integer` (int64)
          - **`id`**: `string` (uuid)
          - **`uploadedAt`**: `string` (date-time)
          - **`uploadedBy`**: `string` (uuid)
    - **`caseId`**: `string`
    - **`content`**: `string`
    - **`id`**: `string`
    - **`senderId`**: `string`
    - **`timestamp`**: `string` (date-time)

---

## Customers API

### `GET /api/baas/v1/customers`

**Get customers**

Fetch all customers with pagination. Can be filtered by IBAN, email, phone number, first name, last name

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `sort` | query | `string` | No |  |
| `dir` | query | `string` | No |  |
| `search` | query | `string` | No |  |
| `status` | query | `string` | No |  |
| `latestKycStatus` | query | `string` | No |  |
| `ids` | query | `array` | No |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — customers fetched

Response body (`application/json`):
  **`CustomerPageResponse`**
  - **`content`**: `array`
      Items:
        **`CustomerResponse`**
        - **`address`** *(required)*: `Address`
        - **`blocked`**: `boolean`
        - **`companyName`**: `string` — Required for organization customer, null otherwise
        - **`createdAt`** *(required)*: `string` (date-time)
        - **`dateOfBirth`**: `string` (date) — Required for individual customer, null otherwise
        - **`dateOfIncorporation`**: `string` (date) — Required for organization customer, null otherwise
        - **`email`** *(required)*: `string`
        - **`firstName`**: `string` — Required for individual customer, null otherwise
        - **`id`** *(required)*: `string` (uuid)
        - **`isBlocked`**: `boolean`
        - **`isKycVerified`**: `boolean`
        - **`isOffboarded`**: `boolean`
        - **`kycSupplementaryUrl`**: `string`
        - **`kycVerified`**: `boolean`
        - **`lastName`**: `string` — Required for individual customer, null otherwise
        - **`offboarded`**: `boolean`
        - **`phoneNumber`** *(required)*: `string`
        - **`registrationNumber`**: `string` — Required for organization customer, null otherwise
        - **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`
        - **`ultimateBeneficialOwner`**: `OrganizationUltimateBeneficialOwnerDocument`
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/customers`

**Create new customer**

New customer created. The customer can be of type individual or organization.

For organizations, the ultimateBeneficiaryOwner field should be provided,
which denotes the ultimate beneficiary owner of the organization.

The kycSupplementaryUrl should contain additional KYC details about the customer.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`CreateCustomerRequest`**
- **`individualDetails`**: `IndividualDetailsDocument`
- **`kycSupplementaryUrl`**: `string` — URL to the KYC document, supplementary details about customer
- **`organizationDetails`**: `OrganizationDetailsDocument`
- **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`

**Responses:**

**201** — Customer created

Response body (`application/json`):
  **`CreateCustomerResponse`**
  - **`id`**: `string` (uuid)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Customer cannot be created

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/v1/customers/{id}`

**Get customer**

Fetch customer details

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `id` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Customer fetched

Response body (`application/json`):
  **`CustomerResponse`**
  - **`address`** *(required)*: `Address`
  - **`blocked`**: `boolean`
  - **`companyName`**: `string` — Required for organization customer, null otherwise
  - **`createdAt`** *(required)*: `string` (date-time)
  - **`dateOfBirth`**: `string` (date) — Required for individual customer, null otherwise
  - **`dateOfIncorporation`**: `string` (date) — Required for organization customer, null otherwise
  - **`email`** *(required)*: `string`
  - **`firstName`**: `string` — Required for individual customer, null otherwise
  - **`id`** *(required)*: `string` (uuid)
  - **`isBlocked`**: `boolean`
  - **`isKycVerified`**: `boolean`
  - **`isOffboarded`**: `boolean`
  - **`kycSupplementaryUrl`**: `string`
  - **`kycVerified`**: `boolean`
  - **`lastName`**: `string` — Required for individual customer, null otherwise
  - **`offboarded`**: `boolean`
  - **`phoneNumber`** *(required)*: `string`
  - **`registrationNumber`**: `string` — Required for organization customer, null otherwise
  - **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`
  - **`ultimateBeneficialOwner`**: `OrganizationUltimateBeneficialOwnerDocument`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Customer not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `PATCH /api/baas/v1/customers/{id}`

**Update customer details**

 Update customer details.

 **Available customer updates:**
 - **blocked**: Denotes whether to block the customer or not
     - **Type**: Boolean
     - **Actions**
         - If blocked:
             - Disables customer's accounts
             - Disables customer's cards
         - If unblocked:
             - Enables customer's accounts
             - Enables customer's cards
     - **Notes**:
         - This action is reversible
         - Inbound payments received on the blocked accounts will be sent to the Transaction Monitoring where they can be returned or accepted
         - Outbound payments and card transactions will be rejected
 - **offboarded**: Denotes whether to offboard the customer or not
     - **Type**: Boolean
     - **Actions**
         - If offboarded:
             - Closes customer's accounts
             - Closes customer's cards
     - **Notes**
         - All customer's accounts must have zero balance before offboarding
         - This action is NOT reversible
         - Inbound payments received on the offboarded accounts will be returned to the debtor (this will leave no trace in the system as returns happen on the rails level)
    - **kycSupplementaryUrl**: Updates kycSupplementaryUrl
     - **Type**: String
     - **Actions**
         - Updates the kycSupplementaryUrl of the customer
- **phoneNumber**: Updates customer's phone number
     - **Type**: PhoneNumber (E.164 format, e.g., +441234567890)
     - **Actions**
         - Updates the customer's phone number
         - Updates phone number for all cards in customer's accounts
- **email**: Updates customer's email address
     - **Type**: Email
     - **Actions**
         - Updates the customer's email address
- **address**: Updates customer's address
     - **Type**: ModifyUserAddress
     - **Actions**
         - Updates the customer's address
         - Updates address for all cards in customer's accounts
- **personalDetails**: Updates customer's personal details
     - **Type**: ModifyPersonalDetails
     - **Actions**
         - Updates the customer's first name, last name, and/or date of birth
         - Updates address for all cards in customer's accounts
         - Updates name for all accounts
- **organizationDetails**: Updates organization's details
     - **Type**: ModifyOrganizationDetails
     - **Actions**
         - Updates the organization's company name
         - Revokes latest KYC
         - Logs out user from all devices
         - Updates name for all Clearbank accounts
         - **ultimateBeneficialOwner**: Updates Ultimate Beneficial Owner (UBO) details
             - **Type**: ModifyUltimateBeneficialOwner
             - **Available UBO fields**:
                 - **firstName**: UBO's first name (with name pattern validation)
                 - **lastName**: UBO's last name (with name pattern validation)
                 - **dateOfBirth**: UBO's date of birth (yyyy-MM-dd format)
                 - **phoneNumber**: UBO's phone number (E.164 format)
                 - **email**: UBO's email address
                 - **address**: UBO's address (full address validation)
             - **Actions**
                 - Updates the specified UBO fields
                 - Revokes latest KYC for all UBO changes
                 - Logs out user from all devices for all UBO changes
                 - Does NOT affect Clearbank account names (UBO changes are separate from account holder names)

 **Key points:**
 - **Blocked** and **offboarded** are mutually exclusive (i.e. you cannot block and offboard a customer at the same time)
 - You can first block and then offboard a customer
 - Only the fields that are provided will be updated


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `id` | path | `string` | Yes | ID of the customer to update |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`BaasModifyCustomerRequest`**
- **`address`**: `ModifyUserAddress`
- **`blocked`**: `boolean` — Denotes whether to block or unblock the user. This is a reversible action
- **`email`**: `string` — Customer email address
- **`kycSupplementaryUrl`**: `string` — URL containing additional KYC details about the customer
- **`offboarded`**: `boolean` — Denotes whether to offboard the user. This is non-reversible action
- **`organizationDetails`**: `ModifyOrganizationDetails`
- **`personalDetails`**: `ModifyPersonalDetails`
- **`phoneNumber`**: `string` — Customer phone number (E.164 format)

**Responses:**

**200** — Customer updated successfully

Response body (`application/json`):
  **`CustomerResponse`**
  - **`address`** *(required)*: `Address`
  - **`blocked`**: `boolean`
  - **`companyName`**: `string` — Required for organization customer, null otherwise
  - **`createdAt`** *(required)*: `string` (date-time)
  - **`dateOfBirth`**: `string` (date) — Required for individual customer, null otherwise
  - **`dateOfIncorporation`**: `string` (date) — Required for organization customer, null otherwise
  - **`email`** *(required)*: `string`
  - **`firstName`**: `string` — Required for individual customer, null otherwise
  - **`id`** *(required)*: `string` (uuid)
  - **`isBlocked`**: `boolean`
  - **`isKycVerified`**: `boolean`
  - **`isOffboarded`**: `boolean`
  - **`kycSupplementaryUrl`**: `string`
  - **`kycVerified`**: `boolean`
  - **`lastName`**: `string` — Required for individual customer, null otherwise
  - **`offboarded`**: `boolean`
  - **`phoneNumber`** *(required)*: `string`
  - **`registrationNumber`**: `string` — Required for organization customer, null otherwise
  - **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`
  - **`ultimateBeneficialOwner`**: `OrganizationUltimateBeneficialOwnerDocument`

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Customer not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Customer already offboarded

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Customer cannot be updated

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## FX Trade

### `POST /api/baas/v1/accounts/{sellAccountId}/fx/trades`

**1) Request an FX trade**

Execute a real-time foreign exchange (FX) trade between two accounts owned by the same customer.
Using this API gives you a real-time exchange rate but the rate is not guaranteed until the trade is executed.
If you need a guaranteed rate, use the `POST /api/baas/v1/accounts/{sellAccountId}/fx/quotes` endpoint to get a quote first, then execute the trade with the `quoteId`.

**Key Points:**
- **Account Ownership**: Both `sellAccountId` and `buyAccountId` must belong to the same customer.
- **Fixed Side**: Use `fixedSide` to indicate whether the `amount` refers to the currency you are buying or selling.
  - **fixedSide=SELL**: All currencies supported. Better rates.
  - **fixedSide=BUY**: CZK, HUF, PLN, RON NOT supported
- **Trade currencies**: Currency pairs are determined by the `sellAccountId` and `buyAccountId`.
- **Minimum Trading Values**: Each currency has a defined minimum trading value. Trades below these values will result in a `422 Bad Request` error.
- **FX Trade Cut-off Times**: Trades are subject to the operating hours of both currencies involved. Ensure trades are within the specified cut-off times to be processed on the desired settlement date.

>> If you are sending trade request during the weekend or outside of the cut-off times, set the `tradeDate` to T+1 or T+2 to schedule the trade for the next business day or two business days ahead. Otherwise your trade will not be processed and 422 Bad Request will be returned.
>> You must submit out of hours trades with a `tradeDate` of T+1 by 23:30 UK time to guarantee processing on the next business day. If you missed the T+1 cut-off time, you can schedule the trade for two business days ahead by setting the `tradeDate` to T+2.
>> Future trades will usually settle at 8:00 UK time on the specified `tradeDate`.

**FX Trade Minimum Values and Support:**

| Currency            | Code | Min Value | fixedSide=SELL | fixedSide=BUY      |
|---------------------|------|-----------|----------------|--------------------|
| Canadian Dollar     | CAD  | 17        | ✅             | ✅                 |
| Swiss Franc         | CHF  | 11        | ✅             | ✅                 |
| Czech Koruna        | CZK  | 279       | ✅             | ❌ Not Available   |
| Danish Krone        | DKK  | 86        | ✅             | ✅                 |
| Euro                | EUR  | 12        | ✅             | ✅                 |
| British Pounds      | GBP  | 10        | ✅             | ✅                 |
| Hungarian Forint    | HUF  | 4411      | ✅             | ❌ Not Available   |
| Norwegian Krone     | NOK  | 134       | ✅             | ✅                 |
| Polish Zloty        | PLN  | 52        | ✅             | ❌ Not Available   |
| Romanian Leu        | RON  | 54        | ✅             | ❌ Not Available   |
| Swedish Krona       | SEK  | 135       | ✅             | ✅                 |
| United States Dollar| USD  | 13        | ✅             | ✅                 |

**FX Trade Cut-off Times:**

Trades must be submitted within the operating hours of both currencies involved to be processed on the same day. For trades scheduled on the next day or two days ahead (indicated by a `tradeDate` of T+1/T+2), the cut-off time is 23:30 UK time.

All times are in UK time (UTC+0 during winter, UTC+1 during summer). The cut-off times for each currency and fixed side are as follows:

| Currency            | Code | Start | SELL Same Day | BUY Same Day | Next Day |
|---------------------|------|-------|---------------|--------------|----------|
| Canadian Dollar     | CAD  | 07:00 | 17:00         | 13:00        | 23:30    |
| Swiss Franc         | CHF  | 07:00 | 11:00         | 09:30        | 23:30    |
| Czech Koruna        | CZK  | 07:00 | 08:30         | N/A          | 23:30    |
| Danish Krone        | DKK  | 07:00 | 11:00         | 09:00        | 23:30    |
| Euro                | EUR  | 07:00 | 14:30         | 13:30        | 23:30    |
| British Pounds      | GBP  | 07:00 | 15:00         | 15:00        | 23:30    |
| Hungarian Forint    | HUF  | 07:00 | 09:30         | N/A          | 23:30    |
| Norwegian Krone     | NOK  | 07:00 | 11:00         | 09:00        | 23:30    |
| Polish Zloty        | PLN  | 07:00 | 09:30         | N/A          | 23:30    |
| Romanian Leu        | RON  | 07:00 | 08:30         | N/A          | 23:30    |
| Swedish Krona       | SEK  | 07:00 | 11:00         | 09:30        | 23:30    |
| United States Dollar| USD  | 07:00 | 17:00         | 15:00        | 23:30    |

**DST Transition Gap:** During DST transition gaps (~2 weeks in March when US springs forward before UK, and ~1 week in late Oct/early Nov when UK falls back before US), ClearBank moves EUR and GBP SELL Same Day cutoffs to **14:00 GMT** due to European market provider illiquidity. After the UK switches to BST (or back to GMT in autumn), cutoffs return to normal (14:30 and 15:00 respectively). This does not affect the RFQ FX service (see Quote endpoint below).

**Settlement Window:** Between 8:00-8:05 UK time (UTC+0 during winter, UTC+1 during summer), there is a settlement window in ClearBank where FX trades are rejected. Please avoid submitting trades during this time.

**Important Notes:**
- Ensure that the trade amount meets or exceeds the minimum value for the respective currency.
- Verify that the trade is submitted within the applicable cut-off times to guarantee same-day settlement or the desired future settlement date.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `sellAccountId` | path | `uuid` | Yes | Account id of the selling party |
| `X-Idempotency-Id` | header | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`FxTradeRequest`**
- **`amount`** *(required)*: `string` e.g. `1000.0` — The amount of currency to buy or sell, depending on the fixed side. Must be a positive number with up to two decimal places.
- **`buyAccountId`** *(required)*: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account to which the currency is bought. This account must belong to the same customer as the sell account.
- **`fixedSide`** *(required)*: `string` e.g. `SELL` — Specifies which side of the trade is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
- **`tradeDate`** *(required)*: `string` (date) e.g. `2024-11-28` — The date when the trade should be executed (Please see FX trading cut-off times). Must be in ISO 8601 date format (YYYY-MM-DD).

**Responses:**

**202** — The FX trade request was accepted and is being processed.

Response body (`application/json`):
  **`FxTradeResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**403** — Transaction not allowed

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account with given id not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Duplicate Idempotency id received

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Problem with the request

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Internal server error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/accounts/{sellAccountId}/fx/quotes`

**2a) Request an FX quote (RFQ - Request for Quote)**

Get a real-time foreign exchange (FX) quote with a guaranteed rate.

**RFQ Limitations:**
- **Not supported**: CZK, HUF, PLN, RON (use Direct Trade with fixedSide=SELL instead)
- **Supported**: CAD, CHF, DKK, EUR, GBP, NOK, SEK, USD

**Key Points:**
- You can get and execute fx quote out of hours for t+1 days and t+2 days.
- The quote is valid for **45 seconds**. If you do not execute the trade within this time, you will need to request a new quote. You will receive a `422 Bad Request` if you try to execute a trade with an expired quote.
- The quote includes the exchange rate, the amounts to be traded, and the currencies involved.
- To execute the trade with given `quoteId`, use the `POST /api/baas/v1/accounts/{sellAccountId}/fx/trades/{quoteId}` endpoint with the same `quoteId` and `sellAccountId`.

**Understanding FX Rates (`marketConvention` parameter):**

The `fxRate` in the response follows different conventions depending on the `marketConvention` parameter:

- **marketConvention=true** (default): FX rate quoted in market convention (the standard market quote direction).
        The direction is determined by currency pair hierarchy—the market uses a preferred "base" currency for each pair—so the rate must be read as:
        - **EUR/GBP** → 1 EUR = X GBP
        - **GBP/USD** → 1 GBP = X USD

        In other words, fxRate is not always “sell → buy”; it follows the market’s conventional base/quote ordering (as typically shown on Bloomberg/Reuters).

- **marketConvention=false**: FX rate using buy/sell convention where it always represents "1 sellCurrency = X buyCurrency".
        This provides consistent interpretation across all currency pairs, calculated as buyAmount / sellAmount.

**Example: Trading GBP → EUR**

Because **GBP/EUR is typically quoted as EUR/GBP** in market convention, the same trade can be shown in two different directions:

- **Market convention (default):** `fxRate = 0.837`
  Read as: **1 EUR = 0.837 GBP** (market-quoted direction for this pair)

- **Buy/sell convention (`marketConvention=false`):** `fxRate = 1.195`
  Read as: **1 GBP = 1.195 EUR** (**always** the sell → buy direction for the trade)

**Example: Trading GBP → USD**

For **GBP/USD**, market convention already matches the trade direction, so both conventions are identical:

- **Market convention (default):** `fxRate = 1.27`
  Read as: **1 GBP = 1.27 USD**

- **Buy/sell convention (`marketConvention=false`):** `fxRate = 1.27`
  Read as: **1 GBP = 1.27 USD** (same value because market convention aligns with sell → buy for this pair)

**FX Quote Minimum Values:**

| Currency            | Code | Min Value |
|---------------------|------|-----------|
| Canadian Dollar     | CAD  | 17        |
| Swiss Franc         | CHF  | 11        |
| Danish Krone        | DKK  | 86        |
| Euro                | EUR  | 12        |
| British Pounds      | GBP  | 10        |
| Norwegian Krone     | NOK  | 134       |
| Swedish Krona       | SEK  | 135       |
| United States Dollar| USD  | 13        |

**FX Quote Cut-off Times:**

Quote execution must be submitted within the operating hours of both currencies involved to be processed on the same day. For trades scheduled on the next day or two days ahead (indicated by a `tradeDate` of T+1/T+2), the cut-off time is 23:30 UK time.

All times are in UK time (UTC+0 during winter, UTC+1 during summer). The cut-off times for each currency are as follows:

| Currency            | Currency Code | Start Time | Same Day Cut-off  | Next Day Cut-off         |
|---------------------|---------------|------------|-------------------|--------------------------|
| Canadian Dollar     | CAD           | 07:00      | 13:00             | 23:30                    |
| Swiss Franc         | CHF           | 07:00      | 09:30             | 23:30                    |
| Danish Krone        | DKK           | 07:00      | 09:00             | 23:30                    |
| Euro                | EUR           | 07:00      | 13:30             | 23:30                    |
| British Pounds      | GBP           | 07:00      | 15:00             | 23:30                    |
| Norwegian Krone     | NOK           | 07:00      | 09:00             | 23:30                    |
| Swedish Krona       | SEK           | 07:00      | 09:30             | 23:30                    |
| United States Dollar| USD           | 07:00      | 15:00             | 23:30                    |

**Settlement Window:** Between 8:00-8:05 UK time (UTC+0 during winter, UTC+1 during summer), there is a settlement window in ClearBank where FX quote executions are rejected. Please avoid executing quotes during this time.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `sellAccountId` | path | `uuid` | Yes | Account id of the selling party |
| `X-Idempotency-Id` | header | `string` | Yes |  |
| `marketConvention` | query | `boolean` | No | Controls FX rate interpretation. Default (true) uses market convention. |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`FxInitiateQuoteRequest`**
- **`amount`** *(required)*: `string` e.g. `1000.0` — The amount of currency to buy or sell, depending on the fixed side. Must be a positive number with up to two decimal places.
- **`buyAccountId`** *(required)*: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being determined
- **`fixedSide`** *(required)*: `string` e.g. `SELL` — Specifies which side of the quote is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
- **`tradeDate`** *(required)*: `string` (date) e.g. `2024-11-28` — The date for the quote, in the format 'yyyy-MM-dd'.

**Responses:**

**200** — The FX quote request was accepted

Response body (`application/json`):
  **`FxInitiateQuoteResponse`**
  - **`buyAccountId`**: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being bought
  - **`buyAmount`**: `number` e.g. `843.2` — The amount of currency to buy
  - **`buyCurrency`**: `string` e.g. `GBP` — The currency being bought
  - **`expiresAt`**: `string` (date-time) e.g. `2024-11-28T00:00:00Z` — Expiration time of the quote
  - **`fixedSide`**: `string` e.g. `SELL` — Specifies which side of the quote is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
  - **`fxRate`**: `number` e.g. `1.19` — The FX rate for this quote. Behavior depends on the marketConvention query parameter:

- **marketConvention=true** (default): FX rate quoted in market convention (the standard market quote direction).
        The direction is determined by currency pair hierarchy—the market uses a preferred “base” currency for each pair—so the rate must be read as:
        - EUR/GBP → 1 EUR = X GBP
        - GBP/USD → 1 GBP = X USD
        In other words, fxRate is not always “sell → buy”; it follows the market’s conventional base/quote ordering (as typically shown on Bloomberg/Reuters).

- **marketConvention=false**: FX rate using buy/sell convention where it always represents "1 sellCurrency = X buyCurrency".
        This provides consistent interpretation across all currency pairs, calculated as buyAmount / sellAmount.

  - **`quoteId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the fx quote
  - **`sellAccountId`**: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being sold
  - **`sellAmount`**: `number` e.g. `1000.0` — The amount of currency to sell
  - **`sellCurrency`**: `string` e.g. `EUR` — The currency being sold

**403** — Transaction not allowed

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account with given id not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Duplicate Idempotency id received

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Problem with the request

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Internal server error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/accounts/{sellAccountId}/fx/trades/{quoteId}`

**2b) Execute an FX quote (RFQ)**

Execute a real-time foreign exchange (FX) quote with a guaranteed rate.

**Key Points:**
- Use this endpoint to execute a trade with a given `quoteId` and `sellAccountId`.
- The `quoteId` is returned by the `POST /api/baas/v1/accounts/{sellAccountId}/fx/quotes` endpoint.
- The `quoteId` is valid for **45 seconds**. If you do not execute the trade within this time, you will need to request a new quote. You will receive a `422 Bad Request` if you try to execute a trade with an expired quote.
- **Not supported**: CZK, HUF, PLN, RON (use Direct Trade with fixedSide=SELL instead - endpoint 1)
- **Supported**: CAD, CHF, DKK, EUR, GBP, NOK, SEK, USD


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `sellAccountId` | path | `uuid` | Yes | Account id of the selling party |
| `quoteId` | path | `uuid` | Yes | Quote id to execute the trade |
| `X-Idempotency-Id` | header | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Digital-Signature` | header | `string` | Yes |  |

**Responses:**

**200** — The FX quote execution request was accepted

Response body (`application/json`):
  **`FxTradeResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**403** — Transaction not allowed

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account with given id not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Duplicate Idempotency id received

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Problem with the request

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**500** — Internal server error

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## Transaction History & Monitoring

### `GET /api/baas/transactions`

**Get transactions (v1)**

> ⚠️ **DEPRECATED**

Fetch transaction history with pagination. Ability to filter transactions by accountId, creation date range, transaction type, and transaction ID.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `sort` | query | `string` | No |  |
| `dir` | query | `string` | No |  |
| `since` | query | `string` | No | Filter transactions created on or after this date-time (ISO-8601 format, e.g., 2024-08-01T00:00:00.000Z) |
| `until` | query | `string` | No | Filter transactions created on or before this date-time (ISO-8601 format, e.g., 2024-08-31T23:59:59.999Z) |
| `accountId` | query | `uuid` | No | Filter transactions by participant accountId |
| `transactionType` | query | `string` | No | Filter transactions by type (can be specified multiple times) |
| `transactionId` | query | `string` | No | Filter by specific transaction ID |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Transaction history fetched

Response body (`application/json`):
  **`TransactionHistoryPage`**
  - **`content`**: `array`
      Items:
        **`TransactionHistoryResponse`**
        - **`amount`** *(required)*: `AmountDocument`
        - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
        - **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
        - **`creditor`** *(required)*: `TransactionHistoryParticipant`
        - **`debtor`** *(required)*: `TransactionHistoryParticipant`
        - **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

        - **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
        - **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
        - **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
        - **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
        - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
        - **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**400** — Bad Request - Invalid Parameters

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/transactions/{transactionId}`

**Get transaction details (v1)**

> ⚠️ **DEPRECATED**

Fetch transaction history information by transactionId.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `transactionId` | path | `uuid` | Yes | Get transaction by transactionId |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Transaction history fetched

Response body (`application/json`):
  **`TransactionHistoryResponse`**
  - **`amount`** *(required)*: `AmountDocument`
  - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
  - **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
  - **`creditor`** *(required)*: `TransactionHistoryParticipant`
  - **`debtor`** *(required)*: `TransactionHistoryParticipant`
  - **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

  - **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
  - **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
  - **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
  - **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
  - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
  - **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Not Found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/v2/transactions`

**Get transactions (v2)**

Fetch transactions with pagination. This endpoint returns a list of transactions with summary information and supports filtering.

For FX trade transactions (businessTransactionType=FX_TRADE), both market convention and buy/sell FX rates are returned in the response.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `sort` | query | `string` | No | Sort fields (can be specified multiple times) |
| `dir` | query | `string` | No | Sort direction |
| `schema` | query | `string` | No | Schema of the transaction listing. Use 'compact' for a reduced set of fields, 'details' for full transaction information (API response schema of /v2/transactions/{transactionId}). |
| `since` | query | `string` | No | Filter transactions created on or after this date-time (ISO-8601 format, e.g., 2024-08-01T00:00:00.000Z) |
| `until` | query | `string` | No | Filter transactions created on or before this date-time (ISO-8601 format, e.g., 2024-08-31T23:59:59.999Z) |
| `status` | query | `string` | No | Filter transactions by status (can be specified multiple times) |
| `accountId` | query | `uuid` | No | Filter transactions by participant accountId (can be specified multiple times) |
| `transactionId` | query | `string` | No | Filter by specific transaction ID |
| `businessTransactionType` | query | `string` | No | Filter transactions by type (can be specified multiple times) |
| `hideTransactionsLinkedAsChild` | query | `boolean` | No | Hide transactions that are linked as child transactions (default: false) |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Transactions fetched

Response body (`application/json`):
  **`TransactionsListItemPage`**
  - **`content`**: `array`
      Items:
        **`TransactionsListItemResponse`**
        - **`amount`** *(required)*: `AmountDocument`
        - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
        - **`creditorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Creditor account administration
        - **`creditorId`**: `string` (uuid) — Customer ID
        - **`creditorName`** *(required)*: `string` e.g. `Jane Smith` — Name of the creditor account holder
        - **`debtorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Debtor account administration
        - **`debtorId`**: `string` (uuid) — Customer ID
        - **`debtorName`** *(required)*: `string` e.g. `John Doe` — Name of the debtor account holder
        - **`fxBoughtAmount`**: `AmountDocument`
        - **`id`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
        - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `HELD` e.g. `SETTLED` — Status of the transaction
        - **`type`** *(required)*: `string` enum: `LOCAL_GBP` | `INTERNATIONAL` | `CROSS_BORDER_GBP` | `CROSS_BORDER_EUR` | `FX_TRADE` | `P2P` | `CHAPS` | `BACS` | `CARD` | `UNKNOWN` e.g. `INTERNATIONAL` — Type of the business transaction
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**400** — Bad Request - Invalid Parameters

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/v2/transactions/{transactionId}`

**Get transaction details (v2)**

Fetch transaction details information by transactionId from transaction store.

For FX trade transactions (businessTransactionType=FX_TRADE), both market convention and buy/sell FX rates are returned in the response.


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `transactionId` | path | `uuid` | Yes | Get transaction by transactionId |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Transaction details fetched

Response body (`application/json`):
  **`TransactionDetailsResponse`**
  - **`amount`** *(required)*: `AmountDocument`
  - **`amountHistory`**: `array` — Log of amount changes for the transaction
      Items:
        **`AmountHistoryEntry`**
        - **`amount`** *(required)*: `number` e.g. `123.45` — Amount value
        - **`currencyCode`** *(required)*: `string` e.g. `GBP` — Currency code
        - **`overriddenAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the amount was overridden by another amount
  - **`businessTransactionType`** *(required)*: `string` enum: `LOCAL_GBP` | `INTERNATIONAL` | `CROSS_BORDER_GBP` | `CROSS_BORDER_EUR` | `FX_TRADE` | `P2P` | `CHAPS` | `BACS` | `CARD` | `UNKNOWN` e.g. `INTERNATIONAL` — Business transaction type
  - **`card`**: `CardInfo`
  - **`createdAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the transaction was created
  - **`creditor`** *(required)*: `ParticipantInfo`
  - **`debtor`** *(required)*: `ParticipantInfo`
  - **`fxTrade`**: `FxTradeInfo`
  - **`id`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
  - **`linkages`**: `LinkageInfo`
  - **`paymentNetwork`**: `string` enum: `FPS` | `BACS` | `CHAPS` | `FX` | `CARD` | `CHAPS_UNKNOWN` | `SWIFT` | `GBP_CROSS_BORDER` | `EUR_CROSS_BORDER` | `TARGET2` | `OVERSEAS` | `CHAPS_SWIFT` | `CHAPS_OVERSEAS` | `UNKNOWN` — Payment network type
  - **`pendingReviewId`**: `string` (uuid) e.g. `d290f1ee-6c54-4b01-90e6-d701748f0851` — Identifier of the pending review if the transaction is under review
  - **`purpose`**: `PaymentPurposeInfo`
  - **`reference`**: `string` e.g. `Payment for services` — Reference of the transaction
  - **`rejections`**: `array` — Rejection records if the transaction was rejected
      Items:
        **`RejectionRecordInfo`**
        - **`reason`**: `string` — Reason for rejection
        - **`recordedAt`**: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the rejection was recorded
  - **`status`** *(required)*: `StatusInfo`
  - **`tags`**: `array` — Business tags associated with the transaction
      Items:
        **`TagLogEntry`**
        - **`recordedAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the tag was recorded
        - **`tag`** *(required)*: `string` enum: `REAL_ACCOUNT_LIQUIDITY_REBALANCE` | `REVERSAL_OF_PREVIOUS_SETTLEMENT` | `DIRECT_DEBIT_RETURN_CONFIRMED` | `REVERSED` — Business tag

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Not Found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/pending-transfers`

**Get pending transfers page**

 Fetch pending transfers with pagination. Ability to filter accounts by accountId and userId.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `page` | query | `integer` | No |  |
| `size` | query | `integer` | No |  |
| `sort` | query | `string` | No |  |
| `dir` | query | `string` | No |  |
| `accountId` | query | `uuid` | No | Filter transfers by participant accountId |
| `Authorization` | header | `string` | Yes |  |
| `userId` | query | `uuid` | No | Filter transfers by participant |

**Responses:**

**200** — Pending transfers fetched

Response body (`application/json`):
  **`TransactionHistoryPage`**
  - **`content`**: `array`
      Items:
        **`TransactionHistoryResponse`**
        - **`amount`** *(required)*: `AmountDocument`
        - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
        - **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
        - **`creditor`** *(required)*: `TransactionHistoryParticipant`
        - **`debtor`** *(required)*: `TransactionHistoryParticipant`
        - **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

        - **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
        - **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
        - **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
        - **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
        - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
        - **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction
  - **`pageNumber`**: `integer` (int64)
  - **`pageSize`**: `integer` (int64)
  - **`totalElements`**: `integer` (int64)
  - **`totalPages`**: `integer` (int64)

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `GET /api/baas/pending-transfers/{pendingReviewTransactionId}`

**Get pending transfer**

Fetch pending transfer details. The URL should include the `pendingReviewTransactionId` as a reference to the transaction being reviewed.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `pendingReviewTransactionId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |

**Responses:**

**200** — Pending transfer fetched

Response body (`application/json`):
  **`TransactionHistoryResponse`**
  - **`amount`** *(required)*: `AmountDocument`
  - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
  - **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
  - **`creditor`** *(required)*: `TransactionHistoryParticipant`
  - **`debtor`** *(required)*: `TransactionHistoryParticipant`
  - **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

  - **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
  - **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
  - **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
  - **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
  - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
  - **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Pending transfer not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `PUT /api/baas/pending-transfers/{pendingReviewTransactionId}/review`

**Manual review of a pending transfer flagged for further investigation. Compliance teams can approve or reject the transfer through this API.**

Transfer remains pending until approved or rejected. The URL should include the `pendingReviewTransactionId` as a reference to the transaction being reviewed.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `pendingReviewTransactionId` | path | `string` | Yes |  |
| `Authorization` | header | `string` | Yes |  |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |

**Request Body:**

**Content-Type:** `application/json`

**`TransactionReviewRequest`**
- **`actions`** *(required)*: `array`
    Items:
      Enum: `ACCEPT` | `ADD_TO_TRUSTED` | `BLOCK_USER` | `RETURN_INCOMING_FUNDS_TO_SENDER` | `REJECT_OUTGOING_TRANSACTION`

**Responses:**

**200** — Successful review

**401** — Unauthorized

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Pending transfer not found

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## Transfers API

### `POST /api/baas/accounts/{creditorAccountId}/simulate-inbound`

**Simulate inbound transfer - only works on sandbox environment**

Simulate inbound transfer from external bank

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `creditorAccountId` | path | `uuid` | Yes | Account id of the recipient |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |

**Request Body:**

**Content-Type:** `application/json`

**`SimulatedInboundTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `SimulatedAddress`
- **`creditorFullName`** *(required)*: `string`
- **`creditorIban`** *(required)*: `string`
- **`debtorAccountNumber`**: `string` e.g. `123456789000001111112` — Debtor Account Number (either this or debtorIban must be provided)
- **`debtorAddress`** *(required)*: `SimulatedAddress`
- **`debtorFullName`** *(required)*: `string`
- **`debtorIban`**: `string` e.g. `DE89370400440532013000` — Debtor IBAN (either this or debtorAccountNumber must be provided)
- **`reference`** *(required)*: `string`

**Responses:**

**204** — Transfer initiated

**401** — Unauthorized

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transfered

Response body (`*/*`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/accounts/{debtorAccountId}/inter-transfers`

**Transfer from Keel to external bank (International) - All Keel supported currencies apart from GBP**

Transfer money to external banks internationally using SWIFT. This API supports all Keel-supported currencies except GBP.
International transfers enable sending money to bank accounts outside the UK through the SWIFT network, typically settling within 1-3 business days.
 
**Key Points:**
- **Currency Support**: All Keel-supported currencies except GBP (for GBP international transfers, use the Cross Border GBP endpoint)
- **Recipient Information**: You must provide either the recipient's IBAN or account number, along with their full name and address
- **Bank Information**: The recipient's bank details (BIC/SWIFT code or ABA routing number for USA) must be provided through the creditorAgent field
- **Operating Hours**: International payments are processed during banking hours on business days
- **Payment Purpose**: For international transfers, some countries require payment purpose information which helps reduce payment query rates
 
**Payment Purpose Information:**
- The optional `paymentPurpose` field allows you to provide purpose information according to ISO 20022 standards
- You can provide a standard ISO purpose code (4 characters), free text (up to 35 characters), or both
   - For countries which do not support ISO 20022 (like the United Arab Emirates), the free text will be used
   - An example of a propertiary attribute to AED would be /BENEFRES/AE//ALW/TO_FRIEND where ALW is a country specific code and TO_FRIEND is a free text
- While currently optional, providing this information is recommended as it can help:
  - Reduce payment query rates from correspondent banks
  - Improve straight-through processing rates
  - Meet regulatory requirements in certain destination countries
 
**Intermediary Bank:**
- For complex routing requirements, you can optionally specify an intermediary bank
- This is typically used when the destination bank doesn't have a direct relationship with the SWIFT network
 
**References:**
- Use the `reference` field to include payment details that will be visible to the recipient
- References should be clear and concise, avoiding special characters when possible


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `debtorAccountId` | path | `uuid` | Yes | Account id of the sender |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |

**Request Body:**

**Content-Type:** `application/json`

**`InterInternationalTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountNumber`**: `string` e.g. `123456789` — Creditor Account Number (either this or creditorIban must be provided)
- **`creditorAddress`** *(required)*: `CreditorAddress`
- **`creditorAgent`** *(required)*: `InterCreditorAgent`
- **`creditorFullName`** *(required)*: `string` e.g. `John Doe` — Full name of the recipient
- **`creditorIban`**: `string` e.g. `DE89370400440532013000` — Creditor IBAN (either this or creditorAccountNumber must be provided)
- **`intermediaryAgent`**: `InterIntermediaryAgent`
- **`paymentPurpose`**: `PaymentPurposeRequest`
- **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose

**Responses:**

**202** — Transfer initiated

Response body (`application/json`):
  **`InterTransferResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transferred

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/accounts/{debtorAccountId}/inter-transfers-uk`

**Transfer from Keel to external bank (UK) - GBP only**

Transfer money to external bank in UK. GBP Only

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `debtorAccountId` | path | `uuid` | Yes | Account id of the sender |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |

**Request Body:**

**Content-Type:** `application/json`

**`InterUkTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountNumber`** *(required)*: `string` e.g. `12345678` — Creditor Account Number
- **`creditorFullName`** *(required)*: `string`
- **`creditorSortCode`** *(required)*: `string` e.g. `123456` — Creditor Sort Code
- **`reference`** *(required)*: `string`

**Responses:**

**202** — Transfer initiated

Response body (`application/json`):
  **`InterTransferResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transferred

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/accounts/{debtorAccountId}/intra-transfers`

**Transfer between Keel bank accounts (P2P) - All Keel supported currencies**

Transfer money between two Keel platform-managed accounts. All Keel supported currencies allowed.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `debtorAccountId` | path | `uuid` | Yes | Account id of the sender |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |

**Request Body:**

**Content-Type:** `application/json`

**`IntraTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountId`** *(required)*: `string` (uuid) e.g. `c0a3a7e8-94c7-4386-ae4b-e143d5de9aa9` — Account id of the recipient
- **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose

**Responses:**

**200** — Funds transferred

Response body (`application/json`):
  **`IntraTransferResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transferred

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/accounts/{debtorAccountId}/inter-transfers-eur`

**Transfers EUR from a Keel account to an external bank via SEPA Credit Transfer - EUR only.**

Initiates a EUR transfer to an external bank via the SEPA Credit Transfer (SCT UK) scheme.
This endpoint allows sending euro payments to any SEPA participant bank account.
 
**Availability and Hours:**
- SCT UK is available Monday to Friday from **07:00** to **14:30** (UK time)
- Subject to scheme holidays: New Year's Day, Good Friday, Easter Monday, Labour Day, Christmas Day, Boxing Day / Christmas Holiday
- Any payment requests submitted outside this timeframe will be rejected
 
**Currency:**
- Only EUR is supported. Requests with any other currency will be rejected
 
**Creditor IBAN:**
- The IBAN must belong to a country that is part of the SEPA CT scheme
- The first two characters of the IBAN indicate the country — if the IBAN belongs to a non-SEPA country, the request will be rejected
- **SEPA member countries (41):**
  - **EU (27):** Austria (AT), Belgium (BE), Bulgaria (BG), Croatia (HR), Cyprus (CY), Czech Republic (CZ), Denmark (DK), Estonia (EE), Finland (FI), France (FR), Germany (DE), Greece (GR), Hungary (HU), Ireland (IE), Italy (IT), Latvia (LV), Lithuania (LT), Luxembourg (LU), Malta (MT), Netherlands (NL), Poland (PL), Portugal (PT), Romania (RO), Slovakia (SK), Slovenia (SI), Spain (ES), Sweden (SE)
  - **EEA (3):** Iceland (IS), Liechtenstein (LI), Norway (NO)
  - **Non-EEA (11):** Albania (AL), Andorra (AD), Moldova (MD), Monaco (MC), Montenegro (ME), North Macedonia (MK), San Marino (SM), Serbia (RS), Switzerland (CH), United Kingdom (GB), Vatican City (VA)
 
**Creditor Agent (BIC):**
- The BIC must belong to a financial institution that is a participant of the SEPA CT scheme
- A list of eligible BICs can be found at: https://www.ebaclearing.eu/services-sepa-payments/step2-sct/participants/


**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `debtorAccountId` | path | `uuid` | Yes | Account id of the sender |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |

**Request Body:**

**Content-Type:** `application/json`

**`CrossBorderEurTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `CrossBorderEurParticipantAddress`
- **`creditorAgent`** *(required)*: `CrossBorderEurCreditorFinancialInstitutionIdentifier`
- **`creditorFullName`** *(required)*: `string` e.g. `John Doe` — Full name of the recipient
- **`creditorIban`** *(required)*: `string` e.g. `DE89370400440532013000` — Creditor IBAN
- **`reference`**: `string` e.g. `Internet Payment` — A short description that will help identify the transaction's purpose.

**Responses:**

**202** — Transfer initiated

Response body (`application/json`):
  **`CrossBorderEurTransferResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transferred

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

### `POST /api/baas/v1/accounts/{debtorAccountId}/inter-transfers-gbp`

**Transfers GBP from a Keel account to an external bank (International) - GBP only.**

Initiates a GBP transfer to an external bank outside the UK. International payments refer to financial transactions where the payer and the recipient are located in different countries. Our GBP international payment service allows you to send sterling payments to any eligible sterling account in an approved overseas jurisdiction. Payments are guaranteed to settle on the same day if the instruction is received by 5 PM UK time on a working day.

You can initiate a payment during the sterling availability period, which runs from **08:00** to **17:00** (UK time) on business days. Any payment requests submitted outside this timeframe will be rejected with a 400 Bad Request response.

**One account identifier — IBAN, BBAN, or SCAN must be provided.**

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `debtorAccountId` | path | `uuid` | Yes | Account id of the sender |
| `X-Idempotency-Id` | header | `uuid` | Yes | Unique identifier for the request |
| `Authorization` | header | `string` | Yes | Bearer token |
| `X-Digital-Signature` | header | `string` | Yes | Digital signature of the request |

**Request Body:**

**Content-Type:** `application/json`

**`CrossBorderGbpTransferRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `ParticipantAddress`
- **`creditorAgent`** *(required)*: `CreditorFinancialInstitutionIdentifier`
- **`creditorBban`**: `string` e.g. `${api.model.bban.example}` — ${api.model.bban.description}
- **`creditorFullName`** *(required)*: `string` e.g. `${api.model.creditor-full-name.example}` — ${api.model.creditor-full-name.description}
- **`creditorIban`**: `string` e.g. `${api.model.iban.example}` — ${api.model.iban.description}
- **`creditorScan`**: `SCAN`
- **`intermediaryAgent`**: `IntermediaryFinancialInstitutionIdentifier`
- **`reference`**: `string` e.g. `${api.model.reference.example}` — ${api.model.reference.description}

**Responses:**

**202** — Transfer initiated

Response body (`application/json`):
  **`InterTransferResponse`**
  - **`responseType`**: `string`
  - **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

**400** — Transfer is not within the payment window

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**401** — Unauthorized

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**403** — Forbidden

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**404** — Account not found

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**409** — Conflict

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

**422** — Funds cannot be transferred

Response body (`application/json`):
  **`ApiError`**
  - **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
  - **`errors`**: `array` — Error (eg. validation errors)
      Items:
        **`ErrorItem`**
        - **`field`**: `string` e.g. `reference` — Name of invalid field
        - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
  - **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
  - **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

---

## Webhooks

### `POST /webhooks/3ds-challenge-created`

**3DS challenge created**

Send to client when a 3DS challenge is created

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`A3DSChallengeCreatedWebhookRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`cardId`** *(required)*: `string` (uuid)
- **`cardOwnerId`** *(required)*: `string` (uuid)
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL`
- **`challengeExpiresAt`** *(required)*: `string` (date-time) e.g. `2026-01-01T14:58:22Z` — UTC timestamp when the challenge expires
- **`challengeId`** *(required)*: `string` (uuid)
- **`maskedPan`** *(required)*: `string` e.g. `**** **** **** 7889`
- **`merchant`** *(required)*: `string` e.g. `Amazon`
- **`transactionTimeStamp`** *(required)*: `string` (date-time) e.g. `2026-01-01T14:53:22Z` — UTC timestamp when the transaction occurred

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/account-created`

**New account created**

Send to client after account creation completed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`AccountCreatedWebhookRequest`**
- **`accountId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/account-creation-failed`

**New account creation failed**

Send to client after account creation failed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`AccountCreationFailedWebhookRequest`**
- **`accountId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/account-state-changed`

**Account state changed**

Send to client when account state is changed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`AccountStateChangedWebhookRequest`**
- **`accountId`** *(required)*: `string`
- **`status`** *(required)*: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/case-state-changed`

**Case state changed**

Send to client when any case change occurs (status, assignee, waiting on team, messages, attachments, etc.). Includes full case data and diff of changed fields.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`CaseStateChangedWebhookRequest`**
- **`caseData`**: `CaseResponse`
- **`changeType`**: `string` enum: `CASE_CREATED` | `STATUS_CHANGED` | `REASSIGNED` | `WAITING_ON_TEAM_CHANGED` | `WAITING_ON_TEAM_CLEARED` | `TITLE_CHANGED` | `DESCRIPTION_CHANGED` | `SUBJECT_ATTACHED` | `SUBJECT_DETACHED` | `MESSAGE_ADDED` | `MESSAGE_UPDATED` | `ATTACHMENT_UPLOADED` | `ATTACHMENT_DELETED` | `MESSAGE_ATTACHMENT_UPLOADED` | `MESSAGE_ATTACHMENT_DELETED` | `UNKNOWN_CHANGE`
- **`fieldModifications`**: `object`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-cancellation-failed`

**Mandate cancellation failed**

Send to client when mandate cancellation fails

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateCancellationFailedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-cancelled`

**Mandate cancelled**

Send to client after mandate cancellation completed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateCancelledWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-created`

**New mandate created**

Send to client after mandate creation completed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateCreatedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-creation-failed`

**Mandate creation failed**

Send to client when mandate creation fails

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateCreationFailedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-migrated`

**Mandate migrated**

Send to client when a mandate is migrated

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateMigratedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-return-failed`

**Mandate return failed**

Send to client when a mandate return fails

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateReturnFailedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/mandate-returned`

**Mandate returned**

Send to client when a mandate is returned

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`MandateReturnedWebhookRequest`**
- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/transaction-pending`

**Transaction pending**

Send to client after transaction gets into pending state. This can be either when the transaction is waiting for approval in Transaction Monitoring or when the transaction is waiting for settlement (e.g. outbound transaction is waiting for settlement from payment rails). You will also get this webhook when there is a pending BACS direct debit transaction.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`TransactionStateChangedWebhookRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditor`** *(required)*: `TransactionParticipant`
- **`creditorAccountId`** *(required)*: `string` (uuid) — Legacy field - use 'creditor.accountId' instead
- **`debtor`**: `TransactionParticipant`
- **`debtorAccountId`**: `string` (uuid) — Legacy field - use 'debtor.accountId' instead
- **`isReversal`**: `boolean` — Indicates whether the transaction is a reversal.
- **`pendingReviewTransactionId`** *(required)*: `string` (uuid) — The pending review transaction id if the transaction is in a pending review state. This parameter is optional.
- **`reference`** *(required)*: `string`
- **`transactionId`** *(required)*: `string` (uuid)
- **`transactionType`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/transaction-rejected`

**Transaction rejected**

Send to client after transaction rejected

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`TransactionStateChangedWebhookRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditor`** *(required)*: `TransactionParticipant`
- **`creditorAccountId`** *(required)*: `string` (uuid) — Legacy field - use 'creditor.accountId' instead
- **`debtor`**: `TransactionParticipant`
- **`debtorAccountId`**: `string` (uuid) — Legacy field - use 'debtor.accountId' instead
- **`isReversal`**: `boolean` — Indicates whether the transaction is a reversal.
- **`pendingReviewTransactionId`** *(required)*: `string` (uuid) — The pending review transaction id if the transaction is in a pending review state. This parameter is optional.
- **`reference`** *(required)*: `string`
- **`transactionId`** *(required)*: `string` (uuid)
- **`transactionType`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/transaction-review`

**Transaction review**

Send to client after transaction gets into review state. This happens when transaction was flagged for review bu the Transaction Monitoring system. The transaction will be reviewed by the compliance team and either approved or rejected. The client will receive a transaction settled or transaction rejected webhook after the review is completed.

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`TransactionStateChangedWebhookRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditor`** *(required)*: `TransactionParticipant`
- **`creditorAccountId`** *(required)*: `string` (uuid) — Legacy field - use 'creditor.accountId' instead
- **`debtor`**: `TransactionParticipant`
- **`debtorAccountId`**: `string` (uuid) — Legacy field - use 'debtor.accountId' instead
- **`isReversal`**: `boolean` — Indicates whether the transaction is a reversal.
- **`pendingReviewTransactionId`** *(required)*: `string` (uuid) — The pending review transaction id if the transaction is in a pending review state. This parameter is optional.
- **`reference`** *(required)*: `string`
- **`transactionId`** *(required)*: `string` (uuid)
- **`transactionType`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/transaction-settled`

**Transaction settled**

Send to client after transaction settled

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`TransactionStateChangedWebhookRequest`**
- **`amount`** *(required)*: `AmountDocument`
- **`creditor`** *(required)*: `TransactionParticipant`
- **`creditorAccountId`** *(required)*: `string` (uuid) — Legacy field - use 'creditor.accountId' instead
- **`debtor`**: `TransactionParticipant`
- **`debtorAccountId`**: `string` (uuid) — Legacy field - use 'debtor.accountId' instead
- **`isReversal`**: `boolean` — Indicates whether the transaction is a reversal.
- **`pendingReviewTransactionId`** *(required)*: `string` (uuid) — The pending review transaction id if the transaction is in a pending review state. This parameter is optional.
- **`reference`** *(required)*: `string`
- **`transactionId`** *(required)*: `string` (uuid)
- **`transactionType`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

### `POST /webhooks/user-state-changed`

**User state changed**

Send to client when user state is changed

**Parameters:**

| Name | In | Type | Required | Description |
|------|----|------|----------|-------------|
| `X-Digital-Signature` | header | `string` | Yes |  |
| `X-Webhook-Version` | header | `string` | Yes |  |
| `X-Webhook-Notification-Id` | header | `string` | Yes |  |

**Request Body:**

**Content-Type:** `application/json`

**`UserStateChangedWebhookRequest`**
- **`blocked`**: `boolean`
- **`kycSupplementaryUrl`**: `string`
- **`offboarded`**: `boolean`
- **`userId`** *(required)*: `string`

**Responses:**

**200** — Acknowledged

Response body (`application/json`):
  **`WebhookResponse`**
  - **`clientId`**: `string`
  - **`notificationId`**: `string`

---

## Appendix: Data Schemas

### `A3DSChallengeCreatedWebhookRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`cardId`** *(required)*: `string` (uuid)
- **`cardOwnerId`** *(required)*: `string` (uuid)
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL`
- **`challengeExpiresAt`** *(required)*: `string` (date-time) e.g. `2026-01-01T14:58:22Z` — UTC timestamp when the challenge expires
- **`challengeId`** *(required)*: `string` (uuid)
- **`maskedPan`** *(required)*: `string` e.g. `**** **** **** 7889`
- **`merchant`** *(required)*: `string` e.g. `Amazon`
- **`transactionTimeStamp`** *(required)*: `string` (date-time) e.g. `2026-01-01T14:53:22Z` — UTC timestamp when the transaction occurred

### `A3DSChallengeResult`

- **`reason`**: `string`
- **`result`** *(required)*: `string` enum: `APPROVED` | `DECLINED`

### `AccountBalancesDocument`

- **`availableBalance`** *(required)*: `AmountDocument`
- **`balance`** *(required)*: `AmountDocument`

### `AccountCreatedWebhookRequest`

- **`accountId`**: `string` (uuid)

### `AccountCreationFailedWebhookRequest`

- **`accountId`**: `string` (uuid)

### `AccountDocument`

- **`accountId`** *(required)*: `string` (uuid)
- **`currencyCode`** *(required)*: `string`
- **`state`** *(required)*: `string` enum: `ORDERED` | `ACCOUNT_ALREADY_EXISTS`

### `AccountIdLink`

- **`id`** *(required)*: `string` (uuid) e.g. `12345678-90ab-cdef-1234-567890abcdef` — Account identifier

### `AccountResponse`

- **`accountId`**: `string` (uuid)
- **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
- **`balance`** *(required)*: `AmountDocument`
- **`bic`**: `string`
- **`createdAt`**: `string` (date-time)
- **`currencyCode`**: `string`
- **`iban`**: `string`
- **`ownerId`**: `string` (uuid)
- **`scan`**: `SCAN`
- **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

### `AccountResponseV2`

- **`accountId`**: `string` (uuid)
- **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
- **`balances`**: `AccountBalancesDocument`
- **`bic`**: `string`
- **`createdAt`**: `string` (date-time)
- **`currencyCode`**: `string`
- **`iban`**: `string`
- **`ownerId`**: `string` (uuid)
- **`scan`**: `SCAN`
- **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

### `AccountStateChangedWebhookRequest`

- **`accountId`** *(required)*: `string`
- **`status`** *(required)*: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

### `AccountWithBalanceResponse`

- **`accountId`**: `string` (uuid)
- **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
- **`balance`** *(required)*: `AmountDocument`
- **`bic`**: `string`
- **`createdAt`**: `string` (date-time)
- **`currencyCode`**: `string`
- **`iban`**: `string`
- **`ownerId`**: `string` (uuid)
- **`scan`**: `SCAN`
- **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

### `AccountWithBalanceResponseV2`

- **`accountId`**: `string` (uuid)
- **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
- **`balances`**: `AccountBalancesDocument`
- **`bic`**: `string`
- **`createdAt`**: `string` (date-time)
- **`currencyCode`**: `string`
- **`iban`**: `string`
- **`ownerId`**: `string` (uuid)
- **`scan`**: `SCAN`
- **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`

### `AccountsPageResponse`

- **`content`**: `array`
    Items:
      **`AccountResponse`**
      - **`accountId`**: `string` (uuid)
      - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
      - **`balance`** *(required)*: `AmountDocument`
      - **`bic`**: `string`
      - **`createdAt`**: `string` (date-time)
      - **`currencyCode`**: `string`
      - **`iban`**: `string`
      - **`ownerId`**: `string` (uuid)
      - **`scan`**: `SCAN`
      - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `AccountsPageResponseV2`

- **`content`**: `array`
    Items:
      **`AccountResponseV2`**
      - **`accountId`**: `string` (uuid)
      - **`accountType`**: `string` enum: `STANDARD_ACCOUNT` | `STANDARD_SAVINGS_ACCOUNT` | `MULTICURRENCY_ACCOUNT`
      - **`balances`**: `AccountBalancesDocument`
      - **`bic`**: `string`
      - **`createdAt`**: `string` (date-time)
      - **`currencyCode`**: `string`
      - **`iban`**: `string`
      - **`ownerId`**: `string` (uuid)
      - **`scan`**: `SCAN`
      - **`status`**: `string` enum: `ENABLED` | `DISABLED` | `CLOSED`
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `Address`

- **`addressLine1`**: `string`
- **`addressLine2`**: `string`
- **`addressLine3`**: `string`
- **`addressLine4`**: `string`
- **`addressLine5`**: `string`
- **`countryCode`**: `string`
- **`moveInDate`**: `string` (date-time)

### `AddressInfo`

- **`countryCode`**: `string` e.g. `GB` — Country code
- **`structuredAddress`**: `StructuredAddressInfo`
- **`unstructuredAddress`**: `string` — Unstructured address

### `AmountDocument`

*Indicates the amount and the currency used in a given transaction or account balance.*

*Indicates the amount and the currency used in a given transaction or account balance.*
- **`amount`** *(required)*: `string` e.g. `10.99` — Specifies the monetary amount involved in the transaction or account balance, represented as a number with up to two decimal places.
- **`currencyCode`** *(required)*: `string` e.g. `GBP` — Specifies the three-letter ISO 4217 currency code corresponding to the amount in the transaction or account balance.

### `AmountHistoryEntry`

- **`amount`** *(required)*: `number` e.g. `123.45` — Amount value
- **`currencyCode`** *(required)*: `string` e.g. `GBP` — Currency code
- **`overriddenAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the amount was overridden by another amount

### `ApiError`

- **`errorCode`** *(required)*: `string` e.g. `3001` — Keel error code
- **`errors`**: `array` — Error (eg. validation errors)
    Items:
      **`ErrorItem`**
      - **`field`**: `string` e.g. `reference` — Name of invalid field
      - **`message`**: `string` e.g. `Reference can't be empty` — Description of error
- **`message`** *(required)*: `string` e.g. `Validation failed` — Description of error
- **`statusCode`** *(required)*: `integer` (int32) e.g. `400` — Http status code

### `AttachmentResponse`

- **`contentType`**: `string`
- **`fileName`**: `string`
- **`fileSize`**: `integer` (int64)
- **`id`**: `string` (uuid)
- **`uploadedAt`**: `string` (date-time)
- **`uploadedBy`**: `string` (uuid)

### `BaasModifyCustomerRequest`

- **`address`**: `ModifyUserAddress`
- **`blocked`**: `boolean` — Denotes whether to block or unblock the user. This is a reversible action
- **`email`**: `string` — Customer email address
- **`kycSupplementaryUrl`**: `string` — URL containing additional KYC details about the customer
- **`offboarded`**: `boolean` — Denotes whether to offboard the user. This is non-reversible action
- **`organizationDetails`**: `ModifyOrganizationDetails`
- **`personalDetails`**: `ModifyPersonalDetails`
- **`phoneNumber`**: `string` — Customer phone number (E.164 format)

### `CardDetailsResponse`

- **`accountIds`** *(required)*: `array` — Set of linked account identifiers
    Items:
      Format: `uuid`
- **`cardHolderName`** *(required)*: `string` e.g. `JOHN DOE` — Name printed on the card
- **`cardId`** *(required)*: `string` (uuid) e.g. `12345678-90ab-cdef-1234-567890abcdef` — Unique card identifier
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of the card
- **`expiryDate`** *(required)*: `string` e.g. `12/25` — Card expiry date in MM/YY format
- **`maskedPan`** *(required)*: `string` e.g. `************1234` — Masked card PAN (Primary Account Number)
- **`status`** *(required)*: `string` enum: `ACTIVE` | `ORDERED` | `LOST` | `STOLEN` | `SUSPECTED_FRAUD` | `SUSPECTED_FRAUD_ORDERED` | `SUSPECTED_FRAUD_BLOCKED` | `FRAUD_REPORTED` | `DESTROYED` | `BLOCKED` | `FULL_BLOCKED` e.g. `ACTIVE` — Current status of the card

### `CardInfo`

- **`cardId`** *(required)*: `string` (uuid) e.g. `123e4567-e89b-12d3-a456-426614174000` — Card ID
- **`feeAmount`**: `number` — Total amount of fees
- **`mccCode`**: `string` e.g. `5542` — Merchant Category Code (MCC)
- **`originalTxAmount`**: `AmountDocument`
- **`transactionCode`** *(required)*: `string` e.g. `ATM` — Type of transaction. One of: PIN_CHANGE, ATM, BALANCE_INQUIRY, TOKENIZATION, REFUND, PURCHASE, CHECK_GUARANTEE, PURCHASE_WITH_CASH, ACCOUNT_FUNDING, QUASI_CASH, FEE_COLLECTION, ENVELOPE_DEPOSIT, CHEQUE_DEPOSIT, CASH_DEPOSIT, CREDIT_ADJUSTMENT, ORIGINAL_CREDIT, PREPAID_LOAD, FUNDS_DISBURSEMENT, MINI_STATEMENT, ELIGIBILITY_INQUIRY, ACCOUNT_TRANSFER, BILL_PAYMENT, PAYMENT, PIN_UNBLOCK, ADDRESS_VERIFICATION, UNDEFINED

### `CardPinResponse`

- **`pin`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted card PIN

### `CardResponse`

- **`accountIds`** *(required)*: `array` — Set of linked account identifiers
    Items:
      Format: `uuid`
- **`cardHolderName`** *(required)*: `string` e.g. `JOHN DOE` — Name printed on the card
- **`cardId`** *(required)*: `string` (uuid) e.g. `card_12345678-90ab-cdef-1234-567890abcdef` — Unique card identifier
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of the card
- **`expiryDate`** *(required)*: `string` e.g. `12/25` — Card expiry date in MM/YY format
- **`lastFourPanDigits`** *(required)*: `string` e.g. `1234` — Last four digits of the card PAN
- **`status`** *(required)*: `string` enum: `ACTIVE` | `ORDERED` | `LOST` | `STOLEN` | `SUSPECTED_FRAUD` | `SUSPECTED_FRAUD_ORDERED` | `SUSPECTED_FRAUD_BLOCKED` | `FRAUD_REPORTED` | `DESTROYED` | `BLOCKED` | `FULL_BLOCKED` e.g. `ACTIVE` — Current status of the card

### `CardsPageResponse`

- **`content`**: `array`
    Items:
      **`CardResponse`**
      - **`accountIds`** *(required)*: `array` — Set of linked account identifiers
          Items:
            Format: `uuid`
      - **`cardHolderName`** *(required)*: `string` e.g. `JOHN DOE` — Name printed on the card
      - **`cardId`** *(required)*: `string` (uuid) e.g. `card_12345678-90ab-cdef-1234-567890abcdef` — Unique card identifier
      - **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of the card
      - **`expiryDate`** *(required)*: `string` e.g. `12/25` — Card expiry date in MM/YY format
      - **`lastFourPanDigits`** *(required)*: `string` e.g. `1234` — Last four digits of the card PAN
      - **`status`** *(required)*: `string` enum: `ACTIVE` | `ORDERED` | `LOST` | `STOLEN` | `SUSPECTED_FRAUD` | `SUSPECTED_FRAUD_ORDERED` | `SUSPECTED_FRAUD_BLOCKED` | `FRAUD_REPORTED` | `DESTROYED` | `BLOCKED` | `FULL_BLOCKED` e.g. `ACTIVE` — Current status of the card
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `CaseMessageResponse`

- **`caseId`**: `string`
- **`content`**: `string`
- **`id`**: `string`
- **`senderId`**: `string`
- **`timestamp`**: `string` (date-time)

### `CaseMessageWithAttachmentsResponse`

- **`attachments`**: `array`
    Items:
      **`AttachmentResponse`**
      - **`contentType`**: `string`
      - **`fileName`**: `string`
      - **`fileSize`**: `integer` (int64)
      - **`id`**: `string` (uuid)
      - **`uploadedAt`**: `string` (date-time)
      - **`uploadedBy`**: `string` (uuid)
- **`caseId`**: `string`
- **`content`**: `string`
- **`id`**: `string`
- **`senderId`**: `string`
- **`timestamp`**: `string` (date-time)

### `CaseResponse`

- **`assigneeId`**: `string`
- **`createdAt`**: `string` (date-time)
- **`description`**: `string`
- **`id`**: `string`
- **`keelAssigneeId`**: `string`
- **`messages`**: `array`
    Items:
      **`CaseMessageResponse`**
      - **`caseId`**: `string`
      - **`content`**: `string`
      - **`id`**: `string`
      - **`senderId`**: `string`
      - **`timestamp`**: `string` (date-time)
- **`reporterId`**: `string`
- **`status`**: `string` enum: `OPEN` | `IN_PROGRESS` | `BLOCKED` | `CLOSED`
- **`subjects`**: `array`
    Items:
      **`CaseSubjectResponse`**
      - **`caseId`**: `string`
      - **`id`**: `string`
      - **`subjectId`**: `string`
      - **`subjectType`**: `string`
- **`tenantAssigneeId`**: `string`
- **`title`**: `string`
- **`updatedAt`**: `string` (date-time)
- **`waitingOnTeam`**: `string` enum: `KEEL` | `TENANT`

### `CaseStateChangedWebhookRequest`

- **`caseData`**: `CaseResponse`
- **`changeType`**: `string` enum: `CASE_CREATED` | `STATUS_CHANGED` | `REASSIGNED` | `WAITING_ON_TEAM_CHANGED` | `WAITING_ON_TEAM_CLEARED` | `TITLE_CHANGED` | `DESCRIPTION_CHANGED` | `SUBJECT_ATTACHED` | `SUBJECT_DETACHED` | `MESSAGE_ADDED` | `MESSAGE_UPDATED` | `ATTACHMENT_UPLOADED` | `ATTACHMENT_DELETED` | `MESSAGE_ATTACHMENT_UPLOADED` | `MESSAGE_ATTACHMENT_DELETED` | `UNKNOWN_CHANGE`
- **`fieldModifications`**: `object`

### `CaseSubjectResponse`

- **`caseId`**: `string`
- **`id`**: `string`
- **`subjectId`**: `string`
- **`subjectType`**: `string`

### `CasesPageResponse`

- **`content`**: `array`
    Items:
      **`CaseResponse`**
      - **`assigneeId`**: `string`
      - **`createdAt`**: `string` (date-time)
      - **`description`**: `string`
      - **`id`**: `string`
      - **`keelAssigneeId`**: `string`
      - **`messages`**: `array`
          Items:
            **`CaseMessageResponse`**
            - **`caseId`**: `string`
            - **`content`**: `string`
            - **`id`**: `string`
            - **`senderId`**: `string`
            - **`timestamp`**: `string` (date-time)
      - **`reporterId`**: `string`
      - **`status`**: `string` enum: `OPEN` | `IN_PROGRESS` | `BLOCKED` | `CLOSED`
      - **`subjects`**: `array`
          Items:
            **`CaseSubjectResponse`**
            - **`caseId`**: `string`
            - **`id`**: `string`
            - **`subjectId`**: `string`
            - **`subjectType`**: `string`
      - **`tenantAssigneeId`**: `string`
      - **`title`**: `string`
      - **`updatedAt`**: `string` (date-time)
      - **`waitingOnTeam`**: `string` enum: `KEEL` | `TENANT`
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `CreateCardRequest`

- **`accountIdLinks`** *(required)*: `array` — Links card to accounts. Linked accounts to be debited or credited after card transfer
    Items:
      **`AccountIdLink`**
      - **`id`** *(required)*: `string` (uuid) e.g. `12345678-90ab-cdef-1234-567890abcdef` — Account identifier
- **`cardCurrencyCode`**: `string` e.g. `GBP` — Needed only for specific card processors, if not specified in programme/product
- **`cardType`** *(required)*: `string` enum: `PHYSICAL` | `VIRTUAL` e.g. `PHYSICAL` — Type of card to create
- **`deliveryAddress`**: `Address`
- **`productId`** *(required)*: `string` (uuid) e.g. `7c803aea-82ff-47b4-a0c2-df7013d01e11` — Product identifier for card configuration

### `CreateCardResponse`

- **`cardId`**: `string` (uuid) e.g. `c1234567-89ab-cdef-0123-456789abcdef` — The unique identifier of the created card

### `CreateCustomerRequest`

- **`individualDetails`**: `IndividualDetailsDocument`
- **`kycSupplementaryUrl`**: `string` — URL to the KYC document, supplementary details about customer
- **`organizationDetails`**: `OrganizationDetailsDocument`
- **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`

### `CreateCustomerResponse`

- **`id`**: `string` (uuid)

### `CreditorAddress`

- **`addressLine1`** *(required)*: `string`
- **`addressLine2`** *(required)*: `string`
- **`addressLine3`**: `string`
- **`countryCode`** *(required)*: `string` e.g. `US` — An Alpha-3 country code that uniquely identifies a country, as defined by the ISO 3166-1 standard.
- **`postCode`** *(required)*: `string` — Postcode or ZIP code

### `CreditorFinancialInstitutionIdentifier`

- **`bic`** *(required)*: `string` e.g. `${api.model.bic.example}` — ${api.model.bic.description}

### `CrossBorderEurCreditorFinancialInstitutionIdentifier`

- **`bic`** *(required)*: `string` e.g. `COBADEFFXXX` — The Bank Identifier Code (BIC) - a unique alphanumeric code that identifies a specific bank or financial institution worldwide

### `CrossBorderEurParticipantAddress`

- **`addressLine1`** *(required)*: `string` e.g. `Friedrichstrasse 123` — Street and number
- **`addressLine2`** *(required)*: `string` e.g. `Berlin` — City/town
- **`countryCode`** *(required)*: `string` e.g. `DEU` — An Alpha-3 country code that uniquely identifies a country, as defined by the ISO 3166-1 standard.
- **`postCode`** *(required)*: `string` e.g. `10117` — Postcode or ZIP code

### `CrossBorderEurTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `CrossBorderEurParticipantAddress`
- **`creditorAgent`** *(required)*: `CrossBorderEurCreditorFinancialInstitutionIdentifier`
- **`creditorFullName`** *(required)*: `string` e.g. `John Doe` — Full name of the recipient
- **`creditorIban`** *(required)*: `string` e.g. `DE89370400440532013000` — Creditor IBAN
- **`reference`**: `string` e.g. `Internet Payment` — A short description that will help identify the transaction's purpose.

### `CrossBorderEurTransferResponse`

- **`responseType`**: `string`
- **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

### `CrossBorderGbpTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `ParticipantAddress`
- **`creditorAgent`** *(required)*: `CreditorFinancialInstitutionIdentifier`
- **`creditorBban`**: `string` e.g. `${api.model.bban.example}` — ${api.model.bban.description}
- **`creditorFullName`** *(required)*: `string` e.g. `${api.model.creditor-full-name.example}` — ${api.model.creditor-full-name.description}
- **`creditorIban`**: `string` e.g. `${api.model.iban.example}` — ${api.model.iban.description}
- **`creditorScan`**: `SCAN`
- **`intermediaryAgent`**: `IntermediaryFinancialInstitutionIdentifier`
- **`reference`**: `string` e.g. `${api.model.reference.example}` — ${api.model.reference.description}

### `CustomerAddressDocument`

- **`addressLine1`** *(required)*: `string`
- **`addressLine2`** *(required)*: `string`
- **`addressLine3`** *(required)*: `string` — Postcode or ZIP code
- **`addressLine4`**: `string`
- **`addressLine5`**: `string`
- **`countryCode`** *(required)*: `string` — Valid ALPHA-3 ISO 3166 country code

### `CustomerPageResponse`

- **`content`**: `array`
    Items:
      **`CustomerResponse`**
      - **`address`** *(required)*: `Address`
      - **`blocked`**: `boolean`
      - **`companyName`**: `string` — Required for organization customer, null otherwise
      - **`createdAt`** *(required)*: `string` (date-time)
      - **`dateOfBirth`**: `string` (date) — Required for individual customer, null otherwise
      - **`dateOfIncorporation`**: `string` (date) — Required for organization customer, null otherwise
      - **`email`** *(required)*: `string`
      - **`firstName`**: `string` — Required for individual customer, null otherwise
      - **`id`** *(required)*: `string` (uuid)
      - **`isBlocked`**: `boolean`
      - **`isKycVerified`**: `boolean`
      - **`isOffboarded`**: `boolean`
      - **`kycSupplementaryUrl`**: `string`
      - **`kycVerified`**: `boolean`
      - **`lastName`**: `string` — Required for individual customer, null otherwise
      - **`offboarded`**: `boolean`
      - **`phoneNumber`** *(required)*: `string`
      - **`registrationNumber`**: `string` — Required for organization customer, null otherwise
      - **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`
      - **`ultimateBeneficialOwner`**: `OrganizationUltimateBeneficialOwnerDocument`
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `CustomerResponse`

- **`address`** *(required)*: `Address`
- **`blocked`**: `boolean`
- **`companyName`**: `string` — Required for organization customer, null otherwise
- **`createdAt`** *(required)*: `string` (date-time)
- **`dateOfBirth`**: `string` (date) — Required for individual customer, null otherwise
- **`dateOfIncorporation`**: `string` (date) — Required for organization customer, null otherwise
- **`email`** *(required)*: `string`
- **`firstName`**: `string` — Required for individual customer, null otherwise
- **`id`** *(required)*: `string` (uuid)
- **`isBlocked`**: `boolean`
- **`isKycVerified`**: `boolean`
- **`isOffboarded`**: `boolean`
- **`kycSupplementaryUrl`**: `string`
- **`kycVerified`**: `boolean`
- **`lastName`**: `string` — Required for individual customer, null otherwise
- **`offboarded`**: `boolean`
- **`phoneNumber`** *(required)*: `string`
- **`registrationNumber`**: `string` — Required for organization customer, null otherwise
- **`type`** *(required)*: `string` enum: `INDIVIDUAL` | `ORGANIZATION`
- **`ultimateBeneficialOwner`**: `OrganizationUltimateBeneficialOwnerDocument`

### `CustomerSecureKeyResponse`

- **`secureKey`** *(required)*: `string` e.g. `MHwwDQYJKoZIhvcNAQEBBQADawAwaAJhAJq2...` — Customer's public key for encryption

### `ErrorItem`

- **`field`**: `string` e.g. `reference` — Name of invalid field
- **`message`**: `string` e.g. `Reference can't be empty` — Description of error

### `FinancialInstitutionAddress`

- **`addressLine1`**: `string`
- **`addressLine2`** *(required)*: `string` e.g. `${api.model.address.line1.example}` — ${api.model.address.line1.description}
- **`countryCode`** *(required)*: `string` e.g. `${api.model.address.country-code.example}` — ${api.model.address.country-code.description}
- **`postCode`** *(required)*: `string` e.g. `${api.model.address.post-code.example}` — ${api.model.address.post-code.description}

### `FinancialInstitutionInfo`

- **`aba`**: `string` e.g. `021000021` — ABA routing number (US bank identifier). Exactly 9 digits that pass checksum validation: (3×d1 + 7×d2 + 1×d3 + 3×d4 + 7×d5 + 1×d6 + 3×d7 + 7×d8 + 1×d9) mod 10 = 0.
- **`address`**: `AddressInfo`
- **`bic`**: `string` — BIC of the financial institution
- **`clearingSystemIdCode`**: `string` — Clearing system ID code
- **`clearingSystemMemberId`**: `string` — Clearing system member ID
- **`name`**: `string` — Name of the financial institution

### `FxInitiateQuoteRequest`

- **`amount`** *(required)*: `string` e.g. `1000.0` — The amount of currency to buy or sell, depending on the fixed side. Must be a positive number with up to two decimal places.
- **`buyAccountId`** *(required)*: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being determined
- **`fixedSide`** *(required)*: `string` e.g. `SELL` — Specifies which side of the quote is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
- **`tradeDate`** *(required)*: `string` (date) e.g. `2024-11-28` — The date for the quote, in the format 'yyyy-MM-dd'.

### `FxInitiateQuoteResponse`

- **`buyAccountId`**: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being bought
- **`buyAmount`**: `number` e.g. `843.2` — The amount of currency to buy
- **`buyCurrency`**: `string` e.g. `GBP` — The currency being bought
- **`expiresAt`**: `string` (date-time) e.g. `2024-11-28T00:00:00Z` — Expiration time of the quote
- **`fixedSide`**: `string` e.g. `SELL` — Specifies which side of the quote is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
- **`fxRate`**: `number` e.g. `1.19` — The FX rate for this quote. Behavior depends on the marketConvention query parameter:

- **marketConvention=true** (default): FX rate quoted in market convention (the standard market quote direction).
        The direction is determined by currency pair hierarchy—the market uses a preferred “base” currency for each pair—so the rate must be read as:
        - EUR/GBP → 1 EUR = X GBP
        - GBP/USD → 1 GBP = X USD
        In other words, fxRate is not always “sell → buy”; it follows the market’s conventional base/quote ordering (as typically shown on Bloomberg/Reuters).

- **marketConvention=false**: FX rate using buy/sell convention where it always represents "1 sellCurrency = X buyCurrency".
        This provides consistent interpretation across all currency pairs, calculated as buyAmount / sellAmount.

- **`quoteId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the fx quote
- **`sellAccountId`**: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account of which the currency is being sold
- **`sellAmount`**: `number` e.g. `1000.0` — The amount of currency to sell
- **`sellCurrency`**: `string` e.g. `EUR` — The currency being sold

### `FxTradeInfo`

- **`boughtAmount`** *(required)*: `number` e.g. `123.45` — Amount bought in the trade
- **`boughtCurrencyCode`** *(required)*: `string` e.g. `EUR` — Currency code of the bought amount
- **`fxRate`**: `number` e.g. `0.8712` — FX rate quoted in market convention (the standard market quote direction).
The direction is determined by currency pair hierarchy—the market uses a preferred “base” currency for each pair—so the rate must be read as:
- EUR/GBP → 1 EUR = X GBP
- GBP/USD → 1 GBP = X USD
In other words, fxRate is not always “sell → buy”; it follows the market’s conventional base/quote ordering (as typically shown on Bloomberg/Reuters).

- **`fxRateBuySell`**: `number` e.g. `1.27` — FX rate using buy/sell convention where it always represents "1 sellCurrency = X buyCurrency".
This provides consistent interpretation across all currency pairs, calculated as buyAmount / sellAmount.


### `FxTradeRequest`

- **`amount`** *(required)*: `string` e.g. `1000.0` — The amount of currency to buy or sell, depending on the fixed side. Must be a positive number with up to two decimal places.
- **`buyAccountId`** *(required)*: `string` (uuid) e.g. `98ee8d8f-afed-458d-8477-1e344348cd11` — The id of the account to which the currency is bought. This account must belong to the same customer as the sell account.
- **`fixedSide`** *(required)*: `string` e.g. `SELL` — Specifies which side of the trade is fixed ('SELL' or 'BUY'). The amount corresponds to this side.
- **`tradeDate`** *(required)*: `string` (date) e.g. `2024-11-28` — The date when the trade should be executed (Please see FX trading cut-off times). Must be in ISO 8601 date format (YYYY-MM-DD).

### `FxTradeResponse`

- **`responseType`**: `string`
- **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

### `GetCardPinRequest`

- **`encryptedCipher`** *(required)*: `string` e.g. `dGVzdEVuY3J5cHRlZENpcGhlcg==` — Client-provided encrypted cipher for secure PIN retrieval (Base64 encoded)

### `GetSecureCardDetailsRequest`

- **`encryptedCipher`** *(required)*: `string` e.g. `hHzMlX4bhUAoAFHPLQ2eXlddXe+XuIVw...` — Client-provided encrypted cipher for secure data exchange (Base64 encoded)

### `IndividualDetailsDocument`

- **`address`** *(required)*: `CustomerAddressDocument`
- **`dateOfBirth`** *(required)*: `string` (date) e.g. `1990-01-01`
- **`email`** *(required)*: `string`
- **`firstName`** *(required)*: `string` e.g. `John`
- **`lastName`** *(required)*: `string` e.g. `Doe`
- **`phoneNumber`** *(required)*: `string`

### `InterCreditorAgent`

- **`aba`**: `string` e.g. `021000021` — ABA routing number (US bank identifier). Exactly one of ABA, BIC, or ClearingSystemIdCode must be provided. Must be exactly 9 digits and pass the ABA checksum validation: (3×d1 + 7×d2 + 1×d3 + 3×d4 + 7×d5 + 1×d6 + 3×d7 + 7×d8 + 1×d9) mod 10 = 0.
- **`address`** *(required)*: `InterFinancialInstitutionAddress`
- **`bic`**: `string` e.g. `DEUTDEFF` — BIC. Exactly one of ABA, BIC, or ClearingSystemIdCode must be provided.
- **`clearingSystemIdCode`**: `string` e.g. `FWIR` — Clearing System ID Code. Exactly one of ABA, BIC, or ClearingSystemIdCode must be provided.
- **`clearingSystemMemberId`**: `string` e.g. `123456` — Clearing System Member ID. Must be provided if using Clearing System ID Code.
- **`name`** *(required)*: `string` — Bank name

### `InterFinancialInstitutionAddress`

- **`addressLine1`**: `string`
- **`addressLine2`**: `string`
- **`addressLine3`**: `string`
- **`countryCode`** *(required)*: `string` e.g. `USA` — An Alpha-3 country code that uniquely identifies a country, as defined by the ISO 3166-1 standard.
- **`postCode`**: `string`

### `InterIntermediaryAgent`

- **`aba`**: `string` e.g. `021000021` — ABA routing number (US bank identifier). Exactly one of ABA or BIC must be provided. Must be exactly 9 digits and pass the ABA checksum validation: (3×d1 + 7×d2 + 1×d3 + 3×d4 + 7×d5 + 1×d6 + 3×d7 + 7×d8 + 1×d9) mod 10 = 0.
- **`address`** *(required)*: `InterFinancialInstitutionAddress`
- **`bic`**: `string` e.g. `DEUTDEFF` — BIC. Exactly one of ABA, BIC, or ClearingSystemIdCode must be provided.
- **`name`** *(required)*: `string` — Bank name

### `InterInternationalTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountNumber`**: `string` e.g. `123456789` — Creditor Account Number (either this or creditorIban must be provided)
- **`creditorAddress`** *(required)*: `CreditorAddress`
- **`creditorAgent`** *(required)*: `InterCreditorAgent`
- **`creditorFullName`** *(required)*: `string` e.g. `John Doe` — Full name of the recipient
- **`creditorIban`**: `string` e.g. `DE89370400440532013000` — Creditor IBAN (either this or creditorAccountNumber must be provided)
- **`intermediaryAgent`**: `InterIntermediaryAgent`
- **`paymentPurpose`**: `PaymentPurposeRequest`
- **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose

### `InterTransferResponse`

- **`responseType`**: `string`
- **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

### `InterUkTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountNumber`** *(required)*: `string` e.g. `12345678` — Creditor Account Number
- **`creditorFullName`** *(required)*: `string`
- **`creditorSortCode`** *(required)*: `string` e.g. `123456` — Creditor Sort Code
- **`reference`** *(required)*: `string`

### `IntermediaryFinancialInstitutionIdentifier`

- **`address`** *(required)*: `FinancialInstitutionAddress`
- **`bic`** *(required)*: `string` e.g. `${api.model.bic.example}` — ${api.model.bic.description}
- **`name`** *(required)*: `string` e.g. `${api.model.intermediary-agent.name.example}` — ${api.model.intermediary-agent.name.description}

### `IntraTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAccountId`** *(required)*: `string` (uuid) e.g. `c0a3a7e8-94c7-4386-ae4b-e143d5de9aa9` — Account id of the recipient
- **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose

### `IntraTransferResponse`

- **`responseType`**: `string`
- **`transactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction

### `LinkageInfo`

- **`childTransactionIds`**: `array` — Set of child transaction IDs if this transaction has child transactions
    Items:
      Format: `uuid`
- **`parentTransactionId`**: `string` (uuid) — Parent transaction ID if this transaction is a child of another transaction

### `MandateCancellationFailedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateCancelledWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateCreatedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateCreationFailedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateDetailsResponse`

- **`accountId`**: `string` (uuid)
- **`createdAt`**: `string` (date-time)
- **`mandateId`**: `string` (uuid)
- **`nextPaymentAt`**: `string` (date-time)
- **`originator`**: `Participant`
- **`payer`**: `Participant`
- **`pendingPayment`**: `PaymentDocument`
- **`previousPayments`**: `array`
    Items:
      **`PaymentDocument`**
      - **`amount`** *(required)*: `AmountDocument`
      - **`paymentDate`**: `string` (date)
- **`reference`**: `string`
- **`serviceUserNumber`**: `string`
- **`status`**: `string` enum: `ACTIVE` | `CANCELLED` | `RETURNED`
- **`type`**: `string` enum: `ELECTRONIC` | `PAPER`

### `MandateMigratedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateResponse`

- **`accountId`**: `string` (uuid)
- **`createdAt`**: `string` (date-time)
- **`mandateId`**: `string` (uuid)
- **`originator`**: `Participant`
- **`payer`**: `Participant`
- **`reference`**: `string`
- **`serviceUserNumber`**: `string`
- **`status`**: `string` enum: `ACTIVE` | `CANCELLED`
- **`type`**: `string` enum: `ELECTRONIC` | `PAPER`

### `MandateReturnFailedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandateReturnedWebhookRequest`

- **`accountId`**: `string` (uuid)
- **`mandateId`**: `string` (uuid)

### `MandatesPageResponse`

- **`content`**: `array`
    Items:
      **`MandateResponse`**
      - **`accountId`**: `string` (uuid)
      - **`createdAt`**: `string` (date-time)
      - **`mandateId`**: `string` (uuid)
      - **`originator`**: `Participant`
      - **`payer`**: `Participant`
      - **`reference`**: `string`
      - **`serviceUserNumber`**: `string`
      - **`status`**: `string` enum: `ACTIVE` | `CANCELLED`
      - **`type`**: `string` enum: `ELECTRONIC` | `PAPER`
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `ModifyOrganizationDetails`

- **`companyName`**: `string` — Organization company name
- **`ultimateBeneficialOwner`**: `ModifyUltimateBeneficialOwner`

### `ModifyPersonalDetails`

- **`dateOfBirth`**: `string` (date) e.g. `1990-01-01` — Customer date of birth
- **`firstName`**: `string` — Customer first name
- **`lastName`**: `string` — Customer last name

### `ModifyUltimateBeneficialOwner`

- **`address`**: `ModifyUserAddress`
- **`dateOfBirth`**: `string` (date) e.g. `1990-01-01` — UBO date of birth
- **`email`**: `string` — UBO email address
- **`firstName`**: `string` — UBO first name
- **`lastName`**: `string` — UBO last name
- **`phoneNumber`**: `string` — UBO phone number (E.164 format)

### `ModifyUserAddress`

- **`addressLine1`** *(required)*: `string`
- **`addressLine2`** *(required)*: `string`
- **`addressLine3`** *(required)*: `string`
- **`addressLine4`**: `string`
- **`addressLine5`**: `string`
- **`countryCode`** *(required)*: `string`

### `OrderMandateRequest`

- **`accountId`** *(required)*: `string` (uuid) — Links mandate to account (managed by Keel or by client).
- **`iban`** *(required)*: `string` — Originator account IBAN - you can generate IBAN on https://www.iban.com/calculate-iban if not provided on Paper Direct Debit Mandate
- **`originatorName`** *(required)*: `string` — Originator Name - must be between 0 and 18 characters. Uppercase and can include numbers . & / - ]
- **`reference`** *(required)*: `string` — Reference - must be between 1 and 18 characters. Uppercase and can include numbers . & / - ]
- **`serviceUserNumber`** *(required)*: `string` — Service user number - must be exactly 6 digits

### `OrganizationDetailsDocument`

- **`address`** *(required)*: `CustomerAddressDocument`
- **`companyName`** *(required)*: `string` e.g. `ACME Inc.`
- **`dateOfIncorporation`** *(required)*: `string` (date) e.g. `1990-01-01`
- **`email`** *(required)*: `string`
- **`phoneNumber`** *(required)*: `string`
- **`registrationNumber`** *(required)*: `string` e.g. `12345678`
- **`ultimateBeneficialOwner`** *(required)*: `IndividualDetailsDocument`

### `OrganizationUltimateBeneficialOwnerDocument`

- **`address`** *(required)*: `Address`
- **`dateOfBirth`** *(required)*: `string` (date)
- **`email`** *(required)*: `string`
- **`firstName`** *(required)*: `string`
- **`lastName`** *(required)*: `string`
- **`phoneNumber`** *(required)*: `string`

### `Participant`

- **`accountId`**: `string` (uuid)
- **`accountNumber`**: `string`
- **`name`**: `string`
- **`sortCode`**: `string`

### `ParticipantAddress`

- **`addressLine1`**: `string`
- **`addressLine2`** *(required)*: `string` e.g. `${api.model.address.line1.example}` — ${api.model.address.line1.description}
- **`countryCode`** *(required)*: `string` e.g. `${api.model.address.country-code.example}` — ${api.model.address.country-code.description}${api.request.cross-border-gbp.creditor-country-code-description}
- **`postCode`** *(required)*: `string` e.g. `${api.model.address.post-code.example}` — ${api.model.address.post-code.description}

### `ParticipantInfo`

- **`accountId`**: `string` (uuid) — Account ID
- **`accountNumber`**: `string` e.g. `31926819` — Account number of the participant - displayed only if used for the transaction
- **`administration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` e.g. `MANAGED` — Administration type of the participant. Managed if the participant's account is administered by Keel, External otherwise
- **`agent`**: `FinancialInstitutionInfo`
- **`bban`**: `string` — BBAN of the participant - displayed only if used for the transaction
- **`bic`**: `string` e.g. `NWBKGB2L` — BIC of the participant
- **`customerId`**: `string` (uuid) — Customer ID
- **`iban`**: `string` e.g. `GB29NWBK60161331926819` — IBAN of the participant - displayed only if used for the transaction
- **`intermediaryAgent`**: `FinancialInstitutionInfo`
- **`name`**: `string` e.g. `John Doe` — Name of the participant
- **`otherNames`**: `array` — Other names of the participant - if any other names were provided by counterpart bank
    Items:
- **`overseasAccountNumber`**: `string` — Overseas account number of the participant - displayed only if used for the transaction
- **`participantAddress`**: `AddressInfo`
- **`phoneNumber`**: `string` — Phone number of the participant - displayed only if used for the transaction
- **`scan`**: `SCAN`
- **`sortCode`**: `string` e.g. `123456` — Sort code of the participant - displayed only if used for the transaction

### `PaymentDocument`

- **`amount`** *(required)*: `AmountDocument`
- **`paymentDate`**: `string` (date)

### `PaymentPurposeInfo`

- **`code`**: `string` e.g. `SALA` — ISO 20022 purpose code (max 4 characters)
- **`proprietary`**: `string` e.g. `Salary payment` — Free-form text describing the purpose (max 35 characters)

### `PaymentPurposeRequest`

- **`code`**: `string` e.g. `SALA` — Purpose of the transaction in coded form as specified by ISO 20022 Message Schemas
- **`proprietary`**: `string` e.g. `Salary payment for April 2025` — Purpose of the transaction in free-form text

### `ProvisionIbanRequest`

- **`currencyCodes`**: `array` — Currencies associated with IBAN
**Key points:**
This parameter is applicable only to MULTICURRENCY variant.
STANDARD variant can have only single ('GBP') currency code

    Items:
- **`ownerId`** *(required)*: `string` (uuid) — Id of account owner - Customer must exist before account can be created
- **`variant`** *(required)*: `string` enum: `STANDARD` | `MULTICURRENCY` — Variant

### `ProvisionIbanResponse`

- **`accounts`**: `array`
    Items:
      **`AccountDocument`**
      - **`accountId`** *(required)*: `string` (uuid)
      - **`currencyCode`** *(required)*: `string`
      - **`state`** *(required)*: `string` enum: `ORDERED` | `ACCOUNT_ALREADY_EXISTS`

### `RejectionRecordInfo`

- **`reason`**: `string` — Reason for rejection
- **`recordedAt`**: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the rejection was recorded

### `SCAN`

*${api.model.scan.description}*

*${api.model.scan.description}*
- **`accountNumber`** *(required)*: `string` e.g. `${api.model.account-number.example}` — ${api.model.account-number.description}
- **`sortCode`** *(required)*: `string` e.g. `${api.model.sort-code.example}` — ${api.model.sort-code.description}

### `SecureCardDetailsResponse`

- **`cvv`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted Card Verification Value (CVV)
- **`pan`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — Encrypted Primary Account Number (PAN)

### `SimulatedAddress`

- **`addressLine1`** *(required)*: `string`
- **`addressLine2`**: `string`
- **`addressLine3`**: `string`
- **`countryCode`** *(required)*: `string` e.g. `US` — An Alpha-3 country code that uniquely identifies a country, as defined by the ISO 3166-1 standard.
- **`postCode`** *(required)*: `string` — Postcode or ZIP code

### `SimulatedInboundTransferRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditorAddress`** *(required)*: `SimulatedAddress`
- **`creditorFullName`** *(required)*: `string`
- **`creditorIban`** *(required)*: `string`
- **`debtorAccountNumber`**: `string` e.g. `123456789000001111112` — Debtor Account Number (either this or debtorIban must be provided)
- **`debtorAddress`** *(required)*: `SimulatedAddress`
- **`debtorFullName`** *(required)*: `string`
- **`debtorIban`**: `string` e.g. `DE89370400440532013000` — Debtor IBAN (either this or debtorAccountNumber must be provided)
- **`reference`** *(required)*: `string`

### `StatusInfo`

- **`currentStatus`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `HELD` e.g. `SETTLED` — Current status of the transaction
- **`statusesLog`** *(required)*: `array` — Log of transaction statuses
    Items:
      **`StatusLogEntry`**
      - **`recordedAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the status was recorded
      - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Transaction status

### `StatusLogEntry`

- **`recordedAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the status was recorded
- **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Transaction status

### `StructuredAddressInfo`

- **`line1`**: `string` — Address line 1
- **`line1Type`**: `string` enum: `STREET` | `POSTCODE` | `CITY` — Type of address line 1
- **`line2`**: `string` — Address line 2
- **`line2Type`**: `string` enum: `STREET` | `POSTCODE` | `CITY` — Type of address line 2
- **`line3`**: `string` — Address line 3
- **`line3Type`**: `string` enum: `STREET` | `POSTCODE` | `CITY` — Type of address line 3
- **`line4`**: `string` — Address line 4
- **`line4Type`**: `string` enum: `STREET` | `POSTCODE` | `CITY` — Type of address line 4
- **`line5`**: `string` — Address line 5
- **`line5Type`**: `string` enum: `STREET` | `POSTCODE` | `CITY` — Type of address line 5

### `TagLogEntry`

- **`recordedAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the tag was recorded
- **`tag`** *(required)*: `string` enum: `REAL_ACCOUNT_LIQUIDITY_REBALANCE` | `REVERSAL_OF_PREVIOUS_SETTLEMENT` | `DIRECT_DEBIT_RETURN_CONFIRMED` | `REVERSED` — Business tag

### `TerminateCardRequest`

- **`reason`** *(required)*: `string` enum: `STOLEN` | `LOST` | `DESTROYED` | `FRAUD` e.g. `LOST` — Reason for card termination

### `TransactionDetailsResponse`

- **`amount`** *(required)*: `AmountDocument`
- **`amountHistory`**: `array` — Log of amount changes for the transaction
    Items:
      **`AmountHistoryEntry`**
      - **`amount`** *(required)*: `number` e.g. `123.45` — Amount value
      - **`currencyCode`** *(required)*: `string` e.g. `GBP` — Currency code
      - **`overriddenAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the amount was overridden by another amount
- **`businessTransactionType`** *(required)*: `string` enum: `LOCAL_GBP` | `INTERNATIONAL` | `CROSS_BORDER_GBP` | `CROSS_BORDER_EUR` | `FX_TRADE` | `P2P` | `CHAPS` | `BACS` | `CARD` | `UNKNOWN` e.g. `INTERNATIONAL` — Business transaction type
- **`card`**: `CardInfo`
- **`createdAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the transaction was created
- **`creditor`** *(required)*: `ParticipantInfo`
- **`debtor`** *(required)*: `ParticipantInfo`
- **`fxTrade`**: `FxTradeInfo`
- **`id`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
- **`linkages`**: `LinkageInfo`
- **`paymentNetwork`**: `string` enum: `FPS` | `BACS` | `CHAPS` | `FX` | `CARD` | `CHAPS_UNKNOWN` | `SWIFT` | `GBP_CROSS_BORDER` | `EUR_CROSS_BORDER` | `TARGET2` | `OVERSEAS` | `CHAPS_SWIFT` | `CHAPS_OVERSEAS` | `UNKNOWN` — Payment network type
- **`pendingReviewId`**: `string` (uuid) e.g. `d290f1ee-6c54-4b01-90e6-d701748f0851` — Identifier of the pending review if the transaction is under review
- **`purpose`**: `PaymentPurposeInfo`
- **`reference`**: `string` e.g. `Payment for services` — Reference of the transaction
- **`rejections`**: `array` — Rejection records if the transaction was rejected
    Items:
      **`RejectionRecordInfo`**
      - **`reason`**: `string` — Reason for rejection
      - **`recordedAt`**: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the rejection was recorded
- **`status`** *(required)*: `StatusInfo`
- **`tags`**: `array` — Business tags associated with the transaction
    Items:
      **`TagLogEntry`**
      - **`recordedAt`** *(required)*: `string` (date-time) e.g. `2023-01-01T12:00:00Z` — When the tag was recorded
      - **`tag`** *(required)*: `string` enum: `REAL_ACCOUNT_LIQUIDITY_REBALANCE` | `REVERSAL_OF_PREVIOUS_SETTLEMENT` | `DIRECT_DEBIT_RETURN_CONFIRMED` | `REVERSED` — Business tag

### `TransactionHistoryPage`

- **`content`**: `array`
    Items:
      **`TransactionHistoryResponse`**
      - **`amount`** *(required)*: `AmountDocument`
      - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
      - **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
      - **`creditor`** *(required)*: `TransactionHistoryParticipant`
      - **`debtor`** *(required)*: `TransactionHistoryParticipant`
      - **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

      - **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
      - **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
      - **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
      - **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
      - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
      - **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `TransactionHistoryParticipant`

- **`accountId`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the account
- **`accountNumber`**: `string` e.g. `31926819` — Account Number
- **`administration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` e.g. `MANAGED` — Determines administration of participant - MANAGED if participant is managed by system for client, EXTERNAL otherwise
- **`bban`**: `string` e.g. `60161331926819` — Basic Bank Account Number
- **`bic`**: `string` e.g. `NWBKGB22` — Bank Identifier Code
- **`iban`**: `string` e.g. `GB29NWBK60161331926819` — International Bank Account Number
- **`name`** *(required)*: `string` e.g. `John Doe` — Name of the account holder
- **`sortCode`**: `string` e.g. `601613` — Sort Code

### `TransactionHistoryResponse`

- **`amount`** *(required)*: `AmountDocument`
- **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
- **`credit`**: `boolean` e.g. `True` — Indicates if the transaction is a credit operation
- **`creditor`** *(required)*: `TransactionHistoryParticipant`
- **`debtor`** *(required)*: `TransactionHistoryParticipant`
- **`fxRate`**: `number` e.g. `1.19` — The fxRate is the number of [sellCurrency] units you need for 1 [buyCurrency]
That is, “1 [buyCurrency] = fxRate [sellCurrency]”.
For example, if fxRate=1.19 and you're selling EUR to buy GBP,
it means “1 GBP = 1.19 EUR”. Equivalently, “1 EUR = ~0.84 GBP”,
so 1000 EUR → ~840–845 GBP.

- **`id`** *(required)*: `string` e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
- **`pendingReviewTransactionId`**: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the pending review transaction. The ID is assigned by the transaction monitoring system when a transaction is identified as potentially suspicious or indicative of illegal activity. The system flags transactions that meet specific risk criteria for further review and investigation by compliance teams, ensuring adherence to regulatory requirements and mitigating the risk of financial crime. This ID should be used as a reference during the review process.
- **`reference`** *(required)*: `string` e.g. `Internet Payment` — A short description that will help identify the transaction’s purpose
- **`rejectionReason`**: `string` enum: `INSUFFICIENT_BALANCE` | `DECLINED` | `INVALID_MERCHANT` | `CAPTURE_CARD` | `DO_NOT_HONOUR` | `UNSPECIFIED_ERROR` | `INVALID_TRANSACTION` | `INVALID_AMOUNT` | `INVALID_CARD_NUMBER` | `UNABLE_TO_ROUTE_AT_IEM` | `FORMAT_ERROR` | `LOST_CARD` | `STOLEN_CARD` | `INSUFFICIENT_FUNDS` | `EXPIRED_CARD` | `INCORRECT_PIN` | `TRANSACTION_NOT_PERMITTED_TO_CARDHOLDER` | `TRANSACTION_NOT_PERMITTED_TO_TERMINAL` | `EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT` | `RESTRICTED_CARD` | `SECURITY_VIOLATION` | `EXCEEDS_WITHDRAWAL_FREQUENCY_LIMIT` | `CARDHOLDER_TO_CONTACT_ISSUER` | `PIN_NOT_CHANGED` | `ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `WRONG_PIN_ALLOWABLE_NUMBER_OF_PIN_TRIES_EXCEEDED` | `ISSUER_DOES_NOT_PARTICIPATE_IN_THE_SERVICE` | `ACCOUNT_BALANCE_UNAVAILABLE` | `UNACCEPTABLE_PIN_TRANSACTION_DECLINED` | `DOMESTIC_DEBIT_TRANSACTION_NOT_ALLOWED` | `PIN_VALIDATION_NOT_POSSIBLE` | `CRYPTOGRAPHIC_FAILURE` | `AUTHENTICATION_FAILURE` | `ISSUER_OR_SWITCH_IS_INOPERATIVE` | `UNABLE_TO_ROUTE_TRANSACTION` | `DUPLICATE_TRANSMISSION` | `CAPTURE_CARD_FRAUD_ACCOUNT` | `ACCOUNT_CLOSED` | `ACCOUNT_DISABLED` | `INVALID_ACCOUNT` | `SUSPECTED_FRAUD` | `VERIFICATION_DATA_FAILED` | `CARD_NOT_ACTIVE` | `SCA_REQUIRED` | `SYSTEM_MALFUNCTION` | `ADDITIONAL_CUSTOMER_AUTHENTICATION_REQUIRED` | `RE_ENTER_TRANSACTION` | `NO_ACTION_TAKEN` | `UNABLE_TO_LOCATE_RECORD_IN_FILE` | `FILE_TEMPORARILY_NOT_AVAILABLE_FOR_UPDATE_OR_INQUIRY` | `NO_CREDIT_ACCOUNT` | `NO_CHECKING_ACCOUNT` | `NO_SAVINGS_ACCOUNT` | `TRANSACTION_DOES_NOT_FULFILL_AML_REQUIREMENT` | `DIFFERENT_VALUE_THAN_THAT_USER_FOR_PIN_ENCRYPTION_ERRORS` | `NO_FINANCIAL_IMPACT` | `NEGATIVE_CAM_DCVV_ICVV_OR_CVV_RESULTS` | `TRANSACTION_CANNOT_BE_COMPLETED_VIOLATION_OF_LAW` | `SURCHARGE_AMOUNT_NOT_PERMITTED_ON_VISA_CARDS_OR_EBT_FOOD_STAMPS` | `SURCHARGE_AMOUNT_NOT_SUPPORTED_BY_DEBIT_ISSUER` | `FORCE_STIP` | `CASH_SERVICE_NOT_AVAILABLE` | `CASH_REQUEST_EXCEEDS_ISSUER_OR_APPROVED_LIMIT` | `INELIGIBLE_FOR_RESUBMISSION` | `TRANSACTION_AMOUNT_EXCEEDS_PREAUTHORISED_APPROVAL_AMOUNT` | `DENIED_PIN_UNBLOCK` | `DENIED_PIN_CHANGE` | `CARD_AUTHENTICATION_FAILED` | `STOP_PAYMENT_ORDER` | `DEBIT_PAYMENT_DISABLED` | `TRANSACTION_DOES_NOT_QUELIFY_FOR_VISA_PIN` | `REVOCATION_OF_ALL_AUTHORIZATIONS_ORDER` | `UNABLE_TO_GO_ONLINE_OFFLINE_DECLINED` | `CVV2_FAILURE` | `INVALID_CURRENCY` | `DAILY_AMOUNT_TOO_HIGH` | `WEEKLY_AMOUNT_TOO_HIGH` | `NAME_MISMATCH` | `ACCOUNT_DISABLED_INBOUND_REVERSAL` | `OUTBOUND_TRANSACTION_STRAIGHT_AFTER_INBOUND` | `MANDATE_NOT_INITIATED` | `REJECTED` | `REJECTED_BY_KILL_SWITCH` | `OUTBOUND_RETRY_EXHAUSTED` | `UNKNOWN` | `FX_TRADE_DATE_WEEKEND` | `FX_TRADE_DATE_PAST` | `FX_TRADE_DATE_OUTSIDE_TRADING_HOURS` | `FX_TRADE_DATE_UNKNOWN` | `FX_TRADE_VALUE_TOO_LOW` | `FX_TRADE_VALUE_UNKNOWN_ERROR` | `FX_TRADE_QUOTE_EXPIRED` | `FX_TRADE_QUOTE_DATE_OUTSIDE_TRADING_HOURS` | `CROSS_BORDER_GBP_NOT_IN_PAYMENT_WINDOW` | `NONE` e.g. `INSUFFICIENT_BALANCE` — The RejectedReason field indicates the cause for the rejection of a transaction or the detection of potentially suspicious activity by the monitoring system, necessitating further review and investigation by compliance teams. This field is populated when a transaction is either rejected or flagged for pending review. It provides details on the specific issue that led to the rejection or the requirement for manual investigation.
- **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `REVERSED` | `HELD` | `CANCELLED` e.g. `SETTLED` — Status of the transaction
- **`type`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER` e.g. `INTER_BANK_TRANSACTION` — Type of the transaction

### `TransactionParticipant`

- **`accountId`**: `string` (uuid)
- **`accountNumber`**: `string`
- **`administration`**: `string` enum: `MANAGED` | `EXTERNAL`
- **`bban`**: `string`
- **`bic`**: `string`
- **`iban`**: `string`
- **`name`**: `string`
- **`phoneNumber`**: `string`
- **`sortCode`**: `string`

### `TransactionReviewRequest`

- **`actions`** *(required)*: `array`
    Items:
      Enum: `ACCEPT` | `ADD_TO_TRUSTED` | `BLOCK_USER` | `RETURN_INCOMING_FUNDS_TO_SENDER` | `REJECT_OUTGOING_TRANSACTION`

### `TransactionStateChangedWebhookRequest`

- **`amount`** *(required)*: `AmountDocument`
- **`creditor`** *(required)*: `TransactionParticipant`
- **`creditorAccountId`** *(required)*: `string` (uuid) — Legacy field - use 'creditor.accountId' instead
- **`debtor`**: `TransactionParticipant`
- **`debtorAccountId`**: `string` (uuid) — Legacy field - use 'debtor.accountId' instead
- **`isReversal`**: `boolean` — Indicates whether the transaction is a reversal.
- **`pendingReviewTransactionId`** *(required)*: `string` (uuid) — The pending review transaction id if the transaction is in a pending review state. This parameter is optional.
- **`reference`** *(required)*: `string`
- **`transactionId`** *(required)*: `string` (uuid)
- **`transactionType`** *(required)*: `string` enum: `INTER_BANK_TRANSACTION` | `INTER_BANK_INTERNATIONAL_TRANSACTION` | `INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `INTER_BANK_OVERSEAS_TRANSACTION` | `INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_INTER_BANK_TRANSACTION` | `PENDING_INTERNATIONAL_INTER_BANK_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_GBP_TRANSACTION` | `PENDING_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `FX_TRADE_TRANSACTION` | `PENDING_FX_TRADE_TRANSACTION` | `REJECTED_FX_TRADE_TRANSACTION` | `HELD_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_TRANSACTION` | `REJECTED_INTERNATIONAL_INTER_BANK_TRANSACTION` | `REJECTED_CROSS_BORDER_GBP_INTER_BANK_TRANSACTION` | `REJECTED_INTER_BANK_CROSS_BORDER_EUR_TRANSACTION` | `REJECTED_BANK_TRANSACTION` | `REJECTED_REVIEWED_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_OVERSEAS_TRANSACTION` | `PENDING_REVIEW_INTER_BANK_UNKNOWN_TRANSACTION` | `PENDING_REVIEW_OUTBOUND_INTER_BANK_TRANSACTION` | `PENDING_REVIEW_DIRECT_CREDIT_TRANSACTION` | `PENDING_REVIEW_INTERNATIONAL_INTER_BANK_TRANSACTION` | `INTRA_BANK_TRANSACTION` | `INTRA_BANK_SAVING_TRANSACTION` | `CHAPS_TRANSACTION` | `PENDING_REVIEW_CHAPS_TRANSACTION` | `PENDING_CARD_TRANSACTION` | `CARD_TRANSACTION` | `CARD_FEE_TRANSACTION` | `REJECT_CARD_TRANSACTION` | `CANCELLED_CARD_TRANSACTION` | `CANCELLED_CARD_FEE_TRANSACTION` | `PENDING_CARD_REVERSAL_TRANSACTION` | `PENDING_CARD_FEE_REVERSAL_TRANSACTION` | `PENDING_BACS_TRANSACTION` | `SETTLED_DEBIT_BACS_TRANSACTION` | `SETTLED_CREDIT_BACS_TRANSACTION` | `RETURNED_BACS_TRANSACTION` | `REJECTED_BACS_TRANSACTION` | `PENDING_CARD_TRANSFER` | `CARD_TRANSFER` | `CARD_TRANSFER_FEE` | `REJECT_CARD_TRANSFER` | `PENDING_CARD_TRANSFER_REVERSAL` | `PENDING_CARD_TRANSFER_FEE_REVERSAL` | `PENDING_INTER_BANK_TRANSFER` | `HELD_INTER_BANK_TRANSFER` | `REJECTED_INTER_BANK_TRANSFER` | `PENDING_BACS_TRANSFER` | `SETTLED_BACS_TRANSFER` | `SETTLED_DEBIT_BACS_TRANSFER` | `SETTLED_CREDIT_BACS_TRANSFER` | `RETURNED_BACS_TRANSFER` | `REJECTED_BACS_TRANSFER`

### `TransactionsListItemPage`

- **`content`**: `array`
    Items:
      **`TransactionsListItemResponse`**
      - **`amount`** *(required)*: `AmountDocument`
      - **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
      - **`creditorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Creditor account administration
      - **`creditorId`**: `string` (uuid) — Customer ID
      - **`creditorName`** *(required)*: `string` e.g. `Jane Smith` — Name of the creditor account holder
      - **`debtorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Debtor account administration
      - **`debtorId`**: `string` (uuid) — Customer ID
      - **`debtorName`** *(required)*: `string` e.g. `John Doe` — Name of the debtor account holder
      - **`fxBoughtAmount`**: `AmountDocument`
      - **`id`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
      - **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `HELD` e.g. `SETTLED` — Status of the transaction
      - **`type`** *(required)*: `string` enum: `LOCAL_GBP` | `INTERNATIONAL` | `CROSS_BORDER_GBP` | `CROSS_BORDER_EUR` | `FX_TRADE` | `P2P` | `CHAPS` | `BACS` | `CARD` | `UNKNOWN` e.g. `INTERNATIONAL` — Type of the business transaction
- **`pageNumber`**: `integer` (int64)
- **`pageSize`**: `integer` (int64)
- **`totalElements`**: `integer` (int64)
- **`totalPages`**: `integer` (int64)

### `TransactionsListItemResponse`

- **`amount`** *(required)*: `AmountDocument`
- **`createdAt`** *(required)*: `string` (date-time) e.g. `2021-07-01T12:00:00Z` — Date and time when the transaction was created
- **`creditorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Creditor account administration
- **`creditorId`**: `string` (uuid) — Customer ID
- **`creditorName`** *(required)*: `string` e.g. `Jane Smith` — Name of the creditor account holder
- **`debtorAdministration`** *(required)*: `string` enum: `MANAGED` | `EXTERNAL` — Debtor account administration
- **`debtorId`**: `string` (uuid) — Customer ID
- **`debtorName`** *(required)*: `string` e.g. `John Doe` — Name of the debtor account holder
- **`fxBoughtAmount`**: `AmountDocument`
- **`id`** *(required)*: `string` (uuid) e.g. `28ece1bd-8426-49c4-a46d-09a1bfca309b` — Unique identifier of the transaction
- **`status`** *(required)*: `string` enum: `PENDING` | `IN_REVIEW` | `SETTLED` | `REJECTED` | `HELD` e.g. `SETTLED` — Status of the transaction
- **`type`** *(required)*: `string` enum: `LOCAL_GBP` | `INTERNATIONAL` | `CROSS_BORDER_GBP` | `CROSS_BORDER_EUR` | `FX_TRADE` | `P2P` | `CHAPS` | `BACS` | `CARD` | `UNKNOWN` e.g. `INTERNATIONAL` — Type of the business transaction

### `UpdateCard3dsPassword`

- **`encryptedPassword`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — New encrypted 3DS password (Base64 encoded)

### `UpdateCardPin`

- **`encryptedPin`** *(required)*: `string` e.g. `aTM68ywOQzL7719pBTCHJL0p2swxsTLtlaUDrsa73nI=` — New RSA encrypted PIN (Base64 encoded)

### `UpdateIbanCurrencyAccountsRequest`

- **`add`** *(required)*: `array` — List of 3-letter currency codes
    Items:

### `UpdateIbanCurrencyAccountsResponse`

- **`accounts`** *(required)*: `array`
    Items:
      **`AccountDocument`**
      - **`accountId`** *(required)*: `string` (uuid)
      - **`currencyCode`** *(required)*: `string`
      - **`state`** *(required)*: `string` enum: `ORDERED` | `ACCOUNT_ALREADY_EXISTS`

### `UserStateChangedWebhookRequest`

- **`blocked`**: `boolean`
- **`kycSupplementaryUrl`**: `string`
- **`offboarded`**: `boolean`
- **`userId`** *(required)*: `string`

### `WebhookResponse`

- **`clientId`**: `string`
- **`notificationId`**: `string`
