> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/getting-started-with-banking-as-a-service/introduction-and-core-paradigms.md).

# Introduction & Core Paradigms

Before you make your first API call, it's worth spending a few minutes understanding how bunq thinks about banking. The API is consistent and predictable — but only once the underlying model clicks.

***

### bunq is the bank. You are the platform.

When you integrate bunq BaaS, you're not connecting to a ledger or a payment processor. You're connecting to a licensed bank. That distinction matters in two ways:

1. **Regulation is handled for you.** bunq holds the banking license, manages AML obligations, safeguards funds, and sits on the payment rails. You don't need your own EMI license to issue IBANs or cards through bunq.
2. **You stay in control.** Everything bunq does for your users — opening accounts, issuing cards, verifying identity, moving money — is driven by API calls your platform makes. bunq executes; you orchestrate.

***

### The user hierarchy

The most important concept in the bunq data model is the **user hierarchy**.

```
bunq (the bank)
└── Your platform (API key holder)
    └── Sub-user A  ←  KYC-verified individual
    │   ├── Monetary Account (IBAN)
    │   │   └── Payments
    │   └── Card
    └── Sub-user B
        ├── Monetary Account
        └── Card
```

Everything in bunq lives under a `user`. When you use BaaS, you create and manage **sub-users** — one per end-user on your platform. Each sub-user goes through KYC, gets their own monetary accounts, and can have cards issued against those accounts.

Your API credentials sit at the top of this tree. You act on behalf of sub-users using the user ID in your API paths: `/v1/user/{userID}/monetary-account`, `/v1/user/{userID}/payment`, and so on.

***

### Everything is an object

bunq's API is resource-oriented. The key objects you'll work with in BaaS, and how they relate:

| Object             | What it is                              | Lives under                             |
| ------------------ | --------------------------------------- | --------------------------------------- |
| `User`             | A verified identity (your end-user)     | Your platform credentials               |
| `MonetaryAccount`  | A bank account with an IBAN             | A `User`                                |
| `Payment`          | A money movement (in or out)            | A `MonetaryAccount`                     |
| `Card`             | A Mastercard debit card                 | A `User`, linked to a `MonetaryAccount` |
| `MastercardAction` | A card transaction (auth or settlement) | A `MonetaryAccount`                     |

Objects reference each other by ID. A card points to its linked monetary account. A payment points to the account it moved money on. When something goes wrong or you need to reconcile, you can always trace the chain back.

***

### The session model

bunq uses a **signed-request, session-token** authentication pattern. You set it up once per integration, then manage short-lived sessions.

The flow has three steps:

1. **Installation** — register your public key with bunq via `POST /v1/installation`. Receive an installation token.
2. **Device registration** — identify your server via `POST /v1/device-server` using the installation token.
3. **Session** — start a session via `POST /v1/session-server`. Receive a session token valid for the duration of that session.

Use the session token in the `X-Bunq-Client-Authentication` header on every subsequent request. Sessions expire after inactivity — your integration should handle re-authentication gracefully.

Every request must also be **signed** with your private key and include the signature in the `X-Bunq-Client-Signature` header. bunq verifies this signature server-side, and signs its responses so you can verify them too.

For the full authentication walkthrough, see [Basics → Getting Started](https://doc.bunq.com/basics).

***

### The lifecycle pattern

Most objects in bunq move through a predictable lifecycle: created → active → closed. The key states to handle in your integration:

| Object          | States to handle                                            |
| --------------- | ----------------------------------------------------------- |
| Sub-user        | `PENDING` → `VERIFIED` (KYC complete) / `REJECTED`          |
| MonetaryAccount | `PENDING` → `ACTIVE` → `CANCELLED`                          |
| Payment         | `PENDING` → `EXECUTED` / `REJECTED` / `REVERTED`            |
| Card            | `ACTIVE` → `SUSPENDED` (frozen) → `DEACTIVATED` / `EXPIRED` |

Design your platform logic around these states. Don't assume an object is active just because you created it — always check status before acting on it.

***

### Callbacks, not polling

bunq is event-driven. Instead of polling for changes, register a **notification filter** (webhook) on the user or account you care about. bunq will `POST` to your endpoint when something happens — a payment arrives, a KYC result comes in, a card transaction is authorised.

```
POST /v1/user/{userID}/notification-filter-url
{
  "notification_filters": [
    {
      "notification_delivery_method": "URL",
      "notification_target": "https://your-platform.com/webhooks/bunq",
      "category": "PAYMENT"
    }
  ]
}
```

Always verify the `X-Bunq-Server-Signature` header on incoming callbacks before processing them. Respond with a `200` quickly — do your processing asynchronously.

Available callback categories relevant to BaaS: `PAYMENT`, `MUTATION`, `CARD_TRANSACTION_AUTHORISED`, `CARD_TRANSACTION_DECLINED`, `KYC`.

***

### Idempotency

Network failures happen. For any state-changing request (creating a payment, issuing a card), always include a unique `X-Bunq-Client-Request-Id` header. If you retry a failed request with the same ID, bunq will return the original result rather than executing the action twice.

```
X-Bunq-Client-Request-Id: your-unique-uuid-here
```

Generate a fresh UUID per request and store it alongside the pending operation. If the request times out, retry with the same ID. Once you have a confirmed response, the ID can be retired.

***

### Sandbox vs production

bunq provides a full sandbox environment at `public-api.sandbox.bunq.com`. It mirrors the production API exactly — same endpoints, same object model, same authentication flow — but uses test money and synthetic identity verification.

Build and test your entire integration in sandbox before going live. The only things that differ in production are real IBANs, real card networks, and real KYC checks.

|          | Sandbox                        | Production                      |
| -------- | ------------------------------ | ------------------------------- |
| Base URL | `public-api.sandbox.bunq.com`  | `api.bunq.com`                  |
| API key  | Generated via sandbox tools    | Issued by bunq after onboarding |
| KYC      | Synthetic (always passes)      | Real identity verification      |
| Payments | Test money, no real settlement | Live SEPA rails                 |
| Cards    | Virtual test cards             | Real Mastercard-network cards   |

***

### What to build first

If you're starting a new BaaS integration, the recommended sequence is:

1. **Authentication** — get your sandbox credentials, complete the installation → device → session flow.
2. **KYC** — create a test sub-user and verify them through the sandbox KYC flow.
3. **Monetary account** — open an account for the verified user and note the IBAN.
4. **Payments** — send a test payment out; trigger an incoming payment to the IBAN.
5. **Cards** — issue a virtual card and generate a CVC2.
6. **Callbacks** — register a webhook and verify you're receiving events for each of the above.

Once all six work end-to-end in sandbox, you're ready to go through the production onboarding process with your bunq BaaS account manager.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/getting-started-with-banking-as-a-service/introduction-and-core-paradigms.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
