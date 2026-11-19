> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/know-your-customer-as-a-service.md).

# Know Your Customer - As a Service

## KYC as a Service

Know Your Customer (KYC) is a regulatory requirement for any business that holds money or moves it on behalf of people. Building a compliant onboarding flow from scratch — identity document checks, liveness detection, sanctions screening, PEP lists — is expensive, slow, and requires maintaining your own compliance program.

With bunq's KYC as a Service, you delegate that entire process to a regulated bank. bunq handles the verification, stores the compliance record, and issues a verified user that your platform can immediately act on.

***

### The paradigm

When a new user signs up to your platform, you create a **sub-user** via the bunq API and kick off the KYC flow. bunq guides your user through identity verification (document upload + liveness check). Once verified, that user gets a bunq identity tied to your platform — ready to open accounts, receive payments, and use cards.

You never handle raw identity documents. bunq does the regulated heavy lifting; you get a simple boolean: verified or not.

Key things to understand:

* **Sub-user model.** Each end-user on your platform maps to a bunq sub-user object. KYC status lives on that sub-user.
* **Verification is asynchronous.** After initiating KYC, use a callback URL to receive the result rather than polling.
* **Retries and failure states.** A user can fail verification (e.g. blurry document) and retry. Your integration should handle `PENDING`, `VERIFIED`, and `REJECTED` states.
* **Regulatory scope.** bunq's KYC covers EU individuals. For corporate onboarding (KYB) or non-EU users, contact your bunq BaaS account manager.

***

### Flow overview

```
Your platform          bunq API
─────────────          ────────
POST /user         →   Creates sub-user shell
POST /kyc-request  →   Triggers identity verification flow
                   ←   Callback: KYC_RESULT (VERIFIED / REJECTED)
GET  /user/{id}    →   Fetch verified user object
```

***

### Relevant API endpoints

| Action                        | Endpoint                                                                                                       |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Create a sub-user             | [`POST /v1/user`](https://doc.bunq.com/api-reference/user)                                                     |
| Get user details / KYC status | [`GET /v1/user/{userID}`](https://doc.bunq.com/api-reference/user)                                             |
| Set a callback URL for events | [`POST /v1/user/{userID}/notification-filter-url`](https://doc.bunq.com/api-reference/notification-filter-url) |

{% hint style="info" %}
The full KYC initiation endpoint and request schema are available upon request. Contact your BaaS account manager for the specific endpoint path for your integration tier.
{% endhint %}

***

### Callback payload

When verification completes, bunq sends a `POST` to your registered callback URL. The payload includes the user ID, the new KYC status, and a timestamp. Always verify the `X-Bunq-Server-Signature` header before processing.

***

### Common integration patterns

**Pattern 1 — Verify before account creation.** Gate monetary account creation on `VERIFIED` status. This is the safest approach and the most common for financial-product builders.

**Pattern 2 — Optimistic onboarding.** Let users start a limited flow (e.g. receive a payment link) before full KYC, and upgrade their permissions once verified. Requires careful UX design to avoid confusing users about what they can and can't do yet.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/know-your-customer-as-a-service.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
