> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/api-versioning-and-deprecation.md).

# API Versioning & Deprecation

## Current Version

The bunq API is currently at **version 1**. All API endpoints are prefixed with `/v1/`:

```
https://api.bunq.com/v1/user
https://api.bunq.com/v1/user/{userId}/monetary-account
```

There are no plans for a version 2. The `/v1/` prefix will remain stable.

## Backwards Compatibility

bunq aims to maintain backwards compatibility within v1. We may add new fields to responses and new optional parameters to requests without a version bump. We will not remove or rename existing fields without a deprecation notice.

## Deprecated Endpoints

Endpoints that are no longer recommended are marked `[deprecated]` in the API Reference. Deprecated endpoints continue to function but may be removed in a future update.

We aim to communicate deprecations in the API documentation. If you are relying on a deprecated endpoint, migrate to the recommended alternative as documented on that endpoint's page.

## Staying Up to Date

* Watch the [bunq developer documentation](https://doc.bunq.com) for updates to endpoint pages
* Check the API Reference for `[deprecated]` tags on endpoints you use
* Contact the API support team if you have questions about a specific endpoint's roadmap


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/api-versioning-and-deprecation.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
