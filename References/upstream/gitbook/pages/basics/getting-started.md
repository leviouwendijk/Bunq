> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/getting-started.md).

# Getting started

## Quick Reference

|                  | Sandbox                                   | Production                       |
| ---------------- | ----------------------------------------- | -------------------------------- |
| Base URL         | `https://public-api.sandbox.bunq.com/v1/` | `https://api.bunq.com/v1/`       |
| API key          | Generated via API or developer app        | Generated in the bunq mobile app |
| Real money       | No                                        | Yes                              |
| Signing required | No (except payments/sessions)             | Yes                              |

See Environments for full details.

### 1. Create a bunq Account

To use the bunq API in production, you'll need a personal or business bunq account, which you can create directly in the [bunq mobile app](https://www.bunq.com).

But if you're just getting started, **you don't need a real account yet**.

We provide a **sandbox environment** where you can:

* Generate sandbox users instantly
* Access test accounts with fake money
* Experiment freely without risk

To get started with the sandbox account we recommend you start with our tutorial: [Your first payment](/tutorials/your-first-payment.md) which guides you through all the steps.

### 2. Choose Between Sandbox and Production

bunq offers two environments for developers:

#### Sandbox

* **Free** and open to anyone — no real bunq account required
* Preloaded with **test money** and **mock users**
* Safe to experiment, test features, and simulate payments

Ideal for:

* Trying out the API
* Building and testing your integration
* Running automated tests

#### Production

* Connects to **real bunq accounts** and **live money**
* Requires a valid bunq personal or business account
* Used for actual payments, user data, and transactions

Use this when:

* You're ready to go live
* You want to interact with real users and money

Follow these instructions to start  and here to .

### 3. Generate an API Key or Register an OAuth Client

If you're building something **just for your own bunq account**, you can generate a personal  directly from the bunq app:

* Grants **full access to your own account**
* Ideal for **internal tools, scripts, or personal automations**
* Simple to set up: no redirects, no user consent flow

If you're building an app or service that needs access to **other users' bunq accounts**, use [OAuth](/basics/authentication/oauth.md):

* Users grant permission to your app
* You get access **only to the scopes** they approve
* Required for **multi-user apps, SaaS products, and platforms**

### 4. Set Up Your Development Environment

Install the tools for your environment. See the [Tools](/getting-started/tools.md) page for Postman collections and other utilities.

### 5. Install an SDK

To make integration easier, we offer official SDKs in the most popular languages:

* Python
* Java
* C#
* PHP

These SDKs handle encryption, session creation, and API communication for you — so you can focus on building.

The official SDKs are archived on GitHub and no longer actively maintained, but remain available as a reference:

* [Python SDK](https://github.com/bunq/sdk_python)
* [Java SDK](https://github.com/bunq/sdk_java)
* [C# SDK](https://github.com/bunq/sdk_csharp)
* [PHP SDK](https://github.com/bunq/sdk_php)

For new integrations, we recommend calling the API directly using the examples in these docs.

#### Why use an SDK?

* Simplifies authentication and session handling
* Automatically manages request signing and response parsing
* Speeds up development with helpful abstractions

### 6. Try a Tutorial

We offer a few Tutorials that help you step-by-step to understand the basics. These tutorials exist:

* [Your first payment](/tutorials/your-first-payment.md)
*
*
* [How to manage your cards](/tutorials/how-to-manage-your-cards.md)

### 7. Explore Callbacks (Webhooks) for Real-Time Updates

bunq supports **webhooks** to notify your app in real time when something happens — like receiving a payment or a card transaction. These events are also available via the API, but webhooks let you react instantly without polling. Just register a callback URL, and bunq will send a signed POST request whenever an event occurs.

Learn how to set up these callbacks here&#x20;


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/getting-started.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
