> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/bank-accounts-as-a-service.md).

# Bank Accounts - As a Service

## Monetary Accounts

A monetary account is the core object in the bunq data model. It's a real euro bank account with its own IBAN, capable of sending and receiving SEPA payments, holding a balance, and being linked to one or more cards.

With bunq BaaS, you can open monetary accounts programmatically on behalf of your verified sub-users. Each account is a fully functional bank account — not a virtual ledger or a pre-paid balance, but a real account at a regulated Dutch bank.

***

### The paradigm

Every monetary account belongs to a `user`. Before you can create an account for someone, that user must be KYC-verified (see [KYC as a Service](https://doc.bunq.com/banking-as-a-service/know-your-customer-as-a-service)).

A single user can hold multiple monetary accounts — for example, a main account and a savings pot, or accounts in different currencies. Each account has its own IBAN and tracks its own transaction history.

The main account type you'll use for BaaS is `MonetaryAccountBank` — a standard IBAN-bearing euro account.

Key things to understand:

* **IBANs are real.** Every `MonetaryAccountBank` gets a dedicated IBAN that works on all SEPA payment rails. Third parties can send money directly to your user's IBAN.
* **Account status.** Accounts move through `PENDING`, `ACTIVE`, `CANCELLED`, and `CANCELLED_PENDING_SETTLEMENT` states. Most of your logic will act on `ACTIVE` accounts.
* **Balance and transactions.** The balance and full transaction history are queryable at any time via the account ID.
* **Limits.** Account limits (transaction volume, balance caps) are set at the BaaS agreement level. Contact your account manager to adjust them.

***

### Flow overview

```
Your platform                    bunq API
─────────────                    ────────
(KYC verified sub-user exists)
POST /monetary-account-bank  →   Opens account, returns IBAN
GET  /monetary-account/{id}  →   Fetch balance and status
GET  /payment                →   List transactions on account
```

***

### Relevant API endpoints

| Action                       | Endpoint                                                                                                                                            |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| Create a bank account (IBAN) | [`POST /v1/user/{userID}/monetary-account-bank`](https://doc.bunq.com/monetary-account/monetary-account-bank)                                       |
| List all accounts for a user | [`GET /v1/user/{userID}/monetary-account`](https://doc.bunq.com/api-reference/monetary-account)                                                     |
| Get a specific account       | [`GET /v1/user/{userID}/monetary-account-bank/{itemID}`](https://doc.bunq.com/monetary-account/monetary-account-bank)                               |
| Close / cancel an account    | [`PUT /v1/user/{userID}/monetary-account-bank/{itemID}`](https://doc.bunq.com/monetary-account/monetary-account-bank) (set `status` to `CANCELLED`) |
| Get account balance          | Included in the account object — see `balance` field                                                                                                |
| List transactions            | [`GET /v1/user/{userID}/monetary-account/{accountID}/payment`](https://doc.bunq.com/api-reference/payment)                                          |

***

### Account object highlights

When you `GET` a monetary account, the response includes:

* `iban` — the account's full IBAN (share this with your user or third parties for incoming payments)
* `balance` — current balance object with `value` and `currency`
* `status` — account lifecycle state
* `display_name` — human-readable label you set at creation
* `alias` — additional payment aliases (e.g. phone number, email) if configured

***

### Common integration patterns

**Pattern 1 — One account per user.** The simplest model. Create one `MonetaryAccountBank` per verified sub-user. Works well for platforms where each user has a single wallet or balance.

**Pattern 2 — Multiple accounts per user.** Create separate accounts for different purposes (e.g. "spending" vs "savings", or separate accounts per project/invoice). Users and your platform can move money between these accounts using internal transfers.

**Pattern 3 — Shared or pooled accounts.** For marketplaces or escrow-like flows, a single account can receive funds from many parties. Use transaction metadata and callbacks to reconcile incoming payments to the correct source.

***

{% hint style="info" %}
Monetary account creation requires the sub-user to have `VERIFIED` KYC status. Attempting to create an account for an unverified user will return a `400` error.
{% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/bank-accounts-as-a-service.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
