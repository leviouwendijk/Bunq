> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/environments.md).

# Environments

The bunq API is available in two environments: **sandbox** and **production**. Both environments share the same API structure but differ in base URL, data, and certain behaviors.

## Base URLs

| Environment | Base URL                                  |
| ----------- | ----------------------------------------- |
| Sandbox     | `https://public-api.sandbox.bunq.com/v1/` |
| Production  | `https://api.bunq.com/v1/`                |

All API paths are appended directly to the base URL. For example:

```http
GET https://api.bunq.com/v1/user
```

## Sandbox

The sandbox environment is free and requires no real bunq account.

**What it provides:**

* Instantly generated test users
* Fake money you can add on demand
* Mock webhooks for testing callbacks
* No signing validation on most calls

**Use it for:**

* Building and testing your integration before going live
* Automated tests in CI/CD pipelines
* Exploring the API without risk

**Get a sandbox API key** via the API:

```bash
curl -X POST https://public-api.sandbox.bunq.com/v1/sandbox-user-person \
  -H "Content-Type: application/json" \
  -H "X-Bunq-Client-Request-Id: $(uuidgen)"
```

## Production

The production environment connects to real bunq accounts and processes real money.

**Requirements:**

* A valid bunq personal or business account
* A production API key generated from the bunq app
* Properly signed requests (see Signing)
* Whitelisted IP addresses (see Whitelisting)

**Key differences from sandbox:**

* All requests must be signed
* API keys are tied to a real account
* Rate limits are enforced (see Rate Limits)
* Payments move real money

See Moving to Production for the full checklist.

## OAuth URLs

| Environment | Authorization URL                     | Token URL                                     |
| ----------- | ------------------------------------- | --------------------------------------------- |
| Sandbox     | `https://oauth.sandbox.bunq.com/auth` | `https://api-oauth.sandbox.bunq.com/v1/token` |
| Production  | `https://oauth.bunq.com/auth`         | `https://api.oauth.bunq.com/v1/token`         |


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/environments.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
