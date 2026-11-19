> For the complete documentation index, see [llms.txt](https://doc.bunq.com/llms.txt). Markdown versions of documentation pages are available by appending `.md` to page URLs; this page is available as [Markdown](https://doc.bunq.com/basics/querying-payments.md).

# Querying Payments

The bunq API provides flexible ways to access payment data. You can either list multiple payments with pagination or retrieve detailed information for a specific payment by its ID. Understanding how to best leverage these endpoints will help you build efficient, scalable integrations with bunq.

***

### Listing Payments with Pagination

When you want to retrieve multiple payments, the bunq API lets you list payments belonging to a specific monetary account. This is ideal when you need to display recent transactions, build transaction histories, or analyze payments over time. Refer to the [Payment](/payment.md) documentation

To manage potentially large datasets, the API supports . This means you specify how many payments you want per request, and the API provides navigation URLs to move through the list. Pagination parameters like `count`, `older_id`, and `newer_id` allow you to control the page size and direction.

Each payment in the list may or may not include geolocation metadata, depending on whether the payment was created with the geolocation header. Since the API doesn't currently support querying or filtering payments by geolocation directly, you will need to filter these client-side after retrieving the payments.

The response includes a  object with URLs to fetch the next or previous pages, helping you navigate the data without manually building query strings.

***

### Retrieving a Specific Payment

Sometimes you need detailed information on a single payment, for example to display full transaction details or to verify specific metadata like geolocation.

The API provides an endpoint to fetch a payment by its unique ID. This request returns all associated data including descriptions, amounts, and if available, the geolocation data provided at the time of payment creation. If you have a payment ID you can simply query the [Payment](/payment.md) API endpoint with the ID to get it's details.

Since not all payments contain geolocation data, you should always check for the presence of the geolocation property and handle its absence gracefully.

### Keeping track of users payments

To track a user's payments efficiently, set up  on their monetary account to receive real-time updates whenever a new payment is created or updated. When a webhook event arrives, fetch the full payment details using the payment ID and store or update it in your system. This ensures your data stays fresh without polling the API.

As a fallback or for historical data, use the  payments endpoint to fetch recent payments. Store the latest known payment ID and use `newer_id` to retrieve only new entries. Always deduplicate using `payment.id`, and handle optional fields like `geolocation` or `attachment` gracefully, as not all payments will include them.

{% hint style="success" %}
To check if newer payments have been created since a specific payment ID, you can use the `future_url` provided in the  response. If the `future_url` is not `null`, following it will return any newer payments that were added after that ID.
{% endhint %}

***

### Recommended Practices for Querying Payments

* **Efficient Pagination:** Always  when listing payments. It helps manage large datasets, reduces memory usage, and prevents hitting rate limits.
* **Use Pagination URLs:** Instead of manually constructing queries with `older_id` or `newer_id`, use the `older_url` and `newer_url` returned by the API for smoother navigation.
* **Leverage Webhooks for Real-Time Updates:** Use bunq's to receive notifications when a new payment is created or updated. This reduces the need for polling and helps you keep your local data in sync.
* **Client-Side Filtering:** Since the bunq API does not currently support filtering on fields like description, amount, or custom metadata, you'll need to implement filtering in your own application after retrieving the payments. For example, you can filter payments by:
  * Date range
  * Minimum or maximum amount
  * Counterparty alias (e.g., a specific email or phone number)
  * Specific keywords in the description
  * Presence of optional fields like `geolocation`
* **Design for Optional Fields:** Not all payments include all fields (e.g., `geolocation`, `attachments`). Always check for presence before relying on them in your UI or processing logic.
* **Cache Frequently Used Data:** If your app or service frequently queries the same payments, consider caching the results to reduce API usage and improve speed.
* **Respect Rate Limits:** bunq enforces  to ensure fair use. Implement retry logic with exponential backoff to gracefully handle any `429 Too Many Requests` responses.

***


---

# Agent Instructions
This documentation is published with GitBook. GitBook is the documentation platform designed so that both humans and AI agents can read, navigate, and reason over technical content effectively. Learn more at gitbook.com.

## Querying This Documentation
If you need additional information that is not directly available in this page, you can query the documentation by asking a question.

Perform an HTTP GET request on the following URL with the `ask` and `goal` query parameters:

```
GET https://doc.bunq.com/basics/querying-payments.md?ask=<question>&goal=<user_goal>
```

`ask` is the immediate question: it should be specific, self-contained, and written in natural language.
`goal` is what the user is ultimately trying to achieve, the reason they need the answer. Sharing it helps GitBook give you a better, more relevant answer. A goal is most helpful when it describes the outcome the user wants rather than restating the question. For example, with `ask=how do I create an API token`, a goal like `automate deployments from our CI pipeline` lets GitBook tailor the answer to that use case.

The response will contain a direct answer to the question and relevant excerpts and sources from the documentation.

Use this mechanism when the answer is not explicitly present in the current page, you need clarification or additional context, or you want to retrieve related documentation sections.
