> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/banking-as-a-service/getting-started-with-banking-as-a-service/overview.md).

# Overview

## Banking as a Service

bunq is a fully licensed European bank — and we're opening the entire stack to developers and businesses who want to build financial products without starting from scratch.

With bunq's Banking as a Service (BaaS) APIs, you get direct access to the same core infrastructure that powers millions of bunq accounts: real IBANs, payment rails, card issuing, and identity verification. No middleware, no workarounds — just clean REST APIs backed by a real bank.

{% hint style="info" %}
BaaS APIs are available to approved partners. [Get in touch](mailto:sales@bunq.com) to discuss access.
{% endhint %}

***

### What you can build

Whether you're embedding financial services into an existing product or building a fintech from the ground up, bunq BaaS gives you the building blocks to do it:

* **KYC as a Service** — verify your users' identities using bunq's regulated onboarding flow, without building your own compliance infrastructure.
* **Monetary Accounts** — open and manage euro bank accounts (with real IBANs) on behalf of your users, programmatically.
* **Payments** — initiate SEPA credit transfers, handle incoming payments, and manage payment flows end-to-end.
* **Cards** — issue and manage virtual and physical Mastercard debit cards linked to bunq accounts.

***

### How it works

bunq BaaS is built on the same public bunq API that powers our consumer and business products. It uses standard REST over HTTPS, with signed requests for security.

The key paradigm to understand is the **user hierarchy**: every account, card, and payment lives under a `user` object. When you use BaaS, you act on behalf of sub-users that your platform creates and manages — giving you full programmatic control while bunq handles the regulatory and banking layer underneath.

Authentication follows the same installation → session pattern used across the bunq API. You'll set up your API credentials once, then use session tokens for all subsequent calls.

For the full authentication flow, see [Basics → Getting Started](https://doc.bunq.com/basics).

***

### BaaS vs the standard bunq API

|                    | Standard bunq API                    | BaaS                                            |
| ------------------ | ------------------------------------ | ----------------------------------------------- |
| Use case           | Automate your own bunq account       | Build white label financial products for others |
| User model         | Your own bunq user                   | Sub-users managed by your platform              |
| KYC                | bunq handles it for your account     | You trigger it via API for your users           |
| Card issuing       | Manage your own cards                | Issue cards on behalf of sub-users              |
| Typical integrator | Developer, fintech, accountancy tool | Neobank, SaaS platform, marketplace             |

***

### Next steps

Pick the capability you want to integrate and follow the dedicated guide:

{% content-ref url="/pages/w1uOfaXHLlimhRKx2d36" %}
[Bank Accounts - As a Service](/banking-as-a-service/bank-accounts-as-a-service.md)
{% endcontent-ref %}

{% content-ref url="/pages/eiSPRVVyVUwjsvhGKt0A" %}
[Cards - As a Service](/banking-as-a-service/cards-as-a-service.md)
{% endcontent-ref %}

{% content-ref url="/pages/axDXpXkhimhuhCDgGEyn" %}
[Payments - As a Service](/banking-as-a-service/payments-as-a-service.md)
{% endcontent-ref %}

{% content-ref url="/pages/uNLOGz6ZH2eq7e0gb9wf" %}
[Know Your Customer - As a Service](/banking-as-a-service/know-your-customer-as-a-service.md)
{% endcontent-ref %}


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/banking-as-a-service/getting-started-with-banking-as-a-service/overview.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
