> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/payments-as-a-service.md).

# Payments - As a Service

## Payments

Once a user has a verified monetary account, they can send and receive money on the SEPA network. bunq's payments API gives you full programmatic control over both sides of that flow.

***

### The paradigm

Payments in bunq are always scoped to a monetary account. To initiate a payment, you specify the source account, the destination (an IBAN or bunq alias), the amount, and a description. bunq handles the routing — internal transfers between bunq accounts settle instantly; external SEPA payments follow standard rail timelines.

Incoming payments arrive on the account's IBAN. Your integration receives them via callbacks and can query the transaction history at any time.

Key things to understand:

* **Payment types.** The `Payment` object covers both outgoing and incoming transfers. Filter by `type` (`IDEAL`, `SEPA`, `INTERNAL`, etc.) to distinguish them.
* **Draft payments.** For flows that require a second approval step (e.g. a human signs off before money moves), use `DraftPayment`. The payment is created but not executed until explicitly confirmed.
* **Batch payments.** You can send multiple payments in a single API call using `PaymentBatch`. Useful for payroll runs, mass payouts, or invoice settlements.
* **Idempotency.** Use the `X-Bunq-Client-Request-Id` header to safely retry failed requests without risk of double payments.
* **Callbacks.** Register a notification filter on the account to receive a webhook whenever a payment arrives or a payment status changes.

***

### Flow overview

**Outgoing payment:**

```
Your platform                         bunq API
─────────────                         ────────
POST /payment                    →    Validates and queues payment
                                 ←    Payment object (status: PENDING)
                                 ←    Callback: PAYMENT_CREATED / PAYMENT_EXECUTED
```

**Incoming payment:**

```
External sender                       bunq API          Your platform
───────────────                       ────────          ─────────────
Sends SEPA to user's IBAN        →    Credits account
                                 →    Callback: MUTATION →  Your webhook
GET /payment/{id}                ←    Full transaction detail
```

***

### Relevant API endpoints

| Action                      | Endpoint                                                                                                                |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Send a payment              | [`POST /v1/user/{userID}/monetary-account/{accountID}/payment`](https://doc.bunq.com/api-reference/payment)             |
| List payments (history)     | [`GET /v1/user/{userID}/monetary-account/{accountID}/payment`](https://doc.bunq.com/api-reference/payment)              |
| Get a specific payment      | [`GET /v1/user/{userID}/monetary-account/{accountID}/payment/{itemID}`](https://doc.bunq.com/api-reference/payment)     |
| Create a draft payment      | [`POST /v1/user/{userID}/monetary-account/{accountID}/draft-payment`](https://doc.bunq.com/api-reference/draft-payment) |
| Send a batch of payments    | [`POST /v1/user/{userID}/monetary-account/{accountID}/payment-batch`](https://doc.bunq.com/api-reference/payment-batch) |
| Register a payment callback | [`POST /v1/user/{userID}/notification-filter-url`](https://doc.bunq.com/api-reference/notification-filter-url)          |

***

### Payment object highlights

The payment response includes:

* `amount` — object with `value` (string decimal) and `currency`
* `counterparty_alias` — the other party's IBAN or bunq alias
* `description` — the payment reference (appears on the recipient's statement)
* `type` — payment rail used (`SEPA_CREDIT_TRANSFER`, `INTERNAL`, etc.)
* `status` — current state (`PENDING`, `EXECUTED`, `REJECTED`, `REVERTED`)
* `created` / `updated` — timestamps in `YYYY-MM-DD HH:MM:SS.SSSSSS` format

***

### Common integration patterns

**Pattern 1 — Instant payouts.** Trigger a payment immediately when an event occurs in your platform (e.g. a gig worker completes a task). Use callbacks to confirm execution and update your own records.

**Pattern 2 — Scheduled / batch payroll.** Collect payment instructions throughout the week, then fire a `PaymentBatch` on payday. Simpler to manage than individual calls and easier to reconcile.

**Pattern 3 — Incoming payment reconciliation.** Each account has a unique IBAN. Assign one account per customer or invoice, so incoming payments self-identify by destination. Query the payment's `description` field for additional reference matching.

**Pattern 4 — Two-step approval.** Use `DraftPayment` for high-value transactions that require a human review step before execution. Your platform surfaces the draft, an authorised user confirms it, and you send the confirmation via API.

***

{% hint style="warning" %} Always store the `X-Bunq-Client-Request-Id` you send with each payment request. If a request times out, resubmit the same ID — bunq will deduplicate and return the original result rather than creating a second payment. {% endhint %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/payments-as-a-service.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
