> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/rate-limits.md).

# Rate Limits

If you receive a `429 RATE_LIMIT` error, you have exceeded the allowed number of requests for a given endpoint. bunq enforces **per-endpoint rate limits** — the window and maximum request count differ depending on what the endpoint does and how sensitive it is.

## How rate limits work

Every request is tracked per device (identified by your API key, session, or IP address). The system counts requests to a specific endpoint within a rolling time window. When you exceed the limit you receive an HTTP `429` response with a message indicating the exact limit:

> *"Too many requests. You can do a maximum of X calls per Y seconds to this endpoint."*

## Rate limits by endpoint category

| Endpoint category              | Example endpoints               | Limit                         |
| ------------------------------ | ------------------------------- | ----------------------------- |
| Payment processing             | Card lookups                    | up to 1,000 requests / second |
| Standard data endpoints        | User info, account info, events | 70–140 requests / 30 seconds  |
| Security-sensitive actions     | Alias registration              | 3 requests / 60 seconds       |
| Setup / installation endpoints | Device installation             | as low as 10 requests / day   |

{% hint style="info" %}
The exact limit for an endpoint is returned in the `429` error message itself. Build your retry logic around that value rather than assuming a fixed global limit.
{% endhint %}

## Callback limits

A maximum of **2 callback URLs** per notification category is allowed.

## Handling 429 errors

* Implement client-side rate limiting to stay below the per-endpoint limits.
* When you receive a `429`, back off and retry using **exponential backoff** (see [Querying Payments](https://doc.bunq.com/basics/querying-payments)).
* Do not hammer the endpoint — repeated 429s will extend your backoff window.


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/rate-limits.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
